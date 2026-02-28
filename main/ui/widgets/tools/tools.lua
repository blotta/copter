local druid = require("druid.druid")
local monarch = require('monarch.monarch')
local event = require('event.event')

local M = {}

local function on_tools_clicked(self)
    print('tools button clicked')
    self.hide_minimap()
    monarch.show('wnd_create_building')
    --nil,   -- { on_back = event.create(self.show_minimap) },
    --event.create(self.hide_minimap))

    monarch.on_focus_changed("wnd_create_building", function(message_id, message)
        if message_id == monarch.FOCUS.LOST then
            print('back from wnd_create_building')
            -- local data = monarch.data('wnd_create_building')
            -- pprint(data)
            self.show_minimap()
        end
    end)
end

function M.init(self, template_name)
    self.druid:new_button(template_name .. "/tools_button/root", on_tools_clicked)
end

return M
