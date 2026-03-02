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
    -- residential = "residential",
    -- commercial = "commercial",
    -- industrial = "industrial",
    segment = "segment",
    landing_spot = "landing-spot",
    job = "job",
    build = "build",
    population = "population"
}

---@enum INFRA_TYPE
INFRA_TYPE = {
    helipad = hash('helipad'),
    taxi = hash('taxi'),
    house = hash('house'),
    lumbermill = hash('lumbermill'),
}

---@class Trait
---@field infra Infra
---@field args any

---@class Infra
---@field go_id hash
---@field infra_type INFRA_TYPE



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
