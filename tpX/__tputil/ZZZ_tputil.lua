local g0 = GetTpUtil();
local thisUtilVer = 1;
if(thisUtilVer <= (g0.UtilVer or 0)) then
	return;
end
g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "ZZZ_tputil";
g0.UtilVer = thisUtilVer;
