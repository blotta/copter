local TaxiJobClass = require 'main.systems.job.processors.taxi'

local JobFactory = {}

JobFactory[JOB_TYPE.taxi] = TaxiJobClass

function JobFactory.create(building)
    local job = JobFactory[building.traits.job.args.job_type].new(building)
    return job
end

return JobFactory
