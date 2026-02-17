---@enum JOB_TYPE
JOB_TYPE = {
    taxi = hash('taxi')
}

---@enum JOB_STATUS
JOB_STATUS = {
    available = 'available',
    in_progress = 'in-progress',
    completed = 'completed',
    cancelled = 'cancelled'
}

---@class JobDef
---@field name string
---@field reward {money: number, exp: number}

---@type table<JOB_TYPE, JobDef>
local JobDefs = {}

JobDefs[JOB_TYPE.taxi] = {
    name = "Taxi",
    reward = {
        money = 10,
        exp = 0
    }
}

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
    o.job_type = building.traits[TRAIT_NAME.job].args.job_type
    o.building_id = building.id
    o.status = JOB_STATUS.available
    o.def = JobDefs[o.job_type]

    pprint(o)

    return o
end

return JobDefs
