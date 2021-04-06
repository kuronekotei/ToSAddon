--[[tpwarp
	日本語
--]]
local g0 = GetTpUtil();
local gQst = g0.Quest;
local gPty = g0.Party;
local gInv = g0.Inv;

local _NAME_ = 'TPWARP';
_G[_NAME_] = _G[_NAME_] or {};
local g9 = _G[_NAME_];
g9.StgPath = g9.StgPath or "../addons/tpwarp/stg_tpwarp.lua";
g9.Stg = g9.Stg or {
	MainUIPosX			= 600,
	MainUIPosY			= 400,

	MainUIShowCamp		= true,
	MainUIShowParty		= true,
	MainUIShowPartyOut	= true,
	MainUIShowQuest		= true,
	MainUIShowEscItm	= true,
	MainUIShowUnique	= true,
	MainUIShowBack		= false,
	MainUIShowShop		= false,

	LastPtId1		= "";
	LastPtNm1		= "";
	LastPtLd1		= "";
	LastPtId2		= "";
	LastPtNm2		= "";
	LastPtLd2		= "";
	LastPtId3		= "";
	LastPtNm3		= "";
	LastPtLd3		= "";
	LastPtId4		= "";
	LastPtNm4		= "";
	LastPtLd4		= "";
	LastPtId5		= "";
	LastPtNm5		= "";
	LastPtLd5		= "";
	LastPtId6		= "";
	LastPtNm6		= "";
	LastPtLd6		= "";
};
local s9 = g9.Stg;
g9.tblSort = g9.tblSort or {
	{name="_",					comm="【ユーザーインターフェースの設定】"},
	{name="MainUIShow",			comm="メインUIを表示する"},
	{name="MainUIPosX",			comm="保存された横位置　(マウスで移動可能)"},
	{name="MainUIPosY",			comm="保存された縦位置　(マウスで移動可能)"},
	{name="MainUIShowCamp",		comm="メインUIのキャンプワープを表示する"},
	{name="MainUIShowParty",	comm="メインUIのパーティー履歴を表示する"},
	{name="MainUIShowPartyOut",	comm="メインUIのパーティー脱退を表示する"},
	{name="MainUIShowQuest",	comm="メインUIのクエストワープを表示する"},
	{name="MainUIShowUnique",	comm="メインUIのユニークレイドを表示する"},
	{name="MainUIShowEscItm",	comm="メインUIの帰還石を表示する"},
	{name="MainUIShowBack",		comm="メインUIの戻るを表示する"},
	{name="MainUIShowShop",		comm="メインUIにTPショップを表示する　(マップの下に置く時用)"},
	{name="_",					comm=""},
	{name="_",					comm="【PT履歴】"},
	{name="LastPtId1",			comm=""},
	{name="LastPtNm1",			comm=""},
	{name="LastPtLd1",			comm=""},
	{name="LastPtId2",			comm=""},
	{name="LastPtNm2",			comm=""},
	{name="LastPtLd2",			comm=""},
	{name="LastPtId3",			comm=""},
	{name="LastPtNm3",			comm=""},
	{name="LastPtLd3",			comm=""},
	{name="LastPtId4",			comm=""},
	{name="LastPtNm4",			comm=""},
	{name="LastPtLd4",			comm=""},
	{name="LastPtId5",			comm=""},
	{name="LastPtNm5",			comm=""},
	{name="LastPtLd5",			comm=""},
	{name="LastPtId6",			comm=""},
	{name="LastPtNm6",			comm=""},
	{name="LastPtLd6",			comm=""},
}
local tblSort = g9.tblSort;

function TPWARP_ON_INIT(adn, frame)
	adn:RegisterMsg("TPUTIL_START", "TPWARP_GAME_START");
	adn:RegisterMsg("TPUTIL_PTYUPD", "TPWARP_PTYUPD");
	adn:RegisterMsg("TPUTIL_QSTUPD", "TPWARP_QSTUPD");
	frame:SetEventScript(ui.LBUTTONUP, "TPWARP_LBUTTONUP");
	g0.PCL(g0.LoadStg,_NAME_,g9.StgPath,s9);
	g0.PCL(g0.SaveStg,_NAME_,g9.StgPath,s9,tblSort);
	g9.frH = 32;
	g9.qsH = 0;
	g9.ptH = 0;
	g9.exH = 0;
