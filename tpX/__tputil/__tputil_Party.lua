--[[__tputil_Party.lua
	日本語
	関数群を保存している
--]]
local g0 = GetTpUtil();

g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "__tputil_Party";

local gPty = g0.Party;

function TPUTIL_PARTY_UPDATE(frame, msg, argStr, argNum)
	g0.PCL(gPty.GetParty);
end
function gPty.GetParty()
	gPty.LstCmp = {}
	g0.MapIsMatch	= session.world.IsIntegrateServer();
	g0.MapIsIndun	= session.world.IsDungeon();
	g0.MapIsPvp		= world.IsPVPMap();
	local fNormal = true;
	if g0.MapIsPvp or g0.MapIsIndun or g0.MapIsMatch then
		fNormal = false;
	end

	local myHandle = session.GetMyHandle();
	local etc = GetMyEtcObject();
	local jobClassID = TryGetProp(etc, 'RepresentationClassID', 'None');
	if jobClassID == 'None' or tonumber(jobClassID) == 0 then
		jobClassID = info.GetJob(myHandle);
	end
	local jobCls = GetClassByType('Job', jobClassID);
	local jobIcon = TryGetProp(jobCls, 'Icon');
	local myPc = GetMyPCObject();
	gPty.LstMem = {
		{
			Name		= myPc.Name,
			Handle		= myHandle,
			AId			= session.loginInfo.GetAID(),
			JobIcon		= jobIcon or "",
			NowHP		= 0,
			MaxHP		= 1000,
			NowSP		= 0,
			MaxSP		= 1000,
			Dist		= 1000,
			Buf			= {},
			Debuf		= {},
			BufSelf		= {},
			BufMe		= {},
			BufFocus	= {},
		}
	};

	local pcParty = session.party.GetPartyInfo();
	local ptId = pcParty and pcParty.info and pcParty.info:GetPartyID();	--nilよけにandを使う　nilならnilが返る

	if (ptId == nil) or (ptId == "") then
		gPty.PtId = nil;
		gPty.PtNm = nil;
		gPty.LdId = nil;
		gPty.LdNm = nil;

		if(session.loginInfo.GetSquireMapID() ~= nil and session.loginInfo.GetSquireMapID() ~= 0) then
			local cmp = {};
			cmp.MapId = session.loginInfo.GetSquireMapID();
			local cmpMap = GetClassByType("Map", cmp.MapId);
			cmp.MapNm = cmpMap.Name;
			cmp.OnrId = gPty.LstMem[1].AId;
			cmp.OnrNm = gPty.LstMem[1].Name;
			gPty.LstCmp[#gPty.LstCmp + 1] = cmp;
		end
	else
		local ptLdId = pcParty.info:GetLeaderAID();
		local ptLdInfo = session.party.GetPartyMemberInfoByAID(PARTY_NORMAL, ptLdId);
		local ptLd = (ptLdInfo and ptLdInfo:GetName()) or "";

		--	CHAT_SYSTEM("TPWARP_PARTY_UPDATE "..ptId.." "..ptNm);
		gPty.PtId = ptId;
		gPty.PtNm = pcParty.info.name;
		gPty.LdId = ptLdId;
		gPty.LdNm = ptLd;
		local memLst = session.party.GetPartyMemberList(PARTY_NORMAL);
		local memCnt = memLst:Count();
		gPty.MmCt = memCnt;
		for i = 0 , memCnt - 1 do
			local memInf = memLst:Element(i);
			if(gPty.LstMem[1].AId==memInf:GetAID()) then
				--既に存在しているので足さない
			else
				local iconInfo = memInf:GetIconInfo();
				local jobCls  = GetClassByType("Job", iconInfo.repre_job);
				gPty.LstMem[#gPty.LstMem + 1] ={
					Name		= memInf:GetName(),
					Handle		= memInf:GetHandle(),
					AId			= memInf:GetAID(),
					JobIcon		= jobCls and jobCls.Icon or "",
					NowHP		= 0,
					MaxHP		= 1000,
					NowSP		= 0,
					MaxSP		= 1000,
					Dist		= 1000,
					Buf			= {},
					Debuf		= {},
					BufSelf		= {},
					BufMe		= {},
					BufFocus	= {},
				};
			end
			if(memInf.campMapID ~=0) then
				local cmpMap = GetClassByType("Map", memInf.campMapID);
				if(cmpMap ~=nil) then
					local cmp = {};
					cmp.MapId = memInf.campMapID;
					cmp.MapNm = cmpMap.Name;
					cmp.OnrId = memInf:GetAID();
					cmp.OnrNm = memInf:GetName();
					gPty.LstCmp[#gPty.LstCmp + 1] = cmp;
				end
			end
		end
	end
	table.sort(gPty.LstCmp,
		function(a,b)
			if (a==nil) then return true end
			if (b==nil) then return false end
			return (a.OnrId<b.OnrId);
		end
	);
	g0.Event("TPUTIL_PTYUPD");
end


function TPUTIL_PT_INST_UPDATE(frame, msg, argStr, argNum)
	g0.PCL(gPty.UpdPartyDtl);
end
function gPty.UpdPartyDtl()
	local myHandle = session.GetMyHandle();
	local pcParty = session.party.GetPartyInfo();
	local ptId = pcParty and pcParty.info and pcParty.info:GetPartyID();	--nilよけにandを使う　nilならnilが返る

	if (ptId == nil) or (ptId == "") then
		return;
	end
	local memLst = session.party.GetPartyMemberList(PARTY_NORMAL);
	local memCnt = memLst:Count();
	for i = 0 , memCnt - 1 do
		local memInf = memLst:Element(i);
		for j = 1 , #gPty.LstMem do
			local mem = gPty.LstMem[j];
			if(mem.Handle==memInf:GetHandle()) then
				local stat	= info.GetStat(mem.Handle);
				local tgt	= info.GetTargetInfo(mem.Handle);
				local inst	= memInf:GetInst();
				local pos	= inst:GetPos();
				local dist	= info.GetDestPosDistance(pos.x, pos.y, pos.z, myHandle);
				mem.NowHP	= (stat and stat.HP) or inst.hp or 0;
				mem.MaxHP	= (stat and stat.maxHP) or inst.maxhp;
				mem.NowSP	= (stat and stat.SP) or inst.sp or 0;
				mem.MaxSP	= (stat and stat.maxSP) or inst.maxsp;
				mem.Dist	= dist or 1000;
				if(mem.MaxHP == nil) or(mem.MaxHP < 1) then
					mem.MaxHP = 1000;
				end
				if(mem.MaxSP == nil) or(mem.MaxSP < 1) then
					mem.MaxSP = 1000;
				end
				if(mem.MaxSta == nil) or(mem.MaxSta < 1) then
					mem.MaxSta = 100;
				end
				mem.Buf ={};
				mem.Debuf ={};
				mem.BufSelf ={};
				mem.BufMe ={};
				mem.BufFocus ={};
				memInf:ResetBuff();
				local bufCnt = memInf:GetBuffCount();
				for k = 0, bufCnt - 1 do
					local bufID		= memInf:GetBuffIDByIndex(k);
					local bufCls	= GetClassByType("Buff", bufID);
					local bufIcon	= 'icon_' .. bufCls.Icon;
					local bufObj	= info.GetBuff(mem.Handle, bufID);
					local fShow		= (bufCls.ShowIcon and bufCls.ShowIcon ~= "FALSE")
					if(bufObj) then
						local casterHandle = bufObj:GetHandle();
						local buf = {BuffId = bufID, Name = bufCls.Name, Stack = bufObj.over, Time= bufObj.time, Icon=bufIcon, IsDebuff= (bufCls.Group1 == 'Debuff'), IsSelf= (casterHandle==mem.Handle), IsMe= (casterHandle==myHandle)};
						if(fShow) then
							if(buf.IsDebuff) then
								mem.Debuf[#mem.Debuf+1] = buf;
							else
								mem.Buf[#mem.Buf+1] = buf;
								if(buf.IsSelf) then
									mem.BufSelf[#mem.BufSelf+1] = buf;
								end
								if(buf.IsMe) then
									mem.BufMe[#mem.BufMe+1] = buf;
								end
								if(buf.Name=="Prophecy_Buff" or buf.Name=="Cleric_Revival_Buff" or buf.Name=="Cleric_Revival_Leave_Buff" or buf.Name=="ReflectShield_Buff") then
									mem.BufFocus[#mem.BufMe+1] = buf;
								end
							end
						end
					end
				end
				table.sort(mem.Debuf,    function(a,b) if (a.Time==b.Time) then return a.BuffId>b.BuffId end if (a.Time==0) then return false end if (b.Time==0) then return true end return (a.Time<b.Time); end );
				table.sort(mem.BufMe,    function(a,b) if (a.Time==b.Time) then return a.BuffId>b.BuffId end if (a.Time==0) then return false end if (b.Time==0) then return true end return (a.Time<b.Time); end );
				table.sort(mem.BufFocus, function(a,b) if (a.Time==b.Time) then return a.BuffId>b.BuffId end if (a.Time==0) then return false end if (b.Time==0) then return true end return (a.Time<b.Time); end );
				break;
			end
		end
	end
	g0.Event("TPUTIL_PTYDTLUPD");
end