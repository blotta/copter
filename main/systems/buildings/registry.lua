local Building = require 'main.systems.buildings.building'
local BuildingRegistry = {}

BuildingRegistry._buildings = {}
BuildingRegistry._next_id = 1

function BuildingRegistry.register(go_id) --, variant_hash)
    local id = BuildingRegistry._next_id
    BuildingRegistry._next_id = id + 1

    local building = Building.new(id, go_id)

    BuildingRegistry._buildings[id] = building

    return id
end

function BuildingRegistry.add_infra(bid, infra)
    BuildingRegistry._buildings[bid]:add_infra(infra)
end

function BuildingRegistry.remove(id)
    BuildingRegistry._buildings[id] = nil
end

function BuildingRegistry.get_all()
    return BuildingRegistry._buildings
end

function BuildingRegistry.get(id)
    return BuildingRegistry._buildings[id]
end

function BuildingRegistry.get_with_trait(trait_str)
    local list = {}

    for i, b in ipairs(BuildingRegistry._buildings) do
        for tk, _ in pairs(b.traits) do
            if tk == trait_str then
                table.insert(list, b)
            end
        end
    end

    return list
end

function BuildingRegistry.get_all_with_jobs()
    local list = {}
    for id, data in pairs(BuildingRegistry._buildings) do
        if data.jobs ~= nil then
            table.insert(list, data)
        end
    end
    return list
end

function BuildingRegistry.get_random(options)
    local opts = options or {}
    local except_ids = opts.except_ids or {}

    if not except_ids or #except_ids == 0 then
        return BuildingRegistry._buildings[math.random(#BuildingRegistry._buildings)]
    end

    local excluded = {}
    for _, id in ipairs(except_ids) do
        excluded[id] = true
    end

    local candidates = {}

    for _, item in ipairs(BuildingRegistry._buildings) do
        if not excluded[item.id] then
            table.insert(candidates, item)
        end
    end

    if #candidates == 0 then
        return nil
    end

    return candidates[math.random(#candidates)]
end

return BuildingRegistry
