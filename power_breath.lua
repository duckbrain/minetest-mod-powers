powers.register_power({

  name = "breath",

  on_step = function(player)
    player:set_breath(11)
  end,

})
