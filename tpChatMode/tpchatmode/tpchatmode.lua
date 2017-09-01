--[[
	日本語
--]]

local acutil = require('acutil');

_G['TPCHATMODE'] = _G['TPCHATMODE'] or {};
local g3 = _G['TPCHATMODE'];
g3.settingPath = g3.settingpath or "../addons/tpchatmode/settings.json";
g3.settings = g3.settings or {};
local s3 = g3.settings;

function TPCHATMODE_ON_INIT(addon, frame)
	--	g3.TPCHATMODE_LOAD_SETTING();
	--	g3.TPCHATMODE_SAVE_SETTING();
	--	CHAT_SYSTEM("TPCHATMODE_ON_INIT");
	addon:RegisterMsg("GAME_START", "TPCHATMODE_GAME_START");
	addon:RegisterMsg("PARTY_UPDATE", "TPCHATMODE_PARTY_UPDATE");
end


function g3.TPCHATMODE_LOAD_SETTING()
	local t, err = acutil.loadJSON(g3.settingPath, g3.settings);
	-- 	値の存在確保と初期値設定
	s3.isDebug		= ((type(s3.isDebug			) == "boolean")	and s3.isDebug		)or false;
end

function g3.TPCHATMODE_SAVE_SETTING()
	local filep = io.open(g3.settingPath,"w+");
	if filep then
		filep:write("{\n");
		filep:write("\t\"isDebug\":"		.. ((s3.isDebug			and "true") or "false")	.."\n"	);
		filep:write("}\n");
		filep:close();
	end
end


function TPCHATMODE_PARTY_UPDATE(frame, msg, str, num)
	--	CHAT_SYSTEM("TPCHATMODE_PARTY_UPDATE");
	local f,m = pcall(g3.TPCHATMODE_PARTY_UPDATE, frame, msg, str, num);
	if f ~= true then
		CHAT_SYSTEM(m);
		return;
	end
end

function TPCHATMODE_GAME_START(frame, msg, str, num)
	--	CHAT_SYSTEM("TPCHATMODE_GAME_START");
	local frm	= ui.GetFrame("tpchatmode");
	frm:ShowWindow(1);
	g3.lastMode = g3.lastMode or -1;
	g3.fDelay = false;
	g3.fFirst = false;
	frm:RunUpdateScript("TPCHATMODE_GAME_START_DELAY",  0.5, 0.0, 0, 1);
end

function TPCHATMODE_GAME_START_DELAY(frame)
	if (g3.fDelay ~= true) then
		--	RunUpdateScriptは初回は0秒で走るので2周させる
		g3.fDelay = true;
		return 1;	--	RunUpdateScriptは1で継続
	end
	
	if (g3.fFirst ~= true) then
		g3.fFirst = true;
		local f,m = pcall(g3.TPCHATMODE_GAME_START_DELAY, frame);
		if f ~= true then
			CHAT_SYSTEM(m);
			return 0;	--	RunUpdateScriptは0で終了
		end
		return 1;	--	RunUpdateScriptは1で継続
	end
	g3.lastMode = ui.GetChatType();	--	そのままチャットモード監視
	return 1;	--	RunUpdateScriptは1で継続
end

function g3.TPCHATMODE_PARTY_UPDATE(frame, msg, str, num)
	local nowMode = ui.GetChatType();
	local pcParty = session.party.GetPartyInfo();
	local partyID = 0;

	--	PTの変更時partyIDが変化したらPTチャットにする
	if (pcParty ~= nil) and (pcParty.info ~= nil) then
		partyID = pcParty.info:GetPartyID();
		if (partyID ~= g3.partyID) then
			ui.SetChatType(2);	--	2はPTチャット
			g3.lastMode=2;
		end
	end

	--	PTがなくてPTチャットならギルドチャットにする
	if (partyID == 0) and (nowMode == 2) then
		ui.SetChatType(3);	--	3はギルドチャット
		g3.lastMode=3;
	end
	g3.partyID = partyID;
end

function g3.TPCHATMODE_GAME_START_DELAY(frame)
	--	※ゲーム開始時はなぜかPTやギルドが一般に変更される　シャウトだけ継続する
	--	※ゲーム開始時ガチ直後に設定してもダメなので0.5秒ずらす工夫入り　(3秒は長すぎるので自作)

	local nowMode = ui.GetChatType();
	local pcParty = session.party.GetPartyInfo();

	--	ゲーム開始時、PTチャットかギルドチャットにする
	--	エリア切り替えでシャウトなら、PTチャットかギルドチャットにする
	if (g3.lastMode == -1) or (nowMode == 1) then	--	1はシャウト
		if (pcParty ~= nil) and (pcParty.info ~= nil) then
			ui.SetChatType(2);	--	2はPTチャット
		else
			ui.SetChatType(3);	--	3はギルドチャット
		end
	else
		ui.SetChatType(g3.lastMode);
	end
end






