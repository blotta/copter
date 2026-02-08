-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local PersonMoveGoal = {}
PersonMoveGoal.__index = PersonMoveGoal

function PersonMoveGoal.new(data)
	local o = {}
	setmetatable(o, PersonMoveGoal)
	
	o.started = false
	o.target = data.position
	o.tolerance = data.tolerance or 10
	
	return o
end

function PersonMoveGoal:start(person)
	local diff = self.target - go.get_position()
	person.facing = diff.x > 0 and 1 or -1
	person.velocity.x = person.speed * person.facing

	--sprite.play_flipbook("#sprite", person.def.anim.run)
	--sprite.set_hflip("#sprite", person.facing == -1)
	msg.post("#", 'start_animation', { anim = person.def.anim.run, hflip = person.facing == -1 })

	self.started = true
end

function PersonMoveGoal:update(person, dt)
	-- movement handled in person fixed update
end

function PersonMoveGoal:is_complete(person)
	local diff = self.target - go.get_position()
	return math.abs(diff.x) <= self.tolerance
end

function PersonMoveGoal:is_blocked(person)
	return false
end

function PersonMoveGoal:stop(person)
	person.velocity.x = 0
end

return PersonMoveGoal