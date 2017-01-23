--[[
	日本語
--]]

local acutil = require('acutil');

_G['TPCHATSYS'] = _G['TPCHATSYS'] or {};
local g2 = _G['TPCHATSYS'];
g2.settingPath	= g2.settingpath	or "../addons/tpchatsys/settings.json";
g2.settings		= g2.settings		or {};
g2.msgList		= g2.msgList		or {};
g2.msgOldNum	= g2.msgOldNum		or 0;
g2.msgNewNum	= g2.msgNewNum		or 0;
g2.msgLastPos	= g2.msgLastPos		or 0;
g2.msgDispMode	= g2.msgDispMode	or 0;

local s2 = g2.settings;

function __TPCHATSYS_ON_INIT(addon, frame)
	TPCHATSYS_LOAD_SETTING();
	TPCHATSYS_SAVE_SETTING();
	--	既存の「CHAT_SYSTEM」を置き換える(addon.ipf\chat)
	--	既存の関数はとっておいて、あとで使う
	if(_G["TPCHATSYS_OLD_CHAT_SYSTEM"]==nil) then
		--	待避する関数がすでにいたら、やらない　(2度置き換えると無限ループ)
		_G["TPCHATSYS_OLD_CHAT_SYSTEM"] = CHAT_SYSTEM;
		_G["CHAT_SYSTEM"] = TPCHATSYS_HOOK_CHAT_SYSTEM;
	end

	-- イベント登録
	frame:SetEventScript(ui.MOUSEMOVE, "TPCAHTSYS_MOUSEMOVE");

	-- 開始位置をいじる
	frame:MoveFrame(s2.posX, s2.posY);
end

function TPCHATSYS2_ON_INIT(addon, frame)
	TPCHATSYS_LOAD_SETTING();
	-- 開始位置と大きさをいじる
	frame:MoveFrame(s2.posX, s2.posY+30);
	frame:Resize(s2.sizeW, s2.sizeH);
	local grp		= tolua.cast(frame:GetChild("chatlist"), "ui::CGroupBox");	-- GET_CHILDで同じことが出来るけどベースコードで書く
	grp:Resize(s2.sizeW-6, s2.sizeH-6);
	TPCHATSYS_INIT_MSG();
end

function TPCHATSYS_HOOK_CHAT_SYSTEM(msg)
	local f,m = pcall(TPCHATSYS_NEW_CHAT_SYSTEM,msg);
	if f then
	else
		TPCHATSYS_OLD_CHAT_SYSTEM(m);
		TPCHATSYS_OLD_CHAT_SYSTEM(msg);
		return;
	end
	if s2.isUseOrignal then
		TPCHATSYS_OLD_CHAT_SYSTEM(msg);
	end
end

function TPCHATSYS_LOAD_SETTING()
	local t, err = acutil.loadJSON(g2.settingPath, g2.settings);
	-- 	値の存在確保と初期値設定
	s2.isDebug		= s2.isDebug		or false;
	s2.isSaveLog	= s2.isSaveLog		or true;
	s2.isUseOrignal	= s2.isUseOrignal	or false;
	s2.msgLimitH	= s2.msgLimitH		or 300;
	s2.msgLimitL	= s2.msgLimitL		or 240;
	s2.msgMargeSpan	= s2.msgMargeSpan	or 2;
	s2.posX			= s2.posX			or 0;
	s2.posY			= s2.posY			or 340;
	s2.sizeW		= s2.sizeW			or 600;
	s2.sizeH		= s2.sizeH			or 370;
	if (s2.msgLimitH < s2.msgLimitL) then
		s2.msgLimitL = s2.msgLimitH;
	end
end

function TPCHATSYS_SAVE_SETTING()
	local t, err = acutil.saveJSON(g2.settingPath, g2.settings);
end

function TPCHATSYS_NEW_CHAT_SYSTEM(msg)
	if (msg == nil) then
		return;
	end
	if s2.isSaveLog then
		TPCHATSYS_SAVE_LOG(msg);
	end
	TPCHATSYS_ON_MSG(msg);
	return;
