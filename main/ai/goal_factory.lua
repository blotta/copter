local PersonDefaultGoal = require "main.ai.person.goals.default"
local PersonMoveGoal = require "main.ai.person.goals.move"
local PersonBoardHelicopterGoal = require "main.ai.person.goals.board_helicopter"
local PersonEnterBuildingGoal = require "main.ai.person.goals.enter_building"

local M = {}

function M.create(entity_type, data)
    if entity_type == hash('person') then
        if data.type == "default" then
            return PersonDefaultGoal.new(data)
        elseif data.type == "move" then
            return PersonMoveGoal.new(data)
        elseif data.type == "board_helicopter" then
            return PersonBoardHelicopterGoal.new(data)
        elseif data.type == "enter_building" then
            return PersonEnterBuildingGoal.new(data)
        end
    end

    error("Unknown goal type '" .. tostring(data.type) .. "' for entity_type " .. tostring(entity_type))
end

return M
