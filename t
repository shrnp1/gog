--] Boot [--
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SRVRHOLDER/alphax/main/lib.lua"))()

--] Window [--
local Window = Library:CreateWindow('AlphaX', 'Dragon Soul', 'Welcome to AlphaX!', 'rbxassetid://0', false, 'AlphaX', 'Default')

--] Locals [--
local ts = game:GetService("TweenService")
local plr = game.Players.LocalPlayer
local char = plr.Character
local hum = char:WaitForChild("Humanoid")
local vim = game:GetService('VirtualInputManager')
local hrp = char:WaitForChild("HumanoidRootPart")
local Players = game:GetService("Players")
local TeleportService = game:GetService ("TeleportService")
local PlaceId = game.PlaceId

--] Extra Locals [--
local farm = false
local doingquest = false
local mob = "Thief Boss" -- mob selected in dropdown
local npcs_folder = workspace.Main.Live -- folder
local selectednpc = nil -- it will be the 'model'
local selectedmob = nil
local AttackMethod = "Kill Aura"
local foundmob = nil
local rmquestfolder = game:GetService("Players").LocalPlayer.QuestRemoteEvents
local selectedquest = nil
local teleportType = "Tween" -- CFrame or Tween
local amount = 1
local doingloot = false
local selectedloot = nil
local maps = game:GetService("Workspace").Map

local questNames = { -- aaaa my fingers
    "Thief Boss",
    "Sell Tier 2"
    "Witch",
    "Yeti",
    "Bear Minion",
    "Bear King",
    "Alien",
    "Rogue Experiments",
    "Green Saibaman",
    "Red Saibaman",
    "Monster Saibablue",
    "Mountain Fighter",
    "Evil Namekian",
    "Martial Artists",
    "Spopov",
    "Yam",
    "Mobster",
    "Mob Mobster",
    "Elite Alien",
    "Funny Guy",
    "Saibablue",
    "Mutant Saibablue",
    "Evil Saiyan",
    "Postboy Namekian",
    "Greater Spopov",
    "Greater Yam",
    "Evil Majin",
    "Elite Saiyan",
    "Prototype Android",
    "Corrupted Kai",
    "Robert",
    "Boku Black",
    "Turles",
    "Nappa",
    "Desert Bandit",
    "Ajax Follower",
    "Ghost",
    "Grand Patrol Recruit",
    "Yeti",
    "Criminal",
    "Rad City Grunt",
    "Saiyan Soldier",
    "Namekian Mercenaries",
    "General Saibaman",
    "Demons",
    "Resurrected Villain"
    
}

local islandNames = {"Jungle Island", "Great Ape Westeland", "Great Plains Island", "Galactic Patrol Island", "Power Tower Island", "Rad Ribbon Island", "Squid Town", "Tree Island", "Destroyed City", "East City"}

local mobPositions = {
    ["Turles"] = Vector3.new(-2765.829345703125, 1466.254638671875, -6175.0419921875),
    ["Nappa"] = Vector3.new(-1070.86376953125, 420.6603698730469, 4223.263671875),
    ["Sell Tier 2"] = Vector3.new(-6080.5576171875, 2335.493408203125, 8781.01953125),
    ["Yeti"] = Vector3.new(-4889.08447265625, 683.5237426757812, -95.19535827636719),
    ["Witch"] = Vector3.new(1066.06201171875, 626.2180786132812, 1039.60400390625),
    ["Ape"] = Vector3.new(-1883.9521484375, 387.333984375, -10719.310546875),
    ["Rogue Experiments"] = Vector3.new(-1479.063232421875, 447.49615478515625, -2792.845458984375),
    ["Bear Minion"] = Vector3.new(-1216.9674072265625, 452.69580078125, -2704.2802734375),
    ["King Bear"] = Vector3.new(-1216.9674072265625, 452.69580078125, -2704.2802734375),
    ["Alien"] = Vector3.new(-1303.8653564453125, 446.894775390625, -2669.360107421875),
    ["Thief"] = Vector3.new(-1129.250732421875, 371.4959716796875, -3004.763427734375),
    ["Thief Boss"] = Vector3.new(-1129.250732421875, 371.4959716796875, -3004.763427734375),
    ["Green Saibaman"] = Vector3.new(-1599.1639404296875, 446.8959045410156, -3080.174560546875),
    ["Red Saibaman"] = Vector3.new(-1599.1639404296875, 446.8959045410156, -3080.174560546875),
    ["Monster Saibablue"] = Vector3.new(-1564.9859619140625, 446.8959045410156, -3246.739990234375),
    ["Mountain Fighter"] = Vector3.new(-1466.444091796875, 481.0957946777344, -3372.070556640625),
    ["Evil Namekian"] = Vector3.new(-996.7686157226562, 485.29583740234375, -3306.4765625),
    ["Martial Artists"] = Vector3.new(-979.8544921875, 649.8385009765625, -3205.873291015625),
    ["Spopov"] = Vector3.new(-709.7240600585938, 453.59814453125, -3202.16162109375),
    ["Yam"] = Vector3.new(-709.7240600585938, 453.59814453125, -3202.16162109375),
    ["Farmer"] = Vector3.new(-675.0194702148438, 506.6448669433594, -2788.84130859375),
    ["Mobster"] = Vector3.new(-715.26318359375, 391.0121765136719, -5393.8251953125),
    ["Mob Boss"] = Vector3.new(-876.4803466796875, 380.9648132324219, -5444.35986328125),
    ["Elite Alien"] = Vector3.new(-1043.607177734375, 380.4270324707031, -5529.52001953125),
    ["Funny Guy"] = Vector3.new(-1203.9664306640625, 380.4270324707031, -5695.42138671875),
    ["Saibablue"] = Vector3.new(-1229.8653564453125, 428.23809814453125, -6604.365234375),
    ["Mutant Saibaman"] = Vector3.new(-1333.634521484375, 428.23809814453125, -6703.60888671875),
    ["Evil Saiyan"] = Vector3.new(-849.1685791015625, 404.3348083496094, -6397.599609375),
    ["Postboy Namekian"] = Vector3.new(-257.0050964355469, 413.2306213378906, -6869.85546875),
    ["Greater Spopov"] = Vector3.new(238.03274536132812, 431.7798767089844, -6451.9267578125),
    ["Greater Yam"] = Vector3.new(238.03274536132812, 431.7798767089844, -6451.9267578125),
    ["Evil Majin"] = Vector3.new(674.0328979492188, 551.2152099609375, -6346.71142578125),
    ["Elite Saiyan"] = Vector3.new(-3082.690673828125, 513.1109619140625, -6233.69677734375),
    ["Robert"] = Vector3.new(-3443.262939453125, 516.8466186523438, -4232.27490234375),
    ["Prototype Android"] = Vector3.new(-3289.005126953125, 646.3092041015625, -4799.3076171875),
    ["Corrupted Kai"] = Vector3.new(-4295.33544921875, 603.7470092773438, -4917.296875),
    ["Boku Black"] = Vector3.new(-4282.38232421875, 671.7479858398438, -4149.2099609375),
    ["Desert Bandit"] = Vector3.new(-1611.2412109375, 398.50054931640625, -10119.3125),
    ["Ajax Follower"] = Vector3.new(-2230.973388671875, 395.3345947265625, -8715.505859375),
    ["Ghost"] = Vector3.new(-1023.784423828125, 398.333984375, -9470.7021484375),
    ["Grand Patrol Recruit"] = Vector3.new(-4425.74267578125, 488.967041015625, -358.7117614746094),
    ["Yeti"] = Vector3.new(-4712.41796875, 535.1127319335938, -222.97975158691406),
    ["Yeti King"] = Vector3.new(-4893.234375, 710.4986572265625, 19.208362579345703),
    ["Android 13"] = Vector3.new(-7707.2060546875, 410.0499267578125, 994.8419799804688),
    ["Criminal"] = Vector3.new(-2846.64892578125, 521.5001220703125, 4013.404541015625),
    ["Rad City Grunt"] = Vector3.new(-3272.364501953125, 421.7643737792969, 3720.447265625),
    ["Saiyan Soldier"] = Vector3.new(-2546.2802734375, 422.764404296875, 4104.0859375),
    ["Namekian Mercenaries"] = Vector3.new(-3010.73681640625, 422.76434326171875, 4878.26123046875),
    ["General Saibaman"] = Vector3.new(-2341.474609375, 422.7643737792969, 4535.72119140625),
    ["Demons"] = Vector3.new(-2665.125244140625, 422.763916015625, 3638.4794921875),
    ["Resurrected Villain"] = Vector3.new(-1974.1162109375, 488.6253967285156, 4843.640625),
}

local islandpos = {
    ["Jungle Island"] = Vector3.new(-1157.947509765625, 371.4959411621094, -2971.9091796875),
    ["Great Ape Westeland"] = Vector3.new(-1157.947509765625, 371.4959411621094, -2971.9091796875),
    ["Great Plains Island"] = Vector3.new(-1157.947509765625, 371.4959411621094, -2971.9091796875),
    ["Galactic Patrol Island"] = Vector3.new(-1157.947509765625, 371.4959411621094, -2971.9091796875),
    ["Power Tower Island"] = Vector3.new(-1157.947509765625, 371.4959411621094, -2971.9091796875),
    ["Rad Ribbon Island"] = Vector3.new(-1157.947509765625, 371.4959411621094, -2971.9091796875),
    ["Squid Town"] = Vector3.new(-1157.947509765625, 371.4959411621094, -2971.9091796875),
    ["Tree Island"] = Vector3.new(-1157.947509765625, 371.4959411621094, -2971.9091796875),
    ["Destroyed City"] = Vector3.new(-1157.947509765625, 371.4959411621094, -2971.9091796875),
    ["East City"] = Vector3.new(-1157.947509765625, 371.4959411621094, -2971.9091796875)
}

--] Functions [--

function getquest(quest)
    local questRemoteEvents = game:GetService("Players").LocalPlayer.QuestRemoteEvents

    if quest == "Thief Boss" then
        questRemoteEvents:WaitForChild("DefeatThievesBoss"):FireServer(1)
    elseif quest == "Bear Minion" then
        questRemoteEvents:WaitForChild("DefeatBearMinions"):FireServer(1)
    elseif quest == "Bear King" then
        questRemoteEvents:WaitForChild("DefeatBearKing"):FireServer(1)
    elseif quest == "Alien" then
        questRemoteEvents:WaitForChild("DefeatAliens"):FireServer(1)
    elseif quest == "Rogue Experiments" then
        questRemoteEvents:WaitForChild("EscapedTestSubjects"):FireServer(1)
    elseif quest == "Green Saibaman" then
        questRemoteEvents:WaitForChild("DefeatGreenSaibaman"):FireServer(1)
    elseif quest == "Red Saibaman" then
        questRemoteEvents:WaitForChild("DefeatRedSaibaman"):FireServer(1)
    elseif quest == "Monster Saibablue" then
        questRemoteEvents:WaitForChild("DefeatPurpleSaibaman"):FireServer(1)
    elseif quest == "Mountain Fighter" then
        questRemoteEvents:WaitForChild("DefeatMountainFighters"):FireServer(1)
    elseif quest == "Evil Namekian" then
        questRemoteEvents:WaitForChild("DefeatNamekians"):FireServer(1)
    elseif quest == "Martial Artists" then
        questRemoteEvents:WaitForChild("JungleInvasion"):FireServer(1)
    elseif quest == "Spopov" or quest == "Yam" then
        questRemoteEvents:WaitForChild("DefeatTheDynamicDuo"):FireServer(1)
    elseif quest == "Mobster" then
        questRemoteEvents:WaitForChild("PHQ1"):FireServer(1)
    elseif quest == "Mob Mobster" then
        questRemoteEvents:WaitForChild("PHQ2"):FireServer(1)
    elseif quest == "Elite Alien" then
        questRemoteEvents:WaitForChild("PHQ3"):FireServer(1)
    elseif quest == "Funny Guy" then
        questRemoteEvents:WaitForChild("PHQ4"):FireServer(1)
    elseif quest == "Saibablue" then
        questRemoteEvents:WaitForChild("PHQ6"):FireServer(1)
    elseif quest == "Mutant Saibaman" then
        questRemoteEvents:WaitForChild("PHQ7"):FireServer(1)
    elseif quest == "Evil Saiyan" then
        questRemoteEvents:WaitForChild("PHQ8"):FireServer(1)
    elseif quest == "Postboy Namekian" then
        questRemoteEvents:WaitForChild("PHQ9"):FireServer(1)
    elseif quest == "Greater Spopov" or quest == "Greater Yam" then
        questRemoteEvents:WaitForChild("PHQ10"):FireServer(1)
    elseif quest == "Evil Majin" then
        questRemoteEvents:WaitForChild("PHQ11"):FireServer(1)
    elseif quest == "Elite Saiyan" then
        questRemoteEvents:WaitForChild("PHQ12"):FireServer(1)
    elseif quest == "Prototype Android" then
        questRemoteEvents:WaitForChild("PHQ13"):FireServer(1)
    elseif quest == "Corrupted Kai" then
        questRemoteEvents:WaitForChild("PHQ14"):FireServer(1)
    elseif quest == "Robert" then
        questRemoteEvents:WaitForChild("PHQ15"):FireServer(1)
    elseif quest == "Boku Black" then
        questRemoteEvents:WaitForChild("PHQ16"):FireServer(1)
    elseif quest == "Yeti" then
        questRemoteEvents:WaitForChild("ReportedSightings"):FireServer(1)
    elseif quest == "Nappa" then
        questRemoteEvents:WaitForChild("Events"):FireServer(1)   
    elseif quest == "Witch" then
        questRemoteEvents:WaitForChild("Events"):FireServer(1)    
    elseif quest == "Desert Bandit" then
        questRemoteEvents:WaitForChild("DefeatDesertBandits"):FireServer(1)
    elseif quest == "Ajax Follower" then
        questRemoteEvents:WaitForChild("AjaxFollower"):FireServer(1)
    elseif quest == "Ghost" then
        questRemoteEvents:WaitForChild("DefeatGhosts"):FireServer(1)
    elseif quest == "Grand Patrol Recruit" then
        questRemoteEvents:WaitForChild("DefeatRecruit"):FireServer(1)
    elseif quest == "Yeti" then
        questRemoteEvents:WaitForChild("ReportedSightings"):FireServer(1)
    elseif quest == "Criminal" then
        questRemoteEvents:WaitForChild("Thievery"):FireServer(1)
    elseif quest == "Rad City Grunt" then
        questRemoteEvents:WaitForChild("RadIsback"):FireServer(1)
    elseif quest == "Saiyan Soldier" then
        questRemoteEvents:WaitForChild("SuperSaiyans"):FireServer(1)
    elseif quest == "Namekian Mercenaries" then
        questRemoteEvents:WaitForChild("NamekianMercenaries"):FireServer(1)
    elseif quest == "General Saibaman" then
        questRemoteEvents:WaitForChild("PlaygroundTerror"):FireServer(1)
    elseif quest == "Demons" then
        questRemoteEvents:WaitForChild("DailyDemons"):FireServer(1)
    elseif quest == "Resurrected Villain" then
        questRemoteEvents:WaitForChild("Reconnaissance"):FireServer(1)
    else
        warn("Mob quest not found")
    end
end


function addstat(stat,amnt)
local ohString1 = stat
local ohNumber2 = amnt

game:GetService("ReplicatedStorage").RemoteEvents.AttemptIncrementStatPoint:FireServer(ohString1, ohNumber2)
end

function teleport(mob)
    local mobPosition = mob:WaitForChild("HumanoidRootPart").Position
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
    local humanoid = hum
    
    humanoid.PlatformStand = true
    local tween = ts:Create(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), tweenInfo, {Position = mobPosition})
    
    tween:Play()
    tween.Completed:Wait()
