--[[__tputil
	日本語
	関数群を保存している
	ゲーム機能を呼び出す関数群
--]]
local g0 = GetTpUtil();

g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "__tputil";

g0.fInit	= g0.fInit	or false;
g0.Exp		= g0.Exp	or {};
g0.Pop		= g0.Pop	or {};
g0.Clock	= g0.Clock	or {};
g0.Pick		= g0.Pick	or {};
g0.Dps		= g0.Dps	or {};
g0.CmnWin	= g0.CmnWin	or {};
g0.Quest	= g0.Quest	or {};
g0.Char		= g0.Char	or {};
g0.Party	= g0.Party	or {};
g0.Inv		= g0.Inv	or {};
g0.MBox		= g0.MBox	or {};

local gExp = g0.Exp;
local gPop = g0.Pop;
local gClk = g0.Clock;
local gPck = g0.Pick;
local gDps = g0.Dps;
local gQst = g0.Quest;
local gChr = g0.Char;
local gPty = g0.Party;
local gInv = g0.Inv;
local gMBx = g0.MBox;

function __TPUTIL_ON_INIT(adn, frame)
	adn:RegisterMsg("GAME_START", "TPUTIL_GAME_START");
	adn:RegisterMsg("JOB_EXP_UPDATE",	"TPUTIL_JOB_EXP_UPDATE");
	adn:RegisterMsg("JOB_EXP_ADD",	"TPUTIL_JOB_EXP_UPDATE");
	adn:RegisterMsg("EXP_UPDATE",	"TPUTIL_EXP_UPDATE");
	adn:RegisterMsg("INV_ITEM_IN",	"TPUTIL_ITEM_IN");
	adn:RegisterMsg("CAMP_UPDATE",	"TPUTIL_PARTY_UPDATE");
	adn:RegisterMsg("PARTY_UPDATE",	"TPUTIL_PARTY_UPDATE");
	adn:RegisterMsg("QUEST_UPDATE", "TPUTIL_QUEST_UPDATE");
	adn:RegisterMsg("S_OBJ_UPDATE",	"TPUTIL_QUEST_UPDATE");
	if(g0.fInit ~= true) then
		g0.PCL(gExp.Init);
	end
	g0.PCL(g0.CmnWinInit);
	gMBx.Init();
	g0.fInit = true;
end
function TPUTIL_GAME_START(frame, control)
	g0.PCL(g0.GameStart);
end
function g0.GameStart(adn, frame)
	g0.fFirst = true;
	local frm = ui.GetFrame("__tputil");
	frm:RunUpdateScript("TPUTIL_START",  0.1, 0.0, 0, 1);
end
function TPUTIL_START(frame)	--	RunUpdateScriptで1秒ごとに動く
	if(g0.fFirst) then
		g0.fFirst = false;
		return 1;	--	RunUpdateScriptは1で継続
	end

	g0.PCL(g0.TpUtilStart);
	return 0;	--	RunUpdateScriptは1で継続
