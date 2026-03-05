---This is a template for a StatList Druid widget.
---Instantiate this template with `druid.new_widget(widget_module, [template_id], [nodes])`.
---Read more about Druid Widgets here: ...

local layout = require 'druid.extended.layout'

---@class widget.stat_list: druid.widget
local M = {}

function M.id_for(self, id)
	if self:get_template() ~= "" then
		return self:get_template() .. "/" .. id
	else
		return id
	end
end

function M:init()
	self.item_prefab = self:get_node("item_prefab")
	gui.set_enabled(self.item_prefab, false)

	self.layout = self.druid:new(layout, self:get_node("layout"), "vertical")

	self.titles = {}
	self.items = {}
end

---@param title string
---@param desc string
---@param pos? number
function M:set_item(title, desc, pos)
	if self.items[title] == nil then
		local item_tree = gui.clone_tree(self.item_prefab)
		local item = item_tree[self:id_for('item_root')]

		local text_title_node = item_tree[self:id_for("text_title")]
		local text_desc_node = item_tree[self:id_for("text_desc")]

		gui.set_text(text_title_node, title)
		gui.set_text(text_desc_node, desc)

		gui.set_enabled(item, true)

		if pos then
			table.insert(self.titles, pos, title)
		else
			table.insert(self.titles, title)
		end
		self.items[title] = {
			desc_hash = hash(desc),
			title_node = text_title_node,
			desc_node = text_desc_node
		}
		self.layout:add(item)
		self.layout:refresh_layout()
	else
		if self.items[title].desc_hash ~= hash(desc) then
			gui.set_text(self.items[title].desc_node, desc)
			self.items[title].desc_hash = hash(desc)
		end
	end
end

return M
