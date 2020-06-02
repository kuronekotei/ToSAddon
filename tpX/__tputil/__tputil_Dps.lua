--[[__tputil_Dps.lua
	日本語
	関数群を保存している
--]]
local g0 = GetTpUtil();

g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "__tputil_Dps";

local gDps = g0.Dps;
local gClk = g0.Clock;

gDps.fEnb = false;

function gDps.MapInit()
	gDps.fUse = (gDps.fEnb and (g0.MapIsCity==false) and (g0.MapIsPvp==false));
	if(gDps.fUse) then
		session.dps.ReqStartDpsPacket();
	end;
end
function gDps.MapEnd()
	gDps.InfoLen		= 0;
	gDps.DtlTbl		= {};
	gDps.MapPerMns	= gDps.PerMns or {};
	gDps.MapPerSkl	= gDps.PerSkl or {};
	gDps.MapPerCrs	= gDps.PerCrs or {};
	gDps.PerMns		= {};
	gDps.PerSkl		= {};
	gDps.PerCrs		= {};
	gDps.MapDmg		= 0;
	gDps.InfoLast		= 0;
	gDps.fUse = ((g0.MapIsCity==false) and (g0.MapIsPvp==false));
	if(gDps.fUse) then
		session.dps.ReqStartDpsPacket();
	end;
end

function gDps.Clock(f10)
	gClk.Table["X1"].Dmg	= (gClk.Table["X1"].Dmg or 0);
	gDps.MapDmg				= (gDps.MapDmg or 0);
	if(gDps.fUse ~= true) then
		return;
	end
	gDps.InfoLen	= session.dps.Get_allDpsInfoSize();
	if(gDps.InfoLast > gDps.InfoLen) then
		gDps.InfoLast	= 0;
	end
	if(gDps.InfoLen == 0) then
		return;
	end
	if(gDps.InfoLast == 0) and (gDps.InfoLen> 0) then
		gDps.InfoLast	= 1;
		gDps.DtlTbl	= {};
	end
	for i=gDps.InfoLast, gDps.InfoLen do
		gDps.InfoLast = i;
		gDps.DtlTbl[i] = {};
		local dps = gDps.DtlTbl[i];
		local info = session.dps.Get_alldpsInfoByIndex(i-1);
		local time = info:GetTime();
		dps.Name	= info:GetName();
		dps.Name	= dictionary.ReplaceDicIDInCompStr(dps.Name);
		if(dps.Name:find("!@#")~=nil)then
			dps.Name	= dictionary.ReplaceDicIDInCompStr(dps.Name);
			if(dps.Name:find("!@#")~=nil)then
				dps.Name	= dictionary.ReplaceDicIDInCompStr(dps.Name);
				if(dps.Name:find("!@#")~=nil)then
					dps.Name	= dictionary.ReplaceDicIDInCompStr(dps.Name);
				end
			end
		end
		dps.Time	= g0.lpn2s(time.wMonth,2).."/"..g0.lpn2s(time.wDay,2).." "..g0.lpn2s(time.wHour,2)..":"..g0.zpn2s(time.wMinute,2)..":"..g0.zpn2s(time.wSecond,2).."."..g0.zpn2s(time.wMilliseconds,3);
		dps.Dmg		= tonumber(info:GetStrDamage()) +0.0;
		local skl	= GetClassByType('Skill', info:GetSkillID()) or {};
		dps.Skill	= dictionary.ReplaceDicIDInCompStr(skl.Name or "");
		gDps.MapDmg				= (gDps.MapDmg or 0.0) +0.0 + dps.Dmg;
		gClk.Table["X1"].Dmg	= (gClk.Table["X1"].Dmg or 0.0) +0.0 + dps.Dmg;
		gDps.PerMns[dps.Name]		= (gDps.PerMns[dps.Name] or 0.0) +0.0 + dps.Dmg;
		gDps.PerSkl[dps.Skill]		= (gDps.PerSkl[dps.Skill] or 0.0) +0.0 + dps.Dmg;
		gDps.PerCrs[dps.Name]		= gDps.PerCrs[dps.Name] or {};
		gDps.PerCrs[dps.Name][dps.Skill]	= (gDps.PerCrs[dps.Name][dps.Skill] or 0.0) +0.0 + dps.Dmg;
		--CHAT_SYSTEM("D ".. g0.lpn2s(i,3).." "..g0.rpmb(dps.Name,24).." "..g0.lpn2s(dps.Dmg,8).." "..g0.rpmb(dps.Skill,24).." "..dps.Time);
	end
	gDps.InfoLen = session.dps.Get_allDpsInfoSize();
	if(gDps.InfoLast ~= 0) and(gDps.InfoLast == gDps.InfoLen) then
		session.dps.Clear_allDpsInfo();
		g0.Event("TPUTIL_DPSCLOCK", "", gDps.InfoLast);
		gDps.InfoLast = 0;
		gDps.DtlTbl = {};
	end
end
