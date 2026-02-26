require 'main.systems.types'

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
---@field traits (TRAIT_NAME|{[TRAIT_NAME]: any})[]

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
        [TRAIT_NAME.commercial] = {
            processors = {}
        },
        [TRAIT_NAME.residential] = {
            processors = {}
        },
        [TRAIT_NAME.industrial] = {
            processors = {}
        },
        [TRAIT_NAME.utility] = {
            processors = {}
        },
        [TRAIT_NAME.job] = {
            processors = {
                apply = function(b, val)
                    b.job_type = val.args.job_type
                end
            }
        },
    },
    ---@type table<INFRA_TYPE,InfraDef>
    infra = {
        [INFRA_TYPE.helipad] = {
            traits = {
                TRAIT_NAME.utility,
                [TRAIT_NAME.landing_spot] = {
                    landing_point_offset = vmath.vector3(0, 48, 0),
                }
            }
        },
        [INFRA_TYPE.house] = {
            traits = {
                TRAIT_NAME.residential
            },
        },
        [INFRA_TYPE.taxi] = {
            traits = {
                TRAIT_NAME.commercial,
                [TRAIT_NAME.job] = {
                    job_type = JOB_TYPE.taxi
                }
            },
        },
        [INFRA_TYPE.lumbermill] = {
            traits = {
                TRAIT_NAME.industrial
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
