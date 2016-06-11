minetest_powers.register_power({

  name = "treasure",

  on_gain = function(player)
    minetest.register_on_dignode(function (pos, oldnode, digger)
    	if digger == player and digger:get_inventory() then
    		local _, dropped_item
    		local r = (minetest_powers.random:next() % 1000)
    		if r == 1 then
    			local stack = ItemStack("default:gold_lump 1")
    			digger:get_inventory():add_item("main", stack)
    		end
    		if r > 100 and r < 125 then
    			local stack = ItemStack("default:iron_lump 1")
    			digger:get_inventory():add_item("main", stack)
    		end
    		if r == 2 then
    			local stack = ItemStack("default:mese 1")
    			digger:get_inventory():add_item("main", stack)
    		end
    	end
    end)
  end,

  on_loose = function(player)

  end,

})
