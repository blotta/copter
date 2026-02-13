local jobs = require 'main.systems.job.defs'
local building_registry = require 'main.systems.buildings.registry'

local TaxiJob = {}
TaxiJob.__index = TaxiJob
TaxiJob._next_id = 1

function TaxiJob.new()
    local o = {}
    setmetatable(o, TaxiJob)

    local def = jobs[hash('taxi')]

    -- assumes there are at least 2 buildings in the game
    local from_building = building_registry.get_random()
    if from_building == nil then return nil end
    local to_building = building_registry.get_random({ except_ids = { from_building.id } })
    if to_building == nil then return nil end

    o.job_id = 'taxi_' .. TaxiJob._next_id
    TaxiJob._next_id = TaxiJob._next_id + 1
    o.job_type = hash('taxi')
    o.status = 'pickup' -- boarding, deliver, unboarding, completed, cancelled
    o.from = from_building
    o.to = to_building
    o.pickup_position = go.get(from_building.go_id, "position")
    if from_building.capabilities.helipad then
        local helipad_offset = g
    end
    o.pickup_position = go.get(from_building.go_id, "position")
        + (from_building.capabilities.helipad or vmath.vector3())
    o.deliver_position = go.get(to_building.go_id, "position")
        + (to_building.capabilities.helipad or vmath.vector3())

    return o
end

function TaxiJob:start()
    -- send necessary messages
end

function TaxiJob:update(dt)
    if self.status == 'pickup' then
        -- check copter is in designated boarding area long enough
        -- possibly disable copter from moving
        -- spawn person with task BoardCopter
    elseif self.status == 'boarding' then
        -- check person boarded the copter
    elseif self.status == 'deliver' then
        -- possibly enable copter movement
        -- check copter is in designated unboarding area long enough
    elseif self.status == 'unboarding' then
        -- unboard (spawn) person from copter with task EnterBuilding
        -- reward player
    end
end

return TaxiJob