end

function TPWARP_LBUTTONUP()
	g0.PCL(g9.UiLBtnUp);
end
function g9.UiLBtnUp()
	local frm	= ui.GetFrame("tpwarp");
	if (frm == nil) then
		return;
	end
	s9.MainUIPosX	= frm:GetX();
	s9.MainUIPosY	= frm:GetY();
	g0.PCL(g0.SaveStg,_NAME_,g9.StgPath,s9,tblSort);
end

function TPWARP_GAME_START(frame, control)
	g0.PCL(g9.UiStart,frame, control);
end
function g9.UiStart(frame, control)
	local frm	= ui.GetFrame("tpwarp");
	if (frm == nil) then
		return;
	end

	g9.frH = frm:GetHeight();
	g9.qsH = 0;
	g9.ptH = 0;
	g9.exH = 0;

	if(g0.MapIsIndun) then
		local gb = frm:CreateOrGetControl("groupbox", "gbback", 430, 2, 40, 28);
		gb:SetSkinName("skin_white");
		gb:SetColorTone("C0000000");
		gb:EnableHitTest(1);
		gb:SetEventScript(ui.LBUTTONUP, "TPWARP_BTN_BACK");
		local rt = gb:CreateOrGetControl("richtext", "rtback",2,0,36,28);
		rt = tolua.cast(rt, "ui::CRichText");	-- ui::CObject を ui::CRichTextにキャスト
		rt:SetFontName("white_16_ol");
		rt:EnableResizeByText(0);	-- CRichTextでないと使えない
		rt:SetTextFixWidth(0);		-- CRichTextでないと使えない
		rt:EnableSplitBySpace(0);	-- CRichTextでないと使えない
		rt:EnableHitTest(0);
		rt:SetText("Back");
		if(s9.MainUIShowBack) then
			gb:ShowWindow(1);
		else
			gb:ShowWindow(0);
		end
	end
	if(g0.MapIsCity) then
		local btn = frm:CreateOrGetControl("button", "btnshop", 430, 2, 30, 28);
		btn = tolua.cast(btn, "ui::CButton");
		btn:SetImage("steam_shop2_btn");
		btn:SetEventScript(ui.LBUTTONUP, "MINIMIZED_TP_BUTTON_CLICK");
		btn:Resize(30, 28);
		if(s9.MainUIShowShop) then
			btn:ShowWindow(1);
		else
			btn:ShowWindow(0);
		end
	end

	frm:MoveFrame(s9.MainUIPosX	,s9.MainUIPosY);
	g0.PCL(g9.SetUnqNItm);
	g0.PCL(g9.SetQuestWarp);
	g0.PCL(g9.SetPartyLink);
	frm:Resize(frm:GetWidth(),g9.frH + g9.qsH + g9.ptH + g9.exH);
end

function TPWARP_QSTUPD(frame, msg, str, num)
	g0.PCL(g9.SetQuestWarp, frame, msg, str, num);
end

