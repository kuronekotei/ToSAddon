--[[
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
	gPty.Now = {}
	gPty.LstCmp = {}
	g0.MapIsIndun = session.world.IsIntegrateServer();
	g0.MapIsPvp = world.IsPVPMap();
	if g0.MapIsPvp then
		return;
	end
	if g0.MapIsIndun then
		return;
	end

	local pcParty = session.party.GetPartyInfo();

	if (pcParty == nil) or (pcParty.info == nil) then
		gPty.Now.PtId = nil;
		gPty.Now.PtNm = nil;
		gPty.Now.LdId = nil;
		gPty.Now.LdNm = nil;
		if session.loginInfo.GetSquireMapID() ~= nil and session.loginInfo.GetSquireMapID() ~= 0 then
			local myPc = GetMyPCObject();
			local cmp = {};
			cmp.MapId = session.loginInfo.GetSquireMapID();
			local cmpMap = GetClassByType("Map", cmp.MapId);
			cmp.MapNm = cmpMap.Name;
			cmp.OnrId = session.loginInfo.GetAID();
			cmp.OnrNm = myPc.Name;
			gPty.LstCmp[#gPty.LstCmp + 1] = cmp;
		end
		g0.Event("TPUTIL_PTYUPD");
		return;
	end

	local ptId = pcParty.info:GetPartyID();
	if (ptId == nil) or (ptId == "") then
		gPty.Now.PtId = nil;
		gPty.Now.PtNm = nil;
		gPty.Now.LdId = nil;
		gPty.Now.LdNm = nil;
		if session.loginInfo.GetSquireMapID() ~= nil and session.loginInfo.GetSquireMapID() ~= 0 then
			local myPc = GetMyPCObject();
			local cmp = {};
			cmp.MapId = session.loginInfo.GetSquireMapID();
			local cmpMap = GetClassByType("Map", cmp.MapId);
			cmp.MapNm = cmpMap.Name;
			cmp.OnrId = session.loginInfo.GetAID();
			cmp.OnrNm = myPc.Name;
			gPty.LstCmp[#gPty.LstCmp + 1] = cmp;
		end
	else
		local ptNm = pcParty.info.name;
		local ptLdId = pcParty.info:GetLeaderAID();
		local ptLdInfo = session.party.GetPartyMemberInfoByAID(PARTY_NORMAL, ptLdId);	
		local ptLd = "";
		if (ptLdInfo ~= nil) then
			ptLd = ptLdInfo:GetName();
		end
		--	CHAT_SYSTEM("TPWARP_PARTY_UPDATE "..ptId.." "..ptNm);
		gPty.Now.PtId = ptId;
		gPty.Now.PtNm = ptNm;
		gPty.Now.LdId = ptLdId;
		gPty.Now.LdNm = ptLd;
		local memLst = session.party.GetPartyMemberList(PARTY_NORMAL);
		local memCnt = memLst:Count();
		for i = 0 , memCnt - 1 do
			local memInf = memLst:Element(i);
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
