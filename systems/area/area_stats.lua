require 'data.types'

local AreaStat = {}

---@return AreaStat
function AreaStat._create_empty_stats()
    ---@type AreaStat
    local stats = {
        population = 0,
        segment_counts = {},
        income = 0,
        income_breakdown = {}
    }
    return stats
end

-- ---@type AreaStat
-- local State = M._create_empty_stats()

---@param buildings Building[]
---@param stats AreaStat
function AreaStat._collect_segments(buildings, stats)
    for _, b in ipairs(buildings) do
        local segment_spec = b:get_trait_spec(TRAIT_NAME.segment) --[[@as SegmentTraitSpec]]
        if segment_spec then
            local seg = segment_spec.segment
            stats.segment_counts[seg] = (stats.segment_counts[seg] or 0) + 1
        end
    end
end

---@param buildings Building[]
---@param stats AreaStat
function AreaStat._collect_population(buildings, stats)
    for _, b in ipairs(buildings) do
        local pop_spec = b:get_trait_spec(TRAIT_NAME.population) --[[@as PopulationTraitSpec]]
        if pop_spec then
            stats.population = stats.population + pop_spec.amount
        end
    end
end

---@param spec IncomeTraitSpec
---@param stats AreaStat
function AreaStat._compute_income_spec(spec, stats)
    if spec.type == "flat" then
        return spec.amount
    end

    if spec.type == "per_stat" then
        local value = stats[spec.stat] or 0
        return value * spec.rate
    end

    if spec.type == "per_segment" then
        local count = stats.segment_counts[spec.segment] or 0
        return count * spec.rate
    end

    if spec.type == "per_stat_scaled" then
        local value = stats[spec.stat] or 0
        return (value ^ spec.exponent) * spec.rate
    end

    return 0
end

---@param buildings Building[]
---@param stats AreaStat
function AreaStat._calculate_income(buildings, stats)
    for _, b in ipairs(buildings) do
        local income_spec = b:get_trait_spec(TRAIT_NAME.income) --[[@as IncomeTraitSpec]]
        if income_spec then
            local income = AreaStat._compute_income_spec(income_spec, stats)

            stats.income = stats.income + income
            stats.income_breakdown[b.id] = income
        end
    end
end

---@param buildings Building[]
function AreaStat.calculate(buildings)
    local stats = AreaStat._create_empty_stats()

    AreaStat._collect_segments(buildings, stats)
    AreaStat._collect_population(buildings, stats)
    AreaStat._calculate_income(buildings, stats)

    return stats
end

return AreaStat
