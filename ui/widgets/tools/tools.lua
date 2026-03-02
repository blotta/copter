local druid = require("druid.druid")
local monarch = require('monarch.monarch')
local event = require('event.event')

local M = {}

local function on_tools_clicked(self)
    self.hide_minimap()
    monarch.show('wnd_purchase_building')

    monarch.on_focus_changed("wnd_purchase_building", function(message_id, message)
        if message_id == monarch.FOCUS.LOST then
            self.show_minimap()
        end
    end)
end

function M.init(self, template_name)
    self.druid:new_button(template_name .. "/tools_button/root", on_tools_clicked)
end

return M
