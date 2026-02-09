local M = {}

-- internal state
local tilemap_url
local tile_size
local map_w, map_h

local nodes = {}
local node_index = {} -- key: "x,y" -> node

-------------
-- helpers --
-------------

local function key(x, y)
    return x .. "," .. y
end

local function is_solid(x, y)
    if x < 1 or y < 1 or x >= map_w or y >= map_h then
        return false
    end

    -- assumes a layer named "ground"

    local tile = tilemap.get_tile(tilemap_url, "level", x, y)
    -- print(x, y, tile)
    return tile > 1
end

local function tile_to_world(x, y)
    return vmath.vector3(
        x * tile_size + tile_size * 0.5,
        y * tile_size + tile_size * 0.5,
        0
    )
end

---------------------
-- node extraction --
---------------------

local function extract_nodes()
    nodes = {}
    node_index = {}

    for y = 1, map_h - 1 do
        for x = 0, map_w - 1 do
            local air = not is_solid(x, y)
            local ground = is_solid(x, y - 1)

            if air and ground then
                local node = {
                    x = x,
                    y = y,
                    world_pos = tile_to_world(x, y),
                    edges = {}
                }

                table.insert(nodes, node)
                node_index[key(x, y)] = node
            end
        end
    end
end

----------------------------------------------------------------
-- Edge building
----------------------------------------------------------------

local function add_edge(from_node, to_node, cost)
    table.insert(from_node.edges, {
        to = to_node,
        cost = cost
    })
end

local function build_walk_edges()
    for _, node in ipairs(nodes) do
        local left = node_index[key(node.x - 1, node.y)]
        local right = node_index[key(node.x + 1, node.y)]

        if left then
            add_edge(node, left, 1)
        end

        if right then
            add_edge(node, right, 1)
        end
    end
end

local function build_fall_edges()
    for _, node in ipairs(nodes) do
        -- check left edge
        for _, dx in ipairs({ -1, 1 }) do
            local edge_x = node.x + dx

            -- no ground ahead?
            if not is_solid(edge_x, node.y - 1) then
                -- fall down
                for y = node.y - 1, 0, -1 do
                    local landing = node_index[key(edge_x, y + 1)]
                    if landing and is_solid(edge_x, y) then
                        add_edge(node, landing, 2) -- falling is a bit more costly
                        break
                    end
                end
            end
        end
    end
end

----------------------------------------------------------------
-- Public API
----------------------------------------------------------------

function M.build(url)
    tilemap_url = url
    tile_size = 32 --tilemap.get_tile_size(tilemap_url)
    --map_w, map_h = tilemap.get_size(tilemap_url)
    local x, y, w, h = tilemap.get_bounds(tilemap_url)
    map_w = w
    map_h = h

    extract_nodes()
    build_walk_edges()
    build_fall_edges()

    -- print("NavGrid built. Nodes:", #nodes)
end

----------------------------------------------------------------
-- Pathfinding (BFS for now)
----------------------------------------------------------------

function M.find_path(start_pos, target_pos)
    local function pos_to_node(pos)
        local x = math.floor(pos.x / tile_size)
        local y = math.floor(pos.y / tile_size)
        return node_index[key(x, y)]
    end

    local start = pos_to_node(start_pos)
    local goal = pos_to_node(target_pos)

    if not start or not goal then
        return nil
    end

    local queue = { start }
    local came_from = {}
    came_from[start] = nil

    local head = 1
    while queue[head] do
        local current = queue[head]
        head = head + 1

        if current == goal then
            break
        end

        for _, edge in ipairs(current.edges) do
            if came_from[edge.to] == nil then
                came_from[edge.to] = current
                table.insert(queue, edge.to)
            end
        end
    end

    if came_from[goal] == nil then
        return nil
    end

    -- reconstruct path
    local path = {}
    local node = goal
    while node do
        table.insert(path, 1, node)
        node = came_from[node]
    end

    return path
end

----------------------------------------------------------------
-- Debug draw
----------------------------------------------------------------

function M.debug_draw()
    local plus = vmath.vector3(4, 4, 0)
    for _, node in ipairs(nodes) do
        msg.post("@render:", "draw_line", {
            start_point = node.world_pos + plus,
            end_point = node.world_pos - plus,
            color = vmath.vector4(1, 1, 1, 1)
        })
    end
end

return M
