--[[
	日本語
	関数群を保存している
--]]
local g0 = GetTpUtil();
local thisUtilVer = 1;
if(thisUtilVer <= (g0.UtilVer or 0)) then
	return;
end
g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "__tputil_Inv";

local gInv = g0.Inv;

function gInv.MapInit()
	gInv.MakeLst();
end

function gInv.MakeLst()
	gInv.MyLst ={};
	local myLst ={};
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
					if (itmObj.ClassName == "EscapeStone_Orsha") 
					or (itmObj.ClassName == "EscapeStone_Klaipeda")
					or (itmObj.ClassName == "Escape_Orb")
					then
						gInv.SubCount = (gInv.SubCount or 0) +1;
						local oldData	=gInv.MyLst[itmObj.ClassName];
						local itmData	={};
						itmData.Guid	= guid;
						itmData.Obj		= itmObj;
						itmData.Name	= itmObj.Name;
						itmData.Count	= invItm.count;
						itmData.Icon	= itmObj.Icon;
						myLst[itmObj.ClassName] =itmData;
						myLstCnt = myLstCnt + 1;
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
