--[[	tpjoyext
日本語
--]]
local g0 = GetTpUtil();
local gInv = g0.Inv;
local gMBx = g0.MBox;

local _NAME_ = 'TPJOYEXT';
_G[_NAME_] = _G[_NAME_] or {};
local g7 = _G[_NAME_];
g7.StgPath = g7.StgPath or "../addons/tpjoyext/stg_tpjoyext.lua";

g7.Stg = g7.Stg or {
	RideOverRide		= true,
	MsgBoxOK1			= false,
	MsgBoxOK2			= false,
	AutoDisOma			= false,
};
local s7 = g7.Stg;
g7.StgTbl = g7.StgTbl or {
	{name="_",					comm="【コントロールの設定】"},
	{name="RideOverRide",		comm="true:L1L2のコンパニオン乗り降りをL1L2R1R2＋キーに変える　false:そのまま"},
	{name="_",					comm="　(キー2(△Y等)で乗る　キー3(×A等)で降りる)"},
	{name="MsgBoxOK1",			comm="true:一部メッセージボックスをR1R2＋キー4(〇Bに変える)　false:機能しない"},
	{name="MsgBoxOK2",			comm="true:一部メッセージボックスをL1L2R1R2＋キー4(〇Bに変える)　false:機能しない"},
	{name="_",					comm="　OK1とOK2はOK2が優先適用"},
	{name="_",					comm=""},
	{name="_",					comm="【別機能】"},
	{name="AutoDisOma",			comm="ディスペラーかお守りがあれば自動的に有効にする　ディスペラー優先　(いずれ消す)"},
}
local StgTbl = g7.StgTbl;

function TPJOYEXT_ON_INIT(adn, frame)
	adn:RegisterMsg("TPUTIL_START", "TPJOYEXT_GAME_START");
	g0.PCL(g0.LoadStg,_NAME_,s7.StgPath,s7);
	g0.PCL(g0.SaveStg,_NAME_,s7.StgPath,s7,StgTbl);
end

function TPJOYEXT_GAME_START(frame)
	local f,m = pcall(g7.TPJOYEXT_AUTOEXE);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end



