local infra_defs = {}

infra_defs[hash('helipad')] = {
    traits = {
        "utility",
        ["landing-spot"] = {
            landing_point_offset = vmath.vector3(0, 48, 0),
        }
    }
}

infra_defs[hash('house')] = {
    traits = {
        "residential"
    },
}

infra_defs[hash('taxi')] = {
    traits = {
        'commercial',
        ['job'] = {
            job_type = 'taxi'
        }
    },
}

infra_defs[hash('lumbermill')] = {
    traits = {
        'industrial'
    },
}

return infra_defs
