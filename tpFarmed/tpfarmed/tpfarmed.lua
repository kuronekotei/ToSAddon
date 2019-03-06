--[[
	日本語
--]]

local acutil = require('acutil');

_G['TPFARMED'] = _G['TPFARMED'] or {};
local g4 = _G['TPFARMED'];
g4.settingPath = g4.settingpath or "../addons/tpfarmed/stg_tpfarmed.json";
g4.settings = g4.settings or {};
local s4 = g4.settings;

function TPFARMED_ON_INIT(addon, frame)
	local f,m = pcall(g4.TPFARMED_LOAD_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
	local f,m = pcall(g4.TPFARMED_SAVE_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
	if(g4.TPFARMED_OLD_GACHA_CUBE_SUCEECD_UI==nil) then
		--	待避する関数がすでにいたら、やらない　(2度置き換えると無限ループ)
		g4.TPFARMED_OLD_GACHA_CUBE_SUCEECD_UI = GACHA_CUBE_SUCEECD_UI;
		_G["GACHA_CUBE_SUCEECD_UI"] = TPFARMED_HOOK_GACHA_CUBE_SUCEECD_UI;
	end
	if(g4.TPFARMED_OLD_CHAT_SYSTEM==nil) then
		--	待避する関数がすでにいたら、やらない　(2度置き換えると無限ループ)
		g4.TPFARMED_OLD_CHAT_SYSTEM = CHAT_SYSTEM;
		_G["CHAT_SYSTEM"] = TPFARMED_CHAT_SYSTEM;
	end
	addon:RegisterMsg("GAME_START", "TPFARMED_GAME_START");
	addon:RegisterMsg("INV_ITEM_IN", "TPFARMED_INV_ITEM_IN");
	addon:RegisterMsg("JOB_EXP_UPDATE", "TPFARMED_JOB_EXP_UPDATE");
	addon:RegisterMsg("JOB_EXP_ADD", "TPFARMED_JOB_EXP_UPDATE");
	addon:RegisterMsg('EXP_UPDATE', 'TPFARMED_EXP_UPDATE');
	local f,m = pcall(g4.TPFARMED_INIT);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end


function TPFARMED_HOOK_GACHA_CUBE_SUCEECD_UI(frame, invItemClsID, rewardItem, btnVisible)
	local f,m = pcall(g4.TPFARMED_NEW_GACHA_CUBE_SUCEECD_UI, frame, invItemClsID, rewardItem, btnVisible);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
	g4.TPFARMED_OLD_GACHA_CUBE_SUCEECD_UI(frame, invItemClsID, rewardItem, btnVisible);
end

function TPFARMED_CHAT_SYSTEM(msg)
	if (msg == nil) then
		return;
	end
	local chk1,chk2 = msg:find("!@#$Get{ITEM}{COUNT}");
	if (chk1 ~= nil) and (chk1 > 0) then
		return;
	end
	g4.TPFARMED_OLD_CHAT_SYSTEM(msg);
end

function TPFARMED_GAME_START(frame, control)
	local f,m = pcall(g4.TPFARMED_MAPSTART);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end

function TPFARMED_UI_GAME_START(frame, control)
	local f,m = pcall(g4.TPFARMED_UI_GAME_START, frame, control);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end

function TPFARMED_INV_ITEM_IN(frame, msg, guid, num)
	local f,m = pcall(g4.TPFARMED_GETITEM, frame, msg, guid, num);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end

function TPFARMED_JOB_EXP_UPDATE(frame, msg, str, exp, tableinfo)
	g4.JobLvl = tableinfo.level;
	g4.JobExp = exp - tableinfo.startExp;
	if (str ~= nil) and (str ~= "None") and (str ~= "") and (msg == "JOB_EXP_ADD") then
		g4.LastCExp = tonumber(str) or 0;
	end
end

function TPFARMED_EXP_UPDATE(frame, msg, argStr, argNum)
	if (argNum ~= nil) and (tonumber(argNum) ~= nil) and (tonumber(argNum) ~= 0) then
		g4.LastBExp = tonumber(argNum);
	end
end

function TPFARMED_UI_LBUTTONUP()
	local f,m = pcall(g4.TPFARMED_UI_LBUTTONUP);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end





function g4.TPFARMED_LOAD_SETTING()
	local t, err = acutil.loadJSON(g4.settingPath);
	if t then
		s4 = acutil.mergeLeft(s4, t);
	end
	-- 	値の存在確保と初期値設定
	s4.isDebug			= ((type(s4.isDebug			) == "boolean")	and s4.isDebug			)or false;
	s4.isShowCube		= ((type(s4.isShowCube		) == "boolean")	and s4.isShowCube		)or (s4.isShowCube		==nil);
	s4.isShowPickItem	= ((type(s4.isShowPickItem	) == "boolean")	and s4.isShowPickItem	)or (s4.isShowPickItem	==nil);
	s4.isShowSilver		= ((type(s4.isShowSilver	) == "boolean")	and s4.isShowSilver		)or false;
	s4.isShowJournal	= ((type(s4.isShowJournal	) == "boolean")	and s4.isShowJournal	)or false;
	s4.isShowGiveDmg	= ((type(s4.isShowGiveDmg	) == "boolean")	and s4.isShowGiveDmg	)or (s4.isShowGiveDmg	==nil);
	s4.isShowTakeDmg	= ((type(s4.isShowTakeDmg	) == "boolean")	and s4.isShowTakeDmg	)or (s4.isShowTakeDmg	==nil);
	s4.isShowExpGain	= ((type(s4.isShowExpGain	) == "boolean")	and s4.isShowExpGain	)or false;
	s4.isShowPopCnt		= ((type(s4.isShowPopCnt	) == "boolean")	and s4.isShowPopCnt		)or false;
	s4.isShowTimeTbl	= ((type(s4.isShowTimeTbl	) == "boolean")	and s4.isShowTimeTbl	)or false;
	s4.ManyMoney		= ((type(s4.ManyMoney		) == "number")	and s4.ManyMoney		)or 10000;
	s4.useUI			= ((type(s4.useUI			) == "boolean")	and s4.useUI			)or (s4.useUI			==nil);
	s4.useUIExp			= ((type(s4.useUIExp		) == "boolean")	and s4.useUIExp			)or false;
	s4.useUIChCh		= ((type(s4.useUIChCh		) == "boolean")	and s4.useUIChCh		)or (s4.useUIChCh		==nil);
	s4.posX				= ((type(s4.posX			) == "number")	and s4.posX				)or 400;
	s4.posY				= ((type(s4.posY			) == "number")	and s4.posY				)or 400;



	s4.isShowGiveDmg	= false;
	s4.isShowTakeDmg	= false;
end

function g4.TPFARMED_SAVE_SETTING()
	local filep = io.open(g4.settingPath,"w+");
	if filep then
		filep:write("{\n");
		filep:write("\t\"isDebug\":"		.. ((s4.isDebug			and "true") or "false")	.."\n"	);
		filep:write(",\t\"isShowCube\":"	.. ((s4.isShowCube		and "true") or "false")	.."\n"	);
		filep:write(",\t\"isShowSilver\":"	.. ((s4.isShowSilver	and "true") or "false")	.."\n"	);
		filep:write(",\t\"isShowPickItem\":".. ((s4.isShowPickItem	and "true") or "false")	.."\n"	);
		filep:write(",\t\"isShowJournal\":"	.. ((s4.isShowJournal	and "true") or "false")	.."\n"	);
--		filep:write(",\t\"isShowGiveDmg\":"	.. ((s4.isShowGiveDmg	and "true") or "false")	.."\n"	);
--		filep:write(",\t\"isShowTakeDmg\":"	.. ((s4.isShowTakeDmg	and "true") or "false")	.."\n"	);
		filep:write(",\t\"isShowTimeTbl\":"	.. ((s4.isShowTimeTbl	and "true") or "false")	.."\n"	);
		filep:write(",\t\"isShowExpGain\":"	.. ((s4.isShowExpGain	and "true") or "false")	.."\n"	);
		filep:write(",\t\"isShowPopCnt\":"	.. ((s4.isShowPopCnt	and "true") or "false")	.."\n"	);
		filep:write(",\t\"ManyMoney\":"		.. (s4.ManyMoney					or 10000)	.."\n"	);
		filep:write(",\t\"useUI\":"			.. ((s4.useUI			and "true") or "false")	.."\n"	);
		filep:write(",\t\"useUIExp\":"		.. ((s4.useUIExp		and "true") or "false")	.."\n"	);
		filep:write(",\t\"useUIChCh\":"		.. ((s4.useUIChCh		and "true") or "false")	.."\n"	);
		filep:write(",\t\"posX\":"			.. (s4.posX							or 400)		.."\n"	);
		filep:write(",\t\"posY\":"			.. (s4.posY							or 400)		.."\n"	);
		filep:write("}\n");
		filep:close();
	end
end

function g4.TPFARMED_INIT()
	if (g4.IsInit) then
		return;
	end
	g4.ExpTableB = {};
	g4.ExpTableC = {};
	g4.ItemCount = {};
	local expB		=0;
	local expBT		=0;
	local expC		=0;
	local expCT		=0;
	local expCTX	=0;
	local i = 0;
	for i=1, 500 do
		local expData  = GetClassByType("Xp", i);
		if (expData ~= nil) then
			expB = expData.TotalXp - expBT;
			if (expB == 0) then
				break;
			end
			expBT = expData.TotalXp;
			local tmptxt = "0"..i;
			g4.ExpTableBLen = i;
			g4.ExpTableB[i] = {};
			g4.ExpTableB[i]["Req"] = expB;
			g4.ExpTableB[i]["TRq"] = expBT;
			g4.ExpTableB[i]["Ttl"] = expBT - expB;
		end
	end
	local clsList, cnt = GetClassList("Xp_Job");	
	
	for i=1, 154 do
		local classR	= 0;
		local classL	= 0;
		if (i < 15)  then
			classR	= 1;
			classL	= i;
		else
			classR	= math.floor((i-15)/44)+2;
			classL	= (((i-14) % 44 == 0) and 44) or ((i-14) % 44);
		end
		local className	= "Job_" .. classR .. "_" ..  classL;
		local classData	= GetClassByNameFromList(clsList, className);
		if (classData ~= nil) then
			if (classL == 1) then
				expCTX = expCT;
				expC = classData.TotalXp;
			else
				expC = classData.TotalXp - expCT + expCTX;
			end
		
			if (expC == 0) then
				break;
			end
			if (classL == 1) then
				expCT = expCT + classData.TotalXp;
			else
				expCT = classData.TotalXp + expCTX;
			end
			g4.ExpTableCLen = i;
			g4.ExpTableC[i] = {};
			g4.ExpTableC[i]["Req"] = expC;
			g4.ExpTableC[i]["TRq"] = expCT;
			g4.ExpTableC[i]["Ttl"] = expCT - expC;
			g4.ExpTableC[i]["Rnk"] = classR;
			g4.ExpTableC[i]["Lvl"] = classL;
		end
	end
end
function g4.TPFARMED_EXP_DUMP()	--	未使用
	local i = 0;
	local pcObj = GetMyPCObject();
	if pcObj == nil then
		return;
	end
	
	i = pcObj.Lv;
	local expB  = g4.ExpTableB[i]["Req"];
	local expBR = g4.ExpTableB[i]["TRq"];
	local expBT = g4.ExpTableB[i]["Ttl"];
	local expBN = session.GetEXP();
	CHAT_SYSTEM("Lv" .. g4.lpnts(i,3).."  "..g4.lpnts(expBN,14).."/"..g4.lpnts(expB,14));
	CHAT_SYSTEM("Total  "..g4.lpnts(expBT+expBN,14).."/"..g4.lpnts(expBR,14));

	local clsL  = g4.JobLvl;
	local clsR  = session.GetPcTotalJobGrade()
	if (clsR > 1) then
		i = math.min((clsR-2) *44 + clsL + 14 ,g4.ExpTableCLen);
	else
		i = math.min((clsR-1) *44 + clsL ,g4.ExpTableCLen);
	end
	local expC  = g4.ExpTableC[i]["Req"];
	local expCR = g4.ExpTableC[i]["TRq"];
	local expCT = g4.ExpTableC[i]["Ttl"];
	local expCN = g4.JobExp;
	CHAT_SYSTEM("R" .. g4.lpnts(clsR,2) .. "L" .. g4.lpnts(clsL,2).." "..g4.lpnts(expCN,14).."/"..g4.lpnts(expC,14));
	CHAT_SYSTEM("Total  "..g4.lpnts(expCT+expCN,14).."/"..g4.lpnts(expCR,14));
		
	local i = 0;
	for i=1, g4.ExpTableBLen do
		local expB  = g4.ExpTableB[i]["Req"];
		local expBT = g4.ExpTableB[i]["Ttl"];
	--	CHAT_SYSTEM("Lv" .. g4.lpnts(i,3).."    Ttl:"..g4.lpnts(expBT,14)).."   Req:"..g4.lpnts(expB,14);
	end
	for i=1, g4.ExpTableCLen do
		local expC  = g4.ExpTableC[i]["Req"];
		local expCT = g4.ExpTableC[i]["Ttl"];
		local clsR  = g4.ExpTableC[i]["Rnk"];
		local clsL  = g4.ExpTableC[i]["Lvl"];
	--	CHAT_SYSTEM("R" .. g4.lpnts(clsR,2) .. "L" .. g4.lpnts(clsL,2).."   Ttl:"..g4.lpnts(expCT,14).."   Req:"..g4.lpnts(expC,14));
	end
end
function g4.TPFARMED_MAPSTART()
	--CHAT_SYSTEM("TPFARMED_MAPSTART");
	--	マップIDの取得
	local mapName = session.GetMapName();
	local mapProp = geMapTable.GetMapProp(mapName);
	--	キャラ名の取得
	local charName = GetMyName();

	if (g4.MapName == mapName) and (g4.CharName == charName) then
		local frm = ui.GetFrame("tpfarmed");
		frm:RunUpdateScript("TPFARMED_UPDATE",  1, 0.0, 0, 1);
		return;
	end
	--	マップ名の取得
	local mapNameS = mapProp:GetName();
	
	--	キャラオブジェクトの取得
	local pcObj = GetMyPCObject();

	--	現在経験値の取得
	local pcLv = pcObj.Lv;
	local expBT = g4.ExpTableB[pcLv]["Ttl"];
	local expBN = session.GetEXP();

	--	現在クラス経験値の取得
	local clsL  = g4.JobLvl;
	local clsR  = session.GetPcTotalJobGrade()
	local clLv = 0;
	if (clsR > 1) then
		clLv = math.min((clsR-2) *44 + clsL + 14 ,g4.ExpTableCLen);
	else
		clLv = math.min((clsR-1) *44 + clsL ,g4.ExpTableCLen);
	end
	local expCT = g4.ExpTableC[clLv]["Ttl"];
	local expCN = g4.JobExp;

	local money = tonumber(GET_TOTAL_MONEY_STR());

	if (g4.MapName ~= nil) then
		--	差分計算
		CHAT_SYSTEM("{#FFFE80}{s14}{ol}△" .. g4.MapNameS .. " [" .. g4.MapName .. "]{/}{/}{/}");

	end
	if (g4.MapName ~= nil) and (g4.CharName == charName) then
		local lapClock	= os.clock() - g4.StartClock;	-- Windowsならシステム秒;
		local expBX = expBT+expBN - g4.StartBExp;
		local expCX = expCT+expCN - g4.StartCExp;
		local moneyX = money - g4.StartMoney;
		
		CHAT_SYSTEM("{#FFFE80}{s14}{ol}　Time　：" .. g4.lpnts(math.floor(lapClock/3600),3) ..":"..g4.lpnts(math.floor(math.floor(lapClock/60)%60),2) ..":" ..g4.lpnts(math.floor(lapClock%60),2) .. "{/}{/}{/}");
		
		
		
		if (expBX > 0) then
			CHAT_SYSTEM("{#FFFE80}{s14}{ol}　＋BExp：" .. g4.lpnts(expBX,15) .. "{/}{/}{/}");
		end
		if (expCX > 0) then
			CHAT_SYSTEM("{#FFFE80}{s14}{ol}　＋CExp：" .. g4.lpnts(expCX,15) .. "{/}{/}{/}");
		end
		if (moneyX > 0) then
			CHAT_SYSTEM("{#FFFE80}{s14}{ol}　＋{img icon_item_silver 14 14}　：" .. g4.lpnts(moneyX,15) .. "{/}{/}{/}");
		end
		if s4.isShowGiveDmg and (g4.MemGiveDmg ~= nil) then
			for key,val in pairs(g4.MemGiveDmg) do
				CHAT_SYSTEM("{#FFFE80}{s14}{ol}　◇与Dm：" .. g4.lpnts(val,15) .. "：".. key .. "{/}{/}{/}");
			end
		end
		if s4.isShowTakeDmg and (g4.MemTakeDmg ~= nil) then
			for key,val in pairs(g4.MemTakeDmg) do
				CHAT_SYSTEM("{#FFFE80}{s14}{ol}　◆被Dm：" .. g4.lpnts(val,15) .. "：".. key .. "{/}{/}{/}");
			end
		end
	end
	g4.CharName		= charName;
	g4.MapName		= mapName;
	g4.MapNameS		= mapNameS;
	g4.StartBExp	= expBT+expBN;
	g4.StartCExp	= expCT+expCN;
	g4.StartMoney	= money;
	if (g4.CharName == charName) then
		g4.LastBExp		= g4.LastBExp or 0;
		g4.LastCExp		= g4.LastCExp or 0;
	else
		g4.LastBExp		= 0;
		g4.LastCExp		= 0;
	end
	g4.PopCnt		= 0;
	g4.MemLogSize	= g4.MemLogSize or 0;
	g4.MemMsgId		= g4.MemMsgId or 0;
	g4.TtlGiveDmg	= 0;
	g4.TtlTakeDmg	= 0;
	g4.MemGiveDmg	= {};
	g4.MemTakeDmg	= {};
	g4.TimeTable	= {};
	g4.TimeSec		= 0;
	g4.FirstClock	= 0;
	g4.LastClock	= 0;
	g4.StartClock	= os.clock();	-- Windowsならシステム秒;
	g4.MemPopCnt	= 0;
	g4.PopMax		= 0;
	g4.PopCnt		= 0;
	local frm = ui.GetFrame("tpfarmed");
	frm:ShowWindow(1);
	frm:RunUpdateScript("TPFARMED_UPDATE",  1, 0.0, 0, 1);
	CHAT_SYSTEM("{#FFFE80}{s14}{ol}▽" .. mapNameS .. " [" .. mapName .. "]{/}{/}{/}");
end
function TPFARMED_UPDATE(frame)
	-- タイムテーブルと、経験値の更新
	local f,m = pcall(g4.TPFARMED_TIMETABLE);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
	-- Ch人数の把握
	local f,m = pcall(g4.TPFARMED_POPCOUNT);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
	-- ダメージログの集計
	local f,m = pcall(g4.TPFARMED_UPDATE);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
	-- UIの更新
	local f,m = pcall(g4.TPFARMED_UI_UPDATE);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
	return 1;	--	RunUpdateScriptは1で継続
end

function g4.TPFARMED_UI_GAME_START(frame, control)
	local frm	= ui.GetFrame("tpfarmed_ui");
	if (frm == nil) then
		return;
	end
	local boxbex	= tolua.cast(frm:GetChild("boxbex"), "ui::CGroupBox");
	local boxcex	= tolua.cast(frm:GetChild("boxcex"), "ui::CGroupBox");
	local boxpop	= tolua.cast(frm:GetChild("boxpop"), "ui::CGroupBox");

	local frH = frm:GetHeight();

	frm:MoveFrame(s4.posX		,s4.posY	);
	if (s4.useUIExp == true) then
		if (boxbex ~= nil) then
			boxbex:SetPos(boxbex:GetX(),frH+2);
		end
		if (boxcex ~= nil) then
			boxcex:SetPos(boxcex:GetX(),frH+28);
		end
		frm:Resize(	520	,frH+52	);
	end
--	local boxdps	= tolua.cast(frm:GetChild("boxdps"), "ui::CGroupBox");
--	if (boxdps ~= nil) then
--		boxdps:SetColorTone("C0000000");
--	end
	if (boxbex ~= nil) then
		boxbex:SetColorTone("C0000000");
	end
	if (boxcex ~= nil) then
		boxcex:SetColorTone("C0000000");
	end
	if (boxpop ~= nil) then
		boxpop:SetColorTone("C0000000");
	end
	local i = 0;
	for i=1, 10 do
		local boxch	= tolua.cast(frm:GetChild("boxch"..i), "ui::CGroupBox");
		if (boxch ~= nil) then
			boxch:SetColorTone("C0000000");
		end
	end
	if s4.useUI then
		frm:ShowWindow(1);
	else
		frm:ShowWindow(0);
	end
end

function g4.TPFARMED_UI_UPDATE()
	local frm	= ui.GetFrame("tpfarmed_ui");
	if (frm == nil) then
		return;
	end
--	local timdps = math.min(g4.LastClock - g4.FirstClock ,50)+g4.TimeSec;
--	local ttldps =0;
--	local i = 0;
--	for i=1, 6 do
--		ttldps = ttldps + (g4.TimeTable["X"..i].GiveDmg or 0);
--	end
--	local numdps = math.floor(ttldps/timdps);
--	local strdps ="{#FE8080}DPS :"..g4.lpnts(numdps,15).."{/}/sec in"..g4.lpnts(timdps,3).."sec   {#FEC080}MapTotal:"..g4.lpnts(g4.TtlGiveDmg,15).."{/}";

	--	キャラオブジェクトの取得
	local pcObj = GetMyPCObject();

	--	現在経験値の取得
	local pcLv = pcObj.Lv;
	local expBR = g4.ExpTableB[pcLv]["Req"] or 0;
	local expBN = session.GetEXP();

	--	現在クラス経験値の取得
	local clsL  = g4.JobLvl;
	local clsR  = session.GetPcTotalJobGrade()
	local clLv = 0;
	if (clsR > 1) then
		clLv = math.min((clsR-2) *44 + clsL + 14 ,g4.ExpTableCLen);
	else
		clLv = math.min((clsR-1) *44 + clsL ,g4.ExpTableCLen);
	end
	local expCR = g4.ExpTableC[clLv]["Req"] or 0;
	local expCN = g4.JobExp;
	local perbex = expBN*100/(expBR+1);
	local percex = expCN*100/(expCR+1);
	local expBRk = math.floor(expBR /1000);
	local expBNk = math.floor(expBN /1000);
	local expCRk = math.floor(expCR /1000);
	local expCNk = math.floor(expCN /1000);
	
	local at1bex = "";
	local at1cex = "";
	if (g4.LastBExp >9999999) then 
		at1bex = g4.lpnts(math.floor(g4.LastBExp /1000000),5).."M"
	elseif (g4.LastBExp >9999) then 
		at1bex = g4.lpnts(math.floor(g4.LastBExp /1000),5).."K"
	else
		at1bex = g4.lpnts(math.floor(g4.LastBExp),5).." "
	end
	if (g4.LastCExp >9999999) then 
		at1cex = g4.lpnts(math.floor(g4.LastCExp /1000000),5).."M"
	elseif (g4.LastCExp >9999) then 
		at1cex = g4.lpnts(math.floor(g4.LastCExp /1000),5).."K"
	else
		at1cex = g4.lpnts(math.floor(g4.LastCExp),5).." "
	end
	local toxbex = (expBR - expBN + g4.LastBExp - 1) / g4.LastBExp;
	local toxcex = (expCR - expCN + g4.LastCExp - 1) / g4.LastCExp;
	local toXbex = "";
	local toXcex = "";
	if (g4.LastBExp > 0) and (toxbex >9999999) then 
		toXbex = g4.lpnts(math.floor(toxbex /1000000),5).."M"
	elseif (g4.LastBExp > 0) and (toxbex >9999) then 
		toXbex = g4.lpnts(math.floor(toxbex /1000),5).."K"
	elseif (g4.LastBExp > 0) then 
		toXbex = g4.lpnts(math.floor(toxbex),5).." "
	else
		toXbex = "----- "
	end
	if (g4.LastCExp > 0) and (toxcex >9999999) then 
		toXcex = g4.lpnts(math.floor(toxcex /1000000),5).."M"
	elseif (g4.LastCExp > 0) and (toxcex >9999) then 
		toXcex = g4.lpnts(math.floor(toxcex /1000),5).."K"
	elseif (g4.LastCExp > 0) then 
		toXcex = g4.lpnts(math.floor(toxcex),5).." "
	else
		toXcex = "----- "
	end

	local strbex ="{#8080FE}BExp:"..g4.lpnts(expBNk,11).."K{/}/{#80FEFE}"..g4.lpnts(expBRk,11).."K{/} {#80FE80}"..string.format("%5.2f", perbex).."%{/}     {#C0FE40}@"..at1bex.."{/} x"..toXbex;
	local strcex ="{#8080FE}CExp:"..g4.lpnts(expCNk,11).."K{/}/{#80FEFE}"..g4.lpnts(expCRk,11).."K{/} {#80FE80}"..string.format("%5.2f", percex).."%{/}     {#C0FE40}@"..at1cex.."{/} x"..toXcex;

	local strpop ="POP:"..g4.lpnts(g4.PopCnt,3).."/"..g4.lpnts(g4.PopMax,3);

--	local txtdps	= GET_CHILD_RECURSIVELY(frm, "txtdps", "ui::CRichText");
--	if (txtdps ~= nil) then
--		txtdps:SetText(strdps);
--	end

	local txtbex	= GET_CHILD_RECURSIVELY(frm, "txtbex", "ui::CRichText");
	if (txtbex ~= nil) then
		txtbex:SetText(strbex);
	end

	local txtcex	= GET_CHILD_RECURSIVELY(frm, "txtcex", "ui::CRichText");
	if (txtcex ~= nil) then
		txtcex:SetText(strcex);
	end

	local boxpop	= tolua.cast(frm:GetChild("boxpop"), "ui::CGroupBox");
	if (boxpop ~= nil) then
		local txtpop	= tolua.cast(boxpop:GetChild("txtpop"), "ui::CRichText");
		if (txtpop ~= nil) then
			txtpop:SetText(strpop);
		end
	end
	if (s4.useUIChCh) then
		for i=1, 10 do
			local boxch	= tolua.cast(frm:GetChild("boxch"..i), "ui::CGroupBox");
			if (boxch ~= nil) then
				if (i>g4.ChNum) or (g4["PopMax"..i] == nil) or (g4["PopCnt"..i] == nil) then
					boxch:ShowWindow(0);
				else
					if ((i-1) == g4.ChNow) then
						boxch:SetColorTone("60FFFFFF");
					else
						boxch:SetColorTone("C0100000");
					end
					boxch:ShowWindow(1);
					local txtch	= tolua.cast(boxch:GetChild("txtch"..i), "ui::CRichText");
					if (txtch ~= nil) then
						local cnt = g4["PopCnt"..i];
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
						txtch:SetText("{#"..textcol.."}c"..i.."{nl}"..g4.lpnts(cnt,4).."{/}");
					end
				end
			end
		end
	end
end
function TPFARMED_ON_CHCH(frame, ctrl, argStr, argNum)
	RUN_GAMEEXIT_TIMER("Channel", tonumber(ctrl:GetName():sub(6))-1);
end

function g4.TPFARMED_UI_LBUTTONUP()
	local frm	= ui.GetFrame("tpfarmed_ui");
	if (frm == nil) then
		return;
	end
	s4.posX	= frm:GetX();
	s4.posY	= frm:GetY();
	g4.TPFARMED_SAVE_SETTING();
end

function g4.TPFARMED_TIMETABLE()
	local nowTime	= math.floor(os.clock());
	local nowTmP10	= math.floor(nowTime/10)*10;
	local nowTmM10	= math.floor(nowTime%10);
	if (g4.FirstClock == 0) then
		g4.FirstClock	= nowTime;
	end
	--	キャラオブジェクトの取得
	local pcObj = GetMyPCObject();

	--	現在経験値の取得
	local pcLv = pcObj.Lv;
	local expBT = g4.ExpTableB[pcLv]["Ttl"];
	local expBN = session.GetEXP();

	--	現在クラス経験値の取得
	local clsL  = g4.JobLvl;
	local clsR  = session.GetPcTotalJobGrade()
	local clLv = 0;
	if (clsR > 1) then
		clLv = math.min((clsR-2) *44 + clsL + 14 ,g4.ExpTableCLen);
	else
		clLv = math.min((clsR-1) *44 + clsL ,g4.ExpTableCLen);
	end
	local expCT = g4.ExpTableC[clLv]["Ttl"];
	local expCN = g4.JobExp;

	local money = tonumber(GET_TOTAL_MONEY_STR());

	if (g4.LastClock ~= nowTmP10) then	--	10秒に1回動く

		if (s4.isShowTimeTbl) and (s4.isShowGiveDmg) and (g4.LastClock ~= 0) and (g4.TimeTable["X1"].GiveDmg > 0) then
			CHAT_SYSTEM("{#80FE80}{s14}{ol}　Dmg/10Sec:"..g4.lpnts(g4.TimeTable["X1"].GiveDmg,15).." (@"..g4.lpnts(nowTime,7) .. "){/}{/}{/}");
		end
		local i = 0;
		for i=1, 29 do
			g4.TimeTable["X"..(31-i)] = (g4.TimeTable["X"..(30-i)] or {});
		end
		g4.TimeTable["X1"] = {};
		g4.TimeTable["X1"].GiveDmg = 0;
		g4.TimeTable["X1"].TakeDmg = 0;
		g4.TimeTable["X1"].expBS = expBT+expBN;
		g4.TimeTable["X1"].expCS = expCT+expCN;
		g4.TimeTable["X1"].moneyS = money;
		g4.TimeTable["X1"].expBX  = 0;
		g4.TimeTable["X1"].expCX  = 0;
		g4.TimeTable["X1"].moneyX = 0;
		if (g4.LastClock ~= 0) then	--	リアルタイムに更新される値はこのタイミングで確定させる
			g4.TimeTable["X2"].expBX  = g4.TimeTable["X1"].expBS  - g4.TimeTable["X2"].expBS;
			g4.TimeTable["X2"].expCX  = g4.TimeTable["X1"].expCS  - g4.TimeTable["X2"].expCS;
			g4.TimeTable["X2"].moneyX = g4.TimeTable["X1"].moneyS - g4.TimeTable["X2"].moneyS;
			if (s4.isShowTimeTbl) and (s4.isShowExpGain) and ((g4.TimeTable["X2"].expBX > 0) or (g4.TimeTable["X2"].expCX > 0)) then
				CHAT_SYSTEM("{#80FE80}{s14}{ol}　Exp/10Sec:"..g4.lpnts(g4.TimeTable["X2"].expBX,15) .." /" ..g4.lpnts(g4.TimeTable["X2"].expCX,15) .." (@"..g4.lpnts(nowTime,7) .. "){/}{/}{/}");
			end
			if (s4.isShowTimeTbl) and (s4.isShowSilver) and (g4.TimeTable["X2"].moneyX > 0) then
				CHAT_SYSTEM("{#80FE80}{s14}{ol}　Sil/10Sec:"..g4.lpnts(g4.TimeTable["X2"].moneyX,15) .." (@"..g4.lpnts(nowTime,7) .. "){/}{/}{/}");
			end
		end
	end
	g4.LastClock = nowTmP10;
	g4.TimeSec = nowTmM10;

	g4.TimeTable["X1"].expBX  = (expBT+expBN) - g4.TimeTable["X1"].expBS;
	g4.TimeTable["X1"].expCX  = (expCT+expCN) - g4.TimeTable["X1"].expCS;
	g4.TimeTable["X1"].moneyX = money         - g4.TimeTable["X1"].moneyS;
end

function g4.TPFARMED_POPCOUNT()
	g4.ChNow = session.loginInfo.GetChannel();
	local zoneInsts = session.serverState.GetMap();
	local popMax = session.serverState.GetMaxPCCount();
	if zoneInsts == nil then
		g4.ChNum = 0;
		return;
	end
	g4.ChNum = zoneInsts:GetZoneInstCount();
	if g4.ChNum == 0 then
		return;
	end
	app.RequestChannelTraffics();
	local i = 0;
	for i=1, g4.ChNum do
		local zoneInst = zoneInsts:GetZoneInstByIndex(i-1);
		g4["PopMax"..i] = popMax;
		g4["PopCnt"..i] = zoneInst.pcCount;
		if ((i-1) == g4.ChNow) then
			g4.PopMax = popMax;
			g4.PopCnt = zoneInst.pcCount;
			if (g4.MemPopCnt ~= zoneInst.pcCount) and ((g4.MemPopCnt < 5) or (zoneInst.pcCount < 5)) then
				g4.MemPopCnt = zoneInst.pcCount;
				if (s4.isShowPopCnt) then
					CHAT_SYSTEM("{#C0FF80}{s14}{ol}　□POP " .. zoneInst.pcCount .. "/" .. popMax .. "{/}{/}{/}");
				end
			end
		end
	end
end

function g4.TPFARMED_UPDATE()
	local logsize = session.ui.GetMsgInfoSize("chatgbox_TOTAL");
	if (logsize ~= nil) and (logsize > 0) then
		g4.MemLogSize = logsize;
		local logpt = logsize-1;
		if logpt > 0 then
			local msg1stInfo = session.ui.GetChatMsgInfo("chatgbox_TOTAL", logpt);
			local msg1stId = msg1stInfo:GetMsgInfoID();
			while logpt > 0 do
				local f,m = pcall(g4.TPFARMED_UPDATEROW,logpt,logsize);
				if f ~= true then
					CHAT_SYSTEM(m);
				elseif (m) then
					break; --trueを返すとループ終了
				end
				logpt = logpt -1;
			end
			g4.MemMsgId = msg1stId;
		end
	end
	return;
end

function g4.TPFARMED_UPDATEROW(logpt,logsize)
	local msgInfo = session.ui.GetChatMsgInfo("chatgbox_TOTAL", logpt);
	if (msgInfo == nil) then
		CHAT_SYSTEM("Alert:MsgInfoNil");
		return false; --trueを返すとループ終了
	end
	local msgId = msgInfo:GetMsgInfoID();
	local chkLogSize = session.ui.GetMsgInfoSize("chatgbox_TOTAL");
	if (chkLogSize ~= logsize) then
		if (logpt < chkLogSize) then
			logpt = chkLogSize;
		end
		CHAT_SYSTEM("Alert:SizeChange "..logsize.." /"..chkLogSize);
	end
	if (g4.MemMsgId == msgId) then
		return true; --trueを返すとループ終了
	end
	local msgType = msgInfo:GetMsgType();
	if (msgType == "Battle") then
		local tempMsg = dictionary.ReplaceDicIDInCompStr(msgInfo:GetMsg());
		if s4.isShowGiveDmg then
			local chk1,chk2 = tempMsg:find("GiveDamage{TO}{AMOUNT}");
			if (chk1 ~= nil) and (chk1 > 0) then
				local chk3,chk4 = tempMsg:find("%$TO%$%*%$");
				local chkmon = tempMsg:sub(chk4+1);
				local chk5,chk6 = chkmon:find("%$%*%$AMOUNT%$%*%$");
				local chk7,chk8 = chkmon:find("#@!");
				if (chk6 ~= nil) and (chk6 > 0) and (chk7 ~= nil) and (chk7 > 0) then
					local chknum = chkmon:sub(chk6+1,chk7-1);
					chkmon = chkmon:sub(1,chk5-1);
					chknum = chknum:gsub(",","");
					if (chkmon ~= nil) and (chknum ~= nil) and (tonumber(chknum) ~= nil) and (tonumber(chknum) > 0) then
						g4.MemGiveDmg[chkmon] = (g4.MemGiveDmg[chkmon] or 0) + tonumber(chknum);
						g4.TimeTable["X1"].GiveDmg = g4.TimeTable["X1"].GiveDmg + tonumber(chknum);
						g4.TtlGiveDmg = g4.TtlGiveDmg + tonumber(chknum);
						-- CHAT_SYSTEM(""..chkmon.." /"..chknum.." /"..g4.MemGiveDmg[chkmon].." x"..msgId);
					else
						CHAT_SYSTEM("Alert:GiveDamage2 "..tempMsg);
					end
				else
					CHAT_SYSTEM("Alert:GiveDamage1 "..tempMsg);
				end
			end
		end
		if s4.isShowTakeDmg then
			local chk1,chk2 = tempMsg:find("TakeDamage{FROM}{AMOUNT}");
			if (chk1 ~= nil) and (chk1 > 0) then
				local chk3,chk4 = tempMsg:find("%$FROM%$%*%$");
				local chkmon = tempMsg:sub(chk4+1);
				local chk5,chk6 = chkmon:find("%$%*%$AMOUNT%$%*%$");
				local chk7,chk8 = chkmon:find("#@!");
				if (chk6 ~= nil) and (chk6 > 0) and (chk7 ~= nil) and (chk7 > 0) then
					local chknum = chkmon:sub(chk6+1,chk7-1);
					chkmon = chkmon:sub(1,chk5-1);
					chknum = chknum:gsub(",","");
					if (chkmon ~= nil) and (chknum ~= nil) and (tonumber(chknum) ~= nil) and (tonumber(chknum) > 0) then
						g4.MemTakeDmg[chkmon] = (g4.MemTakeDmg[chkmon] or 0) + tonumber(chknum);
						g4.TimeTable["X1"].TakeDmg = g4.TimeTable["X1"].TakeDmg + tonumber(chknum);
						g4.TtlTakeDmg = g4.TtlTakeDmg + tonumber(chknum);
						-- CHAT_SYSTEM(""..chkmon.." /"..chknum.." /"..g4.MemTakeDmg[chkmon].." x"..msgId);
					else
						CHAT_SYSTEM("Alert:TakeDamage2 "..tempMsg);
					end
				else
					CHAT_SYSTEM("Alert:TakeDamage1 "..tempMsg);
				end
			end
		end
	end
	return false; --trueを返すとループ終了
end

function g4.TPFARMED_NEW_GACHA_CUBE_SUCEECD_UI(frame, invItemClsID, rewardItem, btnVisible)
	if (s4.isShowCube) then
		local cubeItem = GetClassByType("Item", invItemClsID);
		local reward = GetClass("Item", rewardItem);
		local fontSize		= GET_CHAT_FONT_SIZE();	

		CHAT_SYSTEM("☆"..	"{img "..cubeItem.Icon.." "..fontSize.." "..fontSize.."}"..cubeItem.Name.. " >>"..	"{img "..reward.Icon.." "..fontSize.." "..fontSize.."}" .. reward.Name);
	end
end

function g4.TPFARMED_GETITEM(frame, msg, guid, num)
	local invItem = GET_ITEM_BY_GUID(guid);
	if (invItem == nil) then
		return;
	end
	local itemObj = GetIES(invItem:GetObject());
	if (itemObj == nil) then
		return;
	end
	if (((s4.isShowSilver ~= true) and (itemObj.ClassID == 900011)) and (num < s4.ManyMoney)) then
		return;
	end
	local fontSize		= GET_CHAT_FONT_SIZE();	
	local itemCnt		= "";
	if (itemObj.MaxStack > 1) then
		local numStr		= g4.nts(num);
		itemCnt		=" x" .. numStr .." (" .. g4.nts(invItem.count) .. ")";
	end
	local diaryCnt	= "";
	if (s4.isShowJournal and itemObj.ClassID ~= 900011) then
		local obtainCount, consumeCount = ADVENTURE_BOOK_ITEM_CONTENT.ITEM_HISTORY_COUNT(itemObj.ClassID);
		local curScore, maxScore = _GET_ADVENTURE_BOOK_POINT_ITEM((itemObj.ItemType == 'Equip'), obtainCount);
		local curLv, curPoint, maxPoint = GET_ADVENTURE_BOOK_ITEM_OBTAIN_COUNT_INFO((itemObj.ItemType == 'Equip'), obtainCount);
	--	CHAT_SYSTEM("{#80C0FF}{s14}{ol}　　<"..obtainCount.."/"..consumeCount.."/"..curScore.."/"..maxScore.."/"..curLv.."/"..curPoint.."/"..maxPoint .. ">{/}{/}{/}");
		
		if (curPoint == maxPoint) then
			diaryCnt	= " <☆>";
		else
			g4.ItemCount = g4.ItemCount or {};
			g4.ItemCount[""..itemObj.ClassID] = g4.ItemCount[""..itemObj.ClassID] or {};
			local itemCount = g4.ItemCount[""..itemObj.ClassID];
			if(itemCount.BaseCt ~= curPoint) then
				itemCount.BaseCt = curPoint;
				itemCount.NowCt  = itemCount.BaseCt + num;
			else
				itemCount.NowCt = itemCount.NowCt  + num;
			end
			local curLv, curPoint, maxPoint = GET_ADVENTURE_BOOK_ITEM_OBTAIN_COUNT_INFO((itemObj.ItemType == 'Equip'), itemCount.NowCt);
			diaryCnt	= " <".. itemCount.NowCt .."/".. maxPoint ..">";
		end;
	--	CHAT_SYSTEM("{#80C0FF}{s14}{ol}　　"..diaryCnt .. "{/}{/}{/}");
	end
	if (s4.isShowPickItem) or ((s4.isShowSilver == true) and (itemObj.ClassID == 900011)) then
		CHAT_SYSTEM("{#80C0FF}{s14}{ol}　＋{img "..itemObj.Icon.." 14 14}"..itemObj.Name .. itemCnt .. diaryCnt .. "{/}{/}{/}");
	end
end

function g4.nts(num)
	local numStr		= "";
	if (num~=nil) then
		numStr = numStr..num;
	end
	if (#numStr > 12) then
		numStr = string.sub(numStr,0,#numStr-12)..","..string.sub(numStr,#numStr-11,#numStr-9)..","..string.sub(numStr,#numStr-8,#numStr-6)..","..string.sub(numStr,#numStr-5,#numStr-3)..","..string.sub(numStr,#numStr-2);
	elseif (#numStr > 9) then
		numStr = string.sub(numStr,0,#numStr-9)                                               ..","..string.sub(numStr,#numStr-8,#numStr-6)..","..string.sub(numStr,#numStr-5,#numStr-3)..","..string.sub(numStr,#numStr-2);
	elseif (#numStr > 6) then
		numStr = string.sub(numStr,0,#numStr-6)                                                                                            ..","..string.sub(numStr,#numStr-5,#numStr-3)..","..string.sub(numStr,#numStr-2);
	elseif (#numStr > 3) then
		numStr = string.sub(numStr,0,#numStr-3)                                                                                                                                         ..","..string.sub(numStr,#numStr-2);
	end
	return numStr;
end
function g4.lpnts(num,len)
	local numStr		= g4.nts(num);
	return string.rep(" ", len - #numStr) .. numStr;
end
