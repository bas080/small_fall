local test, gen = luanti_check()

local range = 40

local function neighbors_are_clear(pos)
	local dirs = {
		{ x = 1, y = 0, z = 0 },
		{ x = -1, y = 0, z = 0 },
		{ x = 0, y = 1, z = 0 },
		{ x = 0, y = -1, z = 0 },
		{ x = 0, y = 0, z = 1 },
		{ x = 0, y = 0, z = -1 },
	}

	for _, d in ipairs(dirs) do
		local npos = vector.add(pos, d)
		local nodename = core.get_node(npos).name
		if nodename == "default:water_source" then
			return false
		end
	end
	return true
end

test("Spawns waterfall in expected places", function(t)
	local player, pos = gen.player_pos({
		pos = { y = range + 2 },
	})

	local function on_emerge()
		local node_pos = core.find_node_near(pos, range, "default:water_source", true)

		if node_pos == nil or not neighbors_are_clear(node_pos) then
			return t.retry("Did not find a likely water fall")
		end

		player:set_pos(node_pos)
		t.done("Found a likely water fall")
	end

	t.emerge(on_emerge)
end)
