

local playerData = {}

addEventHandler("onPlayerJoin", root, function()
    playerData[source] = { hunger = 100, thirst = 100, lastUpdate = getTickCount() }
end)


addEventHandler("onPlayerQuit", root, function()
    playerData[source] = nil
end)

setTimer(function()
    local now = getTickCount()
    for player, data in pairs(playerData) do
        if isElement(player) then
            local diff = now - (data.lastUpdate or now)
            if diff >= 30000 then 
                data.hunger = math.max(0, data.hunger - 1)
                data.thirst = math.max(0, data.thirst - 2)
                data.lastUpdate = now
                triggerClientEvent(player, "updateHunger", player, data.hunger)
                triggerClientEvent(player, "updateThirst", player, data.thirst)
                if data.hunger <= 0 or data.thirst <= 0 then
                    local hp = getElementHealth(player)
                    if hp > 10 then setElementHealth(player, hp - 5) end
                end
            end
        end
    end
end, 5000, 0)

addCommandHandler("sethunger", function(player, _, value)
    value = tonumber(value)
    if value and playerData[player] then
        playerData[player].hunger = math.max(0, math.min(100, value))
        triggerClientEvent(player, "updateHunger", player, playerData[player].hunger)
        outputChatBox("Hunger: "..playerData[player].hunger, player, 0,255,0)
    end
end)
addCommandHandler("setthirst", function(player, _, value)
    value = tonumber(value)
    if value and playerData[player] then
        playerData[player].thirst = math.max(0, math.min(100, value))
        triggerClientEvent(player, "updateThirst", player, playerData[player].thirst)
        outputChatBox("Thirst: "..playerData[player].thirst, player, 0,255,0)
    end
end)