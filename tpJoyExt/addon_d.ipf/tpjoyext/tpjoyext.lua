function TPJOYEXT_ON_INIT(addon, frame)
end

function JOYSTICK_QUICKSLOT_EXECUTE(slotIndex)
	local quickFrame = ui.GetFrame('joystickquickslot')

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
	
	if input_L1 == 1 and input_R1 == 1 then
		--CHAT_SYSTEM("ON_L1R1");
		if	slotIndex == 2	or slotIndex == 14 then
			slotIndex = 10
		elseif	slotIndex == 0	or slotIndex == 12 then
			slotIndex = 8
		elseif	slotIndex == 1	or slotIndex == 13 then
			slotIndex = 9
		elseif	slotIndex == 3	or slotIndex == 15 then
			slotIndex = 11
		end
	elseif input_L1 == 1 and input_L2 == 1 then
		--CHAT_SYSTEM("ON_L1L2");
		if	slotIndex == 2	or slotIndex == 6 then
			slotIndex = 22
		elseif	slotIndex == 0	or slotIndex == 4 then
			slotIndex = 20
		elseif	slotIndex == 1	or slotIndex == 5 then
			slotIndex = 21
		elseif	slotIndex == 3	or slotIndex == 7 then
			slotIndex = 23
		end
	elseif input_L2 == 1 and input_R2 == 1 then
		--CHAT_SYSTEM("ON_L2R2");
		if	slotIndex == 6	or slotIndex == 18 then
			slotIndex = 30
		elseif	slotIndex == 4	or slotIndex == 16 then
			slotIndex = 28
		elseif	slotIndex == 5	or slotIndex == 17 then
			slotIndex = 29
		elseif	slotIndex == 7	or slotIndex == 19 then
			slotIndex = 31
		end
	elseif input_R1 == 1 and input_R2 == 1 then
		--CHAT_SYSTEM("ON_R1R2");
		if	slotIndex == 14	or slotIndex == 18 then
			slotIndex = 34
		elseif	slotIndex == 12	or slotIndex == 16 then
			slotIndex = 32
		elseif	slotIndex == 13	or slotIndex == 17 then
			slotIndex = 33
		elseif	slotIndex == 15	or slotIndex == 19 then
			slotIndex = 35
		end

	end
	 
	local quickslotFrame = ui.GetFrame('joystickquickslot');
	local slot = quickslotFrame:GetChildRecursively("slot"..slotIndex+1);
	QUICKSLOTNEXPBAR_SLOT_USE(quickSlotFrame, slot, 'None', 0);	
end

function UPDATE_JOYSTICK_INPUT(frame)

	if IsJoyStickMode() == 0 then
		return;
	end

	local input_L1 = joystick.IsKeyPressed("JOY_BTN_5")
	local input_L2 = joystick.IsKeyPressed("JOY_BTN_7")
	local input_R1 = joystick.IsKeyPressed("JOY_BTN_6")
	local input_R2 = joystick.IsKeyPressed("JOY_BTN_8")

	if joystick.IsKeyPressed("JOY_UP") == 1 and joystick.IsKeyPressed("JOY_L1L2") == 1	then
		ON_RIDING_VEHICLE(1)
	end

	if joystick.IsKeyPressed("JOY_DOWN") == 1 and joystick.IsKeyPressed("JOY_L1L2") == 1  then
		ON_RIDING_VEHICLE(0)
	end

	if joystick.IsKeyPressed("JOY_LEFT") == 1 and joystick.IsKeyPressed("JOY_L1L2") == 1  then
		COMPANION_INTERACTION(2)
	end

	if joystick.IsKeyPressed("JOY_RIGHT") == 1 and joystick.IsKeyPressed("JOY_L1L2") == 1  then
		COMPANION_INTERACTION(1)
	end

	local gboxL1 = frame:GetChildRecursively("L1_slot_Set1");
	local gboxR1 = frame:GetChildRecursively("R1_slot_Set1");
	local gboxL2 = frame:GetChildRecursively("L2_slot_Set1");
	local gboxR2 = frame:GetChildRecursively("R2_slot_Set1");
	local gboxL1L2 = frame:GetChildRecursively("L1_slot_Set2");
	local gboxR1R2 = frame:GetChildRecursively("R1_slot_Set2");
	local gboxL1R1 = frame:GetChildRecursively("L1R1_slot_Set1");
	local gboxL2R2 = frame:GetChildRecursively("L1R1_slot_Set2");

	if input_L1 == 1 and input_R1 == 0 and input_L2 == 0 then
		gboxL1:SetSkinName(padslot_onskin);
	else
		gboxL1:SetSkinName(padslot_offskin);
	end
	if input_R1 == 1 and input_L1 == 0 and input_R2 == 0 then
		gboxR1:SetSkinName(padslot_onskin);
	else
		gboxR1:SetSkinName(padslot_offskin);
	end
	if input_L2 == 1 and input_R2 == 0 and input_L1 == 0 then
		gboxL2:SetSkinName(padslot_onskin);
	else
		gboxL2:SetSkinName(padslot_offskin);
	end
	if input_R2 == 1 and input_L2 == 0 and input_R1 == 0 then
		gboxR2:SetSkinName(padslot_onskin);
	else
		gboxR2:SetSkinName(padslot_offskin);
	end
	if input_L1 == 1 and input_L2 == 1 and input_R1 == 0 and input_R2 == 0 then
		gboxL1L2:SetSkinName(padslot_onskin);
	else
		gboxL1L2:SetSkinName(padslot_offskin);
	end
	if input_R1 == 1 and input_R2 == 1 and input_L1 == 0 and input_L2 == 0 then
		gboxR1R2:SetSkinName(padslot_onskin);
	else
		gboxR1R2:SetSkinName(padslot_offskin);
	end
	if input_L1 == 1 and input_R1 == 1 and input_L2 == 0 and input_R2 == 0 then
		gboxL1R1:SetSkinName(padslot_onskin);
	else
		gboxL1R1:SetSkinName(padslot_offskin);
	end
	if input_L2 == 1 and input_R2 == 1 and input_L1 == 0 and input_R1 == 0 then
		gboxL2R2:SetSkinName(padslot_onskin);
	else
		gboxL2R2:SetSkinName(padslot_offskin);
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




