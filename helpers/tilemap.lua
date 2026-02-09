local size = 32
local tilemap_url = msg.url("/level#level")

local M = {}

function M.tile_to_world_position(tx, ty, normalized_offset)
    local offset = size * (normalized_offset or vmath.vector3(0.5, 0, 0)) -- bottom_center

    local wpos = vmath.vector3((tx - 1) * size, (ty - 1) * size, 0) + offset

    return wpos
end

function M.world_xy_to_tile(wx, wy)
    local tx = math.floor(wx / size) + 1
    local ty = math.floor(wy / size) + 1
    return tx, ty
end

return M
