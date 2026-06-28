function widget:GetInfo()
	local config = VFS.Include("custom/configs/map_customizations.lua", nil, VFS.ZIP)

	return {
		name = "Custom Minimal Map UI",
		desc = "Removes game UI widgets on configured maps while leaving map view and input available",
		author = "custom",
		date = "2026-06-28",
		license = "GPLv2",
		layer = 100000,
		enabled = config.IsCurrentMapEnabled(),
		handler = true,
	}
end

local keepWidgets = {
	["Custom Minimal Map UI"] = true,
}

local function removeOtherWidgets()
	for i = #widgetHandler.widgets, 1, -1 do
		local otherWidget = widgetHandler.widgets[i]
		local info = otherWidget and otherWidget.whInfo
		if info and not keepWidgets[info.name] then
			widgetHandler:RemoveWidget(otherWidget)
		end
	end
end

function widget:Initialize()
	removeOtherWidgets()
end

function widget:Update()
	removeOtherWidgets()
	widgetHandler:RemoveWidgetCallIn("Update", self)
end
