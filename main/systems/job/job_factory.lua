local job_defs = require 'main.systems.job.defs'
local taxi_job = require 'main.systems.job.processors.taxi'

local M = {}

M[hash('taxi')] = taxi_job

function M.create(job_type_hash, opts)
    return M[job_type_hash].new(opts)
end

return M
