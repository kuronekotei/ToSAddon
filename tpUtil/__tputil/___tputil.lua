--[[
	日本語
	関数群を保存している
	ゲーム機能を呼び出さない、純粋なLua関数はここに置く
--]]
local _NAME_ = 'TPUTIL';
_G[_NAME_] = _G[_NAME_] or {};
local g0 = _G[_NAME_];

g0.LogL = g0.LogL or {};
g0.LogL[#g0.LogL +1] = "___tputil";

function GetTpUtil()
	return g0;
end


--	関数登録系
g0.FuncList = g0.FuncList or {};

function g0.FuncInit(tgtName) -- tgtName:string
	--	基本的にはHookするだけの機能
	--	唯一特殊な機能は g0.FuncList[tgtName].fEnd がtrueになると後続機能を停止する
	if(g0.FuncList[tgtName] ~= nil)then
		return;
	end
	g0.FuncList[tgtName] = g0.FuncList[tgtName] or {};
	g0.FuncList[tgtName].Func = g0.FuncList[tgtName].Func or _G[tgtName];
	g0.FuncList[tgtName].BefF = g0.FuncList[tgtName].BefF or {};
	g0.FuncList[tgtName].AftF = g0.FuncList[tgtName].AftF or {};
	g0.FuncList[tgtName].fEnd = g0.FuncList[tgtName].fEnd or false;
	_G[tgtName] = function(...)
		g0.FuncList[tgtName].fEnd = false;
		for k, v in pairs(g0.FuncList[tgtName].BefF) do
			local f,x1,x2,x3 = pcall(v.myFunc, ...);
			if f ~= true then
				CHAT_SYSTEM(x1);
				return;
			end
			if(g0.FuncList[tgtName].fEnd)then
				return x1,x2,x3;
			end
		end
		local f,x1,x2,x3 = pcall(g0.FuncList[tgtName].Func,...);
		if f ~= true then
			CHAT_SYSTEM(x1);
			return;
		end
		if(g0.FuncList[tgtName].fEnd)then
			return x1,x2,x3;
		end
		for k, v in pairs(g0.FuncList[tgtName].AftF) do
			local f,x1,x2,x3 = pcall(v.myFunc, ...);
			if f ~= true then
				CHAT_SYSTEM(x1);
				return;
			end
			if(g0.FuncList[tgtName].fEnd)then
				return x1,x2,x3;
			end
		end
		return x1,x2,x3;
	end
end
function g0.FuncBef(tgtName,addonName,myFunc) -- tgtName:string  addonName:string  myFunc:func
	--	基本的にはHookするだけの機能 tgtName関数より前にmyFuncを実行する
	--	唯一特殊な機能は g0.FuncList[tgtName].fEnd がfalseになると後続機能を停止する
	g0.FuncInit(tgtName);
	local i = 1;
	for k, v in pairs(g0.FuncList[tgtName].BefF) do
		i = i + 1;
		if(v.addonName == addonName) then
			v.myFunc = myFunc;
			return;
		end
	end
	g0.FuncList[tgtName].BefF[i] = {};
	g0.FuncList[tgtName].BefF[i].addonName = addonName;
	g0.FuncList[tgtName].BefF[i].myFunc = myFunc;
end
function g0.FuncAft(tgtName,addonName,myFunc) -- tgtName:string  addonName:string  myFunc:func
	--	基本的にはHookするだけの機能 tgtName関数の後でmyFuncを実行する
	--	唯一特殊な機能は g0.FuncList[tgtName].fEnd がfalseになると後続機能を停止する
	g0.FuncInit(tgtName);
	local i = 1;
	for k, v in pairs(g0.FuncList[tgtName].AftF) do
		i = i + 1;
		if(v.addonName == addonName) then
			v.myFunc = myFunc;
			return;
		end
	end
	g0.FuncList[tgtName].AftF[i] = {};
	g0.FuncList[tgtName].AftF[i].addonName = addonName;
	g0.FuncList[tgtName].AftF[i].myFunc = myFunc;
end

function g0.PCL(myFunc,a1,a2,a3,a4,a5,a6)
	local f,x1,x2,x3 = pcall(myFunc,a1,a2,a3,a4,a5,a6);
	if f ~= true then
		CHAT_SYSTEM(x1);
		return;
	end
	return x1,x2,x3;
end

function g0.Event(msg, argStr, argNum)
	argStr = argStr or "";
	argNum = argNum or 0;
	
	local f,m = pcall(addon.BroadMsg, msg, argStr, argNum);
	if f ~= true then
		CHAT_SYSTEM(m);
	end
end

--	設定処理系

function g0.LoadStg(addonName,stgPath,tblData) -- addonName:string  stgPath:string  片方はnilでも動く
	--	tblData ={
	--		"settingname1":settingdata1,
	--		"settingname2":settingdata2,
	--		"settingname3":settingdata3,
	--	}
	local addonNameS = string.lower(addonName);
	stgPath = stgPath or ("../addons/"..addonNameS.."/stg_"..addonNameS..".lua");
	local f,m = pcall(dofile,stgPath);
	if (f ~= true) then
		CHAT_SYSTEM(m);
		return;
	end
	g0.MergeStg(tblData,m);
end

function g0.MergeStg(tblData,plusData) -- 
	for k, v in pairs(plusData) do
		if (type(v) == "table") and (type(tblData[k] or false) == "table") then
			g0.MergeStg(tblData[k], plusData[k]);
		else
			tblData[k] = v;
		end
	end
end

function g0.SaveStg(addonName,stgPath,tblData,tblSort) -- addonName:string  stgPath:string(nil)
	--	tblData ={
	--		settingname1=settingdata1,
	--		settingname2=settingdata2,
	--		settingname3=settingdata3,
	--	}
	--	tblSort ={
	--		{name="settingname1",comm="comment1"},
	--		{name="settingname2",comm="comment2"},
	--		{name="settingname3",comm="comment3"},
	--	}
	local addonNameS = string.lower(addonName);
	stgPath = stgPath or ("../addons/"..addonNameS.."/stg_"..addonNameS..".lua");
	local filep = io.open(stgPath,"w+");
	if filep then
		filep:write("local stg ={};\n");
		if(type(tblSort or false) == "table") then
			for k, v in pairs(tblSort) do
				g0.SaveLine(filep, v.name, tblData[v.name] ,v.comm, "stg" ,1);
			end
		else
			for k, v in pairs(tblData) do
				g0.SaveLine(filep, k, v ,nil, "stg" ,1);
			end
		end
		filep:write("return stg;\n");
		filep:close();
	end
end

function g0.SaveLine(filep,name,val,comm,parent,lvl) -- name:string  value:string(nil) comm:string(nil) lvl:int
	comm = (comm or "");
	local tab1 		= string.rep("\t", lvl);
	if(name=="_" and comm=="") then
		filep:write("\n");
		return;
	end
	if(name=="_") then
		filep:write(tab1.. "--\t"..comm.."\n");
		return;
	end
	if(val==nil) then
		return;
	end
    local typ 		= type(val);
	local xname 	= parent.."[\""..name.."\"]";
	local tab2 		= string.rep("\t", 5-math.floor(#xname / 4));
	local lside 	= tab1..xname..tab2.."\t= ";
	local rside 	= ";\t--\t" ..comm.."\n";
	if(name=="_" and comm=="") then
		filep:write("\n");
		return;
	end
	if(name=="_") then
		filep:write(tab1.. "--\t"..comm.."\n");
		return;
	end
	if (typ == "boolean") then 
		filep:write(lside.. ((val and "true") or "false")	..rside);
		return;
	end
	if (typ == "string" ) then 
		filep:write(lside.. "\""..val.."\""	..rside);
		return;
	end
	if (typ == "number") then 
		filep:write(lside.. val	..rside);
		return;
	end
	if (typ == "table") then 
		lside 	= tab1..parent.."[\""..name.."\"]"..tab2.."\t= {";
		rside 	= " }"..rside;
		filep:write(lside..rside);
		for k, v in pairs(val) do
			g0.SaveLine(filep,k,val[k],nil,xname,lvl+1);
		end
		return;
	end
end




function g0.DumpObj(obj,name,lvl)
	lvl = lvl or 0;
	if(lvl>3)then
		return "";
	end
	if(type(name) ~= "string")then
		name = "obj";
	end
	name = name or "obj";
	local typ	= type(obj);
	local tab1	= string.rep("  ", lvl);
	local tab2	= string.rep(" ", 20-#name);
	local nl	= "{nl}\n";
	if (obj == nil ) then 
		return tab1..name..tab2.."="..nl;
	end
	if (name == "tolua_ubox" ) then 
		return tab1..name..tab2.."=T[]"..nl;
	end
	if (typ == "string" ) then 
		return tab1..name..tab2.."="..obj..nl;
	end
	if (typ == "number" ) then 
		return tab1..name..tab2.."="..g0.lpn2s(obj,9)..nl;
	end
	if (typ == "boolean" ) then 
		return tab1..name..tab2.."="..((obj and "true") or "false")..nl;
	end
	if (typ == "table") then 
		local ret = tab1..name..tab2.."=T[]"..nl;
		for k, v in pairs(obj) do
			if(obj~=v) then
				ret = ret .. g0.DumpObj(v,k,lvl+1);
			end
		end
		return ret;
	end
	if (typ == "function") then
		if(name:sub(1,2)=="__") then
			return "";
		end
		return tab1..name..tab2.."=function()"..nl;
	end
	if (typ == "userdata") then 
		local ret = tab1..name..tab2.."=U[]"..nl;
		local mtt = getmetatable(obj);
		for k, v in pairs(mtt) do
			if(obj~=v) then
				ret = ret .. g0.DumpObj(v,k,lvl+1);
			end
		end
		return ret;
	end
	return tab1..name..tab2.."=("..typ..")"..nl;
end



function g0.mdcol(str1)
	local len1 = #str1;
	local str2 = str1:gsub("%w*%s*%p*","")
	local len2 = #str2;
	return len1 - math.floor(len2/3);
end
function g0.rpmb(str1,len)
	local len1 = #str1;
	local str2 = str1:gsub("%w*%s*%p*","")
	local len2 = #str2;
	local cols = len1 - math.floor(len2/3);
	return str1 .. string.rep(" ", len - cols);
end

function g0.s(obj)
	if(obj==nil) then
		return "";
	end
	local typ	= type(obj);
	if (typ == "string" ) then 
		return obj;
	end
	if (typ == "boolean") then 
		return((obj and "true") or "false");
	end
	if (typ == "number") then 
		return ""..obj;
	end
	if (typ == "table") then 
		return "_["..#obj.."]";
	end
	if (typ == "function") then 
		return "_function_";
	end
	if (typ == "userdata") then 
		return "_userdata_";
	end
end

function g0.n2s(num)
	local numStr		= ""..num;
	local thx = 15;
	local settop = 0;
	if(tonumber(num)<0)then
		settop = 1;	--	マイナス記号の1文字を保護
	end
	while(thx > 0) do
		if (#numStr - settop > thx) then
			numStr = string.sub(numStr,0,#numStr-thx)..","..string.sub(numStr,#numStr-thx+1);
		end
		thx = thx -3;
	end
	return numStr;
end
function g0.lpn2s(num,len)
	local numStr		= ""..num;
	local thx = 15;
	local settop = 0;
	if(tonumber(num)<0)then
		settop = 1;	--	マイナス記号の1文字を保護
	end
	while(thx > 0) do
		if (#numStr - settop > thx) then
			numStr = string.sub(numStr,0,#numStr-thx)..","..string.sub(numStr,#numStr-thx+1);
		end
		thx = thx -3;
	end
	return string.rep(" ", len - #numStr) .. numStr;
end
function g0.zpn2s(num,len)
	local numStr		= ""..num;
	local thx = 15;
	local settop = 0;
	if(tonumber(num)<0)then
		settop = 1;	--	マイナス記号の1文字を保護
	end
	while(thx > 0) do
		if (#numStr - settop > thx) then
			numStr = string.sub(numStr,0,#numStr-thx)..","..string.sub(numStr,#numStr-thx+1);
		end
		thx = thx -3;
	end
	return string.rep("0", len - #numStr) .. numStr;
end
function g0.n2sk(num,len)	--	1000Mや100k等に成形する　最低でもlen+1文字になる
	--	数字は1桁にはしない　9,999の次は10k　9,999kの次は10M
	--	Mより上にはしない　99,999Mや999,999M等になる
	len = len or 5;
	if (num >9999) then 
		return g0.lpn2s(math.floor(num /1000),len).."k"
	elseif (num <-9999) then 
		return g0.lpn2s(math.floor(num /1000),len).."k"
	else
		return g0.lpn2s(math.floor(num),len).." "
	end
end
function g0.n2sMk(num,len)	--	1000Mや100k等に成形する　最低でもlen+1文字になる
	--	数字は1桁にはしない　9,999の次は10k　9,999kの次は10M
	--	Mより上にはしない　99,999Mや999,999M等になる
	len = len or 5;
	if (num >9999999) then 
		return g0.lpn2s(math.floor(num /1000000),len).."M"
	elseif (num >9999) then 
		return g0.lpn2s(math.floor(num /1000),len).."k"
	elseif (num <-9999999) then 
		return g0.lpn2s(math.floor(num /1000000),len).."M"
	elseif (num <-9999) then 
		return g0.lpn2s(math.floor(num /1000),len).."k"
	else
		return g0.lpn2s(math.floor(num),len).." "
	end
end
function g0.sec2hms(sec)	--	秒を半角9文字に成型		__0:00:00
	return g0.lpn2s(math.floor(sec/3600),3) ..":"..g0.zpn2s(math.floor(math.floor(sec/60)%60),2) ..":" ..g0.zpn2s(math.floor(sec%60),2) ;
end


function g0.FileExists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
end


--	外部関数ファイル読み込み

function g0.LoadMyFunc()
	local fname = "";
	fname = "../addons/_tputil/myFunc1.lua";
	if(g0.FileExists(fname)) then
		local f,m = pcall(dofile,fname);
		if (f ~= true) and (CHAT_SYSTEM ~= nil) then
			CHAT_SYSTEM(m);
		end
	end
	fname = "../addons/_tputil/myFunc2.lua";
	if(g0.FileExists(fname)) then
		local f,m = pcall(dofile,fname);
		if (f ~= true) and (CHAT_SYSTEM ~= nil) then
			CHAT_SYSTEM(m);
		end
	end
	fname = "../addons/_tputil/myFunc3.lua";
	if(g0.FileExists(fname)) then
		local f,m = pcall(dofile,fname);
		if (f ~= true) and (CHAT_SYSTEM ~= nil) then
			CHAT_SYSTEM(m);
		end
	end
	fname = "../addons/_tputil/myFunc4.lua";
	if(g0.FileExists(fname)) then
		local f,m = pcall(dofile,fname);
		if (f ~= true) and (CHAT_SYSTEM ~= nil) then
			CHAT_SYSTEM(m);
		end
	end
end
--	TPUTIL.LoadMyFunc();