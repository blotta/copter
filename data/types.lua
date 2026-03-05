---@alias BuildingId number

---@class Building
---@field id BuildingId
---@field go_id hash
---@field main_infra_type INFRA_TYPE
---@field traits table<TRAIT_NAME, BuildingTrait>
---@field infras BuildingInfra[]
---@field landing_point_offset vector3
---@field job {type: JOB_TYPE|nil, current: Job | nil, completed: number}
---@field earnings { income: number, job: number}

---@enum SEGMENT_NAME
SEGMENT_NAME = {
    residential = "residential",
    commercial = "commercial",
    industrial = "industrial"
}
SEGMENT_NAMES = {
    SEGMENT_NAME.residential,
    SEGMENT_NAME.commercial,
    SEGMENT_NAME.industrial
}

---@enum TRAIT_NAME
TRAIT_NAME = {
    utility = "utility",
    segment = "segment",
    landing_spot = "landing-spot",
    job = "job",
    build = "build",
    population = "population",
    income = "income"
}

---@enum INFRA_TYPE
INFRA_TYPE = {
    helipad = hash('helipad'),
    taxi = hash('taxi'),
    house = hash('house'),
    lumbermill = hash('lumbermill'),
}

---@alias TraitSpec table
---@alias SegmentTraitSpec {segment: SEGMENT_NAME}
---@alias PopulationTraitSpec {amount: number}
---@alias IncomeTraitSpec {type: 'flat', amount: number} | {type: 'per_stat', stat: AREA_STAT_NAME, rate: number} | {type: 'per_segment', segment: SEGMENT_NAME} | {type: 'per_stat_scaled', stat: AREA_STAT_NAME, rate: number, exponent: number}

---@class BuildingTrait
---@field infra BuildingInfra
---@field spec TraitSpec

---@class BuildingInfra
---@field go_id hash
---@field infra_type INFRA_TYPE


---@class AreaStat
---@field population number
---@field segment_counts table<SEGMENT_NAME,number>
---@field income number
---@field income_breakdown table<number,number>

---@enum AREA_STAT_NAME
AREA_STAT_NAME = {
    population = "population",
    population_income_rate = "population_income_rate"
}

---@enum JOB_TYPE
JOB_TYPE = {
    taxi = hash('taxi')
}

---@enum JOB_STATUS
JOB_STATUS = {
    available = 'available',
    in_progress = 'in-progress',
    completed = 'completed',
    cancelled = 'cancelled'
}
