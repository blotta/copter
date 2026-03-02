local D = require 'data.defs'

---@class Building
---@field id number
---@field go_id hash
---@field main_infra_type INFRA_TYPE
---@field traits table<TRAIT_NAME, Trait>
---@field infras Infra[]
---@field landing_point_offset vector3
---@field job_type? JOB_TYPE
---@field population number
local Building = {}
Building.__index = Building

---@param id number
---@param go_id hash
---@param main_infra_type INFRA_TYPE
---@return Building
function Building.new(id, go_id, main_infra_type)
    if not D.infra_has_trait(main_infra_type, TRAIT_NAME.segment) then
        error('Building must have a main infra with segment trait')
    end
    local self = {
        id = id,
        go_id = go_id,
        main_infra_type = main_infra_type,
        infras = {},

        traits = {},
        landing_point_offset = vmath.vector3(),
        job_type = nil
    }
    setmetatable(self, Building)
    return self
end

function Building:reset_traits()
    -- self.infra = {}
    self.traits = {}
    self.job_type = nil
    self.population = 0
    self.landing_point_offset = vmath.vector3()
end

---@param infra Infra
function Building:add_infra(infra)
    if #self.infras == 0 and infra.infra_type ~= self.main_infra_type then
        error('first infra added must be of building main infra type')
    end
    table.insert(self.infras, infra)
    self:reapply_traits()
end

function Building:reapply_traits()
    self:reset_traits()

    ---@type table<TRAIT_NAME, Trait>
    local new_traits = {}

    for _, infra in ipairs(self.infras) do
        local infra_def = DEFS.building.infra[infra.infra_type]
        for trait_name, trait_args in pairs(infra_def.traits) do
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
