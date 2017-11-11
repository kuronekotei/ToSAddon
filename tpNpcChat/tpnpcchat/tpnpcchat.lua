--[[
	日本語
--]]

local acutil = require('acutil');

_G['TPNPCCHAT'] = _G['TPNPCCHAT'] or {};
local g1 = _G['TPNPCCHAT'];
g1.settingPath = g1.settingpath or "../addons/tpnpcchat/settings.json";
g1.settings = g1.settings or {};
local s1 = g1.settings;

ADDONS											= ADDONS or {};
ADDONS.torahamu									= ADDONS.torahamu or {};
ADDONS.torahamu.CHATEXTENDS						= ADDONS.torahamu.CHATEXTENDS or {};
ADDONS.torahamu.CHATEXTENDS.settings			= ADDONS.torahamu.CHATEXTENDS.settings or {};
ADDONS.torahamu.CHATEXTENDS.settings.BALLON_FLG	= ADDONS.torahamu.CHATEXTENDS.settings.BALLON_FLG or false;

function TPNPCCHAT_ON_INIT(addon, frame)
	--	既存の「DIALOG_SHOW_DIALOG_TEXT」を置き換える(addon.ipf\dialog)
	--	既存の関数はとっておいて、あとで使う
	if(g1.TPNPCCHAT_OLD_DIALOG_SHOW_DIALOG_TEXT==nil) then
		--	待避する関数がすでにいたら、やらない　(2度置き換えると無限ループ)
		g1.TPNPCCHAT_OLD_DIALOG_SHOW_DIALOG_TEXT = DIALOG_SHOW_DIALOG_TEXT;
		_G["DIALOG_SHOW_DIALOG_TEXT"] = TPNPCCHAT_HOOK_DIALOG_SHOW_DIALOG_TEXT;
	end
	--	既存の「NOTICE_ON_MSG」を置き換える(addon.ipf\notice)
	if(g1.TPNPCCHAT_OLD_NOTICE_ON_MSG==nil) then
		--	待避する関数がすでにいたら、やらない　(2度置き換えると無限ループ)
		g1.TPNPCCHAT_OLD_NOTICE_ON_MSG = NOTICE_ON_MSG;
		_G["NOTICE_ON_MSG"] = TPNPCCHAT_HOOK_NOTICE_ON_MSG;
	end
	local f,m = pcall(g1.TPNPCCHAT_LOAD_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
	local f,m = pcall(g1.TPNPCCHAT_SAVE_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
--	addon:RegisterMsg("SOLD_ITEM_NOTICE", "TPNPCCHAT_SOLD_ITEM_NOTICE");
--	addon:RegisterMsg("RECEIVABLE_SILVER_NOTICE", "TPNPCCHAT_RECEIVABLE_SILVER_NOTICE");
end

--	再読込しても、この関数(の効果)は更新されない(DIALOG_SHOW_DIALOG_TEXTになってるため)
function TPNPCCHAT_HOOK_DIALOG_SHOW_DIALOG_TEXT(frame, text, titleName, voiceName)
	local f,m = pcall(g1.TPNPCCHAT_NEW_DIALOG_SHOW_DIALOG_TEXT,frame, text, titleName, voiceName);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
	g1.TPNPCCHAT_OLD_DIALOG_SHOW_DIALOG_TEXT(frame, text, titleName, voiceName);
end

function TPNPCCHAT_HOOK_NOTICE_ON_MSG(frame, msg, argStr, argNum)
	local f,m = pcall(g1.TPNPCCHAT_NEW_NOTICE_ON_MSG,frame, msg, argStr, argNum);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
	g1.TPNPCCHAT_OLD_NOTICE_ON_MSG(frame, msg, argStr, argNum);
end

function TPNPCCHAT_SOLD_ITEM_NOTICE(frame, msg, argStr, argNum)	
	local f,m = pcall(g1.TPNPCCHAT_SOLD_ITEM_NOTICE,frame, msg, argStr, argNum);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end

function TPNPCCHAT_RECEIVABLE_SILVER_NOTICE(frame, msg, argStr, argNum)	
	local f,m = pcall(g1.TPNPCCHAT_RECEIVABLE_SILVER_NOTICE,frame, msg, argStr, argNum);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end

function g1.TPNPCCHAT_LOAD_SETTING()
	local t, err = acutil.loadJSON(g1.settingPath, g1.settings);
	-- 	値の存在確保と初期値設定
	s1.isDebug   = s1.isDebug   or false;
	s1.isShowExc = s1.isShowExc or true; -- NOTICE_Dm_!
	s1.isShowScr = s1.isShowScr or true; -- NOTICE_Dm_scroll
	s1.isShowClr = s1.isShowClr or true; -- NOTICE_Dm_Clear
	s1.isShowGet = s1.isShowGet or true; -- NOTICE_Dm_GetItem
	s1.isShowRes = s1.isShowRes or true; -- NOTICE_Dm_ResBuff
	s1.isShowUse = s1.isShowUse or true; -- NOTICE_Dm_UsePotion
	s1.isShowCmp = s1.isShowCmp or true; -- NOTICE_Dm_quest_complete
	s1.isShowGlb = s1.isShowGlb or true; -- NOTICE_Dm_Global_Shout
	s1.isShowLvl = s1.isShowLvl or true; -- NOTICE_Dm_levelup_base NOTICE_Dm_levelup_skill
	s1.isShowFsh = s1.isShowFsh or true; -- NOTICE_Dm_Fishing
end

function g1.TPNPCCHAT_SAVE_SETTING()
	local filep = io.open(g1.settingPath,"w+");
	if filep then
		filep:write("{\n");
		filep:write("\t\"isDebug\":"		.. ((s1.isDebug			and "true") or "false")	.."\n"	);
		filep:write("\t\"isShowExc\":"		.. ((s1.isShowExc		and "true") or "false")	.."\n"	);
		filep:write("\t\"isShowScr\":"		.. ((s1.isShowScr		and "true") or "false")	.."\n"	);
		filep:write("\t\"isShowClr\":"		.. ((s1.isShowClr		and "true") or "false")	.."\n"	);
		filep:write("\t\"isShowGet\":"		.. ((s1.isShowGet		and "true") or "false")	.."\n"	);
		filep:write("\t\"isShowRes\":"		.. ((s1.isShowRes		and "true") or "false")	.."\n"	);
		filep:write("\t\"isShowUse\":"		.. ((s1.isShowUse		and "true") or "false")	.."\n"	);
		filep:write("\t\"isShowCmp\":"		.. ((s1.isShowCmp		and "true") or "false")	.."\n"	);
		filep:write("\t\"isShowGlb\":"		.. ((s1.isShowGlb		and "true") or "false")	.."\n"	);
		filep:write("\t\"isShowLvl\":"		.. ((s1.isShowLvl		and "true") or "false")	.."\n"	);
		filep:write("\t\"isShowFsh\":"		.. ((s1.isShowFsh		and "true") or "false")	.."\n"	);
		filep:write("}\n");
		filep:close();
	end
end


function g1.TPNPCCHAT_NEW_DIALOG_SHOW_DIALOG_TEXT(frame, text, titleName, voiceName)
	if (titleName ==nil) then
		titleName="";
	end
	--	DIALOGで表示する内容をシステムチャットに流し込む
	local dispMode	= (ADDONS.torahamu.CHATEXTENDS.settings.BALLON_FLG and 0 or 1);
	if (dispMode ==1) then
		--	簡易チャット(背景が黒い)
		CHAT_SYSTEM("<<{#FF8040}"..titleName.."{/}>>{nl}{#FFFFA0}"..text.."{/}{nl} ");
	else
		--	吹出チャット(背景が白い)
		CHAT_SYSTEM("<<{#FF2000}"..titleName.."{/}>>{nl}{#000020}"..text.."{/}{nl} ");
	end
end

function g1.TPNPCCHAT_NEW_NOTICE_ON_MSG(frame, msg, argStr, argNum)
	local fontSize = GET_CHAT_FONT_SIZE();
	local dispMode	= (ADDONS.torahamu.CHATEXTENDS.settings.BALLON_FLG and 0 or 1);
	if (msg ==nil) or (argStr  ==nil) or (fontSize  ==nil) then
		return;
	end

	local iconSize = math.floor(fontSize *1.6);	--	設定されたフォントの1.6倍のサイズにする　(整数とする)

	if (msg == "NOTICE_Dm_!") and s1.isShowExc then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#FF2000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#E00000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_scroll") and s1.isShowScr then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#E04000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#602000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_Clear") and s1.isShowClr then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#00A0FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#0000FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_GetItem") and s1.isShowGet then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#00A0FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#0000FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_levelup_base") and s1.isShowLvl then
		CHAT_SYSTEM("{img "..msg.." "       ..iconSize.." "..iconSize.."}{/}{/}{s"..fontSize.."}" .. argStr.."{nl}");
	elseif (msg == "NOTICE_Dm_levelup_skill") and s1.isShowLvl then
		CHAT_SYSTEM("{img "..msg.." "      ..iconSize.." "..iconSize.."}{/}{/}{s"..fontSize.."}" .. argStr.."{nl}");
	elseif (msg == "NOTICE_Dm_ResBuff") and s1.isShowRes then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#FF2000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#E00000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_UsePotion") and s1.isShowUse then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#FF2000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#E00000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_quest_complete") and s1.isShowCmp then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#00A0FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#0000FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_Fishing") and s1.isShowFsh then
		if (dispMode ==1) then
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#00A0FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#0000FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_Global_Shout") and s1.isShowGlb then
		if (dispMode ==1) then
			CHAT_SYSTEM("{#FF2000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		else
			CHAT_SYSTEM("{#E00000}{s"..fontSize.."}" .. argStr.."{/}{/}{nl}");
		end
	elseif (msg == "NOTICE_Dm_GuildQuestSuccess") then
		--何もしない
	elseif s1.isDebug then
		CHAT_SYSTEM("{#FF2000}"..msg.."{nl}".."{img "..msg.." " ..iconSize.." "..iconSize.."}{/}{/}{#0000FF}{s"..fontSize.."}" .. argStr.."{/}{/}{nl} ");
	end
end

--function g1.TPNPCCHAT_SOLD_ITEM_NOTICE(frame, msg, argStr, argNum)	
--	local fontSize = GET_CHAT_FONT_SIZE();
--	local dispMode	= (ADDONS.torahamu.CHATEXTENDS.settings.BALLON_FLG and 0 or 1);
--	local argList = StringSplit(argStr, '/');
--	if #argList ~= 3 then
--		frame:ShowWindow(0);
--		return;
--	end
--	local askMsg = ScpArgMsg("SoldItemNotice", "ITEM", argList[2], "COUNT", argList[3]);
--	if (dispMode ==1) then
--		--	簡易チャット(背景が黒い)
--		CHAT_SYSTEM("{#E04000}{s"..fontSize.."}" .. askMsg.."{/}{/}{nl}");
--	else
--		--	吹出チャット(背景が白い)
--		CHAT_SYSTEM("{#602000}{s"..fontSize.."}" .. askMsg.."{/}{/}{nl}");
--	end
--
--end
--function ON_SOLD_ITEM_NOTICE(frame, msg, argStr, argNum)	
--end
--
--function g1.TPNPCCHAT_RECEIVABLE_SILVER_NOTICE(frame, msg, argStr, argNum)	
--	local fontSize = GET_CHAT_FONT_SIZE();
--	local dispMode	= (ADDONS.torahamu.CHATEXTENDS.settings.BALLON_FLG and 0 or 1);
--	
--	local askMsg = "受取可能な シルバーがあります。{nl}[マーケット受取箱]で受け取れます。";
--	if (dispMode ==1) then
--		--	簡易チャット(背景が黒い)
--		local askMsg2 = askMsg:gsub("{#000000}","{#E04000}");
--		CHAT_SYSTEM("{#E04000}{s"..fontSize.."}" .. askMsg2.."{/}{/}{nl}");
--	else
--		--	吹出チャット(背景が白い)
--		CHAT_SYSTEM("{#602000}{s"..fontSize.."}" .. askMsg.."{/}{/}{nl}");
--	end
--
--end
--function ON_RECEIVABLE_SILVER_NOTICE(frame, msg, argStr, argNum)
--end
