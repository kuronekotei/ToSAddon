--[[
	日本語
--]]

local acutil = require('acutil');

_G['TPAUTOCHAT'] = _G['TPAUTOCHAT'] or {};
local g8 = _G['TPAUTOCHAT'];
g8.settingPath = g8.settingpath or "../addons/tpautochat/stg_tpautochat.json";
g8.settings = g8.settings or {};
local s8 = g8.settings;

function TPAUTOCHAT_ON_INIT(addon, frame)
	local f,m = pcall(g8.TPAUTOCHAT_LOAD_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
		return;
	end
	f,m = pcall(g8.TPAUTOCHAT_SAVE_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
		return;
	end
 	addon:RegisterMsg("GAME_START", "TPAUTOCHAT_GAME_START")
	addon:RegisterMsg('INDUN_REWARD_RESULT', 'TPAUTOCHAT_LEVEL_END')
	addon:RegisterMsg('OPEN_INDUN_REWARD_HUD', 'TPAUTOCHAT_LEVEL_UPD')
end
function TPAUTOCHAT_GAME_START()
	g8.lvlCount = 0;
	g8.lvlScore = 0;
	g8.lvlStart = false;
	g8.lvlEnd = false;
end
function TPAUTOCHAT_LEVEL_UPD(frame, msg, argStr, argNum)
	local f,m = pcall(g8.TPAUTOCHAT_LEVEL_UPD, frame, msg, argStr, argNum);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end
function TPAUTOCHAT_LEVEL_END(frame, msg, argStr, argNum)
	local f,m = pcall(g8.TPAUTOCHAT_LEVEL_END, frame, msg, argStr, argNum);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end

function g8.TPAUTOCHAT_LOAD_SETTING()
	local t, err = acutil.loadJSON(g8.settingPath);
	if t then
		s8 = acutil.mergeLeft(s8, t);
	end
	-- 	値の存在確保と初期値設定
	s8.isDebug		= ((type(s8.isDebug			) == "boolean")	and s8.isDebug		)or false;
	s8.LevelIDStart	= ((type(s8.LevelIDStart	) == "string")	and s8.LevelIDStart	)or "$p よろしくお願いします";
	s8.LevelID20p	= ((type(s8.LevelID20p		) == "string")	and s8.LevelID20p	)or "$p 達成率20％";
	s8.LevelID40p	= ((type(s8.LevelID40p		) == "string")	and s8.LevelID40p	)or "$p 達成率40％";
	s8.LevelID60p	= ((type(s8.LevelID60p		) == "string")	and s8.LevelID60p	)or "$p 達成率60％";
	s8.LevelID80p	= ((type(s8.LevelID80p		) == "string")	and s8.LevelID80p	)or "$p 達成率80％";
	s8.LevelID100p	= ((type(s8.LevelID100p		) == "string")	and s8.LevelID100p	)or "$p 達成率100％!!ボス戦行けます!!";
	s8.LevelIDEnd	= ((type(s8.LevelIDEnd		) == "string")	and s8.LevelIDEnd	)or "$p お疲れ様でした{img emoticon_0001 24 24}{$}";
	s8.LevelIDExit	= ((type(s8.LevelIDExit		) == "boolean")	and s8.LevelIDExit	)or false;
	g8.LevelIDStart	= string.gsub(s8.LevelIDStart	,"%$","/");
	g8.LevelID20p	= string.gsub(s8.LevelID20p		,"%$","/");
	g8.LevelID40p	= string.gsub(s8.LevelID40p		,"%$","/");
	g8.LevelID60p	= string.gsub(s8.LevelID60p		,"%$","/");
	g8.LevelID80p	= string.gsub(s8.LevelID80p		,"%$","/");
	g8.LevelID100p	= string.gsub(s8.LevelID100p	,"%$","/");
	g8.LevelIDEnd	= string.gsub(s8.LevelIDEnd		,"%$","/");
end

function g8.TPAUTOCHAT_SAVE_SETTING()
	local filep = io.open(g8.settingPath,"w+");
	if filep then
		filep:write("{\n");
		filep:write("\t\"isDebug\":"			.. ((s8.isDebug			and "true") or "false")	.."\n"	);
		filep:write(",\t\"LevelIDStart\":\""	.. s8.LevelIDStart		.."\"\n"		);
		filep:write(",\t\"LevelID20p\":\""		.. s8.LevelID20p		.."\"\n"		);
		filep:write(",\t\"LevelID40p\":\""		.. s8.LevelID40p		.."\"\n"		);
		filep:write(",\t\"LevelID60p\":\""		.. s8.LevelID60p		.."\"\n"		);
		filep:write(",\t\"LevelID80p\":\""		.. s8.LevelID80p		.."\"\n"		);
		filep:write(",\t\"LevelID100p\":\""		.. s8.LevelID100p		.."\"\n"		);
		filep:write(",\t\"LevelIDEnd\":\""		.. s8.LevelIDEnd		.."\"\n"		);
		filep:write(",\t\"LevelIDExit\":"		.. ((s8.LevelIDExit		and "true") or "false")	.."\n"	);
		filep:write("}\n");
		filep:close();
	end
end

function g8.TPAUTOCHAT_LEVEL_UPD(frame, msg, argStr, argNum)
--	CHAT_SYSTEM((msg or "").."//"..(argStr or "").."//"..(argNum or "").."//");
	g8.lvlCount = g8.lvlCount +1;
	if (g8.lvlStart~=true and g8.lvlCount>3) then
		g8.lvlStart = true;
		if ((g8.LevelIDStart ~= nil) and (g8.LevelIDStart ~= "")) then
			ui.Chat(g8.LevelIDStart);
		end
		return;
	end
	if ((g8.lvlScore<100) and (argNum==100) and (g8.LevelID100p ~= nil) and (g8.LevelID100p ~= "")) then
		ui.Chat(g8.LevelID100p);
	elseif ((g8.lvlScore<80) and (argNum>=80) and (g8.LevelID80p ~= nil) and (g8.LevelID80p ~= "")) then
		ui.Chat(g8.LevelID80p);
	elseif ((g8.lvlScore<60) and (argNum>=60) and (g8.LevelID60p ~= nil) and (g8.LevelID60p ~= "")) then
		ui.Chat(g8.LevelID60p);
	elseif ((g8.lvlScore<40) and (argNum>=40) and (g8.LevelID40p ~= nil) and (g8.LevelID40p ~= "")) then
		ui.Chat(g8.LevelID40p);
	elseif ((g8.lvlScore<20) and (argNum>=20) and (g8.LevelID20p ~= nil) and (g8.LevelID20p ~= "")) then
		ui.Chat(g8.LevelID20p);
	end
	g8.lvlScore = argNum;
end

function g8.TPAUTOCHAT_LEVEL_END(frame, msg, argStr, argNum)
--	CHAT_SYSTEM((msg or "").."//"..(argStr or "").."//"..(argNum or ""));
	if (g8.lvlEnd~=true) then
		g8.lvlEnd = true;
		if ((g8.LevelIDEnd ~= nil) and (g8.LevelIDEnd ~= "")) then
			ui.Chat(g8.LevelIDEnd)
		end
		if (s8.LevelIDExit) then
			packet.ReqReturnOriginServer();
		end
	end
end
