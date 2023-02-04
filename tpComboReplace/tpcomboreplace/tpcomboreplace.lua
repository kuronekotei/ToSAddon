--[[
	日本語
--]]

local function get_key_image_name(key_id)
	CHAT_SYSTEM("get_key_image_name "..key_id);
	config.InitHotKeyByCurrentUIMode('Battle')
	
	local key_idx = config.GetHotKeyElementIndex('ID', key_id)
	local hotkey_str = config.GetHotKeyElementAttributeForConfig(key_idx, 'Key')

	local use_shift = config.GetHotKeyElementAttributeForConfig(key_idx, 'UseShift')
	local use_ctrl = config.GetHotKeyElementAttributeForConfig(key_idx, 'UseCtrl')
	local use_alt = config.GetHotKeyElementAttributeForConfig(key_idx, 'UseAlt')
	local custom_txt = nil

	if string.find(hotkey_str, 'NUMPAD') ~= nil then
        local find_start, find_end = string.find(hotkey_str, 'NUMPAD')
        hotkey_str = string.sub(hotkey_str, find_end + 1, string.len(hotkey_str))
	end
	
	local img_name = 'key_' .. hotkey_str
	if IsJoyStickMode() == 1 then
		if key_id == 'NormalAttack' then
			img_name = 'x_button'
		elseif key_id == 'Jump' then
			img_name = 'a_button'
		elseif key_id == 'MoveLeft' then
			img_name = 'key_LEFT'
		elseif key_id == 'MoveUp' then
			img_name = 'key_UP'
		elseif key_id == 'MoveRight' then
			img_name = 'key_RIGHT'
		elseif key_id == 'MoveDown' then
			img_name = 'key_DOWN'
		end
		use_shift = 'NO'
		use_ctrl = 'NO'
		use_alt = 'NO'
	end
	
	--強制置換
	if key_id == 'MoveLeft' then
		img_name = 'key_LEFT'
	elseif key_id == 'MoveUp' then
		img_name = 'key_UP'
	elseif key_id == 'MoveRight' then
		img_name = 'key_RIGHT'
	elseif key_id == 'MoveDown' then
		img_name = 'key_DOWN'
	end

	if ui.IsImageExist(img_name) == false then
		img_name = 'key_empty'
		custom_txt = hotkey_str
	end

	return img_name, use_shift, use_ctrl, use_alt, custom_txt
end

function ON_COMBOINPUT_START(frame, msg, arg_str, arg_num)
	CHAT_SYSTEM("ON_COMBOINPUT_START");

	if arg_str == nil then return end

	local key_list = SCR_STRING_CUT(arg_str, ';')
	if #key_list <= 0 then return end

	frame:SetUserValue('COMBO_SIZE', #key_list)

	local bg = GET_CHILD_RECURSIVELY(frame, 'bg')
	bg:RemoveAllChild()

	for i = 1, #key_list do
		local ctrl = bg:CreateOrGetControlSet('comboinput_key', 'KEY_' .. i, (i - 1) * 80, 0)
		if ctrl ~= nil then
			local key_id = key_list[i]
			local img_name, use_shift, use_ctrl, use_alt, custom_txt = get_key_image_name(key_id)

			local combi_cnt = 0
			if use_shift == 'YES' then
				local img_shift = ctrl:CreateControl('picture', 'img_shift', 30, 30, ui.LEFT, ui.BOTTOM, 0, 0, 0, 0)
				tolua.cast(img_shift, 'ui::CPicture')
				img_shift:SetEnableStretch(1)
				img_shift:SetImage('SHIFT')
				combi_cnt = 1
			end

			if use_ctrl == 'YES' then
				local horz = ui.LEFT
				if combi_cnt > 0 then
					horz = ui.RIGHT
				end
				local img_ctrl = ctrl:CreateControl('picture', 'img_ctrl', 30, 30, horz, ui.BOTTOM, 0, 0, 0, 0)
				tolua.cast(img_ctrl, 'ui::CPicture')
				img_ctrl:SetEnableStretch(1)
				img_ctrl:SetImage('ctrl')
				combi_cnt = combi_cnt + 1
			end

			if use_alt == 'YES' then
				local horz = ui.LEFT
				if combi_cnt > 0 then
					horz = ui.RIGHT
				end
				local img_alt = ctrl:CreateControl('picture', 'img_alt', 30, 30, horz, ui.BOTTOM, 0, 0, 0, 0)
				tolua.cast(img_alt, 'ui::CPicture')
				img_alt:SetEnableStretch(1)
				img_alt:SetImage('alt')
			end

			local keycap = GET_CHILD_RECURSIVELY(ctrl, 'keycap')
			keycap:SetImage(img_name)

			if custom_txt ~= nil then
				local txt = ctrl:CreateControl('richtext', 'key_name', 50, 30, ui.CENTER_HORZ, ui.CENTER_VERT, 0, -8, 0, 0)
				txt:AdjustFontSizeByWidth(50)
				txt:SetText('{@st45}{s16}' .. custom_txt .. '{/}{/}')
			end
		end
	end

	bg:Resize(#key_list * 64 + (#key_list - 1) * 16, 64)

	local combo_timer = GET_CHILD_RECURSIVELY(frame, 'combo_timer')
	combo_timer:StopUpdateScript('COMBOINPUT_TIME_UPDATE')
	combo_timer:RunUpdateScript('COMBOINPUT_TIME_UPDATE')
	combo_timer:SetUserValue('COMBO_START_TIME', tostring(imcTime.GetAppTimeMS()))
	combo_timer:SetUserValue('COMBO_LIMIT_TIME', tostring(arg_num))

	ui.OpenFrame('comboinput')
end
