--[[
	日本語
--]]

local acutil = require('acutil');

_G['TPFARMED'] = _G['TPFARMED'] or {};
local g4 = _G['TPFARMED'];
g4.settingPath = g4.settingpath or "../addons/tpfarmed/settings.json";
g4.settings = g4.settings or {};
local s4 = g4.settings;

ADDONS											= ADDONS or {};
ADDONS.torahamu									= ADDONS.torahamu or {};
ADDONS.torahamu.CHATEXTENDS						= ADDONS.torahamu.CHATEXTENDS or {};
ADDONS.torahamu.CHATEXTENDS.settings			= ADDONS.torahamu.CHATEXTENDS.settings or {};
ADDONS.torahamu.CHATEXTENDS.settings.BALLON_FLG	= ADDONS.torahamu.CHATEXTENDS.settings.BALLON_FLG or false;

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
	addon:RegisterMsg("GAME_START", "TPFARMED_GAME_START")
	addon:RegisterMsg("INV_ITEM_IN", "TPFARMED_INV_ITEM_IN");
	addon:RegisterMsg("JOB_EXP_UPDATE", "TPFARMED_JOB_EXP_UPDATE");
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

function TPFARMED_GAME_START(frame, control)
	local f,m = pcall(g4.TPFARMED_MAPSTART());
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
end

function g4.TPFARMED_LOAD_SETTING()
	local t, err = acutil.loadJSON(g4.settingPath);
	if t then
		s4 = acutil.mergeLeft(s4, t);
	end
	-- 	値の存在確保と初期値設定
	s4.isDebug			= ((type(s4.isDebug			) == "boolean")	and s4.isDebug			)or false;
	s4.isShowCube		= ((type(s4.isShowCube		) == "boolean")	and s4.isShowCube		)or (s4.isShowCube		==nil);
	s4.isShowSilver		= ((type(s4.isShowSilver	) == "boolean")	and s4.isShowSilver		)or (s4.isShowSilver	==nil);
	s4.isShowJournal	= ((type(s4.isShowJournal	) == "boolean")	and s4.isShowJournal	)or (s4.isShowJournal	==nil);
end

