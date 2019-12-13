--[[
	日本語
	関数群を保存している
--]]
local g0 = GetTpUtil();

g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "__tputil_Exp";

local gExp = g0.Exp;
local gClk = g0.Clock;



function TPUTIL_JOB_EXP_UPDATE(frame, msg, str, exp, tableinfo)
	gExp.JobLvl = tableinfo.level;
	gExp.JobExp = exp - tableinfo.startExp;
	if (str ~= nil) and (str ~= "None") and (str ~= "") and (msg == "JOB_EXP_ADD") then
		gExp.LastCExp = tonumber(str) or 0;
	end
end
function TPUTIL_EXP_UPDATE(frame, msg, argStr, argNum)
	if (argNum ~= nil) and (tonumber(argNum) ~= nil) and (tonumber(argNum) ~= 0) then
		gExp.LastBExp = tonumber(argNum);
	end
end

function gExp.Init()
	gExp.TableBLen	= gExp.TableBLen	or 0;
	gExp.TableCLen	= gExp.TableCLen	or 0;
	gExp.TableB		= gExp.TableB	or {};
	gExp.TableC		= gExp.TableC	or {};
	gExp.LastBExp		= gExp.LastBExp	or 0;
	gExp.LastCExp		= gExp.LastCExp	or 0;
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
			gExp.TableBLen = i;
			gExp.TableB[i] = {};
			gExp.TableB[i]["Req"] = expB;
			gExp.TableB[i]["TRq"] = expBT;
			gExp.TableB[i]["Ttl"] = expBT - expB;
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
			gExp.TableCLen = i;
			gExp.TableC[i] = {};
			gExp.TableC[i]["Req"] = expC;
			gExp.TableC[i]["TRq"] = expCT;
			gExp.TableC[i]["Ttl"] = expCT - expC;
			gExp.TableC[i]["Rnk"] = classR;
			gExp.TableC[i]["Lvl"] = classL;
		end
	end
end

function gExp.Dump()
	local i = 0;
	local pcObj = GetMyPCObject();
	if pcObj == nil then
		return;
	end
	
	i = pcObj.Lv;
	local expB  = gExp.TableB[i]["Req"];
	local expBR = gExp.TableB[i]["TRq"];
	local expBT = gExp.TableB[i]["Ttl"];
	local expBN = session.GetEXP();
	CHAT_SYSTEM("Lv" .. g0.lpn2s(i,3).."  "..g0.lpn2s(expBN,14).."/"..g0.lpn2s(expB,14));
	CHAT_SYSTEM("Total  "..g0.lpn2s(expBT+expBN,14).."/"..g0.lpn2s(expBR,14));

	local clsL  = gExp.JobLvl;
	local clsR  = session.GetPcTotalJobGrade()
	if (clsR > 1) then
		i = math.min((clsR-2) *44 + clsL + 14 ,gExp.TableCLen);
	else
		i = math.min((clsR-1) *44 + clsL ,gExp.TableCLen);
	end
	local expC  = gExp.TableC[i]["Req"];
	local expCR = gExp.TableC[i]["TRq"];
	local expCT = gExp.TableC[i]["Ttl"];
	local expCN = gExp.JobExp;
	CHAT_SYSTEM("R" .. g0.lpn2s(clsR,2) .. "L" .. g0.lpn2s(clsL,2).." "..g0.lpn2s(expCN,14).."/"..g0.lpn2s(expC,14));
	CHAT_SYSTEM("Total  "..g0.lpn2s(expCT+expCN,14).."/"..g0.lpn2s(expCR,14));
		
	local i = 0;
	for i=1, gExp.TableBLen do
		local expB  = gExp.TableB[i]["Req"];
		local expBT = gExp.TableB[i]["Ttl"];
	--	CHAT_SYSTEM("Lv" .. g0.lpn2s(i,3).."    Ttl:"..g0.lpn2s(expBT,14)).."   Req:"..g0.lpn2s(expB,14);
	end
	for i=1, gExp.TableCLen do
		local expC  = gExp.TableC[i]["Req"];
		local expCT = gExp.TableC[i]["Ttl"];
		local clsR  = gExp.TableC[i]["Rnk"];
		local clsL  = gExp.TableC[i]["Lvl"];
	--	CHAT_SYSTEM("R" .. g0.lpn2s(clsR,2) .. "L" .. g0.lpn2s(clsL,2).."   Ttl:"..g0.lpn2s(expCT,14).."   Req:"..g0.lpn2s(expC,14));
	end
