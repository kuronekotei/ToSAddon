--[[
	日本語
--]]

_G['TPFARMED'] = _G['TPFARMED'] or {};
local g4 = _G['TPFARMED'];
g4.settingPath = g4.settingpath or "../addons/tpfarmed/stg_tpfarmed.json";
g4.settings = g4.settings or {};
local s4 = g4.settings;

function TPFARMED_UI_ON_INIT(addon, frame)
	frame:SetEventScript(ui.LBUTTONUP, "TPFARMED_UI_LBUTTONUP");
	addon:RegisterMsg("GAME_START", "TPFARMED_UI_GAME_START");
end
