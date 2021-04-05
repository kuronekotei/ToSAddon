--[[__tputil_MBox.lua
	日本語
	関数群を保存している
--]]
local g0 = GetTpUtil();

g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "__tputil_MBox";

local gMBx = g0.MBox;

if(gMBx.MsgBox==nil)then
	gMBx.MsgBox = ui.MsgBox;
end
function ui.MsgBox(msgStr, yesScp,noScp)
	gMBx.LstMsg = gMBx.LstMsg or {};

	if (yesScp == nil) or (yesScp == "") or (yesScp == "None") then
		local msgbox = gMBx.MsgBox(msgStr, yesScp, noScp);
		return msgbox;
	end
	if (yesScp:match("^.+%(.*%)$")==nil) then
		yesScp = yesScp .."()"
	end
	gMBx.LastId = (gMBx.LastId or 0)+1;
	local msgbox = gMBx.MsgBox(msgStr, "gMBx_YesScp("..gMBx.LastId..")","gMBx_NoScp("..gMBx.LastId..")");
	if(msgbox ~= nil and yesScp ~= nil and yesScp ~= "None") then
		local msgbox2 = tolua.cast(msgbox, 'ui::CMessageBoxFrame');
		local msgid = msgbox2:GetIndex();
		gMBx.LstMsg[msgid] = {};
		gMBx.LstMsg[msgid].MsgId	= msgid;
		gMBx.LstMsg[msgid].LastId	= gMBx.LastId;
		gMBx.LstMsg[msgid].MsgStr	= msgStr;
		gMBx.LstMsg[msgid].YesScp	= yesScp;
		gMBx.LstMsg[msgid].NoScp	= noScp;
	end
	return msgbox;
end
function gMBx_YesScp(idx)
	g0.PCL(gMBx.YesScp,idx);
end
function gMBx.YesScp(idx)
	for k, v in pairs(gMBx.LstMsg) do
		if(v.LastId==idx)then
			if(v.YesScp ~= nil and v.YesScp ~= "None")then
				--CHAT_SYSTEM(v.YesScp);
				load(v.YesScp)();
			end
			ui.CloseMsgBoxByIndex(v.MsgId);
			gMBx.LstMsg[k] = nil;
			return;
		end
	end
end
function gMBx_NoScp(idx)
	g0.PCL(gMBx.NoScp,idx);
end
function gMBx.NoScp(idx)
	for k, v in pairs(gMBx.LstMsg) do
		if(v.LastId==idx)then
			if(v.NoScp ~= nil and v.NoScp ~= "None")then
				--CHAT_SYSTEM(v.NoScp);
				load(v.NoScp)();
			end
			ui.CloseMsgBoxByIndex(v.MsgId);
			gMBx.LstMsg[k] = nil;
			return;
		end
	end
end

function gMBx.Init()
	gMBx.LstMsg = {};
	gMBx.LastId = 0;
end
function gMBx.BtnOK()
	g0.PCL(gMBx.BtnOK_);
end
function gMBx.CheckMsg()
	return (tbn(gMBx.LstMsg)>0);
end

function gMBx.BtnOK_()
	local tmplst = {};
	for k,v in pairs(gMBx.LstMsg) do	--	キーだけで配列化
		tmplst[#tmplst + 1] = k;
	end
	table.sort(tmplst, function(a,b) return a>b end)	--	キーだけで逆順ソート
	for i, k in ipairs(tmplst) do-- キー順で
		CHAT_SYSTEM("BtnOK "..gMBx.LstMsg[k].YesScp.."");
		if(gMBx.LstMsg[k].YesScp ~= nil and gMBx.LstMsg[k].YesScp ~= "None")then
			load(gMBx.LstMsg[k].YesScp)();
		end
		ui.CloseMsgBoxByIndex(gMBx.LstMsg[k].MsgId);
		gMBx.LstMsg[k] = nil;
		return;
	end
end
