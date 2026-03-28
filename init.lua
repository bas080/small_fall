local register_decoration = luanti_utils.dofile("register_decoration.lua")

local dirs = {
    { x = 1, y = 0, z = 0 },
    { x = -1, y = 0, z = 0 },
    { x = 0, y = 0, z = 1 },
    { x = 0, y = 0, z = -1 },
}

local function try_place_water(pos)
    local check_pos = vector.new(pos)

    check_pos.y = check_pos.y + 1

    for i = 1, 50 do
        local below_node = core.get_node(check_pos)

        if below_node.name ~= "air" then
            break
        end

        check_pos.y = check_pos.y + 1

        if i > 7 then
            local dir = dirs[math.random(#dirs)]

            local p = vector.add(check_pos, dir)
            local n = core.get_node(vector.add(check_pos, dir))

            if core.get_item_group(n.name, "stone") > 0 then
                core.set_node(p, { name = "default:water_source" })
            end
        end
    end
end

register_decoration({
    name = "small_fall:waterfall",
    place_on = { "default:water_source" },
    deco_type = "simple",
    fill_ratio = 0.01, -- controls how often waterfalls spawn
    y_min = 0,
    y_max = 1,
    flags = "liquid_surface",
    on_position = function(pos)
        try_place_water(pos)
    end,
})

return try_place_water
