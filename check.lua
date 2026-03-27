local property, gen = luanti_check()

local range = 40

property("Spawns waterfall in expected places", function(t)
    local player = gen.player_pos({
        pos = { y = range + 2 },
    })

    t.on_emerge(function()
        t.done(player)
    end)
end, function(t, player)
    local pos = player:get_pos()

    -- core.after(function()
    local node_pos = core.find_node_near(pos, range, "default:water_source", true)

    -- Retry if the node was a sea level node.
    -- Bad idea? Cannot use this in an after
    gen.where(node_pos ~= nil)

    t.done() -- Reached the end. It seems you have spawned a waterfall.
    -- end)
end)
