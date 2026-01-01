local Synchronizer = require(game:GetService("ReplicatedStorage").Packages.Synchronizer)
local player = game:GetService("Players").LocalPlayer
local sharedAnimals = require(game.ReplicatedStorage.Shared.Animals)
local result = {}

local function formatNumber(n)
    local suffixes = {"", "K", "M", "B", "T"}
    local index = 1
    while n >= 1000 and index < #suffixes do
        n = n / 1000
        index = index + 1
    end
    local defParse = string.format("%.2f%s", n, suffixes[index])

    if (defParse:find(".00")) then
        defParse = string.format("%.0f%s", n, suffixes[index])
    end

    return defParse
end

Synchronizer:WaitAndCall(player, function(playerData)

    local config = getgenv().RecryParserConfig

    local animals = playerData:Get("AnimalPodiums")
    print(animals)
    for i,v in pairs(animals) do
        local gen = sharedAnimals:GetGeneration(v.Index, v.Mutation, v.Traits)
        if (gen >= config.Minimum) then
            
            -- print(v.Index, formatNumber(gen))

            local function createTitle(lang)
                return config.Title:gsub("{brainrot}", v.Index):gsub("{emoji}", config.Emoji):gsub("{income}", formatNumber(gen).."/"..config.suffixSec[lang]):gsub("{translationText}", config.translationText[lang])
            end

            local mutationCurrent = v.Mutation or "Default"
            local traits = ""

            if (v.Traits) then
                for i,v2 in pairs(v.Traits) do
                    traits = traits..v2;

                    if (v.Traits[i+1] ~= nil) then
                        traits = traits..", "
                    end
                end
            end

            local function createDesc(lang)
                return config.description:gsub("{brainrot}", v.Index)
                :gsub("{emoji}", config.Emoji)
                :gsub("{income}", formatNumber(gen).."/"..config.suffixSec[lang])
                :gsub("{mutationTranslation}", config.mutationTranslation[lang])
                :gsub("{mutation}", mutationCurrent)
                :gsub("{buffsTranslation}", config.buffsTranslation[lang])
                :gsub("{buffs}", if traits == "" then config.noBuffs[lang] else traits)
            end

            local function createAutoAnswer(lang)
                if (config.AutoAnswerEnabled) then
                    return config.FriendRequestText:gsub("{brainrot}", v.Index)
                    :gsub("{sendTranslation}", config.sendTranslation[lang])
                    :gsub("{account}", config.FriendRequestTo)
                else    
                    return ""
                end
            end



            local titleRU = createTitle("ru")
            local titleEN = createTitle("en")

            local descRU = createDesc("ru")
            local descEN = createDesc("en")

            local answerRU = createAutoAnswer("ru")
            local answerEN = createAutoAnswer("ru")

            local datSlot = {
                sourceTitle = titleRU..", Предметы, Трейд",
                data = {
                    form_created_at = "1767203419",
                    offer_id = "61104895",
                    node_id = "3503",
                    deleted = "",
                    ["fields[type]"] = "Предметы",
                    ["fields[method]"] = "Трейд",
                    ["fields[summary][ru]"] = titleRU,
                    ["fields[summary][en]"] = titleEN,
                    ["fields[desc][ru]"] = descRU,
                    ["fields[desc][en]"] = descEN,
                    ["fields[payment_msg][ru]"] = answerRU,
                    ["fields[payment_msg][en]"] = answerEN,
                    secrets = "",
                    price = "99999",
                    amount = "1",
                    active = if config.LotEnable then "on" else "off"
                }
            }
            
            table.insert(result, datSlot)



        end
    end

    writefile("SavedParse.json", game:GetService("HttpService"):JSONEncode(result))

    if config.KickAfterParse then
        player:Kick("Парсинг завершён. Результат сохранен в SavedParse.json | Брейнротов найдено: "..tostring(#result))
    end

end)
