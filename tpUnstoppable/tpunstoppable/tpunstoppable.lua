--[[
	日本語
--]]

local acutil = require('acutil');

_G['TPUNSTOPPABLE'] = _G['TPUNSTOPPABLE'] or {};
local g6 = _G['TPUNSTOPPABLE'];
g6.settingPath = g6.settingpath or "../addons/tpunstoppable/stg_tpunstoppable.json";
g6.settings = g6.settings or {};
local s6 = g6.settings;



function TPUNSTOPPABLE_ON_INIT(addon, frame)
	local f,m = pcall(g6.LOAD_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
		return;
	end
	f,m = pcall(g6.SAVE_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
		return;
	end
	if(g6.O_START_CRAFT==nil) then
		g6.O_START_CRAFT = CRAFT_START_CRAFT;
		CRAFT_START_CRAFT = g6.H_START_CRAFT;
	end
	if(g6.O_CRAFT_FAIL==nil) then
		g6.O_CRAFT_FAIL = CRAFT_DETAIL_CRAFT_EXEC_ON_FAIL;
		CRAFT_DETAIL_CRAFT_EXEC_ON_FAIL = g6.H_CRAFT_FAIL;
	end
	if(g6.O_CRAFT_SUCCESS==nil) then
		g6.O_CRAFT_SUCCESS = CRAFT_DETAIL_CRAFT_EXEC_ON_SUCCESS;
		CRAFT_DETAIL_CRAFT_EXEC_ON_SUCCESS = g6.H_CRAFT_SUCCESS;
	end
	g6.failCount = 0;
end
function g6.LOAD_SETTING()
	local t, err = acutil.loadJSON(g6.settingPath);
	if t then
		s6 = acutil.mergeLeft(s6, t);
	end
	-- 	値の存在確保と初期値設定
	s6.isDebug			= ((type(s6.isDebug			) == "boolean")	and s6.isDebug			)or false;
	s6.actCount			= ((type(s6.actCount		) == "number")	and s6.actCount			)or 3;
end

function g6.SAVE_SETTING()
	local filep = io.open(g6.settingPath,"w+");
	if filep then
		filep:write("{\n");
		filep:write("\t\"isDebug\":"		.. ((s6.isDebug			and "true") or "false")	.."\n"	);
		filep:write(",\t\"actCount\":"		.. (s6.actCount			or 3) .."\n"		);
		filep:write("}\n");
		filep:close();
	end
end
function g6.H_START_CRAFT(idSpace, recipeName, totalCount)
	g6.failCount = 0;
	return g6.O_START_CRAFT(idSpace, recipeName, totalCount);
end
function g6.H_CRAFT_FAIL(frame, msg, str, time)
	g6.failCount = g6.failCount +1;
	CHAT_SYSTEM("CRAFT_FAIL:" .. g6.failCount);
	if(g6.failCount >= s6.actCount) then
		return g6.O_CRAFT_FAIL(frame, msg, str, time);
	end
	return g6.O_CRAFT_SUCCESS(frame, msg, str, time);
end
function g6.H_CRAFT_SUCCESS(frame, msg, str, time)
	g6.failCount = 0;
	return g6.O_CRAFT_SUCCESS(frame, msg, str, time);
end
