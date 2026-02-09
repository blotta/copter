-- reponsible for keeping track of the goals
--
local goal_factory = require 'main.ai.goal_factory'

local Brain = {}
Brain.__index = Brain

function Brain.new(go, on_blocked)
    local o = {}
    setmetatable(o, Brain)

    o.go = go
    o.goals = {}
    o.current_goal = goal_factory.create(go.type, { type = 'default' })
    o.current_goal:start(go)
    o.on_blocked = on_blocked

    return o
end

function Brain:add_goal(data)
    local goal = goal_factory.create(self.go.type, data)
    table.insert(self.goals, goal)
end

function Brain:cancel_current_goal()
    self.current_goal:cancel()
end

function Brain:fixed_update(dt)
    self.current_goal:fixed_update(self.go, dt)
end

function Brain:update(dt)
    -- ensure not nil
    if self.current_goal == nil then
        self.current_goal = goal_factory.create(self.go.type, { type = 'default' })
    end

    -- check if other goals available
    if self.current_goal.type == 'default'
        or self.current_goal.status == 'completed'
        or self.current_goal.status == 'cancelled'
    then
        if #self.goals > 0 then
            self.current_goal:dispose(self.go)
            self.current_goal = table.remove(self.goals, 1)
            self.current_goal:start(self.go)
        elseif self.current_goal.type ~= 'default' then
            self.current_goal = goal_factory.create(self.go.type, { type = 'default' })
        end
    end

    if self.current_goal.status == 'queued' then
        self.current_goal:start()
    end

    local prev_goal_status = self.current_goal.status
    self.current_goal:update(self.go, dt)

    if self.current_goal.status ~= prev_goal_status then
        if self.current_goal.status == 'blocked' then
            if self.on_blocked then
                self.on_blocked(self.go, self.current_goal)
            end
        end
    end
end

return Brain
