local PersonMoveGoal = require "main.ai.person.goals.move"

local PersonEnterBuildingGoal = {}
PersonEnterBuildingGoal.__index = PersonEnterBuildingGoal

function PersonEnterBuildingGoal.new(data)
    local o = {}
    setmetatable(o, PersonEnterBuildingGoal)

    o.type = 'enter_building'
    o.status = 'queued' -- queued, doing, completed, blocked, cancelled

    if data.building_id == nil then
        error('PersonEnterBuildingGoal.new: required parameter building_id is nil')
    end
    o.building_id = data.building_id
    o.move_goal = nil

    return o
end

function PersonEnterBuildingGoal:start(person)
    self.status = 'doing'
    self.move_goal = PersonMoveGoal.new({ position = go.get_position(self.building_id) })
    self.move_goal:start(person)
end

function PersonEnterBuildingGoal:fixed_update(person, dt)
    self.move_goal:fixed_update(person, dt)
end

function PersonEnterBuildingGoal:update(person, dt)
    if self.status == 'doing' then

        self.move_goal:update(person, dt)

        if self.move_goal.status == 'completed' then
            msg.post(self.building_id, 'request_person_enter', {
                person_id = go.get_id()
            })
        end
    end
end

function PersonEnterBuildingGoal:dispose(person)
    self.move_goal:dispose(person)
end

function PersonEnterBuildingGoal:cancel(person)
    self.move_goal:cancel(person)
    self.status = 'cancelled'
end

return PersonEnterBuildingGoal
