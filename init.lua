minetest_powers = {
	random = PseudoRandom(minetest.get_us_time()),

	register_power = function(options)
		minetest_powers.powers_count = minetest_powers.powers_count + 1
		minetest_powers.powers[options.name] = options
		minetest_powers.powers[minetest_powers.powers_count] = options
	end,

	assign_power = function(player, power_names)
		if power_names == nil then
			local r = (minetest_powers.random:next() % minetest_powers.powers_count) + 1
			power_names = minetest_powers.powers[r].name
		end

		local setting_name = "powers_player_" .. player:get_player_name()
		minetest.setting_set(setting_name, power_names)
		minetest.setting_save()

		for _,i in pairs(power_names:split(",")) do
			print('Granting player ' .. player:get_player_name() .. ' the power ' .. i)
			minetest_powers.powers[i].on_gain(player)
		end
	end,

	powers_count = 0,
	powers = {},


}

minetest.register_on_joinplayer(function(player)
	local setting_name = "powers_player_" .. player:get_player_name()
	local power_names = minetest.setting_get(setting_name)
	minetest_powers.assign_power(player, power_names)
end)

minetest.register_chatcommand("power", {
	privs = {
		-- admin = true
	},
	func = function(player_name, power_names)
		local player = minetest.get_player_by_name(player_name)
		if player then
			-- TODO: Privleges
			minetest_powers.assign_power(player, power_names)
			return true, "Powers: " .. power_names
		else
			return false, "Player is not online"
		end
	end
})

dofile(minetest.get_modpath("powers") .. "/util.lua")
dofile(minetest.get_modpath("powers") .. "/power_breath.lua")
dofile(minetest.get_modpath("powers") .. "/power_treasure.lua")
dofile(minetest.get_modpath("powers") .. "/power_fast.lua")
dofile(minetest.get_modpath("powers") .. "/power_time.lua")
dofile(minetest.get_modpath("powers") .. "/power_light.lua")