function JOYSTICK_QUICKSLOT_EXECUTE(slotIndex)
	local quickFrame = ui.GetFrame('joystickquickslot')
	if quickFrame ~= nil and quickFrame:IsVisible() == 0 then
		local monsterquickslot = ui.GetFrame('monsterquickslot');
		if monsterquickslot ~= nil and monsterquickslot:IsVisible() == 1 then
			quickFrame = monsterquickslot;
		end
	end

	GET_CHILD_RECURSIVELY(quickFrame,'Set1','ui::CGroupBox'):ShowWindow(1);
	GET_CHILD_RECURSIVELY(quickFrame,'Set2','ui::CGroupBox'):ShowWindow(0);
	GET_CHILD_RECURSIVELY(quickFrame,'Set3','ui::CGroupBox'):ShowWindow(1);

	local input_L1	= joystick.IsKeyPressed("JOY_BTN_5");
	local input_R1	= joystick.IsKeyPressed("JOY_BTN_6");
	local input_L2	= joystick.IsKeyPressed("JOY_BTN_7");
	local input_R2	= joystick.IsKeyPressed("JOY_BTN_8");

	local joystickRestFrame = ui.GetFrame('joystickrestquickslot')
	if joystickRestFrame:IsVisible() == 1 then
		REST_JOYSTICK_SLOT_USE(joystickRestFrame, slotIndex);
		return;
	end

	local fourkey=slotIndex % 4;
	local offset=slotIndex - fourkey;
	if (input_L1 == 1) and (input_R1 == 1) and (input_L1 == 1) and (input_L2 == 1) then	-- L1R1L2R2
		--CHAT_SYSTEM("ON_L1R1");
		if	(fourkey == 2) then	-- △
			if (s7.RideOverRide) then
				ON_RIDING_VEHICLE(1);
			end
		elseif(fourkey == 0) then	-- □
		elseif(fourkey == 1) then	-- ×
			if (s7.RideOverRide) then
				ON_RIDING_VEHICLE(0);
			end
		elseif(fourkey == 3) then	-- 〇
		end
		return;
	end

	if s7.MsgBoxOK2 and input_L1 == 1 and input_L2 == 1 and input_R1 == 1 and input_R2 == 1 and fourkey == 3 then	-- R1R2〇
		if gMBx.CheckMsg() then	-- R1R2〇
			gMBx.BtnOK();
			return;
		end
	elseif s7.MsgBoxOK1 and input_L1 == 0 and input_L2 == 0 and input_R1 == 1 and input_R2 == 1 and fourkey == 3 then	-- R1R2〇
		if gMBx.CheckMsg() then	-- R1R2〇
			gMBx.BtnOK();
			return;
		end
	end

	if input_L1 == 1 and input_L2 == 0 and input_R1 == 1 and input_R2 == 0 then	-- L1R1
		offset = 8;
	end
	if input_L1 == 1 and input_L2 == 1 and input_R1 == 0 and input_R2 == 0 then	-- L1L2
		offset = 20;
	end
	if input_L1 == 0 and input_L2 == 1 and input_R1 == 1 and input_R2 == 0 then	-- L2R1
		offset = 20+4;
	end
	if input_L1 == 0 and input_L2 == 1 and input_R1 == 0 and input_R2 == 1 then	-- L2R2
		offset = 20+8;
	end
	if input_L1 == 0 and input_L2 == 0 and input_R1 == 1 and input_R2 == 1 then	-- R1R2
		offset = 20+12;
	end
	if input_L1 == 1 and input_L2 == 0 and input_R1 == 0 and input_R2 == 1 then	-- L1R2
		offset = 20+16;
	end

	slotIndex = offset+fourkey;

	local slot = quickFrame:GetChildRecursively("slot" .. slotIndex + 1);


	QUICKSLOTNEXPBAR_SLOT_USE(quickFrame, slot, 'None', 0);

end