end

function TPCHATSYS_SAVE_LOG(msg)
	g2.logPath = g2.logPath or "../addons/tpchatsys/log" .. os.date("%Y%m%d%H%M%S") .. ".log";
	local filep = io.open(g2.logPath,"a+");
	if filep then
		filep:write(os.date("%Y/%m/%d %H:%M:%S") .. "\t" .. dictionary.ReplaceDicIDInCompStr(msg).."\n");
		filep:close();
	end
end

function TPCAHTSYS_MOUSEMOVE()
	local frm1	= ui.GetFrame("__tpchatsys");
	local frm2	= ui.GetFrame("tpchatsys2");
	if (frm1 == nil) or (frm2 == nil) then
		return;
	end
	if (frm1:GetX() ~= frm2:GetX()) or ((frm1:GetY() + frm1:GetHeight()) ~= frm2:GetY()) then
		frm2:MoveFrame(frm1:GetX(), frm1:GetY() + frm1:GetHeight());
	end
end

function TPCAHTSYS_LBTNUP()
	local frm1	= ui.GetFrame("__tpchatsys");
	if (frm1 == nil) then
		return;
	end
	s2.posX	= frm1:GetX();
	s2.posY	= frm1:GetY();
	TPCHATSYS_SAVE_SETTING();
end


function TPCHATSYS_ON_SCROLL(frame, ctrl, str, scrollValue)
	local frm1	= ui.GetFrame("__tpchatsys");
	local frm2	= ui.GetFrame("tpchatsys2");
	if (frm1 == nil) or (frm2 == nil) then
		return;
	end

	local grp		= tolua.cast(frm2:GetChild("chatlist"), "ui::CGroupBox");	-- GET_CHILDで同じことが出来るけどベースコードで書く
	local btnTop	= frm1:GetChild("btn_top");
	local btnBtm	= frm1:GetChild("btn_bottom");
	if (grp == nil) then
		return;
	end

	if (btnTop ~= nil) then
		-- 最下部判定
		if grp:GetCurLine() <  2 then	-- CGroupBoxでないと使えない Lineとは言うが、Y座標値が取れる
			btnTop:ShowWindow(0);
		else
			btnTop:ShowWindow(1);
		end
	end
	
	if (btnBtm ~= nil) then
		-- 最上部判定
		if grp:GetLineCount() < grp:GetCurLine() + grp:GetVisibleLineCount() + 2 then	-- CGroupBoxでないと使えない Lineとは言うが、Y座標値が取れる
			btnBtm:ShowWindow(0);
		else
			btnBtm:ShowWindow(1);
		end
	end
end

function TPCHATSYS_ON_BTN_MIN()
	local frm1	= ui.GetFrame("__tpchatsys");
	local frm2	= ui.GetFrame("tpchatsys2");
	if (frm1 == nil) or (frm2 == nil) then
		return;
	end

	if frm2:IsVisible() == 1 then
		frm2:ShowWindow(0);
	else
		frm2:ShowWindow(1);
	end
end

function TPCHATSYS_ON_BTN_TOP()
	local frm1	= ui.GetFrame("__tpchatsys");
	local frm2	= ui.GetFrame("tpchatsys2");
	if (frm1 == nil) or (frm2 == nil) then
		return;
	end

	local grp		= tolua.cast(frm2:GetChild("chatlist"), "ui::CGroupBox");	-- GET_CHILDで同じことが出来るけどベースコードで書く
	if (grp == nil) then
		return;
	end
	grp:SetScrollPos(0);	-- CGroupBoxでないと使えない
	local btnTop	= frm1:GetChild("btn_top");
	local btnBtm	= frm1:GetChild("btn_bottom");
	btnTop:ShowWindow(0);
	btnBtm:ShowWindow(1);
end