function g9.SetQuestWarp()
	if (s9.MainUIShowQuest ~= true) then
		return;
	end
	local frm	= ui.GetFrame("tpwarp");
	if (frm == nil) then
		return;
	end
	local qsCol = -1;
	local qsRow = 0;
	local i = 0;
	for i = 1, #gQst.LstWarp do
		local qData = gQst.LstWarp[i];
		qsCol = qsCol +1;
		if (qData.mLv ~= 0) and (qsRow == 0) then
			qsCol = 0;
			qsRow = 1;
		end
		if (qData.mLv ~= 0) and (qsRow > 0) and (qsCol > 11) then
			qsCol = 0;
			qsRow = qsRow + 1;
		end

		local posL = 3 + (qsCol *42) +(math.floor(qsCol/3)*5);
		local posH = g9.frH + g9.exH + (qsRow *30);

		local gb = frm:CreateOrGetControl("groupbox", "qgb"..i, posL, posH, 40, 28);
		gb:SetSkinName("skin_white");
		if(qData.mCName == "c_Klaipe") then
			gb:SetColorTone("E0001000");
		elseif(qData.mCName == "c_orsha") then
			gb:SetColorTone("E0100000");
		elseif(qData.mCName == "c_fedimian") then
			gb:SetColorTone("E0000010");
		else
			gb:SetColorTone("C0000000");
		end
		gb:EnableHitTest(1);
		gb:SetEventScript(ui.LBUTTONUP, "TPWARP_BTN_QUEST");
		gb:ShowWindow(1);
		local rt = gb:CreateOrGetControl("richtext", "qrt"..i,2,0,36,28);
		rt = tolua.cast(rt, "ui::CRichText");	-- ui::CObject を ui::CRichTextにキャスト
		rt:SetFontName("white_12_ol");
		rt:EnableResizeByText(0);	-- CRichTextでないと使えない
		rt:SetTextFixWidth(0);		-- CRichTextでないと使えない
		rt:EnableSplitBySpace(0);	-- CRichTextでないと使えない
		rt:EnableHitTest(0);
		local clr = "";
		if(qData.qMode == "MAIN") then
			clr ="{#FFFF80}";
		elseif(qData.qMode == "SUB") then
			clr ="{#8080FF}";
		elseif(qData.qMode == "REPEAT") then
			clr ="{#80FF80}";
		end
		rt:SetText(clr..qData.mName.."{nl}"..qData.nName);

		--	CHAT_SYSTEM(qData.mName.." /"..qData.nName.." /"..qData.mLv.." /"..qData.qCId);
	end
	g9.qsH = (qsRow+1) *30;
	local i = #gQst.LstWarp;
	while(true) do
		i = i+1;
		local gb = frm:GetChild("qgb"..i);
		if(gb==nil) then
			break;
		end
		gb:ShowWindow(0);
	end
end

function TPWARP_PTYUPD(frame, msg, str, num)
	g0.PCL(g9.PtyUpd, frame, msg, str, num);
	g0.PCL(g9.SetPartyLink, frame, msg, str, num);
	g0.PCL(g9.SetCampLink, frame, msg, str, num);
end
function g9.PtyUpd(frame, msg, str, num)
	if (gPty.PtId == nil) or (gPty.PtId == "") or (gPty.MmCt<1) then
		return;
	end
	--CHAT_SYSTEM("g9.PtyUpd 1");
	if g0.MapIsPvp or g0.MapIsIndun or g0.MapIsMatch then
		return;
	end
	--CHAT_SYSTEM("g9.PtyUpd 2");

	for i = 1, 6 do
		if (gPty.PtId == s9["LastPtId"..i]) or (i==6) then
			if (gPty.MmCt>1) then
				if(i>1)then
					for j = i, 2, -1 do
						s9["LastPtId"..j] = s9["LastPtId"..(j-1)];
						s9["LastPtNm"..j] = s9["LastPtNm"..(j-1)];
						s9["LastPtLd"..j] = s9["LastPtLd"..(j-1)];
					end
				end
				s9.LastPtId1 = gPty.PtId;
				s9.LastPtNm1 = gPty.PtNm;
				s9.LastPtLd1 = gPty.LdNm;
			else
				for j = i, 5 do
					s9["LastPtId"..j] = s9["LastPtId"..(j+1)];
					s9["LastPtNm"..j] = s9["LastPtNm"..(j+1)];
					s9["LastPtLd"..j] = s9["LastPtLd"..(j+1)];
				end
				s9.LastPtId6 = "";
				s9.LastPtNm6 = "";
				s9.LastPtLd6 = "";
			end
			break;
		end
	end
	g0.PCL(g0.SaveStg,_NAME_,g9.StgPath,s9,tblSort);
end

