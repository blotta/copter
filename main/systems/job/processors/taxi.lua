local jobs = require 'main.systems.job.defs'
local building_registry = require 'main.systems.buildings.registry'

local TaxiJob = {}
TaxiJob.__index = TaxiJob
TaxiJob._next_id = 1

function TaxiJob.new(building)
    local o = {}
    setmetatable(o, TaxiJob)

    local def = jobs[hash('taxi')]
    for k, v in pairs(def) do
        o[k] = v
    end

    -- assumes there are at least 2 buildings in the game
    local from_building = building
    local to_building = building_registry.get_random({ except_ids = { from_building.id } })
    if to_building == nil then
        error('could not find destination building for taxi job')
        return nil
    end

    if math.random() > 0.5 then
        from_building, to_building = to_building, from_building
    end

    o.job_id = 'taxi_' .. TaxiJob._next_id
    TaxiJob._next_id = TaxiJob._next_id + 1
    o.job_type = hash('taxi')
    o.status = 'available'    -- in-progress, completed, cancelled

    o.inner_status = 'pickup' -- boarding, deliver, unboarding, completed, cancelled
    o.from = from_building
    o.to = to_building
    o.pickup_position = go.get(from_building.go_id, "position") + from_building.landing_point_offset
    o.deliver_position = go.get(to_building.go_id, "position") + to_building.landing_point_offset

    o._trigger = nil
    o._helicopter_id = nil -- copter
    o._in_area_time = 2
    o._in_area_timer = 0

    o._passeger = nil

    return o
end

local function board_passenger(self)
    local position = go.get_position(self.from.go_id)
    local goal = { type = "board_helicopter", helicopter_id = self._helicopter_id }

    if self._passenger == nil or not go.exists(self._passenger) then
        local possible_variants = { hash("normal1"), hash("normal2") }
        self._passenger = factory.create("/systems#person-factory", position, nil,
            {
                variant = possible_variants[math.random(2)]
            })
    end

    msg.post(self._passenger, 'cancel_current_goal')
    -- local data = { type = "board_helicopter", helicopter_id = self._helicopter_id }
    msg.post(self._passenger, 'add_goal', goal)
end

local function unboard_passenger(self)
    local goal = { type = "enter_building", building_id = self.to.go_id }

    msg.post(self._helicopter_id, 'request_person_unboard', {
        goal = goal
    })
end

function TaxiJob:start()
    -- send necessary messages
    self._trigger = factory.create(
        "/systems#trigger-area-factory",
        self.pickup_position,
        nil,
        { owner_url = msg.url(go.get_id()) })
end

function TaxiJob:update(dt)
    if self.inner_status == 'pickup' then
        -- check helicopter is in designated boarding area long enough
        -- possibly disable helicopter from moving
        -- spawn person with task BoardHelicopter
        if self._helicopter_id ~= nil then
            self._in_area_timer = self._in_area_timer + dt
            if self._in_area_timer >= self._in_area_time then
                self.inner_status = 'boarding'
                board_passenger(self)
            end
        end
    elseif self.inner_status == 'boarding' then
        if self._helicopter_id == nil then
            self.inner_status = 'pickup'
            -- make person go back to building
            msg.post(self._passenger, 'cancel_current_goal')
            msg.post(self._passenger, 'add_goal', { type = "enter_building", building_id = self.from.go_id })
        end
        -- check person boarded the copter
        if not go.exists(self._passenger) then
            self._passenger = nil
            self.inner_status = 'deliver'
            self.status = 'in-progress'
            go.set_position(self.deliver_position, self._trigger)
        end
    elseif self.inner_status == 'deliver' then
        -- possibly enable copter movement
        -- check copter is in designated unboarding area long enough
        if self._helicopter_id ~= nil then
            self._in_area_timer = self._in_area_timer + dt
            if self._in_area_timer >= self._in_area_time then
                self.inner_status = 'unboarding'
                go.delete(self._trigger)
                unboard_passenger(self)
            end
        end
    elseif self.inner_status == 'unboarding' then
        -- unboard (spawn) person from copter with task EnterBuilding
        if self._passenger ~= nil and not go.exists(self._passenger) then
            self._passenger = nil
            self.inner_status = 'completed'
            self.status = 'completed'
        end
        -- reward player
    end
end

function TaxiJob:on_message(message_id, message, sender)
    local sender_go_url = msg.url(sender.socket, sender.path, nil)
    if message_id == hash('trigger_response') and sender_go_url == msg.url(self._trigger)
    then
        if message.enter then
            if self._helicopter_id == nil then
                self._helicopter_id = message.other_id
                self._in_area_timer = 0
            end
        else
            if self._helicopter_id == message.other_id then
                self._helicopter_id = nil
            end
        end
    end

    if message_id == hash('unboarded_person') and sender_go_url == msg.url(self._helicopter_id) then
        if self._passenger == nil then
            self._passenger = message.person_id
        end
    end
end

return TaxiJob
