require("data.defs")

local InfraFactory = {}

local infra_factory_map = {
    [INFRA_TYPE.house] = "#house_factory",
    [INFRA_TYPE.taxi] = "#taxi_factory",
    [INFRA_TYPE.lumbermill] = "#lumbermill_factory",
    [INFRA_TYPE.helipad] = "#helipad_factory",
}

---@param infra_type INFRA_TYPE
---@param pos? vector3
---@param rot? vector4
---@param extra_props? table
function InfraFactory.create(infra_type, pos, rot, extra_props)
    local props = {infra_type = infra_type}
    if extra_props ~= nil then
        for k, v in pairs(extra_props) do
            props[k] = v
        end
    end
    local url = "/instantiator" .. infra_factory_map[infra_type]
    local infra = factory.create(url, pos, rot, props)
    return infra
end

return InfraFactory
