local TraitProcessors = require 'main.systems.buildings.traits'
local InfraDefs = require 'main.systems.buildings.infra_defs'

---@class Building
---@field id number
---@field go_id hash
---@field traits table<TRAIT_NAME, Trait>
---@field infras Infra[]
---@field landing_point_offset vector3
local Building = {}
Building.__index = Building

---@param id number
---@param go_id hash
---@return Building
function Building.new(id, go_id)
    local self = {
        id = id,
        go_id = go_id,
        infras = {},

        traits = {},
        job_type = nil,
        landing_point_offset = vmath.vector3()
    }
    setmetatable(self, Building)
    return self
end

function Building:reset()
    -- self.infra = {}
    self.traits = {}
    self.job_type = nil
    self.landing_point_offset = vmath.vector3()
end

---@param infra Infra
function Building:add_infra(infra)
    table.insert(self.infras, infra)
    self:reapply_traits()
end

function Building:reapply_traits()
    self:reset()

    ---@type table<TRAIT_NAME, Trait>
    local new_traits = {}

    for _, infra in ipairs(self.infras) do
        local infra_def = InfraDefs[infra.infra_type]
        for k, v in pairs(infra_def.traits) do
            local trait_name = type(k) == "string" and k or v --[[@as TRAIT_NAME]]
            local trait_args = type(k) == "string" and v or {} --[[@as any]]

            local trait_value = {
                infra = infra,
                args = trait_args
            }

            local trait_processor = TraitProcessors[trait_name]
            if trait_processor.apply ~= nil then
                trait_processor.apply(self, trait_value)
            end
            new_traits[trait_name] = trait_value
        end
    end

    self.traits = new_traits
end

return Building
