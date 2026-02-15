local PersonMoveGoal = require "main.ai.person.goals.move"

local PersonBoardHelicopter = {}
PersonBoardHelicopter.__index = PersonBoardHelicopter

function PersonBoardHelicopter.new(data)
    local o = {}
    setmetatable(o, PersonBoardHelicopter)

    o.type = 'board_helicopter'
    o.status = 'queued' -- queued, doing, completed, blocked, cancelled

    if data.helicopter_id == nil then
        error('PersonBoardHelicopter.new: required parameter helicopter_id is nil')
    end
    o.helicopter_id = data.helicopter_id
    o.move_goal = nil

    return o
end

function PersonBoardHelicopter:start(person)
    self.status = 'doing'
    self.move_goal = PersonMoveGoal.new({ position = go.get_position(self.helicopter_id) })
    self.move_goal:start(person)
end

function PersonBoardHelicopter:fixed_update(person, dt)
    self.move_goal:fixed_update(person, dt)
end

function PersonBoardHelicopter:update(person, dt)
    if self.status == 'doing' then
        -- if arrived at next frame and person didn't board (i.e GO got deleted)
        -- then we're blocked (no passenger_slots available)
        if self.move_goal.status == 'completed' then
            self.status = 'blocked'
            return
        end

        self.move_goal:update(person, dt)

        if self.move_goal.status == 'completed' then
            msg.post(self.helicopter_id, 'request_person_board', {
                person_id = go.get_id()
            })
        end
    end
end

function PersonBoardHelicopter:dispose(person)
    self.move_goal:dispose(person)
end

function PersonBoardHelicopter:cancel(person)
    self.move_goal:cancel(person)
    self.status = 'cancelled'
end

return PersonBoardHelicopter