function TPCHATSYS_ON_BTN_BOTTOM()
	local frm1	= ui.GetFrame("__tpchatsys");
	local frm2	= ui.GetFrame("tpchatsys2");
	if (frm1 == nil) or (frm2 == nil) then
		return;
	end

	local grp		= tolua.cast(frm2:GetChild("chatlist"), "ui::CGroupBox");	-- GET_CHILDで同じことが出来るけどベースコードで書く
	if (grp == nil) then
		return;
	end
	grp:SetScrollPos(999999);	-- CGroupBoxでないと使えない
	local btnTop	= frm1:GetChild("btn_top");
	local btnBtm	= frm1:GetChild("btn_bottom");
	btnTop:ShowWindow(1);
	btnBtm:ShowWindow(0);
end

function TPCHATSYS_ON_MSG(msg)
	local nowTime	= os.clock();	-- Windowsならシステム秒
	local dispMode	= config.GetXMLConfig("ToggleTextChat");

	-- メッセージをマージする範囲内なら、UPD_MSG	※msgLastPosが変化
	if (g2.msgNewNum>0) and (g2.msgLast + s2.msgMargeSpan > nowTime) and (g2.msgDispMode == dispMode) then
		if TPCHATSYS_UPD_MSG(msg) then
			return;
		end
	end
	g2.msgLast = nowTime;
	g2.msgDispMode = dispMode;

	-- 最大行数を超えたら、DEL_MSG	※msgOldNum　msgLastPosが変化
	if (g2.msgNewNum+1 > g2.msgOldNum + s2.msgLimitH) then
		TPCHATSYS_DEL_MSG();
	end

	-- 新しいメッセージを追加　	※msgNewNum　msgLastPosが変化
	TPCHATSYS_ADD_MSG(msg);
end

-- 管理メッセージで最後のメッセージを更新する　boolを返却
function TPCHATSYS_UPD_MSG(msg)
	local xxx 		= g2.msgList["cht"..g2.msgNewNum];
	if (xxx == nil) then
		return false;
	end
	local mainchatFrame	= ui.GetFrame("chatframe")
	local fontSize		= GET_CHAT_FONT_SIZE();	
	local fontStyle		= mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_SYSTEM");
	if (xxx.dsp ==0) then
		fontStyle	= mainchatFrame:GetUserConfig("BALLONCHAT_FONTSTYLE_SYSTEM");
	end

	local frm		= ui.GetFrame("tpchatsys2");
	if (frm == nil) then
		-- 最終データの文字列を置き換える
		xxx.msg = xxx.msg .. "{/}{/}{/}{nl}" .. fontStyle.."{s"..fontSize.."}"..msg;
		return true;
	end
	local grp		= tolua.cast(frm:GetChild("chatlist"), "ui::CGroupBox");	-- GET_CHILDで同じことが出来るけどベースコードで書く
	if (grp == nil) then
		-- 最終データの文字列を置き換える
		xxx.msg = xxx.msg .. "{/}{/}{/}{nl}" .. fontStyle.."{s"..fontSize.."}"..msg;
		return true;
	end

	local tmpBox	= grp:GetChild("cht"..g2.msgNewNum);
	if (tmpBox == nil) then
		return false;
	end
	local tmpTxt = tmpBox:GetChild("chtTxt");
	if (tmpTxt == nil) then
		return false;
	end
	-- 最終データの文字列を置き換える
	xxx.msg = xxx.msg .. "{/}{/}{/}{nl}" .. fontStyle.."{s"..fontSize.."}"..msg;


	-- 最下部判定　全体Yサイズ　＜　表示上端Y＋表可能Yサイズ＋1行文　なら、最下部に設定し直す
	local isBottom = false;
	if grp:GetLineCount() < grp:GetCurLine() + grp:GetVisibleLineCount() + fontSize then	-- CGroupBoxでないと使えない Lineとは言うが、Y座標値が取れる」
		isBottom = true;
	end

	tmpTxt:SetText("{/}{/}{/}"..fontStyle.."{s"..fontSize.."}"..xxx.msg.."{/}{/}{/}{nl}");

	tmpBox:Resize(tmpBox:GetWidth(), tmpTxt:GetHeight());
	g2.msgLastPos = tmpBox:GetY() + tmpBox:GetHeight() + s2.msgMargeSpan;

	if (isBottom) then
		grp:SetScrollPos(999999);	-- CGroupBoxでないと使えない
		local frm1		= ui.GetFrame("__tpchatsys");
		local btnTop	= frm1:GetChild("btn_top");
		local btnBtm	= frm1:GetChild("btn_bottom");
		btnTop:ShowWindow(1);
		btnBtm:ShowWindow(0);
	end

	return true;
