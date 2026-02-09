-- person idle
-- default goals can't be completed, cancelled or blocked

local PersonDefaultGoal = {}
PersonDefaultGoal.__index = PersonDefaultGoal

function PersonDefaultGoal.new(data)
    local o = {}
    setmetatable(o, PersonDefaultGoal)

    o.type = 'default'
    o.status = 'queued' -- queued, doing

    return o
end

function PersonDefaultGoal:start(person)
    self.status = 'doing'
end

function PersonDefaultGoal:fixed_update(person, dt)
    person.controller.velocity.x = 0
end

function PersonDefaultGoal:update(person, dt)
end

function PersonDefaultGoal:dispose(person)
end

function PersonDefaultGoal:cancel(person)
    error('attempted to cancel a default goal')
end

return PersonDefaultGoal