end

function teleport(mob) -- for mob
    local mobPosition = mob:WaitForChild("HumanoidRootPart").Position

    if teleportType == "CFrame" then
        game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(mobPosition)
    elseif teleportType == "Tween" then
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
        local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
if humanoid then
        humanoid.PlatformStand = true
        local tween = ts:Create(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), tweenInfo, {Position = mobPosition})

        tween:Play()
        tween.Completed:Wait()
     end
     else
     wait()
  end
end


function tele(pos) -- for position idk a name to this
    if teleportType == "CFrame" then
        game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(pos)
    elseif teleportType == "Tween" then
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
        local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")

        humanoid.PlatformStand = true
        local tween = ts:Create(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), tweenInfo, {Position = pos})

        tween:Play()
        tween.Completed:Wait()
    end
end

function findNearestNPC(player) 
        -- initialize the shortest distance
        local shortestDistance = math.huge 

        -- initialize the nearest NPC
        local nearestNPC = nil

        -- loop through all NPCs
        for _, npc in ipairs(npcs_folder:GetChildren()) do
            -- check if the NPC is not a player character and if it's the selected mob
            if not game.Players:GetPlayerFromCharacter(npc) and npc.Name == mob then
                -- calculate the distance to the NPC
                local distance = (npc:WaitForChild("HumanoidRootPart").Position - player.Character.PrimaryPart.Position).magnitude

                -- if this distance is shorter than the current shortest distance, update the shortest distance and nearest NPC
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestNPC = npc
                    -- you can use 'print(nearestNPC)' to see the selected npc
                end
            end
        end

        -- return the nearest NPC and its distance to the player
        return nearestNPC, shortestDistance
    end