end

-- 管理メッセージで古いメッセージを削除する
function TPCHATSYS_DEL_MSG()
	local msgOldNum = g2.msgOldNum;
	local i			= 0;
	-- 古いデータを消す
	for i = g2.msgOldNum , g2.msgNewNum+1-s2.msgLimitL do
		g2.msgList["cht"..i] = nil;
	end
	g2.msgOldNum = g2.msgNewNum+2-s2.msgLimitL;

	local frm		= ui.GetFrame("tpchatsys2");
	if (frm == nil) then
		return;
	end
	local grp		= tolua.cast(frm:GetChild("chatlist"), "ui::CGroupBox");	-- GET_CHILDで同じことが出来るけどベースコードで書く
	if (grp == nil) then
		return;
	end

	-- 古いコントロールを消す
	for i = msgOldNum , g2.msgNewNum+1-s2.msgLimitL do
		local tmpCht1 = grp:GetChild("cht"..i);
		if (tmpCht1 ~= nil) then
			grp:RemoveChild("cht"..i);
		end
		g2.msgList["cht"..i] = nil;
	end
	
	-- 残ったデータの表示位置再計算
	g2.msgLastPos = 0;
	for i = g2.msgOldNum , g2.msgNewNum do
		local tmpCht2	= grp:GetChild("cht"..i);
		if (tmpCht2 ~= nil) then
			tmpCht2:SetPos(tmpCht2:GetX(),g2.msgLastPos);
			g2.msgLastPos	= g2.msgLastPos + tmpCht2:GetHeight() + s2.msgMargeSpan;
		end
	end
end

-- 管理メッセージ追加する
function TPCHATSYS_ADD_MSG(msg)
	-- 新しいデータを追加
	g2.msgNewNum = g2.msgNewNum+1;
	g2.msgList["cht"..g2.msgNewNum] = {};
	g2.msgList["cht"..g2.msgNewNum].msg = msg;
	g2.msgList["cht"..g2.msgNewNum].tim = os.date("%H:%M:%S");
	g2.msgList["cht"..g2.msgNewNum].dsp = config.GetXMLConfig("ToggleTextChat");

	local frm		= ui.GetFrame("tpchatsys2");
	if (frm == nil) then
		return;
	end
	local grp		= tolua.cast(frm:GetChild("chatlist"), "ui::CGroupBox");	-- GET_CHILDで同じことが出来るけどベースコードで書く
	if (grp == nil) then
		return;
	end
	local fontSize	= GET_CHAT_FONT_SIZE();	

	-- 最下部判定　全体Yサイズ　＜　表示上端Y＋表可能Yサイズ＋1行文　なら、最下部に設定し直す
	local isBottom = false;
	if grp:GetLineCount() < grp:GetCurLine() + grp:GetVisibleLineCount() + fontSize then	-- CGroupBoxでないと使えない Lineとは言うが、Y座標値が取れる
		isBottom = true;
	end

	TPCHATSYS_ADD_MSG_BOX(g2.msgNewNum)

	if (isBottom) then
		grp:SetScrollPos(999999);	-- CGroupBoxでないと使えない
		local frm1		= ui.GetFrame("__tpchatsys");
		local btnTop	= frm1:GetChild("btn_top");
		local btnBtm	= frm1:GetChild("btn_bottom");
		btnTop:ShowWindow(1);
		btnBtm:ShowWindow(0);
	end

