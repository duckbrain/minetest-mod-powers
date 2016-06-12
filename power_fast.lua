powers.register_power({

  name = "fast",

  on_step = function(player)
    local controls = player:get_player_control()
    -- TODO: Only allow fast if you were last standing on land
    if controls.aux1 then
      player:set_physics_override({speed = 2.0})
    else
      player:set_physics_override({speed = 1.0})
    end
  end,

})
