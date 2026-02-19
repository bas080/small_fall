local stone_nodes = {
    ["default:stone"] = true,
    ["default:desert_stone"] = true,
    ["default:sandstone"] = true,
}

minetest.register_on_generated(function(minp, maxp, seed)
    local pr = PseudoRandom(seed + minp.x * 31 + minp.z * 17)
    local dirs = {
        {x = 1, y = 0, z = 0},
        {x = -1, y = 0, z = 0},
        {x = 0, y = 0, z = 1},
        {x = 0, y = 0, z = -1},
    }

    for x = minp.x, maxp.x, 1 do for z = minp.z, maxp.z, 1 do for y = maxp.y, math.max(minp.y, 0), -1 do
        local pos = {x = x, y = y, z = z}
        local node = minetest.get_node(pos)

        -- Add a random to reduce amount of waterfalls.
        if stone_nodes[node.name] and pr:next(1, 1000) == 1 then
            for _, d in ipairs(dirs) do
                local check_pos = vector.add(pos, d)

                for i = 1, 30 do
                    local below_node = minetest.get_node(check_pos)

                    if below_node.name == "air" then
                        check_pos.y = check_pos.y - 1
                    else
                        if below_node.name == "default:water_source" then
                            -- Do not place if water is too close to water.
                            if i < 7 then break end

                            minetest.set_node(pos, {name = "default:water_source"})
                        end
                        break
                    end
                end
            end
        end
    end end end
end)
