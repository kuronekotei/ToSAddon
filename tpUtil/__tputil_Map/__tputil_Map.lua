--[[__tputil_Map.lua
	日本語
	関数群を保存している
--]]
local g0 = GetTpUtil();

g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "__tputil_Map";

local gClk = g0.Clock;
local gMap = g0.Map;


gMap.Stg = gMap.Stg or {};
gMap.Stg.Mon = gMap.Stg.Mon or {};
gMap.Stg.Ntc = {};
gMap.LstWtc = {};	--	監視リスト
gMap.LstAll = {};	--	全オブジェクトリスト
gMap.LstDel = {};	--	削除リスト
gMap.LstNtc = {};

function gMap.Init()
	gMap.Stg.Ntc = {};
	gMap.LstAll = {};
	gMap.LstDel = {};

	gMap.LstWtc = {};

	gMap.LstNtc = {};
	g0.FuncBef("NOTICE_ON_MSG","gMap",gMap.Notice)
end
function gMap.AddStg(clsNm,data)
	gMap.Stg.Mon[clsNm] = data;
end

function gMap.ClockEx()
	local fndList, fndCount = SelectObject(self, 2000, 'ALL');
	if (fndCount == nil) or (fndCount == 0) then
		return;
	end
	local i=0;
	local obj=nil;
	g0.myPC = GetMyPCObject();
	g0.myHnd=session.GetMyHandle();
	for i = 1, fndCount do
		obj		= fndList[i];
		gMap.ObjAddList(obj);
	end
	gMap.ObjDelList();
	gMap.ObjWatch();
	gMap.NtcWatch();
end

function gMap.ObjAddList(obj)
	local hnd	= GetHandle(obj);
	if (g0.myHnd == nil) or (g0.myHnd == hnd) then
		return;
	end
	if (hnd > 1000000000) then
		return;
	end
	local hnd2	= tostring(hnd);
	if (gMap.LstAll[hnd2]) then
		return;
	end
	local clsNm	= obj.ClassName;
	local fct	= (obj.ClassName=="PC" and "PC") or obj.Faction;
	local tgt	= info.GetTargetInfo(hnd);
	local actr	= world.GetActor(hnd);
	local cls	= GetClassByType("Monster", actr:GetType());
	gMap.LstAll[hnd2] = {	Hnd=hnd	,Actr = actr, ClsNm = clsNm, Cls = cls, };
	if (gMap.Stg.Mon[clsNm] ~= nil) and (gMap.LstWtc[hnd2] == nil) then
		CHAT_SYSTEM(clsNm.." "..hnd2);
		gMap.LstWtc[hnd2] = {	Hnd=hnd	,Actr = actr, ClsNm = clsNm, Cls = cls, HpRate = 0, LastSkl=nil, LstAlerm={},};
		if (gMap.Stg.Mon[clsNm].Notice ~= nil) then
			for key,itm in pairs(gMap.Stg.Mon[clsNm].Notice) do
				gMap.Stg.Ntc[clsNm.."_"..key] = {Ntc=itm.Ntc,	Msg=itm.Msg,	Mon=itm.Mon,	Name=itm.Name,	Cd=itm.Cd,	Alerm=itm.Alerm,	Sound=itm.Sound,	};
			end
		end
	end
end

function gMap.ObjDelList()
	gMap.LstDel = {};
	for key,itm in pairs(gMap.LstAll) do
		local actr = world.GetActor(itm.Hnd);
		local tgt = info.GetTargetInfo(itm.Hnd);
		if (actr == nil) or (tgt == nil) or ((tgt.stat.maxHP > 0) and (tgt.stat.HP==0)) then	--	削除モード
			gMap.LstDel[key] = itm;
			gMap.LstAll[key] = nil;
		end
	end
end
function gMap.ObjWatch()
	for key,itm in pairs(gMap.LstWtc) do
		local tgt	= info.GetTargetInfo(itm.Hnd);
		local actr	= world.GetActor(itm.Hnd);
		if (actr ~= nil) and (tgt ~= nil) and ((tgt.stat.maxHP > 0) and (tgt.stat.HP > 0)) then
			gMap.ObjWatchOne(itm,tgt,actr)
		end
	end
