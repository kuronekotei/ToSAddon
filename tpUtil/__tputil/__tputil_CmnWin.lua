--[[__tputil_CmnWin.lua
	日本語
	関数群を保存している
--]]
local g0 = GetTpUtil();

g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "__tputil_CmnWin";

g0.CmnWin.settingPath = g0.CmnWin.settingpath or "../addons/_tputil/stg_cmnwin.lua";
g0.CmnWin.settings = g0.CmnWin.settings or {
	Lst		= {},
};
g0.CmnWin.tblSort = g0.CmnWin.tblSort or {
	{name="_",				comm="【汎用ウィンドウの設定一覧】"},
	{name="_",				comm="　"},
	{name="Lst",			comm="テーブル名称をキーにウィンドウ位置を保持する　表示等は制御しない"},
}
local tblSort = g0.CmnWin.tblSort;



function g0.CmnWinInit()
	g0.CmnWin = g0.CmnWin;
	g0.PCL(g0.LoadStg, "", g0.CmnWin.settingPath, g0.CmnWin.settings);
	g0.PCL(g0.SaveStg, "", g0.CmnWin.settingPath, g0.CmnWin.settings, tblSort);
end

function g0.CmnWinCreate(name , lstStg)
	--	local lstStg = {
	--		Icon = "icon_item_halloween_pistol",
	--		DefLine = 5,
	--		CloseScp = func,
	--		BackCol = "C0000010",
	--		BtnStg ={
	--			{name="/Mon",func=g0.testfunc},
	--			{name="/Skill",func=g0.testfunc},
	--			{name="/Cross",func=g0.testfunc},
	--		},
	--	};
	g0.CmnWin[name] = g0.CmnWin[name] or {};
	g0.CmnWin[name].lstTxt = g0.CmnWin[name].lstTxt or {};
	g0.CmnWin[name].BackCol = lstStg.BackCol or "C0000010";
	g0.CmnWin[name].DefLine = lstStg.DefLine or 5;
	g0.CmnWin[name].BtnStg = lstStg.BtnStg or {};
	g0.CmnWin[name].CloseScp = lstStg.CloseScp;
	g0.CmnWin.settings.Lst[name] = g0.CmnWin.settings.Lst[name] or {};
	g0.CmnWin.settings.Lst[name].PosX = g0.CmnWin.settings.Lst[name].PosX or 500;
	g0.CmnWin.settings.Lst[name].PosY = g0.CmnWin.settings.Lst[name].PosY or 300;
	local line = g0.CmnWin[name].DefLine;
	local icon = lstStg.Icon or "icon_item_halloween_pistol";
	local frm	= ui.GetFrame(name);
	if(frm ~= nil) then
		return;
	end
	if(frm == nil) then
		frm	= ui.CreateNewFrame("tputil_cmnwin", name);
	end
	frm:SetEventScript(ui.LBUTTONUP, "TPUTIL_CMNWIN_LBUTTONUP");
	frm:ShowWindow(1);
	frm:SetOffset(g0.CmnWin.settings.Lst[name].PosX, g0.CmnWin.settings.Lst[name].PosY);
	local ttl	= GET_CHILD(frm,		"title", "ui::CRichText");
	ttl:SetText("{img "..icon.." 32 32}{/}");
	local btnClose	= GET_CHILD(frm,	"btn_close", "ui::CButton");
	btnClose:SetEventScriptArgString(ui.LBUTTONUP,name);

	local frmH	= 32;
	local lines	= frm:CreateOrGetControl("groupbox", "lines", 1, frmH, frm:GetWidth() - 2, 19 * line + 2);	--	22x4 +2 = 90
	frmH = frmH + 1;
	local linH	= 2;
	for i = 1,line do
		local gb	= lines:CreateOrGetControl("groupbox", "gb"..i, 1, linH, lines:GetWidth() - 24, 18);
		linH = linH + 19;
		gb:SetSkinName("skin_white");
		gb:SetColorTone(g0.CmnWin[name].BackCol);
		gb:EnableHitTest(0);
		local rt	= gb:CreateOrGetControl("richtext", "rt"..i,2,1,gb:GetWidth()-4,16);
		rt = tolua.cast(rt, "ui::CRichText");	-- ui::CObject を ui::CRichTextにキャスト
		rt:SetFontName("white_14_ol");
		rt:EnableResizeByText(0);	-- CRichTextでないと使えない
		rt:SetTextFixWidth(0);		-- CRichTextでないと使えない
		rt:EnableSplitBySpace(0);	-- CRichTextでないと使えない
		rt:EnableHitTest(0);
	end
	local posL = 48;
	for i = 1,#g0.CmnWin[name].BtnStg do
		local btnnm = g0.CmnWin[name].BtnStg[i].name;
		local btn	= frm:CreateOrGetControl("button", "btn"..i,posL,1,0,30);
		btn = tolua.cast(btn, "ui::CButton");
		btn:SetEventScript(ui.LBUTTONUP,"TPUTIL_CMNWIN_ON_BTN");
		btn:SetEventScriptArgString(ui.LBUTTONUP,name);
		btn:SetEventScriptArgNumber(ui.LBUTTONUP, i);
		btn:SetText(" "..btnnm.." ");
		posL = posL + btn:GetWidth() + 4;
	end
	frmH = frmH + linH + 1;
	frm:Resize(	frm:GetWidth()	,frmH	);
