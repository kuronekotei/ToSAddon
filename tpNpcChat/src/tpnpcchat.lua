--[[
	日本語
--]]

local acutil = require('acutil');

_G['TPNPCCHAT'] = _G['TPNPCCHAT'] or {};
local g1 = _G['TPNPCCHAT'];
g1.settingPath = g1.settingpath or "../addons/tpnpcchat/settings.json";
g1.settings = g1.settings or {};
local s1 = g1.settings;

function TPNPCCHAT_ON_INIT(addon, frame)
	--	既存の「DIALOG_SHOW_DIALOG_TEXT」を置き換える(addon.ipf\dialog)
	--	既存の関数はとっておいて、あとで使う
	if(_G["TPNPCCHAT_OLD_DIALOG_SHOW_DIALOG_TEXT"]==nil) then
		--	待避する関数がすでにいたら、やらない　(2度置き換えると無限ループ)
		_G["TPNPCCHAT_OLD_DIALOG_SHOW_DIALOG_TEXT"] = DIALOG_SHOW_DIALOG_TEXT;
		_G["DIALOG_SHOW_DIALOG_TEXT"] = TPNPCCHAT_HOOK_DIALOG_SHOW_DIALOG_TEXT;
	end
	--	既存の「NOTICE_ON_MSG」を置き換える(addon.ipf\notice)
	if(_G["TPNPCCHAT_OLD_NOTICE_ON_MSG"]==nil) then
		--	待避する関数がすでにいたら、やらない　(2度置き換えると無限ループ)
		_G["TPNPCCHAT_OLD_NOTICE_ON_MSG"] = NOTICE_ON_MSG;
		_G["NOTICE_ON_MSG"] = TPNPCCHAT_HOOK_NOTICE_ON_MSG;
	end
	TPNPCCHAT_LOAD_SETTING();
	TPNPCCHAT_SAVE_SETTING();
end

--	再読込しても、この関数(の効果)は更新されない(DIALOG_SHOW_DIALOG_TEXTになってるため)
function TPNPCCHAT_HOOK_DIALOG_SHOW_DIALOG_TEXT(frame, text, titleName, voiceName)
	local f,m = pcall(TPNPCCHAT_NEW_DIALOG_SHOW_DIALOG_TEXT,frame, text, titleName, voiceName);
	if f then
		-- あえて何も書かない
	else
		CHAT_SYSTEM(m);
	end
	TPNPCCHAT_OLD_DIALOG_SHOW_DIALOG_TEXT(frame, text, titleName, voiceName);
end

function TPNPCCHAT_HOOK_NOTICE_ON_MSG(frame, msg, argStr, argNum)
	local f,m = pcall(TPNPCCHAT_NEW_NOTICE_ON_MSG,frame, msg, argStr, argNum);
	if f then
		-- あえて何も書かない
	else
		CHAT_SYSTEM(m);
	end
	TPNPCCHAT_OLD_NOTICE_ON_MSG(frame, msg, argStr, argNum);
end

function TPNPCCHAT_LOAD_SETTING()
	local t, err = acutil.loadJSON(g1.settingPath, g1.settings);
	-- 	値の存在確保と初期値設定
	s1.isDebug   = s1.isDebug   or false;
	s1.isShowExc = s1.isShowExc or true; -- NOTICE_Dm_!
	s1.isShowScr = s1.isShowScr or true; -- NOTICE_Dm_scroll
	s1.isShowClr = s1.isShowClr or true; -- NOTICE_Dm_Clear
	s1.isShowGet = s1.isShowGet or true; -- NOTICE_Dm_GetItem
	s1.isShowRes = s1.isShowRes or true; -- NOTICE_Dm_ResBuff!
	s1.isShowUse = s1.isShowUse or true; -- NOTICE_Dm_UsePotion!
	s1.isShowCmp = s1.isShowCmp or true; -- NOTICE_Dm_quest_complete!
	s1.isShowGlb = s1.isShowGlb or true; -- NOTICE_Dm_UsePotion!
	s1.isShowLvl = s1.isShowLvl or true; -- NOTICE_Dm_levelup_base NOTICE_Dm_levelup_skill
end

function TPNPCCHAT_SAVE_SETTING()
	local t, err = acutil.saveJSON(g1.settingPath, g1.settings);
