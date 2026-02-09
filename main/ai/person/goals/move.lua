local PersonMoveGoal = {}
PersonMoveGoal.__index = PersonMoveGoal

function PersonMoveGoal.new(data)
    local o = {}
    setmetatable(o, PersonMoveGoal)

    o.type = 'move'
    o.target = data.position
    o.tolerance_x = data.tolerance_x or 10
    o.tolerance_y = data.tolerance_y or 32
    o.status = 'queued' -- queued, doing, completed, blocked, cancelled
    o.ray_eye_facing = nil

    return o
end

function PersonMoveGoal:start(person)
    self.status = 'doing'
end

function PersonMoveGoal:fixed_update(person, dt)
    if self.status == 'doing' then
        if not person.controller.is_grounded then
            person.controller.velocity.x = 0
            return
        end

        local diff = self.target - go.get_position()
        person.facing = diff.x > 0 and 1 or -1
        person.controller.velocity.x = person.speed * person.facing

        local eye = go.get_position() + vmath.vector3(0, 16, 0)
        local eye_range_vec = vmath.vector3(person.facing * 16, 0, 0)
        self.ray_eye_facing = physics.raycast(eye, eye + eye_range_vec, { hash('floor') })
        msg.post("@render:", "draw_line", {
            start_point = eye,
            end_point = eye + eye_range_vec,
            color = self.ray_eye_facing ~= nil and vmath.vector4(0, 1, 0, 1) or vmath.vector4(1, 1, 1, 1)
        })
        return
    end

    if self.status == 'blocked' then
        person.controller.velocity.x = 0
    end
end

function PersonMoveGoal:update(person, dt)
    msg.post("@render:", "draw_line", {
        start_point = go.get_position(),
        end_point = self.target,
        color = vmath.vector4(1, 1, 1, 1)
    })


    if self.status == 'doing' then
        -- check completed
        local diff = self.target - go.get_position()
        if math.abs(diff.x) <= self.tolerance_x and math.abs(diff.y) <= self.tolerance_y then -- vmath.length_sqr(diff) < self.tolerance * self.tolerance then
            self.status = 'completed'
            return
        end

        -- check blocked
        if math.abs(diff.x) <= self.tolerance_x and math.abs(diff.y) > self.tolerance_y then
            -- vertical difference
            self.status = 'blocked'
        elseif self.ray_eye_facing ~= nil then
            self.status = 'blocked'
        end
    end
end

function PersonMoveGoal:dispose(person)
    person.controller.velocity.x = 0
end

function PersonMoveGoal:cancel()
    self.status = 'cancelled'
end

return PersonMoveGoal
