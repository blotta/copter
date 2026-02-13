local jobs = {}

jobs[hash("taxi")] = {
    job_type = hash("taxi"),
    status = 'pickup',
    name = "taxi",
    from = vmath.vector3(),
    to = vmath.vector3(),
    reward = {
        money = 10,
        exp = 0
    }
}

return jobs
