local botToken = Config.DiscordBotToken
local guildID = Config.guildID
local bypassRoles = Config.NameBypassRoleIDs or {}
local whitelistRoles = Config.RequiredWhitelistRoleIDs or {}

local function GetDiscordUser(source)
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.find(id, "discord:") then
            return string.gsub(id, "discord:", "")
        end
    end
    return nil
end

local function GetDiscordMember(discordID, callback)
    local url = ("https://discord.com/api/guilds/%s/members/%s"):format(guildID, discordID)
    local headers = {
        ["Authorization"] = "Bot " .. botToken,
        ["Content-Type"] = "application/json"
    }

    PerformHttpRequest(url, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local data = json.decode(resultData)
            callback(true, data)
        else
            callback(false, nil)
        end
    end, "GET", "", headers)
end

AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    local src = source
    deferrals.defer()
    Wait(0)

    local discordID = GetDiscordUser(src)
    if not discordID then
        deferrals.done("You must have Discord linked to join this server.")
        return
    end

    deferrals.update("Checking your Discord Information...")

    GetDiscordMember(discordID, function (success, data)
        if not success or not data then
            deferrals.done("Failed to verify your Discord Account. Please try again.")
            return
        end

        local hasWhitelistRole = false
        for _, userRole in pairs(data.roles or {}) do
            for _, allowedRole in pairs(whitelistRoles) do
                if userRole == allowedRole then
                    hasWhitelistRole = true
                    break
                end
            end
            if hasWhitelistRole then break end
        end

        local hasBypass = false
        for _, userRole in pairs(data.roles or {}) do
            for _, allowedRole in pairs(bypassRoles) do
                if userRole == allowedRole then
                    hasBypass = true
                end
            end
            if hasBypass then break end
        end

        if hasBypass then
            deferrals.done()
            return
        end

        if #whitelistRoles > 0 and not hasWhitelistRole and not hasBypass then
            deferrals.done("You do not have a required role to join this server.")
            return
        end

        local discordNick = data.nick or GetPlayerName(src)
        if discordNick ~= playerName then
            deferrals.done("Your in-game name must match your Discord Nickname exactly. \n\n Discord: " .. (discordNick or "N/A") .. "\nFiveM: " .. playerName)
            return
        end

        deferrals.done()
    end)
end)