minetest_powers.register_power({

  name = "breath",

  on_gain = function(player)
    minetest.register_globalstep(function(dtime)
      player:set_breath(11)
    end)
  end,

  on_loose = function(player)

  end,

})
