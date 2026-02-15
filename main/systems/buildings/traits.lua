local traits = {}

traits["landing-spot"] = {
    apply = function(b, args)
        local infra_pos_offset = go.get_position(args.infra.go_id)
        b.landing_point_offset = infra_pos_offset + args.landing_point_offset
    end
}

traits["utility"] = {}
traits["residential"] = {}
traits["commercial"] = {}
traits["industrial"] = {}

traits["job"] = {
    apply = function(b, args)
        b.job_type = args.job_type
    end
}

return traits
