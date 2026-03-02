local M = {}

function M.init(self, template_name)
	self.stick_parent = gui.get_node(template_name .. "/root")
    gui.set_enabled(self.stick_parent, false)
	self.stick = gui.get_node(template_name .. "/stick")
	self.dragging = false
	self.start_drag_pos = vmath.vector3()
	self.max_stick_drag_radius = gui.get_size(self.stick_parent).x / 2
	self.max_stick_vec = vmath.vector3(self.max_stick_drag_radius, 0, 0)
	self.stick_drag = vmath.vector3()
	self.stick_value = vmath.vector3()
	self.stick_hide_timer = nil
end

function M.on_input(self, action_id, action)
	if action_id == hash('touch') then
		local touch_pos = vmath.vector3(action.screen_x, action.screen_y, 0)

		if self.dragging == false then
			if action.pressed then
				self.dragging = false
				self.start_drag_pos = touch_pos
			end

			if vmath.length_sqr(touch_pos - self.start_drag_pos) > 10 * 10 then
				self.dragging = true
				gui.set_enabled(self.stick_parent, true)
				gui.set_screen_position(self.stick_parent, self.start_drag_pos)
				gui.set_screen_position(self.stick, touch_pos)
				return true
			end

            return false
		else
			if action.pressed and self.stick_hide_timer ~= nil then
				timer.cancel(self.stick_hide_timer)
			end

			if action.released then
				gui.set_screen_position(self.stick, gui.get_screen_position(self.stick_parent))
				msg.post("/copter#copter", "throttle-inactive")
				msg.post("/copter#copter", "pitch-inactive")
				self.stick_hide_timer = timer.delay(2, false, function()
					self.dragging = false
					gui.set_enabled(self.stick_parent, false)
					self.stick_hide_timer = nil
				end)
				return true
			end

			self.stick_drag = touch_pos - self.start_drag_pos

			if vmath.length_sqr(self.stick_drag) > self.max_stick_drag_radius * self.max_stick_drag_radius then
				local touch_start_angle = vmath.quat_rotation_z(math.atan2(self.stick_drag.y, self.stick_drag.x))
				self.stick_drag = vmath.rotate(touch_start_angle, self.max_stick_vec)
				touch_pos = self.start_drag_pos + self.stick_drag
			end

			gui.set_screen_position(self.stick, touch_pos)

			self.stick_value.x = self.stick_drag.x / self.max_stick_drag_radius
			if math.abs(self.stick_value.x) < 0.2 then
				self.stick_value.x = 0
			end
			self.stick_value.y = self.stick_drag.y / self.max_stick_drag_radius
			if math.abs(self.stick_value.y) < 0.2 then
				self.stick_value.y = 0
			end

			-- adjust stick_value to negate the copter's rotation, so fly direction is more intuitive
			local inv_rot = vmath.conj(self.copter_rotation)
			self.stick_value = vmath.rotate(inv_rot, self.stick_value)

			if self.stick_value.x ~= 0 then
				msg.post("/copter#copter", "pitch-active", { value = self.stick_value.x })
			else
				msg.post("/copter#copter", "pitch-inactive")
			end

			if self.stick_value.y ~= 0 then
				msg.post("/copter#copter", "throttle-active", { value = self.stick_value.y })
			else
				msg.post("/copter#copter", "throttle-inactive")
			end

			return true
		end
        return false
	end
end

return M