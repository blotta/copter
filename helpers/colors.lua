
---@enum PALETTE
PALETTE = {
    green = "8ab060",
    yellow = "ede19e",
    blue = "4b80ca",
    teal = "567b79",
    red = "b45252"
}

local M = {}


---@param hex string
---@param alpha? number
---@return vector4
function M.hex_to_color(hex, alpha)
    hex = string.gsub(hex, "#", "")
    alpha = alpha or 1

    local r = tonumber(hex:sub(1,2), 16) / 255
    local g = tonumber(hex:sub(3,4), 16) / 255
    local b = tonumber(hex:sub(5,6), 16) / 255

    return vmath.vector4(r, g, b, alpha)
end

return M