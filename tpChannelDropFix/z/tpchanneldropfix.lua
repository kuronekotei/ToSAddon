function UPDATE_CURRENT_CHANNEL_TRAFFIC(frame)
    local curchannel = frame:GetChild("curchannel");

    local channel = session.loginInfo.GetChannel();     
    local zoneInst = session.serverState.GetZoneInst(channel);
    if zoneInst ~= nil then
        local str, stateString = GET_CHANNEL_STRING(zoneInst);
        curchannel:SetTextByKey("value", str .. "          " .. stateString);
    else
        curchannel:SetTextByKey("value", "");
    end
end