function attackWithVirtualClick()
   vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
end 

function callprompt(prompt)
fireproximityprompt(prompt, 1, true)
end

--] Tabs [--

local Home = Window:CreateTab('Home', true, 'rbxassetid://0', Vector2.new(484, 44), Vector2.new(36, 36))

local Farm = Window:CreateTab('Farm', true, 'rbxassetid://0', Vector2.new(484, 44), Vector2.new(36, 36))

local Points = Window:CreateTab('Points', true, 'rbxassetid://0', Vector2.new(484, 44), Vector2.new(36, 36))

local Teleports = Window:CreateTab('Teleport', true, 'rbxassetid://0', Vector2.new(484, 44), Vector2.new(36, 36))

local Misc = Window:CreateTab('Misc', true, 'rbxassetid://0', Vector2.new(484, 44), Vector2.new(36, 36))

local Settings = Window:CreateTab('Settings', true, 'rbxassetid://0', Vector2.new(484, 44), Vector2.new(36, 36))

--] Sections [--

local Level = Farm:CreateSection('Level Farm')

local Configs = Settings:CreateSection('Farm Config')

local Island = Teleports:CreateSection('Islands')

local Auto = Points:CreateSection('Auto Points')

local Useful = Misc:CreateSection('Useful things')

--] Buttons [--

local Island1 = Island:CreateButton('Jungle Island (Start Island)', function()
    hrp.Position = Vector3.new(-1157.947509765625, 371.4959411621094, -2971.9091796875)
end)

local Island2 = Island:CreateButton('East City', function()
    hrp.Position = Vector3.new(-2849.2109375, 646.6458740234375, 3467.677734375)
end)

local Island3 = Island:CreateButton('Destroyed City', function()
    hrp.Position = Vector3.new(-2875.5712890625, 603.77197265625, -5244.017578125)
end)

local Island4 = Island:CreateButton('Galatic Patrol Island', function()
    hrp.Position = Vector3.new(-3767.85791015625, 426.56781005859375, -975.8282470703125)
end)

local Island5 = Island:CreateButton('Grand Surveillance Site', function()
    hrp.Position = Vector3.new(-1833.1131591796875, 424.76422119140625, 3362.51953125)
end)

local Island6 = Island:CreateButton('Great Ape Westland', function()
    hrp.Position = Vector3.new(-408.2165832519531, 401.9606628417969, -10324.5751953125)
end)

local Island7 = Island:CreateButton('Great Plains Island', function()
    hrp.Position = Vector3.new(-1001.2476196289062, 380.4270324707031, -5523.01220703125)
end)

local Island8 = Island:CreateButton('Power Tower Island', function()
    hrp.Position = Vector3.new(-7772.259765625, 457.64990234375, 1246.0604248046875)
end)

local Island9 = Island:CreateButton('Rad Ribbon Island', function()
    hrp.Position = Vector3.new(1995.3524169921875, 465.64990234375, -3207.902587890625)
end)

local Island10 = Island:CreateButton('Squid Town', function()
    hrp.Position = Vector3.new(-1097.5382080078125, 145.03456115722656, -4050.289306640625)
end)

local Island11 = Island:CreateButton('Tree Island', function()
    hrp.Position = Vector3.new(-2795.547119140625, 571.4552001953125, -6629.16845703125)
end)

--] Level Dropdowns [--

local Dropdown_Mob = Level:CreateDropdown("Select a Mob", {"nil","Ape", "Turles", "Nappa", "Yeti", "Witch", "Sell Tier 2", "Thief", "Thief Boss", "Bear Minion", "Bear King", "Aien", "Rogue Experiments", "Green Saibaman", "Red Saibaman", "Mountain Fighter", "Monster Saibablue", "Evil Namekian", "Martial Artists", "Spopov", "Yam", "Farmer", "Mobster", "Mob Mobster", "Elite Alien", "Funny Guy", "Saibablue", "Mutant Saibaman", "Evil Saiyan", "Postboy Namekian", "Greater Spopov", "Greater Yam", "Evil Majin", "Evil Saiyan", "Prototype Android", "Corrupted Kai", "Robert", "Boku Black", "Desert Bandit", "Ajax Follower" }, "nil", 0.25, function(newmobxd)
    mob = newmobxd
end)

-- Toggles [--

local Proximity = Useful:CreateToggle('Loot Aura', false, Color3.fromRGB(0, 125, 255), 0.25, function(valuee5)
    while valuee5 do
        local player = game.Players.LocalPlayer
        local playerPosition = player.Character and player.Character.PrimaryPart.Position

for _, item in pairs(workspace.ActiveDrops:GetDescendants()) do
    if item:IsA('ProximityPrompt') then
        callprompt(item)
    end
end
wait()
end
end)

local Toggle_Lootbox = Useful:CreateToggle('Auto Lootbox', false, Color3.fromRGB(0, 125, 255), 0.25, function(newidk)
    doingloot = newidk
    while doingloot do

        local mapsFolder = game.Workspace.Map
        if mapsFolder then

            for _, island in ipairs(mapsFolder:GetChildren()) do
                local devFolder = island:FindFirstChild('_Dev')
                if devFolder then
                    local lootboxesFolder = devFolder:FindFirstChild('Lootboxes')
                    if lootboxesFolder then

                        -- Pegue todas as crianças dentro da pasta "lootboxes"
                        local allChildren = lootboxesFolder:GetChildren()

                        for _, child in ipairs(allChildren) do
                            -- Verifique se a criança é um modelo e tem uma criança chamada 'Common'
                            if child:IsA("Model") and child:FindFirstChild('Common') then
                                local idkmodellol = child.Common
                                hum.PlatformStand = true

                                tele(idkmodellol.Crate.Position)

                                hum.PlatformStand = false

                                callprompt(idkmodellol.CrateDoor.ProximityPrompt)

                                -- Aguarde 1 segundo antes de teleportar para a próxima caixa de saque
                                wait(1)
                            end
                        end
                    end
                end
            end
        end
        
    end
    
end)

local Toggle_Farm = Level:CreateToggle('Start Farm', false, Color3.fromRGB(0, 125, 255), 0.25, function(newvalue)
    farm = newvalue
end)

local Toggle_Farm = Level:CreateToggle('Auto Quest', false, Color3.fromRGB(0, 125, 255), 0.25, function(questinglol)
    doingquest = questinglol
end)

local Sliderxd = Auto:CreateSlider('Amount of Points', 1, 1000, 1, Color3.fromRGB(0, 125, 255), function(newslidervalue)
    amount = newslidervalue
end)

local Toggle_Points_Str = Auto:CreateToggle('Auto Strength', false, Color3.fromRGB(0, 125, 255), 0.25, function(valuee1)
    while valuee1 do
        wait()
        addstat("Strength", amount)
    end
end)

local Toggle_Points_Ki = Auto:CreateToggle('Auto Ki Power', false, Color3.fromRGB(0, 125, 255), 0.25, function(valuee2)
    while valuee2 do
        wait()
        addstat("KiPower", amount)
    end
end)

local Toggle_Points_Htl = Auto:CreateToggle('Auto Health', false, Color3.fromRGB(0, 125, 255), 0.25, function(valuee3)
    while valuee3 do
        wait()
        addstat("MaxHealth", amount)
    end
end)

local Toggle_Points_Htl = Auto:CreateToggle('Auto Max Ki', false, Color3.fromRGB(0, 125, 255), 0.25, function(valuee4)
    while valuee4 do
        wait()
        addstat("KiMax", amount)
    end
end)

--] Buttons [--

local Rejoin = Useful:CreateButton('Rejoin', function()
-- not made by me, Creator: POTATO228
local Rejoin = coroutine.create(function()
    local Success, ErrorMessage = pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
 
    if ErrorMessage and not Success then
        warn(ErrorMessage)
    end
end)
 
coroutine.resume(Rejoin)
end)

local ServerHop = Useful:CreateButton('Serverhop', function()
-- not made by me, Creator: idk who made it (guest)
  local PlaceID = game.PlaceId
          local AllIDs = {}
          local foundAnything = ""
          local actualHour = os.date("!*t").hour
          local Deleted = false
          --[[
          local File = pcall(function()
              AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
          end)
          if not File then
              table.insert(AllIDs, actualHour)
              writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
          end
          ]]
          function TPReturner()
              local Site;
              if foundAnything == "" then
                  Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
              else
                  Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
              end
              local ID = ""
              if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                  foundAnything = Site.nextPageCursor
              end
              local num = 0;
              for i,v in pairs(Site.data) do
                  local Possible = true
                  ID = tostring(v.id)
                  if tonumber(v.maxPlayers) > tonumber(v.playing) then
                      for _,Existing in pairs(AllIDs) do
                          if num ~= 0 then
                              if ID == tostring(Existing) then
                                  Possible = false
                              end
                          else
                              if tonumber(actualHour) ~= tonumber(Existing) then
                                  local delFile = pcall(function()
                                      -- delfile("NotSameServers.json")
                                      AllIDs = {}
                                      table.insert(AllIDs, actualHour)
                                  end)
                              end
                          end
                          num = num + 1
                      end
                      if Possible == true then
                          table.insert(AllIDs, ID)
                          wait()
                          pcall(function()
                              -- writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                              wait()
                              game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                          end)
                          wait(4)
                      end
                  end
              end
          end
 
          function Teleport()
              while wait() do
                  pcall(function()
                      TPReturner()
                      if foundAnything ~= "" then
                          TPReturner()
                      end
                  end)
              end
          end
 
          Teleport()
end)

--] Config Dropdown [--

local Dropdown_Mob = Configs:CreateDropdown('Select a Attack Method', {'Kill Aura', 'Virtual Click'}, 'Kill Aura', 0.25, function(newconfig)
    AttackMethod = newconfig
end)

local Dropdown_Teleport = Configs:CreateDropdown("Select a Teleport Type", {"Tween", "CFrame"}, "Tween", 0.25, function(newtp)
    teleportType = newtp
end)

-- Main Loop
while wait() do
    if mob and farm then
        if doingquest then
            getquest(mob)
        end

        local selectedmob = npcs_folder:FindFirstChild(mob)

        if selectedmob then
            teleport(selectedmob)

            if AttackMethod == "Kill Aura" then
                local nearestNPC, distance = findNearestNPC(game.Players.LocalPlayer)
                
                if nearestNPC and distance <= 10 and not game.Players:GetPlayerFromCharacter(nearestNPC) then
                    vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    
                    local main = {
                        ["Victim"] = nearestNPC,
                        ["Type"] = "Light",
                        ["VictimPosition"] = nearestNPC:WaitForChild("HumanoidRootPart").Position,
                        ["CurrentHeavy"] = 1,
                        ["CurrentLight"] = 1,
                        ["CurrentLightCombo"] = 1,
                        ["LocalInfo"] = {
                            ["Flying"] = false
                        },
                        ["AnimSet"] = "Generic"
                    }

                    game:GetService("ReplicatedStorage").Events.TryAttack:FireServer(main)
                end
            elseif AttackMethod == "Virtual Click" then
                attackWithVirtualClick()
            end
        else
            hum.PlatformStand = false
            local location = mobPositions[mob]
            if location then
                tele(location)
            else
                Library:CreateNotification('Warning', 'This mob doesnt have a quest.', 5)
            end
        end
    else
        if mob ~= nil and farm == true and doingquest == false then
            if doingquest then
                getquest(mob)
            end
            selectedmob = npcs_folder:FindFirstChild(mob)
            if selectedmob then
                teleport(selectedmob)
                if AttackMethod == "Kill Aura" then
                    local npcs = workspace.Main.Live
                    local distance = 10
                    local nearestnpc = nil 
                    local isfarming = true 

                    local nearestNPC, distance = findNearestNPC(game.Players.LocalPlayer)
                    
                    if nearestNPC and distance <= 10 and not game.Players:GetPlayerFromCharacter(nearestNPC) then

                        vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        
                        local main = {
                            ["Victim"] = nearestNPC,
                            ["Type"] = "Light",
                            ["VictimPosition"] = nearestNPC:WaitForChild("HumanoidRootPart").Position,
                            ["CurrentHeavy"] = 1,
                            ["CurrentLight"] = 1,
                            ["CurrentLightCombo"] = 1,
                            ["LocalInfo"] = {
                                ["Flying"] = false
                            },
                            ["AnimSet"] = "Generic"
                        }

                        game:GetService("ReplicatedStorage").Events.TryAttack:FireServer(main)
                    end
                    
                elseif AttackMethod == "Virtual Click" then
                    attackWithVirtualClick()
                end
            else
                hum.PlatformStand = false
                local location = mobPositions[mob]
                if location then
                    tele(location)
                    else
                    Library:CreateNotification('Warning', 'This mob doesnt have a quest.', 5)
                end
            end
        end
    end
end
