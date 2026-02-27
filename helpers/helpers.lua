
local M = {}

---Make a copy table with all nested tables (druid deepcopy)
---@param orig_table table Original table
---@return table Copy of original table
function M.deepcopy(orig_table)
	local orig_type = type(orig_table)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig_table, nil do
			copy[M.deepcopy(orig_key)] = M.deepcopy(orig_value)
		end
	else -- number, string, boolean, etc
		copy = orig_table
	end
	return copy
end

function M.group_by(input, key_getter)
    local result = {}

    for key, value in pairs(input) do
        local group_key = key_getter(value)

        if not result[group_key] then
            result[group_key] = {}
        end

        result[group_key][key] = value
    end

    return result
end

return M