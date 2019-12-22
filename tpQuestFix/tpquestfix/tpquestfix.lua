function NEW_QUEST_ADD(frame, msg, argStr, argNum) 
	local questIES = GetClassByType("QuestProgressCheck", argNum);
	local sobjIES = GET_MAIN_SOBJ();

	local ret = QUEST_ABANDON_RESTARTLIST_CHECK(questIES, sobjIES);
	local pcObj = GetMyPCObject();
	local mapCode = session.GetMapName();
	local mapCls = GetClass("Map", mapCode);
	local questState = SCR_QUEST_CHECK_C(pcObj, questIES.ClassName); 

	-- new quest check
	if ret == 'NOTABANDON' or questState == 'SUCCESS' then
		local isNew = 0
		if (questState == 'SUCCESS') or (questState == 'PROGRESS') or  (questState == 'COMPLETE') or (questIES.QuestMode ~= nil and ((questIES.Level < pcObj.Lv) or (questIES.Level < (mapCls.QuestLevel+6)) and (questIES.QuestMode == 'MAIN')) or (questIES.QuestMode == "PARTY")) then
			isNew = 1
		end

		if isNew == 1 and quest.IsCheckQuest(argNum) == false then
			if quest.GetCheckQuestCount() < 5 then		
				quest.AddCheckQuest(argNum);
				local questframe2 = ui.GetFrame("questinfoset_2");
				UPDATE_QUESTINFOSET_2(questframe2); -- infoset에 보여줌.
			end
		end
	end

	if questIES ~= nil then
		_UPDATE_QUEST_INFO(questIES)
	end

	QUEST_RESERVE_DRAW_LIST(frame)
end
