local KinematicController = {}
KinematicController.__index = KinematicController

function KinematicController.new(config)
    local o = {
        -- Motion
        velocity = vmath.vector3(),
        gravity = config.gravity or physics.get_gravity().y,
        max_fall_speed = config.max_fall_speed or -300,

        -- Collision resolution
        correction = vmath.vector3(),
        is_grounded = false,

        contacts = {},

        -- Slope handling
        max_slope_cos = math.cos(math.rad(config.max_slope_angle or 45)),
    }
    setmetatable(o, KinematicController)

    return o
end

-- call in update (move step)
function KinematicController.fixed_update_start(self, dt)
    local pos = go.get_position()

    -- check grounded
    local ray_start_left = pos + vmath.vector3(-6, 1, 0)
    local ray_start_right = pos + vmath.vector3(6, 1, 0)
    local ray_end_offset = vmath.vector3(0, -11, 0)

    local ray_left = physics.raycast(ray_start_left, ray_start_left + ray_end_offset, { hash('floor') })
    local ray_right = physics.raycast(ray_start_right, ray_start_right + ray_end_offset, { hash('floor') })

    -- msg.post("@render:", "draw_line", {
    --     start_point = ray_start_left,
    --     end_point = ray_start_left + ray_end_offset,
    --     color = ray_left ~= nil and vmath.vector4(0, 1, 0, 1) or vmath.vector4(1, 1, 1, 1)
    -- })
    -- msg.post("@render:", "draw_line", {
    --     start_point = ray_start_right,
    --     end_point = ray_start_right + ray_end_offset,
    --     color = ray_right ~= nil and vmath.vector4(0, 1, 0, 1) or vmath.vector4(1, 1, 1, 1)
    -- })

    self.is_grounded = (ray_left ~= nil or ray_right ~= nil)

    -- apply gravity
    self.velocity.y = self.velocity.y + self.gravity * dt
    if self.velocity.y < self.max_fall_speed then
        self.velocity.y = self.max_fall_speed
    end
end

function KinematicController.fixed_update_end(self, dt)
    -- apply velocity
    local pos = go.get_position()
    pos = pos + self.velocity * dt
    go.set_position(pos)
end

function KinematicController.late_update(self, dt)
    -- self.is_grounded = false
    self.correction = vmath.vector3()
end

-- call from on_message when contact_point_response
function KinematicController.on_contact(self, message)
    pprint(message.normal)
    if message.distance > 0 then
        local proj = vmath.project(self.correction, message.normal * message.distance)
        if proj < 1 then
            local comp = (message.distance - message.distance * proj) * message.normal
            go.set_position(go.get_position() + comp)
            self.correction = self.correction + comp
        end
    end

    -- ceiling
    -- if message.normal.y < 0 then
    --     self.velocity.y = 0
    -- end

    -- --- FLOOR DETECTION ---
    -- if message.normal.y > self.max_slope_cos then
    --     self.is_grounded = true
    -- end

    -- --- VELOCITY SLIDING ---
    -- local vn = vmath.dot(self.velocity, normal)
    -- if vn < 0 then
    --     -- Remove velocity into surface
    --     self.velocity = self.velocity - normal * vn
    -- end
    -- if math.abs(message.normal.x) > self.max_slope_cos then self.velocity.x = 0 end
    if math.abs(message.normal.y) > self.max_slope_cos then self.velocity.y = 0 end
end

return KinematicController
