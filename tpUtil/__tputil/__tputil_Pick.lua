--[[
	日本語
	関数群を保存している
--]]
local g0 = GetTpUtil();

g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "__tputil_Pick";

local gPck = g0.Pick;
local gClk = g0.Clock;




function gPck.MapEnd(fSameChar)
	local slv = tonumber(GET_TOTAL_MONEY_STR());
	if (fSameChar) then
		gPck.NowMoney		= slv;
		gPck.MapMoney		= gPck.NowMoney - (gPck.StartMoney or gPck.NowMoney);
	else
		gPck.NowMoney		= gPck.NowMoney or slv;
		gPck.MapMoney		= gPck.MapMoney or 0;
	end
	gPck.StartMoney	= slv;
	gPck.ItemCount	= {};
end

function gPck.Clock(f10)	--	f10:bool 10秒に1回true;
	gPck.NowMoney	= tonumber(GET_TOTAL_MONEY_STR());
	gPck.MapMoney	= gPck.NowMoney - gPck.StartMoney;
	if(f10) then
		gClk.Table["X1"].MoneyS = gPck.NowMoney;
		gClk.Table["X1"].MoneyX = 0;
		if (gClk.LastClock ~= -1) then	--	1ループ目はX2がないので実行しない
			gClk.Table["X2"].MoneyX = gClk.Table["X1"].MoneyS - gClk.Table["X2"].MoneyS;
		end
	
	end
	gClk.Table["X1"].MoneyX = gPck.NowMoney - gClk.Table["X1"].MoneyS;
end

function TPUTIL_ITEM_IN(frame, msg, guid, num)
	g0.PCL(gPck.Item,frame, msg, guid, num);
end

function gPck.Item(frame, msg, guid, num)
	local invItem = GET_ITEM_BY_GUID(guid);
	if (invItem == nil) then
		return;
	end
	local itemObj = GetIES(invItem:GetObject());
	if (itemObj == nil) then
		return;
	end
	gPck.LastItemId	= itemObj.ClassID;
	gPck.ItemCount	= gPck.ItemCount or {};
	gPck.ItemCount[""..itemObj.ClassID] = gPck.ItemCount[""..itemObj.ClassID] or {};
	local itemCount		= gPck.ItemCount[""..itemObj.ClassID];
	itemCount.Name 		= itemObj.Name;
	itemCount.LastNum 	= num;
	itemCount.Icon		= itemObj.Icon;
	itemCount.Max		= itemObj.MaxStack;
	if (itemObj.ClassID == 900011) then
		gPck.NowMoney	= tonumber(GET_TOTAL_MONEY_STR());
		itemCount.Jarnal 	= false;
		itemCount.Total 	= gPck.NowMoney;
		itemCount.MapNum 	= gPck.NowMoney - gPck.StartMoney;
		itemCount.JarBse	= 0;
		itemCount.JarNow	= 0;
		itemCount.JarNxt	= 0;
	else
		local obtainCount, consumeCount = ADVENTURE_BOOK_ITEM_CONTENT.ITEM_HISTORY_COUNT(itemObj.ClassID);
		local curScore, maxScore = _GET_ADVENTURE_BOOK_POINT_ITEM((itemObj.ItemType == 'Equip'), obtainCount);
		local curLv, curPoint, maxPoint = GET_ADVENTURE_BOOK_ITEM_OBTAIN_COUNT_INFO((itemObj.ItemType == 'Equip'), obtainCount);
		itemCount.Jarnal 	= (curPoint == maxPoint);
		itemCount.Total 	= invItem.count;
		itemCount.MapNum 	= num + (itemCount.MapNum or 0);
		if(itemCount.JarBse ~= curPoint) then
			itemCount.JarBse	= curPoint;
			itemCount.JarNow	= itemCount.JarBse + num;
		else
			itemCount.JarNow	= itemCount.JarNow  + num;
		end
		local curLv, curPoint, maxPoint = GET_ADVENTURE_BOOK_ITEM_OBTAIN_COUNT_INFO((itemObj.ItemType == 'Equip'), itemCount.JarNow);
		itemCount.JarNxt	= maxPoint;
	end
	g0.Event("TPUTIL_PICKITEM", itemCount.Name, num);
end
