--[[
	日本語
--]]
local g0 = GetTpUtil();
local gExp = g0.Exp;
local gPop = g0.Pop;
local gClk = g0.Clock;
local gPck = g0.Pick;
local gDps = g0.Dps;

local _NAME_ = 'TPFARM';
_G[_NAME_] = _G[_NAME_] or {};
local g4 = _G[_NAME_];
g4.StgPath = g4.StgPath or "../addons/tpfarm/stg_tpfarm.lua";
g4.Stg = g4.Stg or {
	FlgMapStart		= true,
	MsgMapStart		= "{#FFFE80}{s14}{ol}▽%s [%s]{/}{/}{/}",
	FlgMapEnd		= true,
	MsgMapEnd		= "{#FFFE80}{s14}{ol}△%s [%s]{/}{/}{/}",
	FlgMapEndTime	= true,
	MsgMapEndTime	= "{#FFFE80}{s14}{ol}　Time　：%s{/}{/}{/}",
	FlgMapEndBExp	= true,
	MsgMapEndBExp	= "{#FFFE80}{s14}{ol}　＋BExp：%s{/}{/}{/}",
	FlgMapEndCExp	= true,
	MsgMapEndCExp	= "{#FFFE80}{s14}{ol}　＋CExp：%s{/}{/}{/}",
	FlgMapEndSlv	= true,
	MsgMapEndSlv	= "{#FFFE80}{s14}{ol}　＋{img icon_item_silver 14 14}　：%s{/}{/}{/}",
	FlgMapEndDpsM	= true,
	MsgMapEndDpsM	= "{#FFFE80}{s14}{ol}　>>Dmg ：%s：%s{/}{/}{/}",
	FlgMapEndDpsS	= false,
	MsgMapEndDpsS	= "{#FFFE80}{s14}{ol}　Dmg>> ：%s：%s{/}{/}{/}",
	FlgMapStartChar	= true,
	MsgMapStartChar	= "{#FFFE80}{s14}{ol}◇%s{/}{/}{/}",

	FlgClockTime	= false,
	MsgClockTime	= "{#80FE80}{s14}{ol}　　(%s){/}{/}{/}",
	FlgClockExp		= false,
	MsgClockExp		= "{#80FE80}{s14}{ol}　Exp/10Sec:%s /%s (@%s){/}{/}{/}",
	FlgClockSlv		= false,
	MsgClockSlv		= "{#80FE80}{s14}{ol}　Slv/10Sec:%s (@%s){/}{/}{/}",
	FlgClockDps		= false,
	MsgClockDps		= "{#80FE80}{s14}{ol}　Dmg/10Sec:%s (@%s){/}{/}{/}",

	FlgPickSlv			= true,
	NumPickSlvMin		= 2000,
	MsgPickSlv			= "{#80C0FF}{s14}{ol}　＋{img icon_item_silver 14 14}%s x%s (%s){/}{/}{/}",
	FlgPickItem			= true,
	MsgPickItem			= "{#80C0FF}{s14}{ol}　＋{img %s 14 14}%s%s{/}{/}{/}",
	MsgPickItemStack	= " x%s (%s)",
	MsgPickItemJarCmp	= " <☆>",
	FlgPickOpenCube		= true,
	MsgPickOpenCube		= "{#80C0FF}{s14}{ol}☆{img %s 14 14}%s >>{img %s 14 14}%s{/}{/}{/}",

	FlgPopChange		= false,
	MsgPopChange		= "{#C0FF80}{s14}{ol}　□POP %s/%s{/}{/}{/}",

	FlgDpsLogSave		= false,
	PthDpsLogRoot		= "../addons/tpfarmed/",

	MainUIShow			= true,
	MainUIPosX			= 400,
	MainUIPosY			= 400,
	MainUIShowChCh		= true,
	MainUIShowDps		= true,
	MainUIShowExp		= true,
	MainUIShowSlv		= true,

	SubDpsShow			= false,
	SubDpsMode			= "Mon",
};
local s4 = g4.Stg;
g4.tblSort = g4.tblSort or {
	{name="_",					comm="【マップ開始時に行う処理】"},
	{name="_",					comm="　キャラ変更には反応し、チャンネル変更では反映しない"},
	{name="FlgMapStart",		comm="マップ開始時にマップ名をシステムメッセージで表示する"},
	{name="MsgMapStart",		comm="1:マップ名　2:マップID"},
	{name="FlgMapEnd",			comm="マップ終了時にマップ名をシステムメッセージで表示する"},
	{name="MsgMapEnd",			comm="1:マップ名　2:マップID"},
	{name="FlgMapEndTime",		comm="マップ終了時にマップで経過した時間をシステムメッセージで表示する"},
	{name="MsgMapEndTime",		comm=""},
	{name="FlgMapEndBExp",		comm="マップ終了時に取得したベース経験値をシステムメッセージで表示する"},
	{name="MsgMapEndBExp",		comm=""},
	{name="FlgMapEndCExp",		comm="マップ終了時に取得したクラス経験値をシステムメッセージで表示する"},
	{name="MsgMapEndCExp",		comm=""},
	{name="FlgMapEndSlv",		comm="マップ終了時に取得したシルバーをシステムメッセージで表示する"},
	{name="MsgMapEndSlv",		comm=""},
	{name="FlgMapEndDpsM",		comm="マップ終了時に与えたモンスター毎のダメージをシステムメッセージで表示する スキル毎と同時にONにするのは非推奨"},
	{name="MsgMapEndDpsM",		comm=""},
	{name="FlgMapEndDpsS",		comm="マップ終了時に与えたスキル毎のダメージをシステムメッセージで表示する モンスター毎と同時にONにするのは非推奨"},
	{name="MsgMapEndDpsS",		comm=""},
	{name="FlgMapStartChar",	comm="キャラ変更時にキャラ名を表示する"},
	{name="MsgMapStartChar",	comm=""},
	{name="_",					comm=""},
	{name="_",					comm="【10秒毎に行う処理】"},
	{name="_",					comm="　特定の数値変更を10秒ごとにチェックしログを表示する"},
	{name="FlgClockTime",		comm="10秒毎にマップ時間をシステムメッセージで表示する　(非表示推奨)"},
	{name="MsgClockTime",		comm=""},
	{name="FlgClockExp",		comm="10秒毎に取得したベース/キャラ経験値をシステムメッセージで表示する"},
	{name="MsgClockExp",		comm="1:ベース経験値　2:クラス経験値　3:経過秒数"},
	{name="FlgClockSlv",		comm="10秒毎に取得したシルバーをシステムメッセージで表示する"},
	{name="MsgClockSlv",		comm="1:シルバー取得数　2:経過秒数"},
	{name="FlgClockDps",		comm="10秒毎に与ダメをシステムメッセージで表示する"},
	{name="MsgClockDps",		comm="1:与ダメ　2:経過秒数"},
	{name="_",					comm=""},
	{name="_",					comm="【一定条件で行う処理】"},
	{name="_",					comm="　条件を満たせばいつでも発動する"},
	{name="FlgPickSlv",			comm="取得時にシルバーをシステムメッセージで表示する"},
	{name="NumPickSlvMin",		comm="設定以下のシルバーを取得しても表示しない"},
	{name="MsgPickSlv",			comm="1:アイテム名　2:取得数　3:総数"},
	{name="FlgPickItem",		comm="取得時にアイテムをシステムメッセージで表示する"},
	{name="MsgPickItem",		comm="1:アイコンID　2:アイテム名　3:下記追加オプション"},
	{name="MsgPickItemStack",	comm="スタック可能なアイテムの 1:取得数 と 2:総数 を表示する"},
	{name="MsgPickItemJarCmp",	comm="冒険日誌でコンプリートしたアイテムに表示する"},
	{name="FlgPickOpenCube",	comm="キューブから取得時に追加のシステムメッセージで表示する"},
	{name="MsgPickOpenCube",	comm="1:キューブアイコンID　2:キューブアイテム名　3:取得アイコンID　4:取得アイテム名"},
	{name="FlgPopChange",		comm="5人以下のチャンネルで人数変化時にメッセージ表示"},
	{name="MsgPopChange",		comm="1:人数　2:最大"},
	{name="FlgDpsLogSave",		comm="DPSの詳細ログを保存する"},
	{name="PthDpsLogRoot",		comm="保存するフォルダのパス　名前は Z_yyyyMMdd_HHmmss_[マップID].tsv"},
	{name="_",					comm=""},
	{name="_",					comm="【ユーザーインターフェースの設定】"},
	{name="MainUIShow",			comm="メインUIを表示する"},
	{name="MainUIPosX",			comm="保存された横位置　(マウスで移動可能)"},
	{name="MainUIPosY",			comm="保存された縦位置　(マウスで移動可能)"},
	{name="MainUIShowChCh",		comm="メインUIのチャンネル切り替えを表示する"},
	{name="MainUIShowDps",		comm="メインUIのDPSを表示する"},
	{name="MainUIShowExp",		comm="メインUIの経験値を表示する"},
	{name="MainUIShowSlv",		comm="メインUIのシルバーを表示する"},
	{name="_",					comm=""},
	{name="SubDpsShow",			comm="サブのDPSUIを表示する"},
	{name="SubDpsMode",			comm="サブのDPSUIの集計モード　Mon：モンスター　Skl：スキル　Crs：モンスターxスキル"},
}
local tblSort = g4.tblSort;

