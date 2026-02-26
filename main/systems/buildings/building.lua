require 'main.systems.defs'

---@class Building
---@field id number
---@field go_id hash
---@field traits table<TRAIT_NAME, Trait>
---@field infras Infra[]
---@field landing_point_offset vector3
---@field job_type? JOB_TYPE
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
        landing_point_offset = vmath.vector3(),
        job_type = nil
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
        local infra_def = DEFS.building.infra[infra.infra_type]
        for k, v in pairs(infra_def.traits) do
            local trait_name = type(k) == "string" and k or v --[[@as TRAIT_NAME]]
            local trait_args = type(k) == "string" and v or {} --[[@as any]]

            local trait_def = DEFS.building.trait[trait_name]

            local trait_value = {
                infra = infra,
                args = trait_args
            }

            if trait_def.processors.apply ~= nil then
                trait_def.processors.apply(self, trait_value)
            end
            new_traits[trait_name] = trait_value
        end
    end

    self.traits = new_traits
end

return Building
