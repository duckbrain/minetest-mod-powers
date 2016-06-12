minetest.register_node("powers:glow_air", {
	description = "Glowing air",
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

minetest.register_node("powers:glow_water", {
	description = "Glowing water",
	drawtype = "liquid",
  light_source = 15,
	paramtype = "light",
	inventory_image = minetest.inventorycube("default_water.png"),
	tiles = {
		{
			name = "default_water_source_animated.png",
			animation = {
				type     = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length   = 2.0
			}
		}
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{
			name      = "default_water_source_animated.png",
			animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 2.0},
			backface_culling = false,
		}
	},
	sunlight_propagates = true,
	walkable     = true,
	pointable    = false,
	diggable     = false,
	buildable_to = true,
	drop = "",
	groups = {not_in_creative_inventory=1},
	--
	-- Liquid Properties
	--
	drowning = 1,
	liquidtype = "source",

	liquid_alternative_flowing = "default:water_flowing",
	-- ^ when the liquid is flowing

	liquid_alternative_source = "default:water_source",
	-- ^ when the liquid is a source
	liquid_viscosity = WATER_VISC,
	-- ^ how fast
	liquid_range = 8,
	-- ^ how far
	post_effect_color = {a=64, r=100, g=100, b=200},
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
minetest.register_abm({
	nodenames = {"powers:glow_water"},
	neighbors = {},
	interval = 1.0, -- Run every 10 seconds
	chance = 1, -- Select every 1 in 50 nodes
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.set_node(pos, {name = "default:water_source"})
	end
})

powers.register_power({

  name = "light",

  --[[on_gain = function(player)

				--TODO: Put this in init.lua

				local button_down = false
				local light_on = false

				local controls = player:get_player_control()
				if controls.aux1 and not button_down then
					light_on = not light_on
				end
				button_down = controls.aux1
  end,


  on_loose = function(player)

  end,]]

	on_step = function(player, toggle)
		if toggle then
			local pos = player:getpos()
			pos.y = pos.y + 2
			pos.y = math.floor(pos.y)
			local node = minetest.get_node(pos).name
			pos.y = pos.y + 1
			if node == 'air' then
				minetest.place_node(pos, {name="powers:glow_air"})
			end
			if node == 'default:water_source' then
				minetest.place_node(pos, {name="powers:glow_water"})
			end
		end
	end,

})