function _TPFARM_ON_INIT(adn, frame)
	gExp = g0.Exp;
	gPop = g0.Pop;
	gClk = g0.Clock;
	gPck = g0.Pick;
	gDps = g0.Dps;
	adn:RegisterMsg("TPUTIL_CHARCHANGE",	"_TPFARM_CHARCHANGE");
	adn:RegisterMsg("TPUTIL_MAPEND",		"_TPFARM_MAPEND");
	adn:RegisterMsg("TPUTIL_MAPSTART",		"_TPFARM_MAPSTART");
	adn:RegisterMsg("TPUTIL_CLOCKWORK",		"_TPFARM_CLOCKWORK");
	adn:RegisterMsg("TPUTIL_PICKITEM",		"_TPFARM_PICKITEM");
	adn:RegisterMsg("TPUTIL_POPCHANGE",		"_TPFARM_POPCHANGE");
	adn:RegisterMsg("TPUTIL_DPSCLOCK",		"_TPFARM_DPSCLOCK");
	adn:RegisterMsg("TPUTIL_REALTIME",		"_TPFARM_REALTIME");
	g0.FuncBef("GACHA_CUBE_SUCEECD_UI", _NAME_, g4.CubeOpen);
	g0.FuncBef("CHAT_SYSTEM", _NAME_, g4.ChatSystem);
	g0.PCL(g0.LoadStg,_NAME_,g4.StgPath,s4);
	g0.PCL(g0.SaveStg,_NAME_,g4.StgPath,s4,tblSort);
	gDps.fEnb = (s4.FlgMapEndDpsM or s4.FlgMapEndDpsS or s4.FlgClockDps);