function g9.SetPartyLink()
	if (s9.MainUIShowParty ~= true) then
		return;
	end
	local frm	= ui.GetFrame("tpwarp");
	if (frm == nil) then
		return;
	end
	local fPty = ((gPty.PtId ~= nil) and (gPty.PtId ~= ""));
	if g0.MapIsPvp or g0.MapIsIndun or g0.MapIsMatch then
		fPty = false;
	end
	local i = 0;
	g9.ptH = 30;

	local gb = frm:CreateOrGetControl("groupbox", "pgbo", 477, g9.frH + g9.qsH + g9.exH, 40, 28);
	gb:SetSkinName("skin_white");
	gb:SetColorTone("C0000000");
	gb:EnableHitTest(1);
	gb:SetEventScript(ui.LBUTTONUP, "TPWARP_BTN_PARTYOUT");
	local rt = gb:CreateOrGetControl("richtext", "prto",2,0,36,28);
	rt = tolua.cast(rt, "ui::CRichText");	-- ui::CObject を ui::CRichTextにキャスト
	rt:SetFontName("white_12_ol");
	rt:EnableResizeByText(0);	-- CRichTextでないと使えない
	rt:SetTextFixWidth(0);		-- CRichTextでないと使えない
	rt:EnableSplitBySpace(0);	-- CRichTextでないと使えない
	rt:EnableHitTest(0);
	rt:SetText("PT{nl}Out");
	if(fPty and s9.MainUIShowPartyOut) then
		gb:ShowWindow(1);
	else
		gb:ShowWindow(0);
	end

	for i = 1, 4 do
		local ptId = s9["LastPtId"..i];
		local ptNm = s9["LastPtNm"..i];
		local ptLd = s9["LastPtLd"..i];
		local posL = 3 + ((i-1) *110);
		local posH = g9.frH + g9.qsH + g9.exH;

		local gb = frm:CreateOrGetControl("groupbox", "pgb"..i, posL, posH, 105, 28);
		gb:SetSkinName("skin_white");
		if(ptId == gPty.PtId) then
			gb:SetColorTone("60FFFFFF");
			gb:EnableHitTest(0);
		elseif(fPty) then
			gb:SetColorTone("C0100000");
			gb:EnableHitTest(0);
		else
			gb:SetColorTone("C0000000");
			gb:EnableHitTest(1);
			gb:SetEventScript(ui.LBUTTONUP, "TPWARP_BTN_PARTY");
		end

		local rt = gb:CreateOrGetControl("richtext", "prt"..i,2,0,100,28);
		rt = tolua.cast(rt, "ui::CRichText");	-- ui::CObject を ui::CRichTextにキャスト
		rt:SetFontName("white_12_ol");
		rt:EnableResizeByText(0);	-- CRichTextでないと使えない
		rt:SetTextFixWidth(0);		-- CRichTextでないと使えない
		rt:EnableSplitBySpace(0);	-- CRichTextでないと使えない
		rt:EnableHitTest(0);

		if (ptId == nil) or (ptId == "") then
			rt:SetText("");
		else
			rt:SetText(ptNm.."{nl}"..ptLd);
		end
	end
end
function g9.SetCampLink()
	if (s9.MainUIShowCamp ~= true) then
		return;
	end
	local frm	= ui.GetFrame("tpwarp");
	if (frm == nil) then
		return;
	end
	local i = 0;
	for i = 1, #gPty.LstCmp do
		local camp = gPty.LstCmp[i];
		local posL = 60 + ((i-1) *42);

		local gb = frm:CreateOrGetControl("groupbox", "cgb"..i, posL, 2, 40, 28);
		gb:SetSkinName("skin_white");
		if(g0.MapId == camp.MapId) then
			gb:SetColorTone("C0000000");
			gb:EnableHitTest(1);
			gb:SetEventScript(ui.LBUTTONUP, "TPWARP_BTN_CAMP");
		else
			gb:SetColorTone("60FFFFFF");
			gb:EnableHitTest(0);
		end

		local rt = gb:CreateOrGetControl("richtext", "crt"..i,2,0,36,28);
		rt = tolua.cast(rt, "ui::CRichText");	-- ui::CObject を ui::CRichTextにキャスト
		rt:SetFontName("white_12_ol");
		rt:EnableResizeByText(0);	-- CRichTextでないと使えない
		rt:SetTextFixWidth(0);		-- CRichTextでないと使えない
		rt:EnableSplitBySpace(0);	-- CRichTextでないと使えない
		rt:EnableHitTest(0);

		if (camp == nil) then
			rt:SetText("");
		else
			rt:SetText(camp.MapNm.."{nl}"..camp.OnrNm);
		end
		gb:ShowWindow(1);
	end
	for i = #gPty.LstCmp+1, 5 do
		local gb = frm:GetChild("cgb"..i);
		if(gb~=nil) then
			gb:ShowWindow(0);
		end
	end
