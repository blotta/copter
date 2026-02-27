local druid = require("druid.druid")
local monarch = require('monarch.monarch')
local event = require('event.event')

local M = {}

local function on_tools_clicked(self)
	print('tools button clicked')
	monarch.show('wnd_create_building', nil, {
        on_back = event.create(self.show_minimap)
    }, event.create(self.hide_minimap))
end

function M.init(self, template_name)
    -- self.druid = druid.new(self)
    self.druid:new_button(template_name .. "/tools_button/root", on_tools_clicked)

end

return M