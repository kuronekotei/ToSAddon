--[[
	日本語
--]]

local acutil = require('acutil');

_G['TPMINIMAP'] = _G['TPMINIMAP'] or {};
local g5 = _G['TPMINIMAP'];
g5.settingPath = g5.settingpath or "../addons/tpminimap/settings.json";
g5.settings = g5.settings or {};
local s5 = g5.settings;


function TPMINIMAP_ON_INIT(addon, frame)
	--CHAT_SYSTEM("TPMINIMAP_ON_INIT");
	local f,m = pcall(g5.TPMINIMAP_LOAD_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
	local f,m = pcall(g5.TPMINIMAP_SAVE_SETTING);
	if f ~= true then
		CHAT_SYSTEM(m);
	end

	frame:SetEventScript(ui.LBUTTONUP, "TPMINIMAP_LBUTTONUP");
	addon:RegisterMsg("GAME_START", "TPMINIMAP_GAME_START");


	local f,m = pcall(g5.TPMINIMAP_INIT,addon, frame);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end


function TPMINIMAP_LBUTTONUP()
	local f,m = pcall(g5.TPMINIMAP_LBUTTONUP);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end

function TPMINIMAP_GAME_START(frame, msg, str, num)
	--CHAT_SYSTEM("TPMINIMAP_GAME_START");
	local frm	= ui.GetFrame("tpminimap");
	if (world.IsPVPMap()) then frm:ShowWindow(0); return; end
	frm:ShowWindow(1);
	g5.fDelay = false;
	g5.fFirst = false;
	frm:RunUpdateScript("TPMINIMAP_UPDATE",  s5.updInterval, 0.0, 0, 1);
end

function TPMINIMAP_UPDATE(frame)
	--CHAT_SYSTEM("TPMINIMAP_UPDATE");
	if (g5.fDelay ~= true) then
		--	RunUpdateScriptは初回は0秒で走るので2周させる
		g5.fDelay = true;
		return 1;	--	RunUpdateScriptは1で継続
	end
	
	if (g5.fFirst ~= true) then
		g5.fFirst = true;
		local f,m = pcall(g5.TPMINIMAP_START_DELAY, frame);
		if f ~= true then
			CHAT_SYSTEM(m);
			return 0;	--	RunUpdateScriptは0で終了
		end
		return 1;	--	RunUpdateScriptは1で継続
	end
	local f,m = pcall(g5.TPMINIMAP_UPDATE, frame);
	if f ~= true then
		CHAT_SYSTEM(m);
		return 0;	--	RunUpdateScriptは0で終了
	end
	return 1;	--	RunUpdateScriptは1で継続
end

function g5.TPMINIMAP_LOAD_SETTING()
	local t, err = acutil.loadJSON(g5.settingPath);
	if t then
		s5 = acutil.mergeLeft(s5, t);
	end
	-- 	値の存在確保と初期値設定
	s5.isDebug			= ((type(s5.isDebug			) == "boolean")	and s5.isDebug			)or false;
	s5.posX				= ((type(s5.posX			) == "number")	and s5.posX				)or 600;
	s5.posY				= ((type(s5.posY			) == "number")	and s5.posY				)or 400;
	s5.sizeW			= ((type(s5.sizeW			) == "number")	and s5.sizeW			)or 360;
	s5.sizeH			= ((type(s5.sizeH			) == "number")	and s5.sizeH			)or 300;
	s5.zoomRate			= ((type(s5.zoomRate		) == "number")	and s5.zoomRate			)or 120;
	s5.updInterval		= ((type(s5.updInterval		) == "number")	and s5.updInterval		)or 0.2;
end

function g5.TPMINIMAP_SAVE_SETTING()
	local filep = io.open(g5.settingPath,"w+");
	if filep then
		filep:write("{\n");
		filep:write("\t\"isDebug\":"		.. ((s5.isDebug			and "true") or "false")	.."\n"	);
		filep:write("\t\"posX\":"			.. s5.posX			.."\n"		);
		filep:write("\t\"posY\":"			.. s5.posY			.."\n"		);
		filep:write("\t\"sizeW\":"			.. s5.sizeW			.."\n"		);
		filep:write("\t\"sizeH\":"			.. s5.sizeH			.."\n"		);
		filep:write("\t\"zoomRate\":"		.. s5.zoomRate		.."\n"		);
		filep:write("\t\"updInterval\":"	.. s5.updInterval	.."\n"		);
		filep:write("}\n");
		filep:close();
	end
end

function g5.TPMINIMAP_LBUTTONUP()
	local frm	= ui.GetFrame("tpminimap");
	if (frm == nil) then
		return;
	end
	s5.posX	= frm:GetX();
	s5.posY	= frm:GetY();
	g5.TPMINIMAP_SAVE_SETTING();
end



function g5.TPMINIMAP_INIT(addon, frame)
	frame:MoveFrame(s5.posX		,s5.posY	);
	frame:Resize(	s5.sizeW	,s5.sizeH	);
end



function g5.TPMINIMAP_START_DELAY(frame)
	g5.DumpMapStat();

	g5.MapBg	= tolua.cast(frame:GetChild('mapbg'), "ui::CPicture");
	g5.MapLd	= tolua.cast(frame:GetChild('mapld'), "ui::CPicture");
	g5.GrpB		= tolua.cast(frame:GetChild('grpb'), "ui::CGroupBox");
	g5.Grp1		= tolua.cast(g5.GrpB:GetChild('grp1'), "ui::CGroupBox");
	g5.Grp2		= tolua.cast(g5.GrpB:GetChild('grp2'), "ui::CGroupBox");
	g5.Grp3		= tolua.cast(g5.GrpB:GetChild('grp3'), "ui::CGroupBox");
	g5.Grp4		= tolua.cast(g5.GrpB:GetChild('grp4'), "ui::CGroupBox");
	g5.Grp5		= tolua.cast(g5.GrpB:GetChild('grp5'), "ui::CGroupBox");
	g5.Grp6		= tolua.cast(g5.GrpB:GetChild('grp6'), "ui::CGroupBox");
	g5.Grp7		= tolua.cast(g5.GrpB:GetChild('grp7'), "ui::CGroupBox");
	g5.Grp8		= tolua.cast(g5.GrpB:GetChild('grp8'), "ui::CGroupBox");
	g5.Grp9		= tolua.cast(g5.GrpB:GetChild('grp9'), "ui::CGroupBox");
	--	マップIDの取得
	g5.MapName = session.GetMapName();
	g5.MapProp = geMapTable.GetMapProp(g5.MapName);
	g5.MapBg:SetImage(g5.MapName .. "_fog");
	g5.MapBg:SetColorTone("D0FF8080");
	
	
	g5.ImgW = g5.MapBg:GetImageWidth();
	g5.ImgH = g5.MapBg:GetImageHeight();
	local pos1 = g5.MapProp:WorldPosToMinimapPos(0, 0, g5.ImgW, g5.ImgH);
	local pos2 = g5.MapProp:WorldPosToMinimapPos(1, 0, g5.ImgW, g5.ImgH);
	--	距離1あたりのピクセル
	local pix = pos2.x - pos1.x;
	--	距離100で見える範囲をフレームの長さに合わせた場合
	local zoomRate = frame:GetWidth() / (pix * s5.zoomRate);
	g5.MapW = g5.ImgW * zoomRate / 10;
	g5.MapH = g5.ImgH * zoomRate / 10;

	g5.MapBg:Resize(g5.MapW, g5.MapH);
	g5.GrpB:Resize(g5.MapW, g5.MapH);
	g5.Grp1:Resize(g5.MapW, g5.MapH);
	g5.Grp2:Resize(g5.MapW, g5.MapH);
	g5.Grp3:Resize(g5.MapW, g5.MapH);
	g5.Grp4:Resize(g5.MapW, g5.MapH);
	g5.Grp5:Resize(g5.MapW, g5.MapH);
	g5.Grp6:Resize(g5.MapW, g5.MapH);
	g5.Grp7:Resize(g5.MapW, g5.MapH);
	g5.Grp8:Resize(g5.MapW, g5.MapH);
	g5.Grp9:Resize(g5.MapW, g5.MapH);

	--	自キャラを中央揃え
	g5.MapLd:SetOffset(frame:GetWidth() / 2 - g5.MapLd:GetImageWidth() / 2 , frame:GetHeight() / 2 - g5.MapLd:GetImageHeight() / 2);


	g5.List1 = {};
	g5.List2 = {};
	g5.List3 = {};
	g5.List4 = {};
	g5.List5 = {};
	g5.List6 = {};
	g5.List7 = {};
	g5.List8 = {};
	g5.List9 = {};

	g5.Counter = 0;
end

function g5.TPMINIMAP_UPDATE(frame)
	if (world.IsPVPMap()) then return end

	g5.Counter = (g5.Counter % 100) + 1;


	g5.MoveMap();
	g5.SetList();

	g5.DelObj(g5.List1,g5.Grp1);
	g5.DelObj(g5.List2,g5.Grp2);
	g5.DelObj(g5.List3,g5.Grp3);
	g5.DelObj(g5.List4,g5.Grp4);
	g5.DelObj(g5.List5,g5.Grp5);
	g5.DelObj(g5.List6,g5.Grp6);
	g5.DelObj(g5.List7,g5.Grp7);
	g5.DelObj(g5.List8,g5.Grp8);
	g5.DelObj(g5.List9,g5.Grp9);

	g5.SetObj(g5.List1,g5.Grp1,"obj1_");
	g5.SetObj(g5.List2,g5.Grp2,"obj2_");
	g5.SetObj(g5.List3,g5.Grp3,"obj3_");
	g5.SetObj(g5.List4,g5.Grp4,"obj4_");
	g5.SetObj(g5.List5,g5.Grp5,"obj5_");
	g5.SetObj(g5.List6,g5.Grp6,"obj6_");
	g5.SetObj(g5.List7,g5.Grp7,"obj7_");
	g5.SetObj(g5.List8,g5.Grp8,"obj8_");
	g5.SetObj(g5.List9,g5.Grp9,"obj9_");
end

function g5.MoveMap()
	local myHnd = session.GetMyHandle();
	if (myHnd == nil) then
	  return;
	end

	--	自キャラの角度を取得
	local myAng = info.GetAngle(myHnd) - g5.MapProp.RotateAngle;	--	マップは最初から45度傾いてる
	g5.MapLd:SetAngle(myAng);

	--	自キャラの位置を取得
	local myPos = info.GetPositionInMap(myHnd, g5.MapW, g5.MapH);


	--	オフセットを計算
	local miniX = myPos.x - g5.MapLd:GetOffsetX() - g5.MapLd:GetImageWidth() / 2;
	local miniY = myPos.y - g5.MapLd:GetOffsetY() - g5.MapLd:GetImageHeight() / 2;
	miniX = math.floor(miniX);
	miniY = math.floor(miniY);

	--	マップ画像の位置を変更
	g5.MapBg:SetOffset( -miniX, -miniY);
	g5.GrpB:SetOffset( -miniX, -miniY);
end

function g5.SetList()
	local fndList, fndCount = SelectObject(self, 400, 'ALL');
	if (fndCount == nil) or (fndCount == 0) then
		return;
	end

	if (world.IsPVPMap()) then return end

	if (g5.Counter == 100) and s5.isDebug then
		CHAT_SYSTEM(fndCount);
		g5.DumpMapStat();
	end
	local ptIcn =	{};
	local memList = session.party.GetPartyMemberList(PARTY_NORMAL);
	for i = 0 , memList:Count() - 1 do
		local memInfo = memList:Element(i);
		ptIcn[memInfo:GetHandle()] = GET_JOB_ICON(memInfo:GetIconInfo().job);
	end

	local i=0;
	local hnd=0;
	local hnd2="";
	local itm=nil;
	local tgt=nil;
	local actr=nil;
	local mon=nil;
	local myHnd=session.GetMyHandle();
	for i = 1, fndCount do
		itm		= fndList[i];
		hnd		= GetHandle(itm);
		hnd2	= tostring(hnd);
		tgt		= info.GetTargetInfo(hnd);
		actr	= world.GetActor(hnd);
		mon		= GetClassByType("Monster", actr:GetType());
		if (myHnd == hnd) or (g5.List1[hnd2]) or (g5.List2[hnd2]) or (g5.List3[hnd2]) or (g5.List4[hnd2]) or (g5.List5[hnd2]) or (g5.List6[hnd2]) or (g5.List7[hnd2]) or (g5.List8[hnd2]) or (g5.List9[hnd2]) or (world.IsPVPMap()) then
			--	何もしない
		elseif(itm.ClassName == "PC") and (tgt.IsDummyPC == 1) then
			g5.List6[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = "DummyPC"	,Col="FF60FF60"	,Pic="sugoidot"	,Size=12};
			--CHAT_SYSTEM(itm.Name ..":DummyPC");
		elseif(itm.ClassName == "PC") and (ptIcn[hnd]) then
			g5.List2[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = "Party"		,Col="FFFFFFFF"	,Pic=ptIcn[hnd]	,Size=48};
			--CHAT_SYSTEM(itm.Name ..":Party");
		elseif(itm.ClassName == "PC") then
			g5.List6[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = "PC"			,Col="FF00FF00"	,Pic="sugoidot"	,Size=16};
			--CHAT_SYSTEM(itm.Name ..":PC");
		elseif (itm.Faction == "Peaceful") then
			g5.List9[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = itm.Faction	,Col="FFFFFF00"	,Pic="sugoidot"	,Size=8};
			--CHAT_SYSTEM(itm.ClassName ..":".. itm.Faction);
		elseif (itm.Faction == "Pet") then
			g5.List6[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = itm.Faction	,Col="FF00FFFF"	,Pic="sugoidot"	,Size=16};
			--CHAT_SYSTEM(itm.ClassName ..":".. itm.Faction);
		elseif (fndList[i].Faction == "Summon") or (itm.ClassName == "pcskill_dirtypole") or (itm.ClassName == "russianblue") then
			if (mon.Size == "S" ) then
				g5.List5[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = "Summon"		,Col="FF8000FF"	,Pic="sugoidot"	,Size=12};
			elseif (mon.Size == "M" ) then
				g5.List5[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = "Summon"		,Col="FF8000FF"	,Pic="sugoidot"	,Size=16};
			elseif (mon.Size == "L" ) then
				g5.List5[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = "Summon"		,Col="FF8000FF"	,Pic="sugoidot"	,Size=24};
			elseif (mon.Size == "XL" ) then
				g5.List3[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = "Summon"		,Col="FF8000FF"	,Pic="sugoidot"	,Size=32};
			end
			--CHAT_SYSTEM(itm.ClassName ..":".. itm.Faction);
		elseif (fndList[i].Faction == "RootCrystal") then
			g5.List4[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = itm.Faction	,Col="FF60FFFF"	,Pic="sugoisqr"	,Size=12};
			--CHAT_SYSTEM(itm.ClassName ..":".. itm.Faction);
		elseif (mon.MonRank == "MISC") then
			g5.List4[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = itm.Faction	,Col="FF404040"	,Pic="sugoisqr"	,Size=16};
			--CHAT_SYSTEM(itm.ClassName ..":".. itm.Faction ..":".. mon.MonRank);
		elseif (mon.MonRank == "NPC") then
			g5.List4[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = itm.Faction	,Col="FF0000FF"	,Pic="sugoidot"	,Size=12};
			--CHAT_SYSTEM(itm.ClassName ..":".. itm.Faction ..":".. mon.MonRank);
		elseif (mon.MonRank == "Material") then
			g5.List4[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = itm.Faction	,Col="FF0080FF"	,Pic="sugoisqr"	,Size=16};
			--CHAT_SYSTEM(itm.ClassName ..":".. itm.Faction ..":".. mon.MonRank);
		elseif (fndList[i].Faction == "Neutral") then
			g5.List4[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = itm.Faction	,Col="FF000080"	,Pic="sugoisqr"	,Size=16};
			--CHAT_SYSTEM(itm.ClassName ..":".. itm.Faction ..":".. mon.MonRank);
		elseif (session.world.IsDungeon()==false) and (ui.IsFrameVisible("challenge_mode")~=true) then
		elseif (fndList[i].Faction == "Monster") then
			if (mon.Size == "S" ) then
				g5.List8[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = itm.Faction	,Col="FFFF0000"	,Pic="sugoidot"	,Size=12};
			elseif (mon.Size == "M" ) then
				g5.List8[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = itm.Faction	,Col="FFFF0000"	,Pic="sugoidot"	,Size=16};
			elseif (mon.Size == "L" ) then
				g5.List7[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = itm.Faction	,Col="FFFF0000"	,Pic="sugoidot"	,Size=24};
			elseif (mon.Size == "XL" ) then
				g5.List1[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = itm.Faction	,Col="FFFF0000"	,Pic="sugoidot"	,Size=64};
			end
			--CHAT_SYSTEM(itm.ClassName ..":".. itm.Faction ..":".. mon.MonRank);
		elseif (fndList[i].Faction == "Our_Forces") then
			g5.List9[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = itm.Faction	,Col="FFFFFFFF"	,Pic="sugoidot"	,Size=16};
			--CHAT_SYSTEM(itm.ClassName ..":".. itm.Faction);
		else
			g5.List9[hnd2] = {	Hnd=hnd	,Actr = actr	,Fct = itm.Faction	,Col="FFFFFFFF"	,Pic="sugoidot"	,Size=16};
			--CHAT_SYSTEM(fndList[i].ClassName ..":".. fndList[i].Faction);
		end
	end
end

function g5.DelObj(lst,grp)
	local tmpLst = {};
	for _,itm in pairs(lst) do
		local actr = world.GetActor(itm.Hnd);
		if (actr == nil) then
			tmpLst[itm.ObjNm] = itm;
		end
	end
	for _,itm in pairs(tmpLst) do
		lst[tostring(itm.Hnd)] = nil;
		grp:RemoveChild(itm.ObjNm);
		itm.Img = nil;
	end
	tmpLst = {};
end


function g5.SetObj(lst,grp,pref)
	for _,itm in pairs(lst) do
		itm.ObjNm = pref..itm.Hnd;
		local tgt = info.GetTargetInfo( itm.Hnd );
		if (tgt == nil) or ((tgt.stat.maxHP > 0) and (tgt.stat.HP==0)) then	--	削除モード
			if (itm.Img ~= nil) then
				itm.Img:ShowWindow(0);
			else
				grp:RemoveChild(itm.ObjNm);
			end
		elseif (itm.Img) then	--	画像あり
			g5.SetImgPos(itm.Img,itm.Hnd)
		else	--	画像無し
			local tmpImg = grp:CreateOrGetControl("picture", itm.ObjNm, 0, 0, itm.Size, itm.Size);
			itm.Img = tolua.cast(tmpImg, "ui::CPicture");
			itm.Img:SetImage(itm.Pic);
			itm.Img:SetEnableStretch(1);
			itm.Img:SetColorTone(itm.Col);
			itm.Img:ShowWindow(1);
			g5.SetImgPos(itm.Img,itm.Hnd)
		end
	end
end

function g5.SetImgPos(img,hnd)
	local pos = info.GetPositionInMap(hnd, g5.MapW, g5.MapH);
	local miniX = pos.x - img:GetWidth()/2;
	local miniY = pos.y - img:GetHeight()/2;
	miniX = math.floor(miniX);
	miniY = math.floor(miniY);
	img:SetOffset(miniX, miniY);
	img:ShowWindow(1);
end

function g5.DumpMapStat()
	if (s5.isDebug == false) then
		return;
	end
	local pc = GetMyPCObject();
	if (IsPVPServer(pc) == 1) then
		CHAT_SYSTEM("IsPVPServer:1");
	end
	if (world.IsPVPMap()) then
		CHAT_SYSTEM("IsPVPMap:true");
	end
	if (world.IsSingleMode()) then
		CHAT_SYSTEM("IsSingleMode:true");
	end
	if (session.world.IsIntegrateServer()) then
		CHAT_SYSTEM("IsIntegrateServer:true");
	end
	if (session.world.IsIntegrateIndunServer()) then
		CHAT_SYSTEM("IsIntegrateIndunServer:true");
	end
	if (session.world.IsDungeon()) then
		CHAT_SYSTEM("IsDungeon:true");
	end
	if (session.world.IsDirectionMode()) then
		CHAT_SYSTEM("IsDirectionMode:true");
	end
	if (session.colonywar.GetIsColonyWarMap()) then
		CHAT_SYSTEM("GetIsColonyWarMap:true");
	end
	if (IS_IN_EVENT_MAP()) then
		CHAT_SYSTEM("IS_IN_EVENT_MAP:true");
	end
	if (chMode ~= nil) and (ui.IsFrameVisible("challenge_mode")) then
		CHAT_SYSTEM("challenge_mode:IsVisible");
	end
end