end
function TPUTIL_CMNWIN_ON_BTN(frame, control, argStr, argNum)
	if((g0.CmnWin ==nil) or (g0.CmnWin[argStr] ==nil) 
	or (g0.CmnWin[argStr].BtnStg ==nil) 
	or (g0.CmnWin[argStr].BtnStg[argNum] ==nil) 
	or (g0.CmnWin[argStr].BtnStg[argNum].func ==nil)) then
		return;
	end
	g0.CmnWin[argStr].BtnStg[argNum].func(frame, control, argStr, argNum);
end
function TPUTIL_CMNWIN_ON_CLOSE(frame, control, argStr)
	if((g0.CmnWin ==nil) or (g0.CmnWin[argStr] ==nil)) then
		return;
	end
	if(g0.CmnWin[argStr].CloseScp ~= nil) then
		g0.CmnWin[argStr].CloseScp();
	end
	g0.CmnWin[argStr] =nil;
	ui.CloseFrame(argStr);
end
function TPUTIL_CMNWIN_LBUTTONUP(frame, control)
	g0.PCL(g0.CmnWinLBtnUp, frame);
end
function g0.CmnWinLBtnUp(frm)
	if (frm == nil) then
		return;
	end
	local name = frm:GetName()
	if((g0.CmnWin ==nil) or (g0.CmnWin[name] ==nil)) then
		return;
	end
	g0.CmnWin.settings.Lst[name].PosX	= frm:GetX();
	g0.CmnWin.settings.Lst[name].PosY	= frm:GetY();
	g0.PCL(g0.SaveStg, "", g0.CmnWin.settingPath, g0.CmnWin.settings, tblSort);
end
function g0.CmnWinUpdate(name , lstTxt)
	--	local lstTxt = {"1a","2a","3a","4a","5a","6","7","8","9","0"};
	local frm	= ui.GetFrame(name);
	if(frm == nil) then
		return;
	end
	if((g0.CmnWin ==nil) or (g0.CmnWin[name] ==nil)) then
		return;
	end
	local lines	= GET_CHILD(frm, "lines", "ui::CGroupBox");
	for i = 1,#lstTxt do
		if(lstTxt[i] ~= g0.CmnWin[name].lstTxt[i]) then
			local gb	= lines:CreateOrGetControl("groupbox", "gb"..i, 1, i * 19 - 18, lines:GetWidth() - 24, 18);
			gb:SetSkinName("skin_white");
			gb:SetColorTone(g0.CmnWin[name].BackCol);
			gb:EnableHitTest(0);
			local rt	= gb:CreateOrGetControl("richtext", "rt"..i,2,1,gb:GetWidth()-4,16);
			rt = tolua.cast(rt, "ui::CRichText");	-- ui::CObject を ui::CRichTextにキャスト
			rt:SetFontName("white_14_ol");
			rt:EnableResizeByText(0);	-- CRichTextでないと使えない
			rt:SetTextFixWidth(0);		-- CRichTextでないと使えない
			rt:EnableSplitBySpace(0);	-- CRichTextでないと使えない
			rt:EnableHitTest(0);
			rt:SetText(lstTxt[i]);
			g0.CmnWin[name].lstTxt[i] = lstTxt[i];
		end
	end
	local lastIndex = #g0.CmnWin[name].lstTxt
	for i = #lstTxt + 1,lastIndex do
		if(i>g0.CmnWin[name].DefLine) then
			lines:RemoveChild("gb"..i);
		else
			local gb	= GET_CHILD(lines,	"gb"..i, "ui::CGroupBox");
			local rt	= GET_CHILD(gb,		"rt"..i, "ui::CRichText");
			rt:SetText("");
		end
		g0.CmnWin[name].lstTxt[i] = nil;
	end
	if(lastIndex>g0.CmnWin[name].DefLine) then
	end
end