end
function g4.CubeOpen(frame, invItemClsID, rewardItem, btnVisible)
	if (s4.FlgPickOpenCube) then
		local cubeItem	= GetClassByType("Item", invItemClsID);
		local reward	= GetClass("Item", rewardItem);
		CHAT_SYSTEM(s4.MsgPickOpenCube:format(cubeItem.Icon, cubeItem.Name, reward.Icon, reward.Name));
	end
end

function _TPFARM_CHARCHANGE(frame, msg, argStr, argNum)
	g0.PCL(g4.CharChange,frame, msg, argStr, argNum);
end
function g4.CharChange(frame, msg, argStr, argNum)
	if(s4.FlgMapStartChar) then
		CHAT_SYSTEM(s4.MsgMapStartChar:format(argStr));
	end
end

function _TPFARM_MAPSTART(frame, msg, argStr, argNum)
	g0.PCL(g4.MapStart,frame, msg, argStr, argNum);
end
function g4.MapStart(frame, msg, argStr, argNum)
	if(s4.FlgMapStart) then
		CHAT_SYSTEM(s4.MsgMapStart:format(g0.MapName,g0.MapCode));
	end
	g4.PthDpsLog = s4.PthDpsLogRoot .."/Z_" .. os.date("%Y%m%d_%H%M%S").."_" .. g0.MapCode .. ".tsv";