end
function g0.TpUtilStart()
	local mapCode = session.GetMapName();
	local mapProp = geMapTable.GetMapProp(mapCode);
	--	キャラ名の取得
	local charName = GetMyName();
	local mapCls = GetClass("Map", mapCode);
	local mapType = TryGetProp(mapCls, "MapType", "None");
	g0.MapIsCity	= (mapType == "City");
	g0.MapIsPvp		= world.IsPVPMap();
	g0.MapIsMatch	= session.world.IsIntegrateServer();
	g0.MapIsIndun	= session.world.IsDungeon();
	g0.MapId		= session.GetMapID();
	g0.MapLv		= mapCls.QuestLevel;
	g0.PCL(gDps.MapInit);
	g0.PCL(gPop.MapInit);
	g0.PCL(gInv.MakeLst);
	g0.PCL(gQst.GetUniq);
	g0.PCL(gQst.GetQuest);
	g0.PCL(gPty.GetParty);
	if (g0.MapCode == mapCode) and (g0.CharName == charName) then
		--	マップもキャラも一緒の時・・・イベントだけ登録
		g0.Event("TPUTIL_START", g0.MapCode ,0);
		local frm = ui.GetFrame("__tputil");
		frm:RunUpdateScript("TPUTIL_CLOCK_WORK",  1, 0.0, 0, 1);
		return;
	end
	--	マップ名の取得
	local mapName = mapProp:GetName();
	g0.PCL(gExp.MapEnd,(g0.CharName == charName);
	g0.PCL(gPck.MapEnd,(g0.CharName == charName);
	g0.PCL(gDps.MapEnd);
	if (g0.CharName ~= charName)then
		--	キャラ変更時
		g0.Event("TPUTIL_CHARCHANGE", charName ,0);
	end
	if (g0.MapCode ~= nil)then
		--	マップorキャラ変更時
		gClk.LapClock	= os.clock() - gClk.StartClock;	-- Windowsならシステム秒;
		g0.Event("TPUTIL_MAPEND", g0.MapCode ,0);
	end
	g0.CharName		= charName;
	g0.MapCode		= mapCode;
	g0.MapName		= mapName;
	gClk.Table		= {};
	gClk.TimeSec	= 0;
	gClk.FirstClock	= 0;
	gClk.LastClock	= -1;
	gClk.NowClock	= 0;
	gClk.StartClock	= os.clock();	-- Windowsならシステム秒;
	g0.Event("TPUTIL_START", g0.MapCode ,0);
	g0.Event("TPUTIL_MAPSTART", g0.MapCode ,0);
	local frm = ui.GetFrame("__tputil");
	frm:RunUpdateScript("TPUTIL_CLOCK_WORK",  1, 0.0, 0, 1);
	return;
end
function TPUTIL_CLOCK_WORK(frame)	--	RunUpdateScriptで1秒ごとに動く
	g0.PCL(g0.ClockWork);
	return 1;	--	RunUpdateScriptは1で継続
end

function g0.ClockWork()
	local nowTime	= math.floor(os.clock());	-- Windowsならシステム秒(ただし小数があるので落とす)
	if (gClk.FirstClock == 0) then
		gClk.FirstClock	= nowTime;
	end
	gClk.NowClock = nowTime - gClk.FirstClock;
	local nowTmP10	= math.floor(gClk.NowClock /10)*10;	-- 10秒単位
	local nowTmM10	= math.floor((gClk.NowClock+1) %10);	-- 10秒単位の端数
	local f10 = (gClk.LastClock ~= nowTmP10);	-- 10秒単位が切り替わった時
	if (f10) then
		local i = 0;
		for i=1, 29 do
			gClk.Table["X"..(31-i)] = (gClk.Table["X"..(30-i)] or {});
		end
		gClk.Table["X1"] = {};
	end
	g0.PCL(gExp.Clock,f10);
	g0.PCL(gPck.Clock,f10);
	g0.PCL(gPop.Clock,f10);
	g0.PCL(gDps.Clock,f10);
	if (f10) then
		g0.Event("TPUTIL_CLOCKWORK", "", gClk.LastClock);
	end
	g0.Event("TPUTIL_REALTIME", "", gClk.NowClock);
	gClk.LastClock = nowTmP10;
	gClk.TimeSec = nowTmM10;
end









function g0.IsRightShow()
	if(ui.IsFrameVisible("inventory") ==1) then	--	アイテム
		return true;
	end
	if(ui.IsFrameVisible("systemoption") ==1) then	--	オプション
		return true;
	end
	if(ui.IsFrameVisible("buffseller_target") ==1) then	--	PC露店　バフ
		return true;
	end
	if(ui.IsFrameVisible("appraisal_pc") ==1) then	--	PC露店　鑑定
		return true;
	end
	if(ui.IsFrameVisible("itemdecompose") ==1) then	--	NPC鍛冶屋　分解
		return true;
	end
	if(ui.IsFrameVisible("repair140731") ==1) then	--	NPC鍛冶屋　修理
		return true;
	end
	if(ui.IsFrameVisible("appraisal") ==1) then	--	NPC鑑定屋
		return true;
	end
	if(ui.IsFrameVisible("fishing_rank") ==1) then	--	釣りランキング
		return true;
	end
	if(ui.IsFrameVisible("worldpvp") ==1) then	--	TBL画面
		return true;
	end
	return false;
end
