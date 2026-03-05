local D = require 'data.defs'

---@class Building
local Building = {}
Building.__index = Building

---@param id BuildingId
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
        job = {
            type = nil,
            current = nil,
            completed = 0
        },

        earnings = {
            income = 0,
            job = 0
        }
    }
    setmetatable(self, Building)
    return self
end

function Building:reset_traits()
    -- self.infra = {}
    self.traits = {}
    self.job.type = nil
    self.population = 0
    self.income_rate = {}
    self.landing_point_offset = vmath.vector3()
end

---@param infra BuildingInfra
function Building:add_infra(infra)
    if #self.infras == 0 and infra.infra_type ~= self.main_infra_type then
        error('first infra added must be of building main infra type')
    end
    table.insert(self.infras, infra)
    self:reapply_traits()
end

function Building:reapply_traits()
    self:reset_traits()

    ---@type table<TRAIT_NAME, BuildingTrait>
    local new_traits = {}

    for _, infra in ipairs(self.infras) do
        local infra_def = DEFS.building.infra[infra.infra_type]
        for trait_name, trait_spec in pairs(infra_def.traits) do
            local trait_def = DEFS.building.trait[trait_name]

            local trait_value = {
                infra = infra,
                spec = trait_spec
            }

            if trait_def.building_apply ~= nil then
                trait_def.building_apply(self, trait_value)
            end
            new_traits[trait_name] = trait_value
        end
    end

    self.traits = new_traits
end

---@param trait_name TRAIT_NAME
function Building:get_trait_spec(trait_name)
    local trait = self.traits[trait_name]
    if trait ~= nil then
        return trait.spec
    end
    return nil
end

---@param trait_name TRAIT_NAME
function Building:get_trait_spec_prop(trait_name, prop, default)
    local trait = self.traits[trait_name]
    if trait == nil or trait.spec[prop] == nil then
        return default
    end

    return trait.spec[prop]
end

return Building