end

function _TPFARM_MAPEND(frame, msg, argStr, argNum)
	g0.PCL(g4.MapEnd,frame, msg, argStr, argNum);
end
function g4.MapEnd(frame, msg, argStr, argNum)
	if(s4.FlgMapEnd) then
		CHAT_SYSTEM(s4.MsgMapEnd:format(g0.MapName,g0.MapCode));
	end
	if(s4.FlgMapEndTime) then
		CHAT_SYSTEM(s4.MsgMapEndTime:format(g0.sec2hms(gClk.LapClock)));
	end
	if(s4.FlgMapEndBExp) and (gExp.MapBExp >0) then
		CHAT_SYSTEM(s4.MsgMapEndBExp:format(g0.lpn2s(gExp.MapBExp,15)));
	end 
	if(s4.FlgMapEndCExp) and (gExp.MapCExp >0) then
		CHAT_SYSTEM(s4.MsgMapEndCExp:format(g0.lpn2s(gExp.MapCExp,15)));
	end 
	if(s4.FlgMapEndSlv) and (gPck.MapMoney >0) then
		CHAT_SYSTEM(s4.MsgMapEndSlv:format(g0.lpn2s(gPck.MapMoney,15)));
	end 
	if(s4.FlgMapEndDpsM) then
		for k,v in pairs(gDps.MapPerMns) do
			CHAT_SYSTEM(s4.MsgMapEndDpsM:format(g0.rpmb(k,32),g0.lpn2s(v,15)));
		end
	end 
	if(s4.FlgMapEndDpsS) then
		for k,v in pairs(gDps.MapPerSkl) do
			CHAT_SYSTEM(s4.MsgMapEndDpsS:format(g0.rpmb(k,32),g0.lpn2s(v,15)));
		end
	end 
end

function _TPFARM_DPSCLOCK(frame, msg, argStr, argNum)
	g0.PCL(g4.DpsClock,frame, msg, argStr, argNum);
end
function g4.DpsClock(frame, msg, argStr, argNum)
	if(s4.FlgDpsLogSave) then
		g4.PthDpsLog = g4.PthDpsLog or s4.PthDpsLogRoot .."/Z_" .. os.date("%Y%m%d_%H%M%S").."_" .. g0.MapCode .. ".tsv";
		local filep = io.open(g4.PthDpsLog ,"a+");
		if filep then
			for k,v in pairs(gDps.DtlTbl) do
				local saveLine = v.Name.."\t"..g0.n2s(v.Dmg).."\t"..v.Skill.."\t"..v.Time.."\n";
				filep:write(saveLine);
			end
			filep:close();
		end
	end
end

function _TPFARM_CLOCKWORK(frame, msg, argStr, argNum)
	g0.PCL(g4.ClockWork,frame, msg, argStr, argNum);
end
function g4.ClockWork(frame, msg, argStr, argNum)
	if(s4.FlgClockTime) then
		CHAT_SYSTEM(s4.MsgClockTime:format(g0.sec2hms(gClk.NowClock)));
	end
	if(s4.FlgClockExp) and(gClk.LastClock ~= -1) and(((gClk.Table["X2"].expBX or 0) >0) or ((gClk.Table["X2"].expCX or 0) >0)) then
		CHAT_SYSTEM(s4.MsgClockExp:format(g0.n2sMk(gClk.Table["X2"].expBX,7), g0.n2sMk(gClk.Table["X2"].expCX,7), g0.sec2hms(gClk.NowClock)));
	end
	if(s4.FlgClockSlv) and(gClk.LastClock ~= -1) and((gClk.Table["X2"].MoneyX or 0) >0) then
		CHAT_SYSTEM(s4.MsgClockSlv:format(g0.n2sMk(gClk.Table["X2"].MoneyX,7), g0.sec2hms(gClk.NowClock)));
	end
	if(s4.FlgClockDps) and(gClk.LastClock ~= -1) and((gClk.Table["X2"].Dmg or 0) >0) then
		CHAT_SYSTEM(s4.MsgClockDps:format(g0.n2sMk(gClk.Table["X2"].Dmg,7), g0.sec2hms(gClk.NowClock)));
	end