end
function gMap.ObjWatchOne(itmWtc,tgt,actr)
	local clsNm	= itmWtc.ClsNm;
	if (actr == nil) or (tgt == nil) or ((tgt.stat.maxHP > 0) and (tgt.stat.HP==0)) then	--	削除モード
		return;
	end
	local hpB	= itmWtc.HpRate;
	local hpA	= (math.floor(tgt.stat.HP * 10000 /tgt.stat.maxHP)/100);
	local sklId	= actr:GetUseSkill();
	if (gMap.Stg.Mon[clsNm] ~= nil) then
		local monName = gMap.Stg.Mon[clsNm].Name;
		local lstLife = gMap.Stg.Mon[clsNm].Life;
		local lstSkill = gMap.Stg.Mon[clsNm].Skill;
		if (lstLife ~= nil) then
			for key,itmLife in pairs(lstLife) do
				if (hpB > itmLife.val) and (itmLife.val >= hpA) then
					table.insert(gClk.ChatQue,"/p "..itmLife.msg);
					CHAT_SYSTEM(itmLife.msg);
				end
			end
		end
		if (itmWtc.LastSkl ~= sklId) then
			itmWtc.LastSkl = sklId;
			if (sklId ~= nil) and (sklId ~= 0) and (lstSkill ~= nil) then
				local fFound = false;
				for key,itmSkl in pairs(lstSkill) do
					if (itmSkl.SklId == sklId) then
						fFound = true;
						if (itmSkl.fShow) then
							table.insert(gClk.ChatQue,"/p "..monName.." Cast "..itmSkl.Name);
							CHAT_SYSTEM(monName.." Cast "..itmSkl.Name);
						else
							CHAT_SYSTEM(monName.." Cast "..itmSkl.Name);
						end
						if (itmSkl.Cd >0) and (itmSkl.Alerm >0) and (itmSkl.Cd >itmSkl.Alerm) then
							itmWtc.LstAlerm[tostring(sklId)] = {
								Mon=monName,	Name=itmSkl.Name,
								tmStart=gClk.NowClockEx,	tmAlerm=gClk.NowClockEx+itmSkl.Alerm,	tmDel=gClk.NowClockEx+itmSkl.Cd,
								tmSub=itmSkl.Cd-itmSkl.Alerm,
							};
						end
					end
				end
				if (fFound==false) then
					CHAT_SYSTEM(monName.." Cast "..sklId);
				end
			end
		end
		for key,itmAlm in pairs(itmWtc.LstAlerm) do
			if (gClk.NowClockEx>=itmAlm.tmDel) then
				itmWtc.LstAlerm[key]=nil;
			elseif (gClk.NowClockEx>=itmAlm.tmAlerm) then
				table.insert(gClk.ChatQue,"/p "..itmAlm.Mon.." ".." 後"..itmAlm.tmSub.."秒 "..itmAlm.Name);
				CHAT_SYSTEM(itmAlm.Mon.." ".." 後"..itmAlm.tmSub.."秒 "..itmAlm.Name);
				itmWtc.LstAlerm[key]=nil;
			end
		end
	end
	itmWtc.HpRate = hpA;
end
function gMap.NtcWatch()
	for key,itmNtc in pairs(gMap.LstNtc) do
		if (gClk.NowClockEx>=itmNtc.tmDel) then
			itmNtc[key]=nil;
		elseif (gClk.NowClockEx>=itmNtc.tmAlerm) then
			table.insert(gClk.ChatQue,"/p "..itmNtc.Mon.." 後"..itmNtc.tmSub.."秒 "..itmNtc.Name);
			CHAT_SYSTEM(itmNtc.Mon.." 後"..itmNtc.tmSub.."秒 "..itmNtc.Name);
			gMap.LstNtc[key]=nil;
		end
	end
end
function gMap.Notice(frame, msg, argStr, argNum)
	for key,itmNtc in pairs(gMap.Stg.Ntc) do
		if (msg == itmNtc.Ntc) and (argStr:find(itmNtc.Msg)) then
			if (itmNtc.Cd >0) and (itmNtc.Alerm >0) and (itmNtc.Cd >itmNtc.Alerm) then
				gMap.LstNtc[key] = {
					Mon=itmNtc.Mon,	Name=itmNtc.Name,
					tmStart=gClk.NowClockEx,	tmAlerm=gClk.NowClockEx+itmNtc.Alerm,	tmDel=gClk.NowClockEx+itmNtc.Cd,
					tmSub=itmNtc.Cd-itmNtc.Alerm,
				};
			end
			if (itmNtc.Sound ~= nil) then
				imcSound.PlaySoundEvent(itmNtc.Sound);
			end
		end
	end
end