end


function g9.SetUnqNItm()
	if (s9.MainUIShowUnique ~= true) and (s9.MainUIShowEscItm ~= true) then
		return;
	end
	local frm	= ui.GetFrame("tpwarp");
	if (frm == nil) then
		return;
	end
	g9.exH = 30;
	local posH = g9.frH;
	if (s9.MainUIShowUnique == true) then
		local i = 0;
		for i = 1, #gQst.LstUniq do
			local uniq = gQst.LstUniq[i];
			local posL = 2 + ((i-1) *42);

			local gb = frm:CreateOrGetControl("groupbox", "ugb"..i, posL, posH, 40, 28);
			gb:SetSkinName("skin_white");
			gb:SetColorTone("C0000000");
			gb:EnableHitTest(1);
			gb:SetEventScript(ui.LBUTTONUP, "TPWARP_BTN_UNIQUE");

			local rt = gb:CreateOrGetControl("richtext", "urt"..i,2,0,36,28);
			rt = tolua.cast(rt, "ui::CRichText");	-- ui::CObject を ui::CRichTextにキャスト
			rt:SetFontName("white_12_ol");
			rt:EnableResizeByText(0);	-- CRichTextでないと使えない
			rt:SetTextFixWidth(0);		-- CRichTextでないと使えない
			rt:EnableSplitBySpace(0);	-- CRichTextでないと使えない
			rt:EnableHitTest(0);
			rt:SetText(uniq.mName.."{nl}"..uniq.Name);

			gb:ShowWindow(1);
		end
	end
	if (s9.MainUIShowEscItm == true) then
		local posL = 422;
		g9.SetItem2Slot(frm, posL, posH,"Escape_Orb", "sltitm1", "TPWARP_BTN_ITM1")
		local posL = 422+32;
		g9.SetItem2Slot(frm, posL, posH,"EscapeStone_Klaipeda", "sltitm2", "TPWARP_BTN_ITM2")
		local posL = 422+64;
		g9.SetItem2Slot(frm, posL, posH,"EscapeStone_Orsha", "sltitm3", "TPWARP_BTN_ITM3")
	end
end

function g9.SetItem2Slot(parent, posL, posH, itmName, sltName, fncName)
	local slt = parent:CreateOrGetControl("slot", sltName, posL, posH, 30, 28);
	slt = tolua.cast(slt, "ui::CSlot");
	local itm = gInv.MyLst[itmName];
	if(itm~=nil) then
		local icn = CreateIcon(slt);
		local invItem = session.GetInvItemByGuid(itm.Guid) or session.GetInvItemByType(itm.Name);
		if(invItem~=nil) then
			SET_SLOT_ITEM_IMAGE(slt, invItem);
			SET_SLOT_ITEM_TEXT(slt, invItem, GetClassByType("Item",invItem.type));
			CreateIcon(slt):SetColorTone("FFFFFFFF");
			slt:EnableDrag(0);
			slt:EnableDrop(0);
			slt:SetEventScript(ui.LBUTTONUP, fncName);
			slt:SetEventScript(ui.RBUTTONUP, fncName);
			ICON_SET_ITEM_COOLDOWN(icn, invItem.type);
			slt:ShowWindow(1);
		else
			slt:ShowWindow(0);
		end
	else
		slt:ShowWindow(0);
	end
end

function TPWARP_BTN_UNIQUE(frame, ctrl, argStr, argNum)
	if(g0.IsRightShow()) then
		return;
	end
	if(os.clock()<(g9.lastclck or 0)+3) then
		return;
	end
	g9.lastclck = os.clock();
	local i = tonumber(string.sub(ctrl:GetName(), 4));
	local uniq = gQst.LstUniq[i];
	control.CustomCommand('MOVE_TO_ENTER_NPC', uniq.ClsID, uniq.ClsTyp, 0);
end