end

function _TPFARM_PICKITEM(frame, msg, argStr, argNum)
	g0.PCL(g4.PickItem,frame, msg, argStr, argNum);
end
function g4.PickItem(frame, msg, argStr, argNum)
	local itmData = gPck.ItemCount[""..gPck.LastItemId];
	if(itmData==nil)then
		return;
	end
	if(s4.FlgPickSlv) and(gPck.LastItemId == 900011) then
		if(itmData.LastNum >= s4.NumPickSlvMin) then
			CHAT_SYSTEM(s4.MsgPickSlv:format(itmData.Name, g0.n2sMk(itmData.LastNum,7), g0.n2sMk(itmData.Total,7)));
		end
		return;
	end
	if(s4.FlgPickItem) then
		local optStr = "";
		if(itmData.Max>1) then
			optStr = optStr .. s4.MsgPickItemStack:format(g0.lpn2s(itmData.LastNum,6), g0.lpn2s(itmData.Total,6));
		end
		if(itmData.Jarnal) then
			optStr = optStr .. s4.MsgPickItemJarCmp;
		end
		CHAT_SYSTEM(s4.MsgPickItem:format(itmData.Icon, itmData.Name, optStr));
	end
end
function _TPFARM_POPCHANGE(frame, msg, argStr, argNum)
	g0.PCL(g4.PopChange,frame, msg, argStr, argNum);
end
function g4.PopChange(frame, msg, argStr, argNum)
	if(s4.FlgPopChange) then
		CHAT_SYSTEM(s4.MsgPopChange:format(g0.lpn2s(gPop.NowPop,3),g0.lpn2s(gPop.MaxPop,3)));
	end
end

function g4.ChatSystem(msg)
	if (type(msg) ~= "string") then
		return;
	end
	local chk1,chk2 = msg:find("!@#$Get{ITEM}{COUNT}");
	if (chk1 ~= nil) and (chk1 > 0) then
		g0.FuncList["CHAT_SYSTEM"].fEnd = true;
		return;
	end
	local chk1,chk2 = msg:find("ETC_20190117_037424");
	if (chk1 ~= nil) and (chk1 > 0) then
		g0.FuncList["CHAT_SYSTEM"].fEnd = true;
		return;
	end
end

function _TPFARM_REALTIME(frame, msg, argStr, argNum)
	g0.PCL(g4.UiUpd,frame, msg, argStr, argNum);
