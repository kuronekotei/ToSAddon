--[[
	日本語
--]]

local acutil = require('acutil');

_G['TPWARP'] = _G['TPWARP'] or {};
local g9 = _G['TPWARP'];
g9.settings = g9.settings or {};
local s9 = g9.settings;
g9.settingPath = g9.settingpath or "../addons/tpwarp/stg_tpwarp.json";

function TPWARP_ON_INIT(addon, frame)
	--	CHAT_SYSTEM("TPWARP_ON_INIT");
	local f,m = pcall(g9.TPWARP_LOAD_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
	local f,m = pcall(g9.TPWARP_SAVE_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
	frame:SetEventScript(ui.LBUTTONUP, "TPWARP_LBUTTONUP");
	addon:RegisterMsg("GAME_START", "TPWARP_GAME_START");
	addon:RegisterMsg("PARTY_UPDATE", "TPWARP_PARTY_UPDATE");


	local f,m = pcall(g9.TPWARP_INIT,addon, frame);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end

function TPWARP_LBUTTONUP()
	local f,m = pcall(g9.TPWARP_LBUTTONUP);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end

function TPWARP_GAME_START(frame, control)
	local f,m = pcall(g9.TPWARP_MAPSTART);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end

function TPWARP_PARTY_UPDATE(frame, msg, str, num)
	local f,m = pcall(g9.TPWARP_PARTY_UPDATE, frame, msg, str, num);
	if f ~= true then
		CHAT_SYSTEM(m);
		return;
	end
end


function g9.TPWARP_LOAD_SETTING()
	local t, err = acutil.loadJSON(g9.settingPath);
	if t then
		s9 = acutil.mergeLeft(s9, t);
	end
	-- 	値の存在確保と初期値設定
	s9.isDebug			= ((type(s9.isDebug			) == "boolean")	and s9.isDebug			)or false;
	s9.posX				= ((type(s9.posX			) == "number")	and s9.posX				)or 400;
	s9.posY				= ((type(s9.posY			) == "number")	and s9.posY				)or 400;
	s9.useQuestWarp		= ((type(s9.useQuestWarp	) == "boolean")	and s9.useQuestWarp		)or (s9.useQuestWarp	==nil);
	s9.usePartyLink		= ((type(s9.usePartyLink	) == "boolean")	and s9.usePartyLink		)or (s9.usePartyLink	==nil);
	s9.LastPtId1		= ((type(s9.LastPtId1		) == "string")	and s9.LastPtId1		)or "";
	s9.LastPtNm1		= ((type(s9.LastPtNm1		) == "string")	and s9.LastPtNm1		)or "";
	s9.LastPtLd1		= ((type(s9.LastPtLd1		) == "string")	and s9.LastPtLd1		)or "";
	s9.LastPtId2		= ((type(s9.LastPtId2		) == "string")	and s9.LastPtId2		)or "";
	s9.LastPtNm2		= ((type(s9.LastPtNm2		) == "string")	and s9.LastPtNm2		)or "";
	s9.LastPtLd2		= ((type(s9.LastPtLd2		) == "string")	and s9.LastPtLd2		)or "";
	s9.LastPtId3		= ((type(s9.LastPtId3		) == "string")	and s9.LastPtId3		)or "";
	s9.LastPtNm3		= ((type(s9.LastPtNm3		) == "string")	and s9.LastPtNm3		)or "";
	s9.LastPtLd3		= ((type(s9.LastPtLd3		) == "string")	and s9.LastPtLd3		)or "";
	s9.LastPtId4		= ((type(s9.LastPtId4		) == "string")	and s9.LastPtId4		)or "";
	s9.LastPtNm4		= ((type(s9.LastPtNm4		) == "string")	and s9.LastPtNm4		)or "";
	s9.LastPtLd4		= ((type(s9.LastPtLd4		) == "string")	and s9.LastPtLd4		)or "";

end

function g9.TPWARP_SAVE_SETTING()
	local filep = io.open(g9.settingPath,"w+");
	if filep then
		filep:write("{\n");
		filep:write("\t\"isDebug\":"		.. ((s9.isDebug			and "true") or "false")	.."\n"	);
		filep:write(",\t\"posX\":"			.. (s9.posX							or 400)		.."\n"	);
		filep:write(",\t\"posY\":"			.. (s9.posY							or 400)		.."\n"	);
		filep:write(",\t\"useQuestWarp\":"	.. ((s9.useQuestWarp	and "true") or "false")	.."\n"	);
		filep:write(",\t\"usePartyLink\":"	.. ((s9.usePartyLink	and "true") or "false")	.."\n"	);
		filep:write(",\t\"LastPtId1\":\""	.. s9.LastPtId1		.."\"\n"	);
		filep:write(",\t\"LastPtNm1\":\""	.. s9.LastPtNm1		.."\"\n"	);
		filep:write(",\t\"LastPtLd1\":\""	.. s9.LastPtLd1		.."\"\n"	);
		filep:write(",\t\"LastPtId2\":\""	.. s9.LastPtId2		.."\"\n"	);
		filep:write(",\t\"LastPtNm2\":\""	.. s9.LastPtNm2		.."\"\n"	);
		filep:write(",\t\"LastPtLd2\":\""	.. s9.LastPtLd2		.."\"\n"	);
		filep:write(",\t\"LastPtId3\":\""	.. s9.LastPtId3		.."\"\n"	);
		filep:write(",\t\"LastPtNm3\":\""	.. s9.LastPtNm3		.."\"\n"	);
		filep:write(",\t\"LastPtLd3\":\""	.. s9.LastPtLd3		.."\"\n"	);
		filep:write(",\t\"LastPtId4\":\""	.. s9.LastPtId4		.."\"\n"	);
		filep:write(",\t\"LastPtNm4\":\""	.. s9.LastPtNm4		.."\"\n"	);
		filep:write(",\t\"LastPtLd4\":\""	.. s9.LastPtLd4		.."\"\n"	);
		filep:write("}\n");
		filep:close();
	end
end

function g9.TPWARP_INIT(addon, frame)
	frame:MoveFrame(s9.posX		,s9.posY	);
end

function g9.TPWARP_LBUTTONUP()
	local frm	= ui.GetFrame("tpwarp");
	if (frm == nil) then
		return;
	end
	s9.posX	= frm:GetX();
	s9.posY	= frm:GetY();
	local f,m = pcall(g9.TPWARP_SAVE_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end

function g9.TPWARP_MAPSTART()
	--	CHAT_SYSTEM("TPWARP_MAPSTART");
	local frm	= ui.GetFrame("tpwarp");
	if (frm == nil) then
		return;
	end
	g9.frH = frm:GetHeight();
	g9.qsH = 0;
	g9.ptH = 0;
	g9.GetQuest();
	if (s9.useQuestWarp	) then
		g9.SetQuestWarp();
	end
	if (s9.usePartyLink	) then
		g9.SetPartyLink();
	end
	frm:Resize(frm:GetWidth(),g9.frH + g9.qsH + g9.ptH );
end

function g9.GetQuest()
	local clsList, cnt = GetClassList("QuestProgressCheck");
	g9.qTable ={};
	local i = 0;
	for i = 0, cnt -1 do
		local questIES = GetClassByIndexFromList(clsList, i);
		local questAutoIES = GetClass('QuestProgressCheck_Auto',questIES.ClassName)
		if questIES.ClassName ~= "None" then
			local result = SCR_QUEST_CHECK_C(pc, questIES.ClassName);
			if ((result == 'POSSIBLE' and questIES.POSSI_WARP == 'YES') or (result == 'PROGRESS' and questIES.PROG_WARP == 'YES') or (result == 'SUCCESS' and questIES.SUCC_WARP == 'YES')) then
				local questnpc_state = GET_QUEST_NPC_STATE(questIES, result);
				local mapProp	= geMapTable.GetMapProp(questIES[questnpc_state..'Map']);
				local npcProp	= mapProp:GetNPCPropByDialog(questIES[questnpc_state..'NPC']);
				local qData ={};
				qData.mCName	= mapProp:GetClassName();
				local mClass	= GetClass("Map", qData.mCName);
				qData.mLv		= mClass.QuestLevel or 0;
				local mName		= mapProp:GetName();
				qData.mName		= dictionary.ReplaceDicIDInCompStr(mName);
				local nName		= npcProp:GetName();
				qData.nName		= dictionary.ReplaceDicIDInCompStr(nName);
				qData.nName		= qData.nName:gsub("{nl} *","");
				qData.qName		= questIES.Name;
				qData.qCName	= questIES.ClassName;
				qData.qCId		= questIES.ClassID;
				g9.qTable[#g9.qTable+1] = qData;
			end
		end
	end
	table.sort(g9.qTable,
		function(a,b)
			if (a==nil) then return true end
			if (b==nil) then return false end
			if (a.mLv<b.mLv) then return true end
			if (a.mLv>b.mLv) then return false end
			return (a.qCId<b.qCId);
		end
	);
end
function g9.SetQuestWarp()
	local frm	= ui.GetFrame("tpwarp");
	if (frm == nil) then
		return;
	end
	local qsCol = -1;
	local qsRow = 0;
	local i = 0;
	for i = 1, #g9.qTable do
		local qData = g9.qTable[i];
		qsCol = qsCol +1;
		if (qData.mLv ~= 0) and (qsRow == 0) then
			qsCol = 0;
			qsRow = 1;
		end
		if (qData.mLv ~= 0) and (qsRow > 0) and (qsCol > 11) then
			qsCol = 0;
			qsRow = qsRow + 1;
		end
		
		local posL = 3 + (qsCol *42) +(math.floor(qsCol/3)*5);
		local posH = g9.frH + (qsRow *30);
		
		local gb = frm:CreateOrGetControl("groupbox", "qgb"..i, posL, posH, 40, 28);
		gb:SetSkinName("skin_white");
		gb:SetColorTone("C0000000");
		gb:EnableHitTest(1);
		gb:SetEventScript(ui.LBUTTONUP, "TPWARP_BTN_QUEST");
		
		local rt = gb:CreateOrGetControl("richtext", "qrt"..i,2,0,36,28);
		rt = tolua.cast(rt, "ui::CRichText");	-- ui::CObject を ui::CRichTextにキャスト
		rt:SetFontName("white_12_ol");
		rt:EnableResizeByText(0);	-- CRichTextでないと使えない
		rt:SetTextFixWidth(0);		-- CRichTextでないと使えない
		rt:EnableSplitBySpace(0);	-- CRichTextでないと使えない
		rt:EnableHitTest(0);

		rt:SetText(qData.mName.."{nl}"..qData.nName);
		
		--	CHAT_SYSTEM(qData.mName.." /"..qData.nName.." /"..qData.mLv.." /"..qData.qCId);
	end
	g9.qsH = (qsRow+1) *30;
end

function g9.TPWARP_PARTY_UPDATE(frame, msg, str, num)
	--	CHAT_SYSTEM("TPWARP_PARTY_UPDATE");
	if session.world.IsIntegrateServer() or world.IsPVPMap() then
		return;
	end
	local pcParty = session.party.GetPartyInfo();

	if (pcParty == nil) or (pcParty.info == nil) then
		return;
	end

	local ptId = pcParty.info:GetPartyID();
	local ptNm = pcParty.info.name;
	local ptLdId = pcParty.info:GetLeaderAID();
	local ptLdInfo = session.party.GetPartyMemberInfoByAID(PARTY_NORMAL, ptLdId);	
	local ptLd = "";
	if (ptLdInfo ~= nil) then
		ptLd = ptLdInfo:GetName();
	end
	--	CHAT_SYSTEM("TPWARP_PARTY_UPDATE "..ptId.." "..ptNm);

	if (ptId == nil) or (ptId == "") then
		return;
	end

	if (ptId == s9.LastPtId1) then
		s9.LastPtId1 = ptId;
		s9.LastPtNm1 = ptNm;
		s9.LastPtLd1 = ptLd;
	elseif (ptId == s9.LastPtId2) then
		s9.LastPtId2 = s9.LastPtId1;
		s9.LastPtNm2 = s9.LastPtNm1;
		s9.LastPtLd2 = s9.LastPtLd1;
		s9.LastPtId1 = ptId;
		s9.LastPtNm1 = ptNm;
		s9.LastPtLd1 = ptLd;
	elseif (ptId == s9.LastPtId3) then
		s9.LastPtId3 = s9.LastPtId2;
		s9.LastPtNm3 = s9.LastPtNm2;
		s9.LastPtLd3 = s9.LastPtLd2;
		s9.LastPtId2 = s9.LastPtId1;
		s9.LastPtNm2 = s9.LastPtNm1;
		s9.LastPtLd2 = s9.LastPtLd1;
		s9.LastPtId1 = ptId;
		s9.LastPtNm1 = ptNm;
		s9.LastPtLd1 = ptLd;
	else
		s9.LastPtId4 = s9.LastPtId3;
		s9.LastPtNm4 = s9.LastPtNm3;
		s9.LastPtLd4 = s9.LastPtLd3;
		s9.LastPtId3 = s9.LastPtId2;
		s9.LastPtNm3 = s9.LastPtNm2;
		s9.LastPtLd3 = s9.LastPtLd2;
		s9.LastPtId2 = s9.LastPtId1;
		s9.LastPtNm2 = s9.LastPtNm1;
		s9.LastPtLd2 = s9.LastPtLd1;
		s9.LastPtId1 = ptId;
		s9.LastPtNm1 = ptNm;
		s9.LastPtLd1 = ptLd;
	end

	if (s9.usePartyLink	) then
		g9.SetPartyLink();
	end

	local f,m = pcall(g9.TPWARP_SAVE_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end

function g9.SetPartyLink()
	local frm	= ui.GetFrame("tpwarp");
	if (frm == nil) then
		return;
	end
	local i = 0;
	g9.ptH = 30;
	for i = 1, 4 do
		local posL = 3 + ((i-1) *131);
		local posH = g9.frH + g9.qsH;

		local gb = frm:CreateOrGetControl("groupbox", "pgb"..i, posL, posH, 126, 28);
		gb:SetSkinName("skin_white");
		gb:SetColorTone("C0000000");
		gb:EnableHitTest(1);
		gb:SetEventScript(ui.LBUTTONUP, "TPWARP_BTN_PARTY");
		
		local rt = gb:CreateOrGetControl("richtext", "prt"..i,2,0,122,28);
		rt = tolua.cast(rt, "ui::CRichText");	-- ui::CObject を ui::CRichTextにキャスト
		rt:SetFontName("white_12_ol");
		rt:EnableResizeByText(0);	-- CRichTextでないと使えない
		rt:SetTextFixWidth(0);		-- CRichTextでないと使えない
		rt:EnableSplitBySpace(0);	-- CRichTextでないと使えない
		rt:EnableHitTest(0);

		local ptId = s9["LastPtId"..i];
		local ptNm = s9["LastPtNm"..i];
		local ptLd = s9["LastPtLd"..i];
		if (ptId == nil) or (ptId == "") then
			rt:SetText("");
		else
			rt:SetText(ptNm.."{nl}"..ptLd);
		end
	end
end
function TPWARP_BTN_PARTY(frame, ctrl, argStr, argNum)
	--	CHAT_SYSTEM("TPWARP_BTN_PARTY"..ctrl:GetName());
	local i = tonumber(string.sub(ctrl:GetName(), 4));
	local ptId = s9["LastPtId"..i];
	if (ptId == nil) or (ptId == "") then
		return;
	end
	local pcParty = session.party.GetPartyInfo();
	if (pcParty == nil) or (pcParty.info == nil) then
		party.JoinPartyByLink(0, ptId);
	end
end
function TPWARP_BTN_QUEST(frame, ctrl, argStr, argNum)
	--	CHAT_SYSTEM("TPWARP_BTN_QUEST"..ctrl:GetName());
	local i = tonumber(string.sub(ctrl:GetName(), 4));
	local qData = g9.qTable[i];
	QUESTION_QUEST_WARP(frame, ctrl, argStr, qData.qCId);
end
