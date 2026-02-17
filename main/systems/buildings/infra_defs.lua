require 'main.systems.buildings.traits'

---@enum INFRA_TYPE
INFRA_TYPE = {
    helipad = hash('helipad'),
    taxi = hash('taxi'),
    house = hash('house'),
    lumbermill = hash('lumbermill'),
}

---@class Infra
---@field go_id hash
---@field infra_type INFRA_TYPE

---@class InfraDef
---@field traits (TRAIT_NAME|{[TRAIT_NAME]: any})[]

---@type table<hash,InfraDef>
local InfraDefs = {}

InfraDefs[INFRA_TYPE.helipad] = {
    traits = {
        TRAIT_NAME.utility,
        [TRAIT_NAME.landing_spot] = {
            landing_point_offset = vmath.vector3(0, 48, 0),
        }
    }
}

InfraDefs[INFRA_TYPE.house] = {
    traits = {
        TRAIT_NAME.residential
    },
}

InfraDefs[INFRA_TYPE.taxi] = {
    traits = {
        TRAIT_NAME.commercial,
        [TRAIT_NAME.job] = {
            job_type = hash('taxi')
        }
    },
}

InfraDefs[INFRA_TYPE.lumbermill] = {
    traits = {
        TRAIT_NAME.industrial
    },
}

return InfraDefs