function UPDATE_JOYSTICK_INPUT(frame)

	if IsJoyStickMode() == 0 then
		return;
	end

	local input_L1 = joystick.IsKeyPressed("JOY_BTN_5");
	local input_L2 = joystick.IsKeyPressed("JOY_BTN_7");
	local input_R1 = joystick.IsKeyPressed("JOY_BTN_6");
	local input_R2 = joystick.IsKeyPressed("JOY_BTN_8");

	if(s7.RideOverRide ~= true) then
		if joystick.IsKeyPressed("JOY_UP") == 1 and joystick.IsKeyPressed("JOY_L1L2") == 1	then
			ON_RIDING_VEHICLE(1)
		end

		if joystick.IsKeyPressed("JOY_DOWN") == 1 and joystick.IsKeyPressed("JOY_L1L2") == 1  then
			ON_RIDING_VEHICLE(0)
		end
	end

	local gboxL1 = frame:GetChildRecursively("L1_slot_Set1");
	local gboxR1 = frame:GetChildRecursively("R1_slot_Set1");
	local gboxL2 = frame:GetChildRecursively("L2_slot_Set1");
	local gboxR2 = frame:GetChildRecursively("R2_slot_Set1");
	local gboxL1L2 = frame:GetChildRecursively("L1L2_slot_Set2");
	local gboxL2R1 = frame:GetChildRecursively("L2R1_slot_Set2");
	local gboxL2R2 = frame:GetChildRecursively("L2R2_slot_Set2");
	local gboxL1R2 = frame:GetChildRecursively("L1R2_slot_Set2");
	local gboxR1R2 = frame:GetChildRecursively("R1R2_slot_Set2");
	local gboxL1R1 = frame:GetChildRecursively("L1R1_slot_Set1");

	if input_L1 == 1 and input_R1 == 0 and input_L2 == 0 and input_R2 == 0 then
		gboxL1:SetSkinName(padslot_onskin);
	else
		gboxL1:SetSkinName(padslot_offskin);
	end
	if input_L1 == 0 and input_R1 == 1 and input_L2 == 0 and input_R2 == 0 then
		gboxR1:SetSkinName(padslot_onskin);
	else
		gboxR1:SetSkinName(padslot_offskin);
	end
	if input_L1 == 0 and input_R2 == 0 and input_L2 == 1 and input_R1 == 0 then
		gboxL2:SetSkinName(padslot_onskin);
	else
		gboxL2:SetSkinName(padslot_offskin);
	end
	if input_L1 == 0 and input_L2 == 0 and input_R1 == 0 and input_R2 == 1 then
		gboxR2:SetSkinName(padslot_onskin);
	else
		gboxR2:SetSkinName(padslot_offskin);
	end
	if input_L1 == 0 and input_L2 == 1 and input_R1 == 1 and input_R2 == 0 then
		gboxL2R1:SetSkinName(padslot_onskin);
	else
		gboxL2R1:SetSkinName(padslot_offskin);
	end
	if input_L1 == 1 and input_R1 == 0 and input_L2 == 0 and input_R2 == 1 then
		gboxL1R2:SetSkinName(padslot_onskin);
	else
		gboxL1R2:SetSkinName(padslot_offskin);
	end
	if input_L2 == 1 and input_R2 == 1 and input_L1 == 0 and input_R1 == 0 then
		gboxL2R2:SetSkinName(padslot_onskin);
	else
		gboxL2R2:SetSkinName(padslot_offskin);
	end
	if input_L2 == 1 and input_R2 == 0 and input_L1 == 1 and input_R1 == 0 then
		gboxL1L2:SetSkinName(padslot_onskin);
	else
		gboxL1L2:SetSkinName(padslot_offskin);
	end
	if input_L2 == 0 and input_R2 == 0 and input_L1 == 1 and input_R1 == 1 then
		gboxL1R1:SetSkinName(padslot_onskin);
	else
		gboxL1R1:SetSkinName(padslot_offskin);
	end
	if input_R1 == 1 and input_R2 == 1 and input_L1 == 0 and input_L2 == 0 then
		gboxR1R2:SetSkinName(padslot_onskin);
	else
		gboxR1R2:SetSkinName(padslot_offskin);
	end
end

function JOYSTICK_QUICKSLOT_SWAP(test)
	QUICKSLOT_INIT();
end

function QUICKSLOT_INIT(frame, msg, argStr, argNum)
	local quickFrame = ui.GetFrame('joystickquickslot')
	local Set1 = GET_CHILD_RECURSIVELY(quickFrame,'Set1','ui::CGroupBox');
	local Set2 = GET_CHILD_RECURSIVELY(quickFrame,'Set2','ui::CGroupBox');
	local Set3 = GET_CHILD_RECURSIVELY(quickFrame,'Set3','ui::CGroupBox');
	Set1:ShowWindow(0);
	Set2:ShowWindow(0);
	Set3:ShowWindow(0);
	Set1:ShowWindow(1);
	Set3:ShowWindow(1);
end

function JOYSTICKQUICKSLOT_DRAW()
	QUICKSLOT_INIT();
	JOYSTICK_QUICKSLOT_UPDATE_ALL_SLOT();
	JOYSTICK_QUICKSLOT_REFRESH(40);
end

function CHECK_SLOT_ON_ACTIVEJOYSTICKSLOTSET(frame, slotNumber)
	return true;
end


function g7.TPJOYEXT_AUTOEXE()
	if(s7.AutoDisOma == true) then
		local itm = gInv.MyLst["Dispeller_1"];
		if(itm~=nil) then
			local invItem = GET_PC_ITEM_BY_GUID(itm.Guid);
			if(invItem~=nil) then
				INV_ICON_USE(invItem);
				return;
			end
		end
		local itm = gInv.MyLst["Bujeok_1"];
		if(itm~=nil) then
			local invItem = GET_PC_ITEM_BY_GUID(itm.Guid);
			if(invItem~=nil) then
				INV_ICON_USE(invItem);
				return;
			end
		end
	end
end
