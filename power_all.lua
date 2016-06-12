powers.register_power({

  name = "all",
  exclude = true,

  on_gain = function(player, state)
    for i = 1,table.getn(powers),1 do
      local power = powers[i]
      if not power.exclude and power.on_gain then
			  power.on_gain(player, state)
      end
		end
  end,

  on_loose = function(player, state)
    for i = 1,table.getn(powers),1 do
      local power = powers[i]
      if not power.exclude and power.on_loose then
			  power.on_loose(player, state)
      end
		end
  end,

  on_step = function(player, state)
    for i = 1,table.getn(powers),1 do
      local power = powers[i]
      if not power.exclude and power.on_step then
        power.on_step(player, state)
      end
    end
  end,

})
