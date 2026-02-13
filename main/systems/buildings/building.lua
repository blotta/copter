local Traits = require 'main.systems.buildings.traits'
local InfraDefs = require 'main.systems.buildings.infra_defs'

local Building = {}
Building.__index = Building

function Building.new(id, go_id)
    local b = {
        id = id,
        go_id = go_id,
        infra = {},

        traits = {},
        job_type = nil,
        landing_point_offset = vmath.vector3()
    }
    setmetatable(b, Building)
    return b
end

function Building:reset()
    -- self.infra = {}
    self.traits = {}
    self.job_type = nil
    self.landing_point_offset = vmath.vector3()
end

function Building:add_infra(infra)
    table.insert(self.infra, infra)
    self:reapply_traits()
end

function Building:reapply_traits()
    self:reset()

    local new_traits = {}

    for _, infra in ipairs(self.infra) do
        local infra_def = InfraDefs[infra.infra_type]
        for k, v in pairs(infra_def.traits) do
            local trait_str = type(k) == "string" and k or v
            local args = type(k) == "string" and v or {}

            local trait_processor = Traits[trait_str]
            if trait_processor.apply ~= nil then
                trait_processor.apply(self, args)
            end
            new_traits[trait_str] = args
            new_traits[trait_str].infra = infra
        end
    end

    self.traits = new_traits
end

return Building
