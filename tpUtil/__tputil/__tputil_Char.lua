--[[
	日本語
	関数群を保存している
--]]
local g0 = GetTpUtil();

g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "__tputil_Char";

local gChr = g0.Char;

function gChr.Init()
	local myAcc = session.barrack.GetMyAccount();
	local pcCnt = myAcc:GetPCCount();
	for i = 1,pcCnt do
		local pc = myAcc:GetPCByIndex(i-1);
		local cid = pc:GetCID();
		local fCheck = true;
		for j = 1,#gChr do
			if(gChr[j].CID == cid) then
				fCheck = false;
			end
		end
		if(fCheck) then
			local j = #gChr +1;
			gChr[j] = {}
			gChr[j].CID = cid;
		end
	end
	for i = 1,#gChr do
		local cid = gChr[i].CID;
		CHAT_SYSTEM(cid);
		myAcc:GetByStrCID(cid):GetSilver();
	end
end