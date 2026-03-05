
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

---@param color vector4
---@return string
function M.color_to_hex(color)
    local r = math.floor(math.max(0, math.min(1, color.x)) * 255 + 0.5)
    local g = math.floor(math.max(0, math.min(1, color.y)) * 255 + 0.5)
    local b = math.floor(math.max(0, math.min(1, color.z)) * 255 + 0.5)

    return string.format("#%02X%02X%02X", r, g, b)
end

return M