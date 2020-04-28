--[[__tputil_Inv.lua
	日本語
	関数群を保存している
--]]
local g0 = GetTpUtil();

g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "__tputil_Inv";

local gInv = g0.Inv;

gInv.MyLst ={};
gInv.SearchTgt ={};
gInv.SearchTgt["EscapeStone_Orsha"] = 1;
gInv.SearchTgt["EscapeStone_Klaipeda"] = 1;
gInv.SearchTgt["Escape_Orb"] = 1;


function gInv.MakeLst()
	local myLst ={};
	session.BuildInvItemSortedList();
	local invLst	= session.GetInvItemList();
	local guidLst	= invLst:GetGuidList();
	local guidCnt	= guidLst:Count();
	local myLstCnt	= 0;
	local fUpd		= false;
	gInv.AllCount =guidCnt;
	for i = 0, guidCnt - 1 do
		local guid = guidLst:Get(i);
		local invItm = invLst:GetItemByGuid(guid);
		if(invItm ~= nil) then
			local itmXXX = invItm:GetObject();
			if(itmXXX ~= nil) then
				local itmObj = GetIES(itmXXX);
				if(itmObj ~= nil) then
					if(gInv.SearchTgt[itmObj.ClassName] == 1) then
						gInv.SubCount	= (gInv.SubCount or 0) +1;
						local oldData	= gInv.MyLst[itmObj.ClassName];
						local itmData	= {};
						itmData.Guid	= guid;
						itmData.Obj		= itmObj;
						itmData.Name	= itmObj.Name;
						itmData.Count	= invItm.count;
						itmData.Icon	= itmObj.Icon;

						myLst[itmObj.ClassName]	= itmData;
						myLstCnt				= myLstCnt + 1;
						fUpd = (fUpd or (oldData == nil) or (oldData.Guid ~= itmData.Guid) or (oldData.Count ~= itmData.Count));
					end
				end
			end
		end
	end
	if(fUpd or (gInv.MyLstCnt ~= myLstCnt)) then
		gInv.MyLst = myLst;
		gInv.MyLstCnt = myLstCnt;
	end
end
