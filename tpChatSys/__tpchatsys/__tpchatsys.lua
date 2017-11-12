--[[
	日本語
--]]

local acutil = require('acutil');
local json = require('json');

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

ADDONS											= ADDONS or {};
ADDONS.torahamu									= ADDONS.torahamu or {};
ADDONS.torahamu.CHATEXTENDS						= ADDONS.torahamu.CHATEXTENDS or {};
ADDONS.torahamu.CHATEXTENDS.settings			= ADDONS.torahamu.CHATEXTENDS.settings or {};
ADDONS.torahamu.CHATEXTENDS.settings.BALLON_FLG	= ADDONS.torahamu.CHATEXTENDS.settings.BALLON_FLG or false;


function __TPCHATSYS_ON_INIT(addon, frame)
	local f,m = pcall(TPCHATSYS_LOAD_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
		return;
	end
	f,m = pcall(TPCHATSYS_SAVE_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
		return;
	end
	--	既存の「CHAT_SYSTEM」を置き換える(addon.ipf\chat)
	--	既存の関数はとっておいて、あとで使う
	if(_G["TPCHATSYS_OLD_CHAT_SYSTEM"]==nil) then
		--	待避する関数がすでにいたら、やらない　(2度置き換えると無限ループ)
		_G["TPCHATSYS_OLD_CHAT_SYSTEM"] = CHAT_SYSTEM;
		_G["CHAT_SYSTEM"] = TPCHATSYS_HOOK_CHAT_SYSTEM;
	end

	f,m = pcall(TPCHATSYS_ON_INIT,addon, frame);
	if f ~= true then
		CHAT_SYSTEM(m);
		return;
	end
end
function TPCHATSYS_ON_INIT(addon, frame)

	-- イベント登録
	frame:SetEventScript(ui.MOUSEMOVE, "TPCAHTSYS_MOUSEMOVE");

	-- 開始位置をいじる
	frame:MoveFrame(s2.posX, s2.posY);
	
	-- ボタン設定
	frame:GetChild("btn_1"):ShowWindow(s2.btn1Show);
	frame:GetChild("btn_2"):ShowWindow(s2.btn2Show);
	frame:GetChild("btn_3"):ShowWindow(s2.btn3Show);
	frame:GetChild("btn_4"):ShowWindow(s2.btn4Show);
	frame:GetChild("btn_5"):ShowWindow(s2.btn5Show);
	frame:GetChild("btn_1"):SetText(g2.btn1Text);
	frame:GetChild("btn_2"):SetText(g2.btn2Text);
	frame:GetChild("btn_3"):SetText(g2.btn3Text);
	frame:GetChild("btn_4"):SetText(g2.btn4Text);
	frame:GetChild("btn_5"):SetText(g2.btn5Text);
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
	if f ~= true then
		TPCHATSYS_OLD_CHAT_SYSTEM(m);
		TPCHATSYS_OLD_CHAT_SYSTEM(msg);
		return;
	end
	if s2.isUseOrignal then
		TPCHATSYS_OLD_CHAT_SYSTEM(msg);
	end
end

function TPCHATSYS_LOAD_SETTING()
	local t, err = acutil.loadJSON(g2.settingPath);
	if t then
		g2.settings = acutil.mergeLeft(g2.settings, t);
	end
	-- 	値の存在確保と初期値設定
	s2.isDebug		= ((type(s2.isDebug			) == "boolean")	and s2.isDebug		)or false;
	s2.isSaveLog	= ((type(s2.isSaveLog		) == "boolean")	and s2.isSaveLog	)or (s2.isSaveLog==nil);
	s2.isUseOrignal	= ((type(s2.isUseOrignal	) == "boolean")	and s2.isUseOrignal	)or false;
	s2.msgLimitH	= ((type(s2.msgLimitH		) == "number")	and s2.msgLimitH	)or 300;
	s2.msgLimitL	= ((type(s2.msgLimitL		) == "number")	and s2.msgLimitL	)or 240;
	s2.msgMargeSpan	= ((type(s2.msgMargeSpan	) == "number")	and s2.msgMargeSpan	)or 2;
	s2.posX			= ((type(s2.posX			) == "number")	and s2.posX			)or 0;
	s2.posY			= ((type(s2.posY			) == "number")	and s2.posY			)or 340;
	s2.sizeW		= ((type(s2.sizeW			) == "number")	and s2.sizeW		)or 600;
	s2.sizeH		= ((type(s2.sizeH			) == "number")	and s2.sizeH		)or 370;
	s2.backCol		= ((type(s2.backCol			) == "number")	and s2.backCol		)or 80;
	s2.btn1Show		= ((type(s2.btn1Show		) == "number")	and s2.btn1Show		)or 0;
	s2.btn2Show		= ((type(s2.btn2Show		) == "number")	and s2.btn2Show		)or 0;
	s2.btn3Show		= ((type(s2.btn3Show		) == "number")	and s2.btn3Show		)or 0;
	s2.btn4Show		= ((type(s2.btn4Show		) == "number")	and s2.btn4Show		)or 0;
	s2.btn5Show		= ((type(s2.btn5Show		) == "number")	and s2.btn5Show		)or 0;
	s2.btn1Text		= ((type(s2.btn1Text		) == "string")	and s2.btn1Text		)or "1";
	s2.btn2Text		= ((type(s2.btn2Text		) == "string")	and s2.btn2Text		)or "2";
	s2.btn3Text		= ((type(s2.btn3Text		) == "string")	and s2.btn3Text		)or "3";
	s2.btn4Text		= ((type(s2.btn4Text		) == "string")	and s2.btn4Text		)or "4";
	s2.btn5Text		= ((type(s2.btn5Text		) == "string")	and s2.btn5Text		)or "{img emoticon_0001 24 24}{$}";
	s2.btn1Cmd		= ((type(s2.btn1Cmd			) == "string")	and s2.btn1Cmd		)or "$dev";
	s2.btn2Cmd		= ((type(s2.btn2Cmd			) == "string")	and s2.btn2Cmd		)or "";
	s2.btn3Cmd		= ((type(s2.btn3Cmd			) == "string")	and s2.btn3Cmd		)or "";
	s2.btn4Cmd		= ((type(s2.btn4Cmd			) == "string")	and s2.btn4Cmd		)or "";
	s2.btn5Cmd		= ((type(s2.btn5Cmd			) == "string")	and s2.btn5Cmd		)or "";
	g2.btn1Text		= string.gsub(s2.btn1Text,"%$","/");
	g2.btn2Text		= string.gsub(s2.btn2Text,"%$","/");
	g2.btn3Text		= string.gsub(s2.btn3Text,"%$","/");
	g2.btn4Text		= string.gsub(s2.btn4Text,"%$","/");
	g2.btn5Text		= string.gsub(s2.btn5Text,"%$","/");
	g2.btn1Cmd		= string.gsub(s2.btn1Cmd ,"%$","/");
	g2.btn2Cmd		= string.gsub(s2.btn2Cmd ,"%$","/");
	g2.btn3Cmd		= string.gsub(s2.btn3Cmd ,"%$","/");
	g2.btn4Cmd		= string.gsub(s2.btn4Cmd ,"%$","/");
	g2.btn5Cmd		= string.gsub(s2.btn5Cmd ,"%$","/");
	if (s2.msgLimitH < s2.msgLimitL) then
		s2.msgLimitL = s2.msgLimitH;
	end
	if (type(s2.backCol) ~= "number") or (s2.backCol < 0) or(s2.backCol > 100) then
		s2.backCol = 80;
	end
	g2.backCol = s2.backCol * 2.55;
end

function TPCHATSYS_SAVE_SETTING()
	local filep = io.open(g2.settingPath,"w+");
	if filep then
		filep:write("{");
		filep:write("\t\"isSaveLog\":"		.. ((s2.isSaveLog		and "true") or "false")	.."\n"	);
		filep:write("\t\"isUseOrignal\":"	.. ((s2.isUseOrignal	and "true") or "false")	.."\n"	);
		filep:write("\t\"msgLimitH\":"		.. s2.msgLimitH		.."\n"		);
		filep:write("\t\"msgLimitL\":"		.. s2.msgLimitL		.."\n"		);
		filep:write("\t\"msgMargeSpan\":"	.. s2.msgMargeSpan	.."\n"		);
		filep:write("\t\"posX\":"			.. s2.posX			.."\n"		);
		filep:write("\t\"posY\":"			.. s2.posY			.."\n"		);
		filep:write("\t\"sizeW\":"			.. s2.sizeW			.."\n"		);
		filep:write("\t\"sizeH\":"			.. s2.sizeH			.."\n"		);
		filep:write("\t\"backCol\":"		.. s2.backCol		.."\n"		);
		filep:write("\t\"btn1Show\":"		.. s2.btn1Show		.."\n"		);
		filep:write("\t\"btn2Show\":"		.. s2.btn2Show		.."\n"		);
		filep:write("\t\"btn3Show\":"		.. s2.btn3Show		.."\n"		);
		filep:write("\t\"btn4Show\":"		.. s2.btn4Show		.."\n"		);
		filep:write("\t\"btn5Show\":"		.. s2.btn5Show		.."\n"		);
		filep:write("\t\"btn1Text\":\""		.. s2.btn1Text		.."\"\n"	);
		filep:write("\t\"btn2Text\":\""		.. s2.btn2Text		.."\"\n"	);
		filep:write("\t\"btn3Text\":\""		.. s2.btn3Text		.."\"\n"	);
		filep:write("\t\"btn4Text\":\""		.. s2.btn4Text		.."\"\n"	);
		filep:write("\t\"btn5Text\":\""		.. s2.btn5Text		.."\"\n"	);
		filep:write("\t\"btn1Cmd\":\""		.. s2.btn1Cmd		.."\"\n"	);
		filep:write("\t\"btn2Cmd\":\""		.. s2.btn2Cmd		.."\"\n"	);
		filep:write("\t\"btn3Cmd\":\""		.. s2.btn3Cmd		.."\"\n"	);
		filep:write("\t\"btn4Cmd\":\""		.. s2.btn4Cmd		.."\"\n"	);
		filep:write("\t\"btn5Cmd\":\""		.. s2.btn5Cmd		.."\"\n"	);
		filep:write("}\n");
		filep:close();
	end
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

function TPCHATSYS_ON_BTN_RESIZE(parent, ctrl)
	local mx, my = GET_MOUSE_POS();
	g2.rssx = mx / ui.GetRatioWidth();
	g2.rssy = my / ui.GetRatioHeight();
	
	--	CHAT_SYSTEM("TPCHATSYS_ON_BTN_RESIZE " .. g2.rssx .. " " .. g2.rssy);
	
	local frm1	= ui.GetFrame("__tpchatsys");
	local frm2	= ui.GetFrame("tpchatsys2");
	if (frm1 == nil) or (frm2 == nil) then
		return;
	end
	g2.rshx = frm1:GetX();
	g2.rshy = frm1:GetY();
	g2.rshw = frm1:GetWidth();
	g2.rshh = frm1:GetHeight();
	g2.rsmx = frm2:GetX();
	g2.rsmy = frm2:GetY();
	g2.rsmw = frm2:GetWidth();
	g2.rsmh = frm2:GetHeight();
	frm1:RunUpdateScript("TPCHATSYS_RESIZE_UPDATE",  0.05, 0.0, 0, 1);
end

function TPCHATSYS_RESIZE_UPDATE(frame)
	local frm1	= ui.GetFrame("__tpchatsys");
	local mx, my = GET_MOUSE_POS();
	g2.rsnx = mx / ui.GetRatioWidth();
	g2.rsny = my / ui.GetRatioHeight();
	if mouse.IsLBtnPressed() == 0 then
		frm1:StopUpdateScript("TPCHATSYS_RESIZE_UPDATE");
		--	CHAT_SYSTEM("TPCHATSYS_RESIZE_UPDATE_STOP " .. g2.rsnx .. " " .. g2.rsny);
		TPCHATSYS_RESIZE();
		TPCHATSYS_SAVE_SETTING();
		TPCHATSYS_INIT_MSG();
		return 0;	--	UPDATEの呼び出し終了
	end
	--	CHAT_SYSTEM("TPCHATSYS_RESIZE_UPDATE " .. g2.rsnx .. " " .. g2.rsny);
	TPCHATSYS_RESIZE();
	return 1;	--	UPDATEの呼び出し継続
end

function TPCHATSYS_RESIZE()
	local frm1	= ui.GetFrame("__tpchatsys");
	local frm2	= ui.GetFrame("tpchatsys2");
	if (frm1 == nil) or (frm2 == nil) then
		return;
	end

	local newmw = math.max(400 , g2.rsmw + g2.rsnx - g2.rssx);
	local newmh = math.max(100 , g2.rsmh + g2.rssy - g2.rsny);
	local newmy = g2.rsmy + g2.rsmh - newmh  ;
	local newhy = g2.rshy + g2.rsmh - newmh  ;

	frm2:MoveFrame(	g2.rsmx	, newmy  );
	frm2:Resize(	newmw	, newmh  );
	frm1:MoveFrame(	g2.rshx	, newhy  );

	s2.posY		= newhy;
	s2.sizeW	= newmw;
	s2.sizeH	= newmh;

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
	local dispMode	= (ADDONS.torahamu.CHATEXTENDS.settings.BALLON_FLG and 0 or 1);

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
	local msgDat	= g2.msgList["cht"..g2.msgNewNum];
	if (msgDat == nil) then
		return false;
	end
	local mainchatFrame	= ui.GetFrame("chatframe")
	local fontSize		= GET_CHAT_FONT_SIZE();	
	local fontStyle		= mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_SYSTEM");
	if (msgDat.dsp ==0) then
		fontStyle	= "{#000000}{b}";
	end

	local frm		= ui.GetFrame("tpchatsys2");
	if (frm == nil) then
		-- 最終データの文字列を置き換える
		msgDat.msg = msgDat.msg .. "{/}{/}{/}{nl}" .. fontStyle.."{s"..fontSize.."}"..msg;
		return true;
	end
	local grp		= tolua.cast(frm:GetChild("chatlist"), "ui::CGroupBox");	-- GET_CHILDで同じことが出来るけどベースコードで書く
	if (grp == nil) then
		-- 最終データの文字列を置き換える
		msgDat.msg = msgDat.msg .. "{/}{/}{/}{nl}" .. fontStyle.."{s"..fontSize.."}"..msg;
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
	msgDat.msg = msgDat.msg .. "{/}{/}{/}{nl}" .. fontStyle.."{s"..fontSize.."}"..msg;


	-- 最下部判定　全体Yサイズ　＜　表示上端Y＋表可能Yサイズ＋1行文　なら、最下部に設定し直す
	local isBottom = false;
	if grp:GetLineCount() < grp:GetCurLine() + grp:GetVisibleLineCount() + fontSize then	-- CGroupBoxでないと使えない Lineとは言うが、Y座標値が取れる」
		isBottom = true;
	end

	tmpTxt:SetText("{/}{/}{/}"..fontStyle.."{s"..fontSize.."}"..msgDat.msg.."{/}{/}{/}{nl}");

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
	g2.msgList["cht"..g2.msgNewNum].dsp = (ADDONS.torahamu.CHATEXTENDS.settings.BALLON_FLG and 0 or 1);

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
	local msgDat	= g2.msgList["cht"..msgNum];
	if (msgDat == nil) then
		return;
	end
	local frm		= ui.GetFrame("tpchatsys2");
	local grp		= tolua.cast(frm:GetChild("chatlist"), "ui::CGroupBox");	-- GET_CHILDで同じことが出来るけどベースコードで書く

	local mainchatFrame	= ui.GetFrame("chatframe")
	local fontSize		= GET_CHAT_FONT_SIZE();	
	local fontStyle		= mainchatFrame:GetUserConfig("TEXTCHAT_FONTSTYLE_SYSTEM");
	local boxCol		= string.format("%02x",g2.backCol) .."000000";
	local timFont		= "white_14_ol";
	if (msgDat.dsp ==0) then
		fontStyle	= "{#000000}{b}";
		boxCol		= string.format("%02x",g2.backCol) .."FFFFFF";
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
	chtTim:SetText(msgDat.tim);

	local chtTxt = chtBox:CreateOrGetControl("richtext", "chtTxt",0,0,wTxt,100);
	chtTxt = tolua.cast(chtTxt, "ui::CRichText");	-- ui::CObject を ui::CRichTextにキャスト
	chtTxt:EnableResizeByText(1);	-- CRichTextでないと使えない
	chtTxt:SetTextFixWidth(1);		-- CRichTextでないと使えない
	chtTxt:SetTextMaxWidth(wTxt);	-- CRichTextでないと使えない
	chtTxt:EnableSplitBySpace(0);	-- CRichTextでないと使えない

	chtTxt:SetText("{/}{/}{/}"..fontStyle.."{s"..fontSize.."}"..msgDat.msg.."{/}{/}{/}{nl}");

	chtBox:Resize(chtBox:GetWidth(), chtTxt:GetHeight());
	g2.msgLastPos = g2.msgLastPos + chtBox:GetHeight() + s2.msgMargeSpan;

end

-- 全管理メッセージ再表示する
function TPCHATSYS_INIT_MSG()
	local frm		= ui.GetFrame("tpchatsys2");
	local grp		= tolua.cast(frm:GetChild("chatlist"), "ui::CGroupBox");	-- GET_CHILDで同じことが出来るけどベースコードで書く

	g2.msgDispMode	= (ADDONS.torahamu.CHATEXTENDS.settings.BALLON_FLG and 0 or 1);

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

function TPCHATSYS_ON_BTN_1()
	ui.Chat(g2.btn1Cmd);
end

function TPCHATSYS_ON_BTN_2()
	ui.Chat(g2.btn2Cmd);
end

function TPCHATSYS_ON_BTN_3()
	ui.Chat(g2.btn3Cmd);
end

function TPCHATSYS_ON_BTN_4()
	ui.Chat(g2.btn4Cmd);
end

function TPCHATSYS_ON_BTN_5()
	ui.Chat(g2.btn5Cmd);
end
