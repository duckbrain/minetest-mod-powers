powers = {
	random = PseudoRandom(minetest.get_us_time()),

	register_power = function(power)
		power.states = {}
		table.insert(powers, power)
		powers[power.name] = power
	end,

	get_powers = function(player)
		local setting_name = "powers_player_" .. player:get_player_name()
		return minetest.setting_get(setting_name)
	end,

	assign_power = function(player, power_names)
		--TODO: Unregister existing powers
		if power_names == nil then
			local r = (powers.random:next() % table.getn(powers)) + 1
			power_names = powers[r].name
		end

		local setting_name = "powers_player_" .. player:get_player_name()
		local old_power_names = minetest.setting_get(setting_name, power_names)
		minetest.setting_set(setting_name, power_names)
		minetest.setting_save()

		if old_power_names then powers.take(player, old_power_names) end

		powers.give(player, power_names)
	end,

	give = function(player, power_names)
		for _,i in pairs(power_names:split(",")) do
			local power = powers[i]
			if power == nil then
				print("Power '" .. i .. "' does not exist")
			else
				print('Granting player ' .. player:get_player_name() .. ' the power ' .. i)
				local state = {player = player}
				table.insert(power.states, state)
				if power.on_gain then power.on_gain(player, state) end
			end
		end
	end,

	take = function(player, power_names)
		for _,power_name in pairs(power_names:split(",")) do
			local power = powers[power_name]
			if power == nil then
				print("Power '" .. power_name .. "' does not exist")
			else
				print('Player ' .. player:get_player_name() .. ' looses the power ' .. power_name)
				for i=1,table.getn(power.states),1 do
					if power.states[i].player == player then
						local state = table.remove(power.states, i)
						if power.on_loose then power.on_loose(player, state) end
					end
				end
			end
		end
	end,
}

minetest.register_globalstep(function(dtime)
	for power_index=1,table.getn(powers),1 do
		local power = powers[power_index]
		if power.on_step then
			for player_index=1,table.getn(power.states),1 do
				local state = power.states[player_index]
				power.on_step(state.player, state)
			end
		end
	end
end)

minetest.register_on_joinplayer(function(player)
	local power_names = powers.get_powers(player)
	powers.assign_power(player, power_names)
end)

minetest.register_chatcommand("power", {
	privs = {
		server = true
	},
	func = function(player_name, power_names)
		local player = minetest.get_player_by_name(player_name)
		if player then
			print(power_names)
			print(power_names)
			if power_names == "" then
				power_names = powers.get_powers(player)
				return true, "Powers: " .. power_names
			else
			-- TODO: Privleges
				powers.assign_power(player, power_names)
				return true, "Powers: " .. power_names
			end
		else
			return false, "Player is not online"
		end
	end
})

dofile(minetest.get_modpath("powers") .. "/util.lua")
dofile(minetest.get_modpath("powers") .. "/power_all.lua")
dofile(minetest.get_modpath("powers") .. "/power_breath.lua")
dofile(minetest.get_modpath("powers") .. "/power_treasure.lua")
dofile(minetest.get_modpath("powers") .. "/power_fast.lua")
dofile(minetest.get_modpath("powers") .. "/power_jump.lua")
dofile(minetest.get_modpath("powers") .. "/power_time.lua")
dofile(minetest.get_modpath("powers") .. "/power_light.lua")
