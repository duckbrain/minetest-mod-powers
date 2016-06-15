function get_nodedef_field(nodename, fieldname)
  if not minetest.registered_nodes[nodename] then
    return nil
  end
  return minetest.registered_nodes[nodename][fieldname]
end

powers.register_power({

  name = "fast",

  on_step = function(player)
    local controls = player:get_player_control()
    -- TODO: Only allow fast if you were last standing on land
    if controls.aux1 then
  		local pos = player:getpos()
  		pos.y = math.floor(pos.y)
      local onnode = get_nodedef_field(minetest.get_node(pos).name, "drawtype")
      pos.y = pos.y + 1
      local innode = get_nodedef_field(minetest.get_node(pos).name, "drawtype")

      if innode == "liquid" then player:set_physics_override({speed = 1.0})
      elseif onnode == "normal" then player:set_physics_override({speed = 2.0})
      end
    else
      player:set_physics_override({speed = 1.0})
    end
  end,

})
