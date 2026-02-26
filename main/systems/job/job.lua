require 'main.systems.defs'

---@class Job
---@field job_type JOB_TYPE
---@field job_id string
---@field building_id number
---@field status JOB_STATUS
---@field def JobDef
Job = {}
Job.__index = Job
Job._next_id = 1

---@param building Building
---@return Job
function Job.new(building)
    o = {}
    setmetatable(o, Job)

    o.job_id = Job._next_id
    Job._next_id = Job._next_id + 1
    o.job_type = building.job_type
    o.building_id = building.id
    o.status = JOB_STATUS.available
    for k, v in pairs(DEFS.job[o.job_type]) do
        o[k] = v
    end

    return o
end

