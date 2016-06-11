
minetest.register_node("powers:glow_air", {
	description = "GlowingAir (you hacker you!)",
	drawtype = "airlike",
  light_source = 15,
	paramtype = "light",
	sunlight_propagates = true,
	walkable     = false,
	pointable    = false,
	diggable     = false,
	buildable_to = true,
	air_equivalent = true,
	drop = "",
	groups = {not_in_creative_inventory=1}
})

minetest.register_abm({
	nodenames = {"powers:glow_air"},
	neighbors = {},
	interval = 1.0, -- Run every 10 seconds
	chance = 1, -- Select every 1 in 50 nodes
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.set_node(pos, {name = "air"})
	end
})

minetest_powers.register_power({

  name = "light",

  on_gain = function(player)

		local illuminate = function(pos)
			if minetest.get_node(pos).name == 'air' then
				minetest.place_node(pos, {name="powers:glow_air"})
			end
		end

    minetest.register_globalstep(function(dtime)
      local controls = player:get_player_control()
      if controls.aux1 then
				local p = player:getpos()
				--illuminate(p)
				illuminate({x = p.x, y = p.y + 1, z = p.z})
				--illuminate({x = p.x + 1, y = p.y + 1, z = p.z})
				--illuminate({x = p.x - 1, y = p.y + 1, z = p.z})
				--illuminate({x = p.x, y = p.y + 1, z = p.z + 1})
				--illuminate({x = p.x, y = p.y + 1, z = p.z - 1})
				--illuminate({x = p.x, y = p.y + 2, z = p.z})
      end
    end)
  end,

  on_loose = function(player)

  end,

})
