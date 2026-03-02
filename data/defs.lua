require 'data.types'
local helpers = require "helpers.helpers"

DEFS = {}

----------------------------
---------- PERSON ----------
----------------------------
DEFS.person = {
    [hash('normal1')] = {
        speed = 64,
        anim = {
            idle = hash('normal1_idle'),
            run = hash('normal1_run'),
            fall = hash('normal1_fall'),
        }
    },
    [hash('normal2')] = {
        speed = 64,
        anim = {
            idle = hash('normal2_idle'),
            run = hash('normal2_run'),
            fall = hash('normal2_fall'),
        }
    }
}

------------------------------
---------- BUILDING ----------
------------------------------

---@alias TraitProcessorParams {infra: Infra, args: any}

---@class TraitDef
---@field processors ({apply?: fun(b:Building, val: TraitProcessorParams)})

---@class InfraDef
---@field name string
---@field description string
---@field image string
---@field traits table<TRAIT_NAME, any>)

DEFS.building = {
    ---@type table<TRAIT_NAME,TraitDef>
    trait = {
        [TRAIT_NAME.landing_spot] = {
            processors = {
                apply = function(b, val)
                    local infra_pos_offset = go.get_position(val.infra.go_id)
                    b.landing_point_offset = infra_pos_offset + val.args.landing_point_offset
                end
            }
        },
        [TRAIT_NAME.segment] = {
            processors = {}
        },
        -- [TRAIT_NAME.residential] = {
        --     processors = {}
        -- },
        -- [TRAIT_NAME.commercial] = {
        --     processors = {}
        -- },
        -- [TRAIT_NAME.industrial] = {
        --     processors = {}
        -- },
        [TRAIT_NAME.utility] = {
            processors = {}
        },
        [TRAIT_NAME.build] = {
            processors = {}
        },
        [TRAIT_NAME.job] = {
            processors = {
                apply = function(b, val)
                    b.job_type = val.args.job_type
                end
            }
        },
        [TRAIT_NAME.population] = {
            processors = {
                apply = function(b, val)
                    b.population = b.population + val.args.amount
                end
            }
        }
    },
    ---@type table<INFRA_TYPE,InfraDef>
    infra = {
        [INFRA_TYPE.helipad] = {
            name = "Helipad",
            description = "A cozy landing spot",
            image = "infra-helipad",
            traits = {
                [TRAIT_NAME.utility] = {},
                [TRAIT_NAME.build] = {
                    cost = 200
                },
                [TRAIT_NAME.landing_spot] = {
                    landing_point_offset = vmath.vector3(0, 48, 0),
                }
            }
        },
        [INFRA_TYPE.house] = {
            name = "House",
            description = "People need somewhere to live",
            image = "infra-house",
            traits = {
                [TRAIT_NAME.segment] = {
                    segment = SEGMENT_NAME.residential
                },
                [TRAIT_NAME.population] = {
                    amount = 2
                },
                [TRAIT_NAME.build] = {
                    cost = 200
                }
            },
        },
        [INFRA_TYPE.taxi] = {
            name = "Taxi",
            description = 'Think "flying cabs"',
            image = "infra-taxi",
            traits = {
                [TRAIT_NAME.segment] = {
                    segment = SEGMENT_NAME.commercial
                },
                [TRAIT_NAME.build] = {
                    cost = 500
                },
                [TRAIT_NAME.job] = {
                    job_type = JOB_TYPE.taxi
                }
            },
        },
        [INFRA_TYPE.lumbermill] = {
            name = "Lumbermill",
            description = "Refining wood since forever",
            image = "infra-lumbermill",
            traits = {
                [TRAIT_NAME.build] = {
                    cost = 1000
                },
                [TRAIT_NAME.segment] = {
                    segment = SEGMENT_NAME.industrial
                }
            },
        }
    }

}

------------------------------
------------ JOBS ------------
------------------------------

---@class JobDef
---@field name string
---@field reward {money: number, exp: number}

---@type table<JOB_TYPE,JobDef>
DEFS.job = {
    [JOB_TYPE.taxi] = {
        name = "Taxi",
        reward = {
            money = 10,
            exp = 0
        }
    }
}



------------------------------
---------- HELPERS -----------
------------------------------

local M = {}

---@param trait_name TRAIT_NAME
---@return bool
function M.infra_has_trait(infra_type, trait_name)
    return DEFS.building.infra[infra_type].traits[trait_name] ~= nil
end

---@param trait_name TRAIT_NAME
---@param infras? table<INFRA_TYPE,InfraDef>
---@return table<INFRA_TYPE,InfraDef>
function M.infra_with_trait(trait_name, infras)
    infras = infras or DEFS.building.infra

    ---@type table<INFRA_TYPE,InfraDef>
    local ret = {}

    for infra_type, infra_def in pairs(infras) do
        if M.infra_has_trait(infra_type, trait_name) then
            ret[infra_type] = helpers.deepcopy(infra_def)
        end
    end

    return ret
end

---@param trait_names TRAIT_NAME[]
---@param infras? table<INFRA_TYPE,InfraDef>
---@return table<INFRA_TYPE,InfraDef>
function M.infra_with_traits(trait_names, infras)
    infras = infras or DEFS.building.infra

    ---@type table<INFRA_TYPE,InfraDef>
    local ret = {}

    for infra_type, infra_def in pairs(infras) do
        local include = true
        for _, trait_name in ipairs(trait_names) do
            if not M.infra_has_trait(infra_type, trait_name) then
                include = false
            end
        end
        if include then
            ret[infra_type] = helpers.deepcopy(infra_def)
        end
    end

    return ret
end

return M