end
function g4.UiUpd(frame, msg, argStr, argNum)
	local frm	= ui.GetFrame("tpfarm_ui");
	if (frm == nil) then
		return;
	end
	local strpop ="POP:"..g0.lpn2s(gPop.NowPop,3).."/"..g0.lpn2s(gPop.MaxPop,3);

	local tim = math.min(gClk.LastClock ,50)+gClk.TimeSec;
	if(tim<01) then
		tim = 1;
	end
	local dmg =0;
	local slv =0;
	local i = 0;
	for i=1, 6 do
		dmg = dmg + (gClk.Table["X"..i].Dmg or 0);
		slv = slv + (gClk.Table["X"..i].MoneyX or 0);
	end
	local d_1 = g0.n2sk(dmg/tim,11);
	local s_1 = g0.n2sk(slv/tim,11);
	local d_2 = g0.n2sk(gDps.MapDmg or 0 ,11);
	local s_2 = g0.n2sk(gPck.MapMoney,11);
	local s_3 = g0.n2sk(gPck.NowMoney,11);
	local strdps ="{#FE8080}DPS :"..d_1.."{/}/s in"..g0.lpn2s(tim,2).."s  {#FEC080}Map:"..d_2.."{/}";
	local strslv ="{#FE8080}{img icon_item_silver 16 16}  :"..s_1.."{/}/s in"..g0.lpn2s(tim,2).."s  {#FEC080}Map:"..s_2.."{/} {#8080FE}Ttl:"..s_3.."{/}";


	local b_1 = g0.n2sk(gExp.SubBExp,11);
	local c_1 = g0.n2sk(gExp.SubCExp,11);
	local b_2 = g0.n2sk(gExp.NxtBExp,11);
	local c_2 = g0.n2sk(gExp.NxtCExp,11);
	local b_3 = string.format("%5.2f", gExp.SubBExp*100/(gExp.NxtBExp+1));
	local c_3 = string.format("%5.2f", gExp.SubCExp*100/(gExp.NxtCExp+1));
	local b_4 = g0.n2sMk(gExp.LastBExp,5);
	local c_4 = g0.n2sMk(gExp.LastCExp,5);
	local b_5 = "----- ";
	local c_5 = "----- ";
	if(gExp.LastBExp >0) then
		b_5 = g0.n2sMk((gExp.NxtBExp - gExp.SubBExp + gExp.LastBExp - 1) / gExp.LastBExp);
	end
	if(gExp.LastCExp >0) then
		c_5 = g0.n2sMk((gExp.NxtCExp - gExp.SubCExp + gExp.LastCExp - 1) / gExp.LastCExp);
	end
	local strbex ="{#8080FE}BExp:"..b_1.."{/}/{#80FEFE}"..b_2.."{/} {#80FE80}"..b_3.."%{/}     {#C0FE40}@"..b_4.."{/} x"..b_5;
	local strcex ="{#8080FE}CExp:"..c_1.."{/}/{#80FEFE}"..c_2.."{/} {#80FE80}"..c_3.."%{/}     {#C0FE40}@"..c_4.."{/} x"..c_5;

	local txtpop	= GET_CHILD_RECURSIVELY(frm, "txtpop", "ui::CRichText");
	if (txtpop ~= nil) then
		txtpop:SetText(strpop);
	end

	local txtdps	= GET_CHILD_RECURSIVELY(frm, "txtdps", "ui::CRichText");
	if (txtdps ~= nil) then
		txtdps:SetText(strdps);
	end

	local txtbex	= GET_CHILD_RECURSIVELY(frm, "txtbex", "ui::CRichText");
	if (txtbex ~= nil) then
		txtbex:SetText(strbex);
	end

	local txtcex	= GET_CHILD_RECURSIVELY(frm, "txtcex", "ui::CRichText");
	if (txtcex ~= nil) then
		txtcex:SetText(strcex);
	end

	local txtslv	= GET_CHILD_RECURSIVELY(frm, "txtslv", "ui::CRichText");
	if (txtslv ~= nil) then
		txtslv:SetText(strslv);
	end

	g4.SetBtnChx();

	for i=1, 10 do
		local boxch	= tolua.cast(frm:GetChild("boxch"..i), "ui::CGroupBox");
		if (boxch ~= nil) then
			local j = i;
			if(g4.fChp) then
				j=j+10;
			end
			if (i ~=1) and ((i>gPop.MaxCh) or (gPop.Lst["Ch"..j.."Pop"] == nil) or (s4.MainUIShowChCh ~= true)) then
				boxch:ShowWindow(0);
			else
				if ((j-1) == gPop.NowCh) or ((i ==1) and gPop.MaxCh == 0) then
					boxch:SetColorTone("60FFFFFF");
				else
					boxch:SetColorTone("C0100000");
				end
				boxch:ShowWindow(1);
				local txtch	= tolua.cast(boxch:GetChild("txtch"..i), "ui::CRichText");
				if (txtch ~= nil) then
					local cnt = gPop.Lst["Ch"..j.."Pop"];
					local textcol = "";
					if ( cnt <10) then
						textcol = "FFFFFF";
					elseif ( cnt <20) then
						textcol = "00FFFF";
					elseif ( cnt <40) then
						textcol = "E0FF00";
					elseif ( cnt <60) then
						textcol = "FFC000";
					else
						textcol = "FF2020";
					end
					txtch:SetText("{#"..textcol.."}c"..j.."{nl}"..g0.lpn2s(cnt,4).."{/}");
				end
			end
		end
	end

	if(s4.SubDpsShow and gDps.fUse ) then
		if(s4.SubDpsMode == "Mon") then
			local lstTxt = {};
			for k,v in pairs(gDps.PerMns) do
				lstTxt[#lstTxt +1] = "{#FFFFC0}"..g0.rpmb(k,40)..":"..g0.lpn2s(v,15).."{/}";
			end
			g0.CmnWinUpdate("tpfarm_dps" , lstTxt);
		end
		if(s4.SubDpsMode == "Skl") then
			local lstTxt = {};
			for k,v in pairs(gDps.PerSkl) do
				lstTxt[#lstTxt +1] = "{#FFFFC0}"..g0.rpmb(k,32)..":"..g0.lpn2s(v,15).."{/}";
			end
			g0.CmnWinUpdate("tpfarm_dps" , lstTxt);
		end
		if(s4.SubDpsMode == "Crs") then
			local lstTxt = {};
			for k,v in pairs(gDps.PerCrs) do
				for k2,v2 in pairs(v) do
					lstTxt[#lstTxt +1] = "{#FFFFC0}{s10}"..g0.rpmb(k,40).." > "..g0.rpmb(k2,32)..":"..g0.lpn2s(v2,15).."{/}{/}";
				end
			end
			g0.CmnWinUpdate("tpfarm_dps" , lstTxt);
		end
	end
end

function TPFARM_UI_GAME_START(frame, control)
	g0.PCL(g4.UiStart,frame, control);
end
function g4.UiStart(frame, control)
	local frm	= ui.GetFrame("tpfarm_ui");
	if (frm == nil) then
		return;
	end
	local boxdps	= tolua.cast(frm:GetChild("boxdps"), "ui::CGroupBox");
	local boxbex	= tolua.cast(frm:GetChild("boxbex"), "ui::CGroupBox");
	local boxcex	= tolua.cast(frm:GetChild("boxcex"), "ui::CGroupBox");
	local boxslv	= tolua.cast(frm:GetChild("boxslv"), "ui::CGroupBox");
	local boxpop	= tolua.cast(frm:GetChild("boxpop"), "ui::CGroupBox");

	local posY = frm:GetHeight() +2;

	frm:MoveFrame(s4.MainUIPosX	,s4.MainUIPosY);
	if ((s4.MainUIShowDps == true) and gDps.fUse) then
		if (boxdps ~= nil) then
			boxdps:SetPos(boxdps:GetX(),posY);
			posY = posY + boxdps:GetHeight() +2;
		end
	else
		boxdps:ShowWindow(0);
	end
	if (s4.MainUIShowExp == true) then
		if ((boxbex ~= nil) and (gExp.IsMaxB == false)) then
			boxbex:SetPos(boxbex:GetX(),posY);
			posY = posY + boxbex:GetHeight() +2;
		else
			boxbex:ShowWindow(0);
		end
		if ((boxcex ~= nil) and (gExp.IsMaxC == false)) then
			boxcex:SetPos(boxcex:GetX(),posY);
			posY = posY + boxcex:GetHeight() +2;
		else
			boxcex:ShowWindow(0);
		end
	else
		boxbex:ShowWindow(0);
		boxcex:ShowWindow(0);
	end
	if (s4.MainUIShowSlv == true) then
		if (boxslv ~= nil) then
			boxslv:SetPos(boxslv:GetX(),posY);
			posY = posY + boxslv:GetHeight() +2;
		end
	else
		boxslv:ShowWindow(0);
	end

	if (boxdps ~= nil) then
		boxdps:SetColorTone("C0000000");
	end
	if (boxbex ~= nil) then
		boxbex:SetColorTone("C0000000");
	end
	if (boxcex ~= nil) then
		boxcex:SetColorTone("C0000000");
	end
	if (boxpop ~= nil) then
		boxpop:SetColorTone("C0000000");
	end
	if (boxslv ~= nil) then
		boxslv:SetColorTone("C0000000");
	end
	local i = 0;
	for i=1, 10 do
		local boxch	= tolua.cast(frm:GetChild("boxch"..i), "ui::CGroupBox");
		if (boxch ~= nil) then
			boxch:SetColorTone("C0000000");
		end
	end

	frm:Resize(	frm:GetWidth()	,posY	);
	if s4.MainUIShow then
		frm:ShowWindow(1);
	else
		frm:ShowWindow(0);
	end

	if(s4.SubDpsShow and gDps.fUse) then
		g4.OnBtnDps();
	end

	g4.fChx = (gPop.MaxCh>10);
	g4.fChp = (gPop.NowCh>10);
	g4.SetBtnChx();
end

function TPFARM_ON_CHX(frame, ctrl, argStr, argNum)
	g0.PCL(g4.OnBtnChx);
end
function g4.OnBtnChx()
	g4.fChp = (g4.fChp == false);
	g4.SetBtnChx()
end
function g4.SetBtnChx()
	local frm	= ui.GetFrame("tpfarm_ui");
	if (frm == nil) then
		return;
	end
	g4.fChx = (gPop.MaxCh>10);
	g4.fChp = (gPop.NowCh>10);
	local btnchx	= GET_CHILD_RECURSIVELY(frm, "btnchx", "ui::CButton");
	if(btnchx==nil) then
		return;
	end
	if(s4.MainUIShowChCh and g4.fChx) then
		btnchx:ShowWindow(1);
	else
		btnchx:ShowWindow(0);
	end
	if(g4.fChp) then
		btnchx:SetText("{s14}Ch{nl}-10");
	else
		btnchx:SetText("{s14}Ch{nl}+10");
	end
end

function TPFARM_UI_LBUTTONUP()
	g0.PCL(g4.UiLBtnUp);
end
function g4.UiLBtnUp()
	local frm	= ui.GetFrame("tpfarm_ui");
	if (frm == nil) then
		return;
	end
	s4.MainUIPosX	= frm:GetX();
	s4.MainUIPosY	= frm:GetY();
	g0.PCL(g0.SaveStg,_NAME_,g4.StgPath,s4,tblSort);
end

function TPFARM_ON_CHCH(frame, ctrl, argStr, argNum)
	if(g0.IsRightShow()) then
		return;
	end
	if(os.clock()<(g4.lastchch or 0)+3) then
		return;
	end
	g4.lastchch = os.clock();
	local i = tonumber(ctrl:GetName():sub(6));
	if(g4.fChp) then
		i=i+10;
	end
	RUN_GAMEEXIT_TIMER("Channel", i-1);
end

function TPFARM_ON_DPS(frame, ctrl, argStr, argNum)
	g0.PCL(g4.OnBtnDps);
end
function g4.OnBtnDps()
	local lstStg = {
		Icon = "hairacc_hat074",
		DefLine = 10,
		BackCol = "C0000010",
		CloseScp = g4.SubDpsClose,
		BtnStg ={
			{name="/Mon",	func=g4.BtnDpsPerMon},
			{name="/Skill",	func=g4.BtnDpsPerSkl},
			{name="/Cross",	func=g4.BtnDpsPerCrs},
		},
	};
	s4.SubDpsShow = true;
	g0.CmnWinCreate("tpfarm_dps",lstStg);
	g0.PCL(g0.SaveStg,_NAME_,g4.StgPath,s4,tblSort);
end
function g4.SubDpsClose()
	s4.SubDpsShow = false;
	g0.PCL(g0.SaveStg,_NAME_,g4.StgPath,s4,tblSort);
end
function g4.BtnDpsPerMon(frame, ctrl, argStr, argNum)
	s4.SubDpsMode = "Mon";
	g0.PCL(g0.SaveStg,_NAME_,g4.StgPath,s4,tblSort);
end
function g4.BtnDpsPerSkl(frame, ctrl, argStr, argNum)
	s4.SubDpsMode = "Skl";
	g0.PCL(g0.SaveStg,_NAME_,g4.StgPath,s4,tblSort);
end
function g4.BtnDpsPerCrs(frame, ctrl, argStr, argNum)
	s4.SubDpsMode = "Crs";
	g0.PCL(g0.SaveStg,_NAME_,g4.StgPath,s4,tblSort);
end
