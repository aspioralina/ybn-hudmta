
local icons = {
    { key = "health",    texture = dxCreateTexture("heart_red.png") },
    { key = "armor",     texture = dxCreateTexture("shield_white.png") },
    { key = "hunger",    texture = dxCreateTexture("hunger.png") },
    { key = "thirst",    texture = dxCreateTexture("thirst.png") },
    { key = "microphone",texture = dxCreateTexture("microphone.png") },
}

for i, v in ipairs(icons) do
    if not v.texture then
        outputDebugString("[YBN HUD] Texture yüklenemedi: "..v.key, 1)
    end
end

local stats = {
    health = 100,
    armor = 0,
    hunger = 100,
    thirst = 100,
    microphone = false,
    microphoneActive = false
}

local iconSize = 36
local spacing = 32

local zKeyDown = false

addEventHandler("onClientKey", root, function(button, press)
    if button == "z" then
        zKeyDown = press
    end
end)

function drawYBNHUD()
    if not localPlayer then return end
    stats.health = math.floor(getElementHealth(localPlayer))
    stats.armor = math.floor(getPedArmor(localPlayer))
    stats.microphoneActive = zKeyDown

    local screenW, screenH = guiGetScreenSize()
    local drawIcons = {}
    for _, v in ipairs(icons) do
        if v.key == "armor" then
            if stats.armor > 0 then
                table.insert(drawIcons, v)
            end
        else
            table.insert(drawIcons, v)
        end
    end
    local totalW = #drawIcons * iconSize + (#drawIcons-1)*spacing
    local startX = 32
    local y = screenH - iconSize - 32

    local idx = 0
    for _, v in ipairs(drawIcons) do
        idx = idx + 1
        local x = startX + (idx-1)*(iconSize+spacing)
        local alpha = 255
        local r, g, b = 255, 255, 255
        if v.key == "health" and stats.health <= 20 then
            alpha = 120
        elseif v.key == "armor" and stats.armor <= 20 then
            alpha = 120
        elseif v.key == "microphone" then
            if stats.microphoneActive then
                r, g, b = 60, 255, 60 -- yeşil
            elseif not stats.microphone then
                alpha = 80
            end
        end
        if v.key == "health" then
            if stats.health > 0 then
                local percent = math.max(0, math.min(1, stats.health/100))
                local iconAlpha = percent > 0.2 and 255 or 100
                dxDrawImage(x, y, iconSize, iconSize, v.texture, 0, 0, 0, tocolor(r, g, b, iconAlpha))
            end
        elseif v.key == "armor" then
            if stats.armor > 0 then
                local percent = math.max(0, math.min(1, stats.armor/100))
                local iconAlpha = percent > 0.2 and 255 or 100
                dxDrawImage(x, y, iconSize, iconSize, v.texture, 0, 0, 0, tocolor(r, g, b, iconAlpha))
            end
        else
            dxDrawImage(x, y, iconSize, iconSize, v.texture, 0, 0, 0, tocolor(r, g, b, alpha))
        end
    end
end
addEventHandler("onClientRender", root, drawYBNHUD)

addEvent("updateHunger", true)
addEventHandler("updateHunger", localPlayer, function(value)
    stats.hunger = math.max(0, math.min(100, tonumber(value) or 100))
end)
addEvent("updateThirst", true)
addEventHandler("updateThirst", localPlayer, function(value)
    stats.thirst = math.max(0, math.min(100, tonumber(value) or 100))
end)
addEvent("setVoiceActive", true)
addEventHandler("setVoiceActive", localPlayer, function(active)
    stats.microphone = not not active
end)

addCommandHandler("hud", function()
    removeEventHandler("onClientRender", root, drawYBNHUD)
    if not _G.hudHidden then
        _G.hudHidden = true
        outputChatBox("[YBN] HUD kapandı", 255,255,0)
    else
        addEventHandler("onClientRender", root, drawYBNHUD)
        _G.hudHidden = false
        outputChatBox("[YBN] HUD açıldı", 255,255,0)
    end
end)

addCommandHandler("sethunger", function(_, value)
    stats.hunger = math.max(0, math.min(100, tonumber(value) or 100))
end)
addCommandHandler("setthirst", function(_, value)
    stats.thirst = math.max(0, math.min(100, tonumber(value) or 100))
end)
addCommandHandler("setmic", function(_, value)
    stats.microphone = (value == "1" or value == "true" or value == "açık")
end)
