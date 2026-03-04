require 'data.types'
require 'systems.area.area_stats'
local colors = require 'helpers.colors'
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

---@alias TraitProcessorParams {infra: BuildingInfra, spec: TraitSpec}

---@class TraitDef
---@field building_apply? fun(b:Building, val: TraitProcessorParams)
---@field description_generator? fun(spec: TraitSpec):string

---@class InfraDef
---@field name string
---@field description string
---@field image string
---@field traits table<TRAIT_NAME, any>)

DEFS.building = {
    segment = {
        colors = {
            [SEGMENT_NAME.residential] = colors.hex_to_color(PALETTE.green, 0.75),
            [SEGMENT_NAME.commercial] = colors.hex_to_color(PALETTE.blue, 0.75),
            [SEGMENT_NAME.industrial] = colors.hex_to_color(PALETTE.yellow, 0.75),
        }
    },
    ---@type table<TRAIT_NAME,TraitDef>
    trait = {
        [TRAIT_NAME.landing_spot] = {
            building_apply = function(b, val)
                local infra_pos_offset = go.get_position(val.infra.go_id)
                b.landing_point_offset = infra_pos_offset + val.spec.landing_point_offset
            end,
            description_generator = function(spec)
                return ''
            end,
        },
        [TRAIT_NAME.segment] = {
            processors = {}
        },
        [TRAIT_NAME.utility] = {
            processors = {}
        },
        [TRAIT_NAME.build] = {
            processors = {}
        },
        [TRAIT_NAME.job] = {
            description_generator = function(spec)
                local job_def = DEFS.job[spec.job_type]
                return string.format("%s - $ %d", job_def.name, job_def.reward.money)
            end,
            building_apply = function(b, val)
                b.job_type = val.spec.job_type
            end
        },
        [TRAIT_NAME.population] = {
            description_generator = function(spec)
                return tostring(spec.amount)
            end,
        },
        [TRAIT_NAME.income] = {
            description_generator = function(spec)
                if spec.type == "flat" then
                    return string.format("$%.2f/s", spec.amount)
                end

                if spec.type == "per_stat" then
                    return string.format(
                        "$%.2f/%s/s",
                        spec.rate,
                        spec.stat
                    )
                end

                if spec.type == "per_segment" then
                    return string.format(
                        "$%.2f/%s building/second",
                        spec.rate,
                        spec.segment
                    )
                end

                if spec.type == "per_stat_scaled" then
                    return string.format(
                        "$%.2f × %s^%.2f/second",
                        spec.rate,
                        spec.stat,
                        spec.exponent
                    )
                end

                return ""
            end,
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
                [TRAIT_NAME.income] = {
                    type = "per_stat",
                    stat = AREA_STAT_NAME.population,
                    rate = 0.2
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

---@param infra InfraDef
---@return table<TRAIT_NAME, string>
function M.trait_descriptions(infra)
    local ret = {}

    for trait_name, spec in pairs(infra.traits) do
        local desc_fn = DEFS.building.trait[trait_name].description_generator
        if desc_fn ~= nil then
            ret[trait_name] = desc_fn(spec)
        end
    end

    return ret
end

return M