end


function TPNPCCHAT_NEW_DIALOG_SHOW_DIALOG_TEXT(frame, text, titleName, voiceName)
	--	DIALOGで表示する内容をシステムチャットに流し込む
	if (config.GetXMLConfig("ToggleTextChat")==1) then
		--	簡易チャット(背景が黒い)
		CHAT_SYSTEM("<<{#FF8040}"..titleName.."{/}>>{nl}{#FFFFA0}"..text.."{/}{nl} ");
	else
		--	吹出チャット(背景が白い)
		CHAT_SYSTEM("<<{#FF2000}"..titleName.."{/}>>{nl}{#000020}"..text.."{/}{nl} ");
	end
end

function TPNPCCHAT_NEW_NOTICE_ON_MSG(frame, msg, argStr, argNum)
	local fontSize = GET_CHAT_FONT_SIZE();
	local dispMode = config.GetXMLConfig("ToggleTextChat");
	if (msg ==nil) or (argStr  ==nil) or (fontSize  ==nil) then
		return;
	end

	local iconSize = math.floor(fontSize *1.6);	--	設定されたフォントの1.6倍のサイズにする　(整数とする)

	if (msg == "NOTICE_Dm_!") and s1.isShowExc then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img NOTICE_Dm_! "              ..iconSize.." "..iconSize.."}{/}{/}{#FF2000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img NOTICE_Dm_! "              ..iconSize.." "..iconSize.."}{/}{/}{#E00000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_scroll") and s1.isShowScr then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img NOTICE_Dm_scroll "         ..iconSize.." "..iconSize.."}{/}{/}{#E04000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img NOTICE_Dm_scroll "         ..iconSize.." "..iconSize.."}{/}{/}{#602000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_Clear") and s1.isShowClr then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img NOTICE_Dm_Clear "          ..iconSize.." "..iconSize.."}{/}{/}{#00A0FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img NOTICE_Dm_Clear "          ..iconSize.." "..iconSize.."}{/}{/}{#0000FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_GetItem") and s1.isShowGet then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img NOTICE_Dm_GetItem "        ..iconSize.." "..iconSize.."}{/}{/}{#00A0FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img NOTICE_Dm_GetItem "        ..iconSize.." "..iconSize.."}{/}{/}{#0000FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_levelup_base") and s1.isShowLvl then
		CHAT_SYSTEM("{img NOTICE_Dm_levelup_base "       ..iconSize.." "..iconSize.."}{/}{/}{s"..fontSize.."}" .. argStr.."{nl}");
	elseif (msg == "NOTICE_Dm_levelup_skill") and s1.isShowLvl then
		CHAT_SYSTEM("{img NOTICE_Dm_levelup_skill "      ..iconSize.." "..iconSize.."}{/}{/}{s"..fontSize.."}" .. argStr.."{nl}");
	elseif (msg == "NOTICE_Dm_ResBuff") and s1.isShowRes then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img NOTICE_Dm_ResBuff! "       ..iconSize.." "..iconSize.."}{/}{/}{#FF2000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img NOTICE_Dm_ResBuff! "       ..iconSize.." "..iconSize.."}{/}{/}{#E00000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_UsePotion") and s1.isShowUse then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img NOTICE_Dm_UsePotion! "     ..iconSize.." "..iconSize.."}{/}{/}{#FF2000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img NOTICE_Dm_UsePotion! "     ..iconSize.." "..iconSize.."}{/}{/}{#E00000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_quest_complete") and s1.isShowCmp then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img NOTICE_Dm_quest_complete " ..iconSize.." "..iconSize.."}{/}{/}{#00A0FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img NOTICE_Dm_quest_complete " ..iconSize.." "..iconSize.."}{/}{/}{#0000FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_Global_Shout") and s1.isShowGlb then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img NOTICE_Dm_Global_Shout! "  ..iconSize.." "..iconSize.."}{/}{/}{#FF2000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img NOTICE_Dm_Global_Shout! "  ..iconSize.." "..iconSize.."}{/}{/}{#E00000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_GuildQuestSuccess") then
		--何もしない
	elseif s1.isDebug then
		CHAT_SYSTEM("{#FF2000}"..msg.."{nl}"..argStr.."{/}{nl} ");
	end
end
