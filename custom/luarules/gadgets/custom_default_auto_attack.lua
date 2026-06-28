function gadget:GetInfo()
	local config = VFS.Include("custom/configs/map_customizations.lua", nil, VFS.ZIP)

	return {
		name = "Custom Default Auto Attack",
		desc = "Sets newly built attacking units to fire at will on configured maps",
		author = "custom",
		date = "2026-06-28",
		license = "GPLv2",
		layer = 100000,
		enabled = config.IsCurrentMapEnabled(),
	}
end

if not gadgetHandler:IsSyncedCode() then
	return
end

local CMD_FIRE_STATE = CMD.FIRE_STATE
local FIRE_AT_WILL = 2
local spGiveOrderToUnit = Spring.GiveOrderToUnit

local function shouldSetAutoAttack(unitDefID)
	local unitDef = UnitDefs[unitDefID]
	return unitDef and unitDef.canAttack and not unitDef.isFactory
end

local function setAutoAttack(unitID, unitDefID)
	if shouldSetAutoAttack(unitDefID) then
		spGiveOrderToUnit(unitID, CMD_FIRE_STATE, { FIRE_AT_WILL }, 0)
	end
end

function gadget:UnitFinished(unitID, unitDefID)
	setAutoAttack(unitID, unitDefID)
end

function gadget:UnitFromFactory(unitID, unitDefID)
	setAutoAttack(unitID, unitDefID)
end