end

function gExp.Culc()	--	retrun expBTotal 現在のベース経験総量	expCTotal 現在のクラス経験総量

	--	キャラオブジェクトの取得
	local pcObj = GetMyPCObject();
	local pcLv = pcObj.Lv;

	gExp.IsMaxB = (pcLv >= PC_MAX_LEVEL);
	--	現在経験値の取得
	local expBT = gExp.TableB[pcLv]["Ttl"];
	gExp.SubBExp = session.GetEXP();
	gExp.NowBExp = expBT + gExp.SubBExp;
	gExp.NxtBExp = gExp.TableB[pcLv]["Req"];

	--	現在クラス経験値の取得
	local clsL  = gExp.JobLvl;
	local clsR  = session.GetPcTotalJobGrade()
	local clLv = 0;
	if (clsR > 1) then
		clLv = math.min((clsR-2) *44 + clsL + 14 ,gExp.TableCLen);
	else
		clLv = math.min((clsR-1) *44 + clsL ,gExp.TableCLen);
	end
	gExp.IsMaxC = (clLv >= 146);
	local expCT = gExp.TableC[clLv]["Ttl"];
	gExp.SubCExp = gExp.JobExp;
	gExp.NowCExp = expCT + gExp.SubCExp;
	gExp.NxtCExp = gExp.TableC[clLv]["Req"];
end

function gExp.MapEnd(fSameChar)
	gExp.Culc();
	if (fSameChar) then	--	同キャラだがマップは変わっている
		gExp.MapBExp = gExp.NowBExp - (gExp.StartBExp or gExp.NowBExp);
		gExp.MapCExp = gExp.NowCExp - (gExp.StartCExp or gExp.NowCExp);
		gExp.LastBExp		= gExp.LastBExp or 0;
		gExp.LastCExp		= gExp.LastCExp or 0;
	else
		gExp.MapBExp = gExp.MapBExp or 0;
		gExp.MapCExp = gExp.MapCExp or 0;
		gExp.LastBExp		= 0;
		gExp.LastCExp		= 0;
	end
	gExp.StartBExp = gExp.NowBExp;
	gExp.StartCExp = gExp.NowCExp;
end

function gExp.Clock(f10)	--	f10:bool 10秒に1回true;
	gExp.Culc();
	gExp.MapBExp = gExp.NowBExp - (gExp.StartBExp or gExp.NowBExp);
	gExp.MapCExp = gExp.NowCExp - (gExp.StartCExp or gExp.NowCExp);
	if(f10) then
		gClk.Table["X1"].expBS = gExp.NowBExp;
		gClk.Table["X1"].expCS = gExp.NowCExp;
		gClk.Table["X1"].expBX = 0;
		gClk.Table["X1"].expCX = 0;
		if (gClk.LastClock ~= -1) then	--	1ループ目はX2がないので実行しない
			gClk.Table["X2"].expBX  = gClk.Table["X1"].expBS  - gClk.Table["X2"].expBS;
			gClk.Table["X2"].expCX  = gClk.Table["X1"].expCS  - gClk.Table["X2"].expCS;
		end
	
	end
	gClk.Table["X1"].expBX  = gExp.NowBExp - gClk.Table["X1"].expBS;
	gClk.Table["X1"].expCX  = gExp.NowCExp - gClk.Table["X1"].expCS;
end
