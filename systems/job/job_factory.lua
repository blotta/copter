local TaxiJobClass = require 'systems.job.processors.taxi'

local JobFactory = {}

JobFactory[JOB_TYPE.taxi] = TaxiJobClass

---@return Job
function JobFactory.create(building)
    local job = JobFactory[building.job.type].new(building)
    return job
end

return JobFactory
