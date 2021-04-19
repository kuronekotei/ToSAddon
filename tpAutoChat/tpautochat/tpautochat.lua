--[[tpautochat
	日本語
--]]
local g0 = GetTpUtil();
local gPty = g0.Party;


local _NAME_ = 'TPAUTOCHAT';
_G[_NAME_] = _G[_NAME_] or {};
local g8 = _G[_NAME_];

g8.StgPath = g8.StgPath or "../addons/tpautochat/stg_tpautochat.lua";
g8.Stg = g8.Stg or {
	MatchingOnly		= true,
	AutoExt				= false,
	MsgStart			= "/p よろしくお願いします",
	MsgEnd				= "/p お疲れ様でした{img emoticon_0001 24 24}{/}",
	MsgLevelID100p		= "/p 達成率100％!!　ボス行けます!!",
};
local s8 = g8.Stg;
g8.tblSort = g8.tblSort or {
	{name="_",					comm="【ユーザーインターフェースの設定】"},
	{name="AutoExt",			comm="自動退出"},
	{name="MsgStart",			comm="入場後の発言"},
	{name="MsgEnd",				comm="終了時の発言"},
}
local tblSort = g8.tblSort;


function TPAUTOCHAT_ON_INIT(adn, frame)
	adn:RegisterMsg("GAME_START", "TPAUTOCHAT_GAME_START")
	adn:RegisterMsg('OPEN_INDUN_REWARD_HUD', 'TPAUTOCHAT_LEVEL_UPD')
	adn:RegisterMsg('TPUTIL_CLOCKWORK', 'TPAUTOCHAT_CLOCKWORK')
	adn:RegisterMsg('INDUN_REWARD_RESULT', 'TPAUTOCHAT_LEVEL_END')
	adn:RegisterMsg('REFRESH_MYTHIC_DUNGEON_HUD', 'TPAUTOCHAT_LEVEL_END2')
	adn:RegisterMsg('ENABLE_RETURN_BUTTON', 'TPAUTOCHAT_RETURN')

	g0.PCL(g0.LoadStg,_NAME_,g8.StgPath,s8);
	g0.PCL(g0.SaveStg,_NAME_,g8.StgPath,s8,tblSort);
end
function TPAUTOCHAT_GAME_START()
	g8.lvlCount = 0;
	g8.lvlScore = 0;
	g8.lvlRet = false;
	g8.lvlStart = (session.world.IsIntegrateServer() == true);
	g8.lvlEnd = (session.world.IsIntegrateServer() == true);
end
function TPAUTOCHAT_CLOCKWORK(frame, msg, argStr, argNum)
	g0.PCL(g8.TPAUTOCHAT_LEVEL_START);
	if(g8.lvlRet)then
		g0.PCL(g8.TPAUTOCHAT_RETURN);
	end
end
function TPAUTOCHAT_LEVEL_UPD(frame, msg, argStr, argNum)
	g0.PCL(g8.TPAUTOCHAT_LEVEL_UPD);
end
function TPAUTOCHAT_LEVEL_END(frame, msg, argStr, argNum)
	g0.PCL(g8.TPAUTOCHAT_LEVEL_END);
end
function TPAUTOCHAT_LEVEL_END2(frame, msg, argStr, argNum)
	g0.PCL(g8.TPAUTOCHAT_LEVEL_END2);
end
function TPAUTOCHAT_RETURN(frame, msg, argStr, argNum)
	g0.PCL(g8.TPAUTOCHAT_RETURN);
end

function g8.TPAUTOCHAT_LEVEL_START(frame, msg, argStr, argNum)
	if (#gPty.LstMem>1) and (g8.lvlStart) then
		g8.lvlStart = false;
		if ((s8.MsgStart ~= nil) and (s8.MsgStart ~= "") ) then
			ui.Chat(s8.MsgStart)
		end
	end
end

function g8.TPAUTOCHAT_LEVEL_UPD(frame, msg, argStr, argNum)
	CHAT_SYSTEM(g0.s(msg).." "..g0.s(argStr).." "..g0.s(argNum));
	if (#gPty.LstMem>1) and (argNum) then
		if ((g8.lvlScore<100) and (argNum==100) and (s8.MsgLevelID100p ~= nil) and (s8.MsgLevelID100p ~= "")) then
			ui.Chat(s8.MsgLevelID100p);
		end
	end
	g8.lvlScore = argNum;
end

function g8.TPAUTOCHAT_LEVEL_END(frame, msg, argStr, argNum)
	if (#gPty.LstMem>1) and (g8.lvlEnd) then
		g8.lvlEnd = false;
		if ((s8.MsgEnd ~= nil) and (s8.MsgEnd ~= "") ) then
			ui.Chat(s8.MsgEnd)
		end
	end
end

function g8.TPAUTOCHAT_LEVEL_END2(frame, msg, argStr, argNum)
	CHAT_SYSTEM(g0.s(msg).." "..g0.s(argStr).." "..g0.s(argNum));
	if (#gPty.LstMem>1) and (argNum) and (argNum>=100) and (g8.lvlEnd) then
		g8.lvlEnd = false;
		if ((s8.MsgEnd ~= nil) and (s8.MsgEnd ~= "") ) then
			ui.Chat(s8.MsgEnd)
		end
		g8.lvlRet = true;
	end
end

function g8.TPAUTOCHAT_RETURN(frame, msg, argStr, argNum)
	if (s8.LevelIDExit) then
		restart.ReqReturn();
	end
end
