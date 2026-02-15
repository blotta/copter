local TaxiJob = require 'main.systems.job.processors.taxi'

local M = {}

M[hash('taxi')] = TaxiJob

function M.create(building)
    local job = M[building.traits.job.job_type].new(building)
    return job
end

return M
