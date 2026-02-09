-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local PersonMoveGoal = {}
PersonMoveGoal.__index = PersonMoveGoal

function PersonMoveGoal.new(data)
    local o = {}
    setmetatable(o, PersonMoveGoal)

    -- o.started = false
    o.target = data.position
    o.tolerance = data.tolerance or 10
    o.state = 'queued' -- queued, doing, completed, blocked
    o.ray_facing = nil

    return o
end

function PersonMoveGoal:start(person)
    --sprite.play_flipbook("#sprite", person.def.anim.run)
    --sprite.set_hflip("#sprite", person.facing == -1)
    -- msg.post("#", 'start_animation', { anim = person.def.anim.run, hflip = person.facing == -1 })

    -- self.started = true
    self.state = 'doing'
end

function PersonMoveGoal:fixed_update(person, dt)
    if self.state == 'doing' then
        local diff = self.target - go.get_position()
        person.facing = diff.x > 0 and 1 or -1
        person.controller.velocity.x = person.speed * person.facing

        local eye = go.get_position() + vmath.vector3(0, 10, 0)
        local eye_range_vec = vmath.vector3(person.facing * 10, 0, 0)
        self.ray_facing = physics.raycast(eye, eye + eye_range_vec, { hash('floor') })
        return
    end

    if self.state == 'blocked' then
        person.controller.velocity.x = 0
    end
end

function PersonMoveGoal:update(person, dt)
    msg.post("@render:", "draw_line", {
        start_point = go.get_position(),
        end_point = self.target,
        color = vmath.vector4(1, 1, 1, 1)
    })

    if self.state == 'doing' then
        -- check completed
        local diff = self.target - go.get_position()
        if vmath.length_sqr(diff) < self.tolerance * self.tolerance then
            self.state = 'completed'
            return
        end

        -- check blocked
        if math.abs(diff.x) <= self.tolerance then
            -- vertical difference
            self.state = 'blocked'
        elseif self.ray_facing ~= nil then
            self.state = 'blocked'
        end
    end
end

function PersonMoveGoal:is_complete(person)
    return self.state == 'completed'
end

function PersonMoveGoal:is_blocked(person)
    return self.state == 'blocked'
end

function PersonMoveGoal:stop(person)
    person.controller.velocity.x = 0
    self.state = 'queued'
end

return PersonMoveGoal
