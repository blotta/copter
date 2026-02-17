---@enum TRAIT_NAME
TRAIT_NAME = {
    utility = "utility",
    residential = "residential",
    commercial = "commercial",
    industrial = "industrial",
    landing_spot = "landing-spot",
    job = "job",
}

---@class Trait
---@field infra Infra
---@field args any

---@class TraitProcessor
---@field apply fun(b: Building, val: Trait) | nil

---@type {[TRAIT_NAME]: TraitProcessor}
local TraitProcessors = {}

TraitProcessors[TRAIT_NAME.landing_spot] = {
    apply = function(b, val)
        local infra_pos_offset = go.get_position(val.infra.go_id)
        b.landing_point_offset = infra_pos_offset + val.args.landing_point_offset
    end
}

TraitProcessors[TRAIT_NAME.commercial] = {}
TraitProcessors[TRAIT_NAME.residential] = {}
TraitProcessors[TRAIT_NAME.industrial] = {}
TraitProcessors[TRAIT_NAME.utility] = {}

TraitProcessors[TRAIT_NAME.job] = {
    -- apply = function(b, val)
    --     b.job_type = val.args.job_type
    -- end
}

return TraitProcessors
