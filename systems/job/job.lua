require 'data.defs'

---@alias JobId number

---@class Job
---@field job_id JobId
---@field job_type JOB_TYPE
---@field building_id number
---@field status JOB_STATUS
---@field def JobDef
---@field reward? {money: number, exp: number}
---@field start fun(self: Job)
---@field update fun(self: Job, dt: number)
---@field on_message fun(self: Job, message_id: hash, message: any, sender: url)
---@field to_msg fun(self: Job):table
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
    o.job_type = building.job.type
    o.building_id = building.id
    o.status = JOB_STATUS.available
    for k, v in pairs(DEFS.job[o.job_type]) do
        o[k] = v
    end

    return o
end

