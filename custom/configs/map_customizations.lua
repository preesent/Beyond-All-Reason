local config = {
	enableAllMaps = false,

	-- Add exact map names here, lower-case matching is handled automatically.
	-- Example:
	-- ["Supreme Isthmus v1.1"] = true,
	enabledMaps = {
	},

	-- Optional plain text fragments matched against the lower-case map name.
	-- Example:
	-- "supreme isthmus",
	enabledMapNameFragments = {
		"faster than light",
		"faster_than_light",
	},
}

local function normalize(value)
	return string.lower(tostring(value or ""))
end

function config.IsMapEnabled(mapName)
	if config.enableAllMaps then
		return true
	end

	local lowerMapName = normalize(mapName)
	for enabledMapName, enabled in pairs(config.enabledMaps) do
		if enabled and normalize(enabledMapName) == lowerMapName then
			return true
		end
	end

	for _, fragment in ipairs(config.enabledMapNameFragments) do
		if string.find(lowerMapName, normalize(fragment), 1, true) then
			return true
		end
	end

	return false
end

function config.IsCurrentMapEnabled()
	return config.IsMapEnabled(Game and Game.mapName)
end

return config
