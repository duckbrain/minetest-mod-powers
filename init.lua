powers = {
	random = PseudoRandom(minetest.get_us_time()),

	register_power = function(power)
		power.players = {}
		table.insert(powers, power)
		powers[power.name] = power
	end,

	assign_power = function(player, power_names)
		--TODO: Unregister existing powers
		if power_names == nil then
			local r = (powers.random:next() % table.getn(powers)) + 1
			power_names = powers[r].name
		end

		local setting_name = "powers_player_" .. player:get_player_name()
		minetest.setting_set(setting_name, power_names)
		minetest.setting_save()

		powers.give(player, power_names)
	end,

	give = function(player, power_names)
		for _,i in pairs(power_names:split(",")) do
			local power = powers[i]
			if power == nil then
				print("Power '" .. i .. "' does not exist")
			else
				print('Granting player ' .. player:get_player_name() .. ' the power ' .. i)
				table.insert(power.players, player)
				if power.on_gain then power.on_gain(player) end
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
				for i=1,table.getn(power.players),1 do
					if power.players[i] == player then
						table.remove(power.players, i)
					end
				end
				if power.on_loose then power.on_loose(player) end
			end
		end
	end,
}

minetest.register_globalstep(function(dtime)
	--TODO: step each power for each of their players
	for power_index=1,table.getn(powers),1 do
		local power = powers[power_index]
		if power.on_step then
			for player_index=1,table.getn(power.players),1 do
				local player = power.players[player_index]
				power.on_step(player, true)
			end
		end
	end
end)

minetest.register_on_joinplayer(function(player)
	local setting_name = "powers_player_" .. player:get_player_name()
	local power_names = minetest.setting_get(setting_name)
	powers.assign_power(player, power_names)
end)

minetest.register_chatcommand("power", {
	privs = {
		-- admin = true
	},
	func = function(player_name, power_names)
		local player = minetest.get_player_by_name(player_name)
		if player then
			-- TODO: Privleges
			powers.assign_power(player, power_names)
			return true, "Powers: " .. power_names
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
