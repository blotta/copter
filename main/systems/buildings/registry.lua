local Building = require 'main.systems.buildings.building'

---@module 'BuildingRegistry'
local BuildingRegistry = {}

---@type table<number,Building>
BuildingRegistry._buildings = {}
BuildingRegistry._next_id = 1

---@param go_id hash
---@return number
function BuildingRegistry.register(go_id)
    local id = BuildingRegistry._next_id
    BuildingRegistry._next_id = id + 1

    local building = Building.new(id, go_id)

    BuildingRegistry._buildings[id] = building

    return id
end

---@param bid number
---@param infra Infra
function BuildingRegistry.add_infra(bid, infra)
    BuildingRegistry._buildings[bid]:add_infra(infra)
end

---@param id number
function BuildingRegistry.remove(id)
    BuildingRegistry._buildings[id] = nil
end

---@return Building[]
function BuildingRegistry.get_all()
    return BuildingRegistry._buildings
end

---@param id number
---@return Building
function BuildingRegistry.get(id)
    return BuildingRegistry._buildings[id]
end

---@param trait_str TRAIT_NAME
---@return Building[]
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

-- function BuildingRegistry.get_all_with_jobs()
--     local list = {}
--     for id, data in pairs(BuildingRegistry._buildings) do
--         if data.jobs ~= nil then
--             table.insert(list, data)
--         end
--     end
--     return list
-- end

---@param options {except_ids?: number[]}
---@return Building | nil
function BuildingRegistry.get_random(options)
    options = options or {}
    local except_ids = options.except_ids or {}

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