end

-- 管理メッセージ表示する
function TPCHATSYS_ADD_MSG_BOX(msgNum)
	local xxx 		= g2.msgList["cht"..msgNum];
	if (xxx == nil) then
		return;
	end
	local frm		= ui.GetFrame("tpchatsys2");
	local grp		= tolua.cast(frm:GetChild("chatlist"), "ui::CGroupBox");	-- GET_CHILDで同じことが出来るけどベースコードで書く

	local mainchatFrame	= ui.GetFrame("chatframe")
	local fontSize		= GET_CHAT_FONT_SIZE();	
	local fontStyle		= mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_SYSTEM");
	local boxCol		= "CC000000";
	local timFont		= "white_14_ol";
	if (xxx.dsp ==0) then
		fontStyle	= mainchatFrame:GetUserConfig("BALLONCHAT_FONTSTYLE_SYSTEM");
		boxCol		= "CCFFFFFF";
		timFont		= "black_14_b";
	end

	local wBox = grp:GetWidth() - 30;
	local wTim = 65;
	local wTxt = wBox - (wTim + 5);

	local chtBox = grp:CreateOrGetControl("groupbox", "cht"..msgNum, 30, g2.msgLastPos, wBox, 0);
	chtBox:SetSkinName("skin_white");
	chtBox:SetColorTone(boxCol);
	chtBox:EnableHitTest(0)

	local chtTim = chtBox:CreateOrGetControl("richtext", "chtTim",wBox - wTim,0,wTim,25);
	chtTim:SetFontName(timFont);
	chtTim:SetText(xxx.tim);

	local chtTxt = chtBox:CreateOrGetControl("richtext", "chtTxt",0,0,wTxt,100);
	chtTxt = tolua.cast(chtTxt, "ui::CRichText");	-- ui::CObject を ui::CRichTextにキャスト
	chtTxt:EnableResizeByText(1);	-- CRichTextでないと使えない
	chtTxt:SetTextFixWidth(1);		-- CRichTextでないと使えない
	chtTxt:SetTextMaxWidth(wTxt);	-- CRichTextでないと使えない
	chtTxt:EnableSplitBySpace(0);	-- CRichTextでないと使えない

	chtTxt:SetText("{/}{/}{/}"..fontStyle.."{s"..fontSize.."}"..xxx.msg.."{/}{/}{/}{nl}");

	chtBox:Resize(chtBox:GetWidth(), chtTxt:GetHeight());
	g2.msgLastPos = g2.msgLastPos + chtBox:GetHeight() + s2.msgMargeSpan;

end

-- 全管理メッセージ再表示する
function TPCHATSYS_INIT_MSG()
	local frm		= ui.GetFrame("tpchatsys2");
	local grp		= tolua.cast(frm:GetChild("chatlist"), "ui::CGroupBox");	-- GET_CHILDで同じことが出来るけどベースコードで書く

	g2.msgDispMode	= config.GetXMLConfig("ToggleTextChat");

	-- 古いコントロールを消す　(データは消さない)
	for i = g2.msgOldNum , g2.msgNewNum do
		local tmpCht1 = grp:GetChild("cht"..i);
		if (tmpCht1 ~= nil) then
			grp:RemoveChild("cht"..i);
		end
	end

	-- 表示開始位置のリセット
	g2.msgLastPos	= 0;
	
	-- 新しいコントロールを足す　(データは増えない)
	for i = g2.msgOldNum , g2.msgNewNum do
		TPCHATSYS_ADD_MSG_BOX(i)
	end

	grp:SetScrollPos(999999);	-- CGroupBoxでないと使えない
	local frm1		= ui.GetFrame("__tpchatsys");
	local btnTop	= frm1:GetChild("btn_top");
	local btnBtm	= frm1:GetChild("btn_bottom");
	btnTop:ShowWindow(1);
	btnBtm:ShowWindow(0);
end


