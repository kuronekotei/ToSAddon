--[[
	日本語
--]]


function TPNPCCHAT_ON_INIT(addon, frame)
	--	既存の「DIALOG_SHOW_DIALOG_TEXT」を置き換える(addon.ipf\dialog)
	--	既存の関数はとっておいて、あとで使う
	if(_G["TPNPCCHAT_OLD_DIALOG_SHOW_DIALOG_TEXT"]==nil) then
		--	待避する関数がすでにいたら、やらない　(2度置き換えると無限ループ)
		_G["TPNPCCHAT_OLD_DIALOG_SHOW_DIALOG_TEXT"] = DIALOG_SHOW_DIALOG_TEXT;
		_G["DIALOG_SHOW_DIALOG_TEXT"] = TPNPCCHAT_HOOK_DIALOG_SHOW_DIALOG_TEXT;
	end
end

--	再読込しても、この関数(の効果)は更新されない(DIALOG_SHOW_DIALOG_TEXTになってるため)
function TPNPCCHAT_HOOK_DIALOG_SHOW_DIALOG_TEXT(frame, text, titleName, voiceName)
	TPNPCCHAT_NEW_DIALOG_SHOW_DIALOG_TEXT(frame, text, titleName, voiceName);
	TPNPCCHAT_OLD_DIALOG_SHOW_DIALOG_TEXT(frame, text, titleName, voiceName);
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
