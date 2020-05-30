--[[
	日本語
--]]

function TPFARM_UI_ON_INIT(addon, frame)
	frame:SetEventScript(ui.LBUTTONUP, "TPFARM_UI_LBUTTONUP");
	addon:RegisterMsg("TPUTIL_START", "TPFARM_UI_GAME_START");
end