function TPWARP_BTN_ITM1(frame, ctrl, argStr, argNum)
	if(g0.IsRightShow()) then
		return;
	end
	if(os.clock()<(g9.lastclck or 0)+3) then
		return;
	end
	g9.lastclck = os.clock();
	local itm = gInv.MyLst["Escape_Orb"];
	if(itm~=nil) then
		local invItem = GET_PC_ITEM_BY_GUID(itm.Guid);
		if(invItem~=nil) then
			INV_ICON_USE(invItem);
		end
	end
end

function TPWARP_BTN_ITM2(frame, ctrl, argStr, argNum)
	if(g0.IsRightShow()) then
		return;
	end
	if(os.clock()<(g9.lastclck or 0)+3) then
		return;
	end
	g9.lastclck = os.clock();
	local itm = gInv.MyLst["EscapeStone_Klaipeda"];
	if(itm~=nil) then
		local invItem = GET_PC_ITEM_BY_GUID(itm.Guid);
		if(invItem~=nil) then
			INV_ICON_USE(invItem);
		end
	end
end

function TPWARP_BTN_ITM3(frame, ctrl, argStr, argNum)
	if(g0.IsRightShow()) then
		return;
	end
	if(os.clock()<(g9.lastclck or 0)+3) then
		return;
	end
	g9.lastclck = os.clock();
	local itm = gInv.MyLst["EscapeStone_Orsha"];
	if(itm~=nil) then
		local invItem = GET_PC_ITEM_BY_GUID(itm.Guid);
		if(invItem~=nil) then
			INV_ICON_USE(invItem);
		end
	end
end

function TPWARP_BTN_CAMP(frame, ctrl, argStr, argNum)
	if(g0.IsRightShow()) then
		return;
	end
	if(os.clock()<(g9.lastclck or 0)+3) then
		return;
	end
	g9.lastclck = os.clock();
	--	CHAT_SYSTEM("TPWARP_BTN_CAMP"..ctrl:GetName());
	if (IS_IN_EVENT_MAP() == true)
	or (session.colonywar.GetIsColonyWarMap() == true)
	then
		ui.SysMsg(ClMsg('ImpossibleInCurrentMap'));
		return;
	end
	local i = tonumber(string.sub(ctrl:GetName(), 4));
	local camp = gPty.LstCmp[i];
	session.party.RequestMoveToCamp(camp.OnrId);
end

function TPWARP_BTN_PARTY(frame, ctrl, argStr, argNum)
	if(g0.IsRightShow()) then
		return;
	end
	if(os.clock()<(g9.lastclck or 0)+3) then
		return;
	end
	g9.lastclck = os.clock();
	--	CHAT_SYSTEM("TPWARP_BTN_PARTY"..ctrl:GetName());
	local i = tonumber(string.sub(ctrl:GetName(), 4));
	local ptId = s9["LastPtId"..i];
	if (ptId == nil) or (ptId == "") then
		return;
	end
	local pcParty = session.party.GetPartyInfo();
	if (pcParty == nil) or (pcParty.info == nil) then
		party.JoinPartyByLink(0, ptId);
	end
end

function TPWARP_BTN_PARTYOUT(frame, ctrl, argStr, argNum)
	if(g0.IsRightShow()) then
		return;
	end
	if(os.clock()<(g9.lastclck or 0)+3) then
		return;
	end
	OUT_PARTY();
end

function TPWARP_BTN_QUEST(frame, ctrl, argStr, argNum)
	if(g0.IsRightShow()) then
		return;
	end
	if(os.clock()<(g9.lastclck or 0)+3) then
		return;
	end
	g9.lastclck = os.clock();
	--	CHAT_SYSTEM("TPWARP_BTN_QUEST"..ctrl:GetName());
	local i = tonumber(string.sub(ctrl:GetName(), 4));
	local qData = gQst.LstWarp[i];
	QUESTION_QUEST_WARP(frame, ctrl, argStr, qData.qCId);
end

function TPWARP_BTN_BACK(frame, ctrl, argStr, argNum)
	if(g0.IsRightShow()) then
		return;
	end
	if(os.clock()<(g9.lastclck or 0)+3) then
		return;
	end
	g9.lastclck = os.clock();
	--	CHAT_SYSTEM("TPWARP_BTN_BACK"..ctrl:GetName());
	packet.ReqReturnOriginServer();
end
