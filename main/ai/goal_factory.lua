local PersonMoveGoal = require "main.ai.person.goals.move"

local M = {}

function M.create(entity_type, message)
	if entity_type == hash('person') then
		if message.type == "move" then
			return PersonMoveGoal.new(message)
		end
	end

	error("Unknown goal type: " .. tostring(message.type))
end

return M
