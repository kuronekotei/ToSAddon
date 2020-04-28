--[[__tputil_Pop.lua
	日本語
	関数群を保存している
--]]
local g0 = GetTpUtil();

g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "__tputil_Pop";

local gPop = g0.Pop;
local gClk = g0.Clock;

function gPop.MapInit()
	gPop.NowCh	= session.loginInfo.GetChannel();
	local zoneInsts	= session.serverState.GetMap();
	gPop.MaxPop	= session.serverState.GetMaxPCCount();
	if zoneInsts == nil then
		gPop.MaxCh	= 0;
		return;
	end
	gPop.MaxCh	= zoneInsts:GetZoneInstCount();
	app.RequestChannelTraffics();
	gPop.NowPop	= 0;
end

function gPop.Clock(f10)
	gPop.NowCh	= session.loginInfo.GetChannel();
	local zoneInsts	= session.serverState.GetMap();
	gPop.MaxPop	= session.serverState.GetMaxPCCount();
	if zoneInsts == nil then
		gPop.MaxCh	= 0;
		return;
	end
	gPop.MaxCh	= zoneInsts:GetZoneInstCount();
	
	app.RequestChannelTraffics();
	local i = 0;
	gPop.Lst = {}
	for i=1, gPop.MaxCh do
		local zoneInst = zoneInsts:GetZoneInstByIndex(i-1);
		gPop.Lst["Ch"..i.."Pop"] = zoneInst.pcCount;
		if ((i-1) == gPop.NowCh) then
			gPop.NowPop = zoneInst.pcCount;
			gPop.BefPop = gPop.BefPop or zoneInst.pcCount;
			if (gPop.BefPop ~= gPop.NowPop) and ((gPop.BefPop < 6) or (gPop.NowPop < 6)) then
				gPop.BefPop = gPop.NowPop;
				g0.Event("TPUTIL_POPCHANGE", "", gClk.LastClock);
			end
		end
	end
end
