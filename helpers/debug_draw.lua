local M = {}

function M.draw_rect(x, y, w, h, options)
    local z = options.z or 0
    local color = options.color or vmath.vector4(1, 1, 1, 1)

    local bl = vmath.vector3(x, y, z)
    local br = vmath.vector3(x + w, y, z)
    local tl = vmath.vector3(x, y + h, z)
    local tr = vmath.vector3(x + w, y + h, z)

    msg.post("@render:", "draw_line", {
        start_point = bl,
        end_point = br,
        color = color
    })
    msg.post("@render:", "draw_line", {
        start_point = br,
        end_point = tr,
        color = color
    })
    msg.post("@render:", "draw_line", {
        start_point = tr,
        end_point = tl,
        color = color
    })
    msg.post("@render:", "draw_line", {
        start_point = tl,
        end_point = bl,
        color = color
    })
end

function M.draw_rect_points(bl, br, tl, tr, options)
    local z = options.z or bl.z
    local color = options.color or vmath.vector4(1, 1, 1, 1)

    local _bl = vmath.vector3(bl.x, bl.y, z)
    local _br = vmath.vector3(br.x, br.y, z)
    local _tl = vmath.vector3(tl.x, tl.y, z)
    local _tr = vmath.vector3(tr.x, tr.y, z)

    msg.post("@render:", "draw_line", {
        start_point = _bl,
        end_point = _br,
        color = color
    })
    msg.post("@render:", "draw_line", {
        start_point = _br,
        end_point = _tr,
        color = color
    })
    msg.post("@render:", "draw_line", {
        start_point = _tr,
        end_point = _tl,
        color = color
    })
    msg.post("@render:", "draw_line", {
        start_point = _tl,
        end_point = _bl,
        color = color
    })
end

function M.draw_cross(p, size, options)
    local z = options.z or p.z
    local color = options.color or vmath.vector4(1, 1, 1, 1)

    local hs = size / 2

    msg.post("@render:", "draw_line", {
        start_point = p + vmath.vector3(-hs, -hs, z),
        end_point = p + vmath.vector3(hs, hs, z),
        color = color
    })
    msg.post("@render:", "draw_line", {
        start_point = p + vmath.vector3(-hs, hs, z),
        end_point = p + vmath.vector3(hs, -hs, z),
        color = color
    })
end

return M
