powers.register_power({

  name = "jump",

  on_gain = function(player)
    player:set_physics_override({jump = 1.4})
  end,

  on_loose = function(player)
    player:set_physics_override({jump = 1.0})
  end,

})