function g4.TPFARMED_SAVE_SETTING()
	local filep = io.open(g4.settingPath,"w+");
	if filep then
		filep:write("{\n");
		filep:write("\t\"isDebug\":"		.. ((s4.isDebug			and "true") or "false")	.."\n"	);
		filep:write("\t\"isShowCube\":"		.. ((s4.isShowCube		and "true") or "false")	.."\n"	);
		filep:write("\t\"isShowSilver\":"	.. ((s4.isShowSilver	and "true") or "false")	.."\n"	);
		filep:write("\t\"isShowJournal\":"	.. ((s4.isShowJournal	and "true") or "false")	.."\n"	);
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
	
	for i=1, 140 do
		local classR	= math.floor((i-1)/14)+1;
		local classL	= (i % 14 == 0) and 14 or (i % 14);
		local className	= "Job_" .. classR .. "_" ..  classL;
		local classData	= GetClassByNameFromList(clsList, className);
		if (classData ~= nil) then
			if (i % 14 == 1) then
				expCTX = expCT;
				expC = classData.TotalXp;
			else
				expC = classData.TotalXp - expCT + expCTX;
			end
		
			if (expC == 0) then
				break;
			end
			if (i % 14 == 1) then
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
	i = (clsR-1) *14 + clsL;
	local expC  = g4.ExpTableC[i]["Req"];
	local expCR = g4.ExpTableC[i]["TRq"];
	local expCT = g4.ExpTableC[i]["Ttl"];
	local expCN = g4.JobExp;
	CHAT_SYSTEM("R" .. g4.lpnts(clsR,2) .. "L" .. g4.lpnts(clsL,2).." "..g4.lpnts(expCN,14).."/"..g4.lpnts(expC,14));
	CHAT_SYSTEM("Total  "..g4.lpnts(expCT+expCN,14).."/"..g4.lpnts(expCR,14));
		
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
	--	マップIDの取得
	local mapName = session.GetMapName();
	local mapProp = geMapTable.GetMapProp(mapName);
	--	キャラ名の取得
	local charName = GetMyName();

	if (g4.MapName == mapName) and (g4.CharName == charName) then
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
	local clLv = (clsR-1) *14 + clsL;
	local expCT = g4.ExpTableC[clLv]["Ttl"];
	local expCN = g4.JobExp;

	local money = GET_TOTAL_MONEY();

	if (g4.MapName ~= nil) then
		--	差分計算
		CHAT_SYSTEM("{#FFFE80}{s14}{ol}△" .. g4.MapNameS .. " [" .. g4.MapName .. "]{/}{/}{/}");

	end
	if (g4.MapName ~= nil) and (g4.CharName == charName) then
		local expBX = expBT+expBN - g4.StartBExp;
		local expCX = expCT+expCN - g4.StartCExp;
		local moneyX = money - g4.StartMoney;
		if (expBX > 0) then
			CHAT_SYSTEM("{#FFFE80}{s14}{ol}　＋BExp：" .. g4.lpnts(expBX,14) .. "{/}{/}{/}");
		end
		if (expCX > 0) then
			CHAT_SYSTEM("{#FFFE80}{s14}{ol}　＋CExp：" .. g4.lpnts(expCX,14) .. "{/}{/}{/}");
		end
		if (moneyX > 0) then
			CHAT_SYSTEM("{#FFFE80}{s14}{ol}　＋{img icon_item_silver 14 14}　：" .. g4.lpnts(moneyX,14) .. "{/}{/}{/}");
		end
	end
	g4.CharName = charName
	g4.MapName = mapName;
	g4.MapNameS = mapNameS;
	g4.StartBExp = expBT+expBN;
	g4.StartCExp = expCT+expCN;
	g4.StartMoney = money;
	CHAT_SYSTEM("{#FFFE80}{s14}{ol}▽" .. mapNameS .. " [" .. mapName .. "]{/}{/}{/}");
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
	if ((s4.isShowSilver ~= true) and (itemObj.ClassID == 900011)) then
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
	CHAT_SYSTEM("{#80C0FF}{s14}{ol}　＋{img "..itemObj.Icon.." 14 14}"..itemObj.Name .. itemCnt .. diaryCnt .. "{/}{/}{/}");
end

function g4.nts(num)
	local numStr		= ""..num;
	if (#numStr > 9) then
		numStr = string.sub(numStr,0,#numStr-9)..","..string.sub(numStr,#numStr-8,#numStr-6)..","..string.sub(numStr,#numStr-5,#numStr-3)..","..string.sub(numStr,#numStr-2);
	elseif (#numStr > 6) then
		numStr = string.sub(numStr,0,#numStr-6)..","..string.sub(numStr,#numStr-5,#numStr-3)..","..string.sub(numStr,#numStr-2);
	elseif (#numStr > 3) then
		numStr = string.sub(numStr,0,#numStr-3)..","..string.sub(numStr,#numStr-2);
	end
	return numStr;
end
function g4.lpnts(num,len)
	local numStr		= ""..num;
	if (#numStr > 9) then
		numStr = string.sub(numStr,0,#numStr-9)..","..string.sub(numStr,#numStr-8,#numStr-6)..","..string.sub(numStr,#numStr-5,#numStr-3)..","..string.sub(numStr,#numStr-2);
	elseif (#numStr > 6) then
		numStr = string.sub(numStr,0,#numStr-6)..","..string.sub(numStr,#numStr-5,#numStr-3)..","..string.sub(numStr,#numStr-2);
	elseif (#numStr > 3) then
		numStr = string.sub(numStr,0,#numStr-3)..","..string.sub(numStr,#numStr-2);
	end
	return string.rep(" ", len - #numStr) .. numStr;
end
