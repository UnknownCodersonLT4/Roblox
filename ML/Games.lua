--#region INITIALIZATION
local whitelistedUsers = {"axxoryyy", "C4OS_Ld", "NW_GlitcherLambda", "Matias_XD2021", "12345AB801", "BloodPuppit2", "LK_HAZ2", "JayTonCost_24k", "singkomong04", " Mrbignewcoming3", "Shadow_RipperZ0", "Elijahbetter785","Backaccountgotstolen"}
local player = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")

-- Whitelist check with instant kick
if not table.find(whitelistedUsers, player.Name) then
    player:Kick("Not WhiteListed L")
    return
end

-- Load library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/UnknownCodersonLT4/Roblox/refs/heads/main/ML/libaray", true))()
local window = library:AddWindow("Private  V2  |   Made For Cup  ", {
    main_color = Color3.fromRGB(0, 0, 0),
    min_size = Vector2.new(700, 550),
    can_resize = false
})

-- Shared functions
local function abbreviateNumber(num)
    if num >= 1e15 then return string.format("%.1fQa", num/1e15) end
    if num >= 1e12 then return string.format("%.1fT", num/1e12) end
    if num >= 1e9 then return string.format("%.1fB", num/1e9) end
    if num >= 1e6 then return string.format("%.1fM", num/1e6) end
    if num >= 1e3 then return string.format("%.1fK", num/1e3) end
    return tostring(math.floor(num))
end
--#endregion

--#region MISC TAB
local Misc = window:AddTab("Misc")

-- Lock Position Feature
local lockPosition = false
local lockedPosition = nil
local positionLockConnection = nil

Misc:AddSwitch("Lock Position", function(state)
    lockPosition = state
    if lockPosition then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            lockedPosition = player.Character.HumanoidRootPart.CFrame
            positionLockConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = lockedPosition
                end
            end)
        end
    else
        if positionLockConnection then
            positionLockConnection:Disconnect()
            positionLockConnection = nil
        end
    end
end)

-- Anti-AFK
Misc:AddSwitch("Anti-AFK", function(state)
    if state then
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

-- Destroy Ad Teleport
Misc:AddButton("Destroy Ad Teleport", function()
    local part = workspace:FindFirstChild("RobloxForwardPortals")
    if part then
        part:Destroy()
    end
end)

-- No Ping
local noPing = false
local batchedCalls = {}
local originalFireServer = player.muscleEvent.FireServer

local function flushBatchedCalls()
    if #batchedCalls > 0 then
        for _, call in ipairs(batchedCalls) do
            originalFireServer(player.muscleEvent, unpack(call))
        end
        batchedCalls = {}
    end
end

Misc:AddSwitch("No Ping", function(state)
    noPing = state
    if noPing then
        -- Optimize network communication by batching calls
        player.muscleEvent.FireServer = function(self, ...)
            table.insert(batchedCalls, {...})
            if #batchedCalls >= 10 then -- Adjust the batch size as needed
                flushBatchedCalls()
            end
        end

        -- Flush batched calls periodically
        game:GetService("RunService").Heartbeat:Connect(function()
            flushBatchedCalls()
        end)
    else
        -- Restore original FireServer method
        player.muscleEvent.FireServer = originalFireServer
    end
end)

-- No Graphic
local noGraphic = false
local originalLighting = nil
local originalTerrain = nil

Misc:AddSwitch("No Graphic", function(state)
    noGraphic = state
    if noGraphic then
        -- Save original lighting and terrain settings
        originalLighting = game.Lighting:Clone()
        originalTerrain = workspace.Terrain:Clone()

        -- Remove textures and graphics
        game.Lighting.GlobalShadows = false
        game.Lighting.FogEnd = 100
        game.Lighting.Brightness = 0
        workspace.Terrain:Clear()
    else
        -- Restore original lighting and terrain settings
        if originalLighting then
            originalLighting.Parent = game.Lighting
        end
        if originalTerrain then
            originalTerrain.Parent = workspace
        end
    end
end)
--#endregion

--#region OP THINGS TAB
local OpThings = window:AddTab("OP Things")

-- Fast Strength (Standard)
OpThings:AddSwitch("Fast Strength", function(state)
    for _ = 1, 20 do
        task.spawn(function()
            while state and task.wait() do
                player.muscleEvent:FireServer("rep")
            end
        end)
    end
end)

-- Ultra Fast Strength (0.00001 speed)
OpThings:AddSwitch("Ultra Fast Strength", function(state)
    for _ = 1, 100 do
        task.spawn(function()
            while state and task.wait(0.00001) do
                player.muscleEvent:FireServer("rep")
            end
        end)
    end
end)

-- Optimized Fast Rebirth
OpThings:AddSwitch("Fast Rebirth", function(fastRebirth)
    if fastRebirth then
        spawn(function()
            local a = game:GetService("ReplicatedStorage")
            local b = game:GetService("Players")
            local c = b.LocalPlayer

            local d = function(e)
                local f = c.petsFolder
                for g, h in pairs(f:GetChildren()) do
                    if h:IsA("Folder") then
                        for i, j in pairs(h:GetChildren()) do
                            a.rEvents.equipPetEvent:FireServer("unequipPet", j)
                        end
                    end
                end
                task.wait(.1)
            end

            local k = function(l)
                d()
                task.wait(.01)
                for m, n in pairs(c.petsFolder.Unique:GetChildren()) do
                    if n.Name == l then
                        a.rEvents.equipPetEvent:FireServer("equipPet", n)
                    end
                end
            end

            local o = function(p)
                local q = workspace.machinesFolder:FindFirstChild(p)
                if not q then
                    for r, s in pairs(workspace:GetChildren()) do
                        if s:IsA("Folder") and s.Name:find("machines") then
                            q = s:FindFirstChild(p)
                            if q then break end
                        end
                    end
                end
                return q
            end

            local t = function()
                local u = game:GetService("VirtualInputManager")
                u:SendKeyEvent(true, "E", false, game)
                task.wait(.1)
                u:SendKeyEvent(false, "E", false, game)
            end

            while fastRebirth do
                local v = c.leaderstats.Rebirths.Value
                local w = 10000 + (5000 * v)
                if c.ultimatesFolder:FindFirstChild("Golden Rebirth") then
                    local x = c.ultimatesFolder["Golden Rebirth"].Value
                    w = math.floor(w * (1 - (x * 0.1)))
                end

                d()
                task.wait(.1)
                k("Swift Samurai")

                -- Ultra strength farming
                while c.leaderstats.Strength.Value < w do
                    for _ = 1, 50 do
                        c.muscleEvent:FireServer("rep")
                    end
                    task.wait(0.001) -- Reduced delay for faster farming
                end

                d()
                task.wait(.1)
                k("Tribal Overlord")

                local z = o("Jungle Bar Lift")
                if z and z:FindFirstChild("interactSeat") and c.Character and c.Character:FindFirstChild("HumanoidRootPart") then
                    c.Character.HumanoidRootPart.CFrame = z.interactSeat.CFrame * CFrame.new(0, 3, 0)
                    local startTime = os.time()
                    repeat
                        task.wait(.05)
                        t()
                    until c.Character.Humanoid.Sit or (os.time() - startTime > 1)
                end

                local A = c.leaderstats.Rebirths.Value
                local startTime = os.time()
                repeat
                    a.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                    task.wait(.05)
                until c.leaderstats.Rebirths.Value > A or (os.time() - startTime > 3)

                -- Switch back to Swift Samurai immediately
                d()
                task.wait(.1)
                k("Swift Samurai")
            end
        end)
    end
end)

-- Hide Frame
OpThings:AddSwitch("Hide Frame", function(state)
    for _, frame in ipairs({"strengthFrame", "durabilityFrame", "agilityFrame"}) do
        local gui = rs:FindFirstChild(frame)
        if gui then gui.Visible = not state end
    end
end)
--#endregion

--#region STATISTIC TAB
local Statistic = window:AddTab("Statistic")
Statistic:AddLabel("Rebirth Statistics:")

local statLabels = {
    RebirthsGainedLabel = Statistic:AddLabel("Rebirths Gained (1m): 0"),
    RebirthsPerMinuteLabel = Statistic:AddLabel("Rebirths/Min: 0"),
    RebirthsPerHourLabel = Statistic:AddLabel("Rebirths/Hour: 0"),
    RebirthsPerDayLabel = Statistic:AddLabel("Rebirths/Day: 0"),
    RebirthsPerWeekLabel = Statistic:AddLabel("Rebirths/Week: 0")
}

local lastRebirthCount = player.leaderstats.Rebirths.Value
local startTime = os.time()

task.spawn(function()
    while task.wait(60) do
        local currentRebirthCount = player.leaderstats.Rebirths.Value
        local rebirthsGained = math.max(0, currentRebirthCount - lastRebirthCount)
        lastRebirthCount = currentRebirthCount

        statLabels.RebirthsGainedLabel.Text = "Rebirths Gained (1m): " .. abbreviateNumber(rebirthsGained)
        statLabels.RebirthsPerMinuteLabel.Text = "Rebirths/Min: " .. abbreviateNumber(rebirthsGained)
        statLabels.RebirthsPerHourLabel.Text = "Rebirths/Hour: " .. abbreviateNumber(rebirthsGained * 60)
        statLabels.RebirthsPerDayLabel.Text = "Rebirths/Day: " .. abbreviateNumber(rebirthsGained * 1440)
        statLabels.RebirthsPerWeekLabel.Text = "Rebirths/Week: " .. abbreviateNumber(rebirthsGained * 10080)
    end
end)
--#endregion

--#region STATS TAB
local Stats = window:AddTab("Stats")
Stats:AddLabel("Your Session Stats:")

local statsLabels = {
    TimeSpentLabel = Stats:AddLabel("Time: 00:00"),
    StrengthGainedLabel = Stats:AddLabel("Strength: +0"),
    DurabilityGainedLabel = Stats:AddLabel("Durability: +0"),
    AgilityGainedLabel = Stats:AddLabel("Agility: +0"),
    KillsGainedLabel = Stats:AddLabel("Kills: +0"),
    EvilKarmaGainedLabel = Stats:AddLabel("Evil Karma: +0"),
    GoodKarmaGainedLabel = Stats:AddLabel("Good Karma: +0")
}

local initialStats = {
    Strength = player.leaderstats.Strength.Value,
    Durability = player.Durability.Value,
    Agility = player.Agility.Value,
    Kills = player.leaderstats.Kills.Value,
    EvilKarma = player.evilKarma.Value,
    GoodKarma = player.goodKarma.Value
}

local function updateStats()
    local timeSpent = os.time() - startTime
    local minutes = math.floor(timeSpent/60)
    local seconds = timeSpent % 60
    statsLabels.TimeSpentLabel.Text = string.format("Time: %02d:%02d", minutes, seconds)

    statsLabels.StrengthGainedLabel.Text = "Strength: +"..abbreviateNumber(player.leaderstats.Strength.Value - initialStats.Strength)
    statsLabels.DurabilityGainedLabel.Text = "Durability: +"..abbreviateNumber(player.Durability.Value - initialStats.Durability)
    statsLabels.AgilityGainedLabel.Text = "Agility: +"..abbreviateNumber(player.Agility.Value - initialStats.Agility)
    statsLabels.KillsGainedLabel.Text = "Kills: +"..abbreviateNumber(player.leaderstats.Kills.Value - initialStats.Kills)
    statsLabels.EvilKarmaGainedLabel.Text = "Evil Karma: +"..abbreviateNumber(player.evilKarma.Value - initialStats.EvilKarma)
    statsLabels.GoodKarmaGainedLabel.Text = "Good Karma: +"..abbreviateNumber(player.goodKarma.Value - initialStats.GoodKarma)
end

game:GetService("RunService").Heartbeat:Connect(function()
    updateStats()
end)
--#endregion

--#region VIEW STATS TAB
local ViewStats = window:AddTab("View Stats")
local targetPlayer = nil
local targetInitialStats = {}

local viewStatsLabels = {
    StrengthLabel = ViewStats:AddLabel("Strength: 0"),
    DurabilityLabel = ViewStats:AddLabel("Durability: 0"),
    AgilityLabel = ViewStats:AddLabel("Agility: 0"),
    RebirthsLabel = ViewStats:AddLabel("Rebirths: 0"),
    KillsLabel = ViewStats:AddLabel("Kills: 0"),
    EvilKarmaLabel = ViewStats:AddLabel("Evil Karma: 0"),
    GoodKarmaLabel = ViewStats:AddLabel("Good Karma: 0"),
    StrengthGainedLabel = ViewStats:AddLabel("Strength Δ: 0"),
    DurabilityGainedLabel = ViewStats:AddLabel("Durability Δ: 0"),
    AgilityGainedLabel = ViewStats:AddLabel("Agility Δ: 0"),
    RebirthsGainedLabel = ViewStats:AddLabel("Rebirths Δ: 0"),
    KillsGainedLabel = ViewStats:AddLabel("Kills Δ: 0"),
    EvilKarmaGainedLabel = ViewStats:AddLabel("Evil Karma Δ: 0"),
    GoodKarmaGainedLabel = ViewStats:AddLabel("Good Karma Δ: 0")
}

ViewStats:AddTextBox("Player Name", function(text)
    targetPlayer = game.Players:FindFirstChild(text)
    if targetPlayer then
        targetInitialStats = {
            Strength = targetPlayer.leaderstats.Strength.Value,
            Durability = targetPlayer.Durability.Value,
            Agility = targetPlayer.Agility.Value,
            Rebirths = targetPlayer.leaderstats.Rebirths.Value,
            Kills = targetPlayer.leaderstats.Kills.Value,
            EvilKarma = targetPlayer.evilKarma.Value,
            GoodKarma = targetPlayer.goodKarma.Value
        }
    else
        for _, label in pairs(viewStatsLabels) do
            label.Text = string.gsub(label.Text, "[%d%.]+", "0")
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if targetPlayer and targetPlayer:FindFirstChild("leaderstats") then
            -- Current stats
            viewStatsLabels.StrengthLabel.Text = "Strength: "..abbreviateNumber(targetPlayer.leaderstats.Strength.Value)
            viewStatsLabels.DurabilityLabel.Text = "Durability: "..abbreviateNumber(targetPlayer.Durability.Value)
            viewStatsLabels.AgilityLabel.Text = "Agility: "..abbreviateNumber(targetPlayer.Agility.Value)
            viewStatsLabels.RebirthsLabel.Text = "Rebirths: "..abbreviateNumber(targetPlayer.leaderstats.Rebirths.Value)
            viewStatsLabels.KillsLabel.Text = "Kills: "..abbreviateNumber(targetPlayer.leaderstats.Kills.Value)
            viewStatsLabels.EvilKarmaLabel.Text = "Evil Karma: "..abbreviateNumber(targetPlayer.evilKarma.Value)
            viewStatsLabels.GoodKarmaLabel.Text = "Good Karma: "..abbreviateNumber(targetPlayer.goodKarma.Value)

            -- Gained stats
            viewStatsLabels.StrengthGainedLabel.Text = "Strength Δ: "..abbreviateNumber(targetPlayer.leaderstats.Strength.Value - targetInitialStats.Strength)
            viewStatsLabels.DurabilityGainedLabel.Text = "Durability Δ: "..abbreviateNumber(targetPlayer.Durability.Value - targetInitialStats.Durability)
            viewStatsLabels.AgilityGainedLabel.Text = "Agility Δ: "..abbreviateNumber(targetPlayer.Agility.Value - targetInitialStats.Agility)
            viewStatsLabels.RebirthsGainedLabel.Text = "Rebirths Δ: "..abbreviateNumber(targetPlayer.leaderstats.Rebirths.Value - targetInitialStats.Rebirths)
            viewStatsLabels.KillsGainedLabel.Text = "Kills Δ: "..abbreviateNumber(targetPlayer.leaderstats.Kills.Value - targetInitialStats.Kills)
            viewStatsLabels.EvilKarmaGainedLabel.Text = "Evil Karma Δ: "..abbreviateNumber(targetPlayer.evilKarma.Value - targetInitialStats.EvilKarma)
            viewStatsLabels.GoodKarmaGainedLabel.Text = "Good Karma Δ: "..abbreviateNumber(targetPlayer.goodKarma.Value - targetInitialStats.GoodKarma)
        end
    end
end)
--#endregion

--#region KILLER TAB
local Killer = window:AddTab("Killer")

Killer:AddSwitch("Auto Good Karma", function(bool)
    autoGoodKarma = bool

    if autoGoodKarma then
        spawn(function()
            while autoGoodKarma do
                local player = game.Players.LocalPlayer
                local playerChar = player.Character
                local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
                local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")

                if playerChar and rightHand and leftHand then
                    for _, target in ipairs(game.Players:GetPlayers()) do
                        if target ~= player then
                            local evilKarma = target:FindFirstChild("evilKarma")
                            local goodKarma = target:FindFirstChild("goodKarma")

                            if evilKarma and goodKarma and evilKarma:IsA("IntValue") and goodKarma:IsA("IntValue") and evilKarma.Value > goodKarma.Value then
                                local targetChar = target.Character
                                local rootPart = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

                                if rootPart then
                                    firetouchinterest(rightHand, rootPart, 1)
                                    firetouchinterest(leftHand, rootPart, 1)
                                    firetouchinterest(rightHand, rootPart, 0)
                                    firetouchinterest(leftHand, rootPart, 0)
                                end
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

Killer:AddSwitch("Auto Bad Karma", function(bool)
    autoBadKarma = bool

    if autoBadKarma then
        spawn(function()
            while autoBadKarma do
                local player = game.Players.LocalPlayer
                local playerChar = player.Character
                local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
                local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")

                if playerChar and rightHand and leftHand then
                    for _, target in ipairs(game.Players:GetPlayers()) do
                        if target ~= player then
                            local evilKarma = target:FindFirstChild("evilKarma")
                            local goodKarma = target:FindFirstChild("goodKarma")

                            if evilKarma and goodKarma and evilKarma:IsA("IntValue") and goodKarma:IsA("IntValue") and goodKarma.Value > evilKarma.Value then
                                local targetChar = target.Character
                                local rootPart = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

                                if rootPart then
                                    firetouchinterest(rightHand, rootPart, 1)
                                    firetouchinterest(leftHand, rootPart, 1)
                                    firetouchinterest(rightHand, rootPart, 0)
                                    firetouchinterest(leftHand, rootPart, 0)
                                end
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

Killer:AddLabel("Whitelisting")

local playerWhitelist = {}

Killer:AddTextBox("Whitelist", function(text)
    local targetPlayer = game.Players:FindFirstChild(text)
    if targetPlayer then
        playerWhitelist[targetPlayer.Name] = true
    end
end)

Killer:AddTextBox("UnWhitelist", function(text)
    local targetPlayer = game.Players:FindFirstChild(text)
    if targetPlayer then
        playerWhitelist[targetPlayer.Name] = nil
    end
end)

Killer:AddLabel("Auto Killing")

local autoKill = false
Killer:AddSwitch("Auto Kill", function(bool)
    autoKill = bool

    while autoKill do
        local player = game.Players.LocalPlayer

        for _, target in ipairs(game.Players:GetPlayers()) do
            if target ~= player and not playerWhitelist[target.Name] then
                local targetChar = target.Character
                local rootPart = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

                if rootPart then
                    local rightHand = player.Character and player.Character:FindFirstChild("RightHand")
                    local leftHand = player.Character and player.Character:FindFirstChild("LeftHand")

                    if rightHand and leftHand then
                        firetouchinterest(rightHand, rootPart, 1)
                        firetouchinterest(leftHand, rootPart, 1)
                        firetouchinterest(rightHand, rootPart, 0)
                        firetouchinterest(leftHand, rootPart, 0)
                    end
                end
            end
        end

        wait(0.1)
    end
end)

Killer:AddLabel("Targeting")

local targetPlayerName = nil

Killer:AddTextBox("Target Name", function(text)
    targetPlayerName = text
end)

local killTarget = false
Killer:AddSwitch("Kill Target", function(bool)
    killTarget = bool

    while killTarget do
        local player = game.Players.LocalPlayer
        local target = game.Players:FindFirstChild(targetPlayerName)

        if target and target ~= player then
            local targetChar = target.Character
            local rootPart = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

            if rootPart then
                local rightHand = player.Character and player.Character:FindFirstChild("RightHand")
                local leftHand = player.Character and player.Character:FindFirstChild("LeftHand")

                if rightHand and leftHand then
                    firetouchinterest(rightHand, rootPart, 1)
                    firetouchinterest(leftHand, rootPart, 1)
                    firetouchinterest(rightHand, rootPart, 0)
                    firetouchinterest(leftHand, rootPart, 0)
                end
            end
        end

        wait(0.1)
    end
end)

local spying = false
Killer:AddSwitch("Spy Player", function(bool)
    spying = bool

    if not spying then
        local player = game.Players.LocalPlayer
        local camera = workspace.CurrentCamera
        camera.CameraSubject = player.Character and player.Character:FindFirstChild("Humanoid") or player
        return
    end

    while spying do
        local player = game.Players.LocalPlayer
        local target = game.Players:FindFirstChild(targetPlayerName)

        if target and target ~= player then
            local targetChar = target.Character
            local targetHumanoid = targetChar and targetChar:FindFirstChild("Humanoid")

            if targetHumanoid then
                local camera = workspace.CurrentCamera
                camera.CameraSubject = targetHumanoid
            end
        end

        wait(0.1)
    end
end)

Killer:AddLabel("Punching Tool")

local autoEquipPunch = false
Killer:AddSwitch("Auto Equip Punch", function(state)
    autoEquipPunch = state

    while autoEquipPunch do
        local player = game.Players.LocalPlayer
        local punchTool = player.Backpack:FindFirstChild("Punch")

        if punchTool then
            punchTool.Parent = player.Character
        end

        wait(0.1)
    end
end)

local autoPunchNoAnim = false
Killer:AddSwitch("Auto Punch [No Animation]", function(state)
    autoPunchNoAnim = state

    while autoPunchNoAnim do
        local player = game.Players.LocalPlayer
        local playerName = player.Name
        local punchTool = player.Backpack:FindFirstChild("Punch") or game.Workspace:FindFirstChild(playerName):FindFirstChild("Punch")

        if punchTool then
            if punchTool.Parent ~= game.Workspace:FindFirstChild(playerName) then
                punchTool.Parent = game.Workspace:FindFirstChild(playerName)
            end

            player.muscleEvent:FireServer("punch", "rightHand")
            player.muscleEvent:FireServer("punch", "leftHand")
        else
            warn("Punch tool not found")
            autoPunchNoAnim = false
        end

        wait(0.01)
    end
end)
--#endregion

--#region ROCK TAB
local Rock = window:AddTab("Rock")

local selectrock = nil
local function gettool()
    local player = game.Players.LocalPlayer
    local playerChar = player.Character
    local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
    local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")

    if playerChar and rightHand and leftHand then
        for _, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
            if v.Name == selectrock and v:IsA("BasePart") then
                firetouchinterest(v, rightHand, 0)
                firetouchinterest(v, rightHand, 1)
                firetouchinterest(v, leftHand, 0)
                firetouchinterest(v, leftHand, 1)
            end
        end
    end
end

Rock:AddSwitch("Auto Punch Jungle Rock (10M)", function(state)
    selectrock = "Ancient Jungle Rock"
    getgenv().autoFarm = state
    while getgenv().autoFarm do
        task.wait()
        if game:GetService("Players").LocalPlayer.Durability.Value >= 10000000 then
            for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                if v.Name == "neededDurability" and v.Value == 10000000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                    gettool()
                end
            end
        end
    end
end)

Rock:AddSwitch("Auto Punch King Rock (5M)", function(state)
    selectrock = "Muscle King Gym Rock"
    getgenv().autoFarm = state
    while getgenv().autoFarm do
        task.wait()
        if game:GetService("Players").LocalPlayer.Durability.Value >= 5000000 then
            for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                if v.Name == "neededDurability" and v.Value == 5000000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                    gettool()
                end
            end
        end
    end
end)

Rock:AddSwitch("Auto Punch Legend Rock (1M)", function(state)
    selectrock = "Legend Gym Rock"
    getgenv().autoFarm = state
    while getgenv().autoFarm do
        task.wait()
        if game:GetService("Players").LocalPlayer.Durability.Value >= 1000000 then
            for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                if v.Name == "neededDurability" and v.Value == 1000000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                    gettool()
                end
            end
        end
    end
end)

Rock:AddSwitch("Auto Punch Inferno Rock (750K)", function(state)
    selectrock = "Eternal Gym Rock"
    getgenv().autoFarm = state
    while getgenv().autoFarm do
        task.wait()
        if game:GetService("Players").LocalPlayer.Durability.Value >= 750000 then
            for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                if v.Name == "neededDurability" and v.Value == 750000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                    gettool()
                end
            end
        end
    end
end)

Rock:AddSwitch("Auto Punch Mythical Rock (400K)", function(state)
    selectrock = "Mythical Gym Rock"
    getgenv().autoFarm = state
    while getgenv().autoFarm do
        task.wait()
        if game:GetService("Players").LocalPlayer.Durability.Value >= 400000 then
            for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                if v.Name == "neededDurability" and v.Value == 400000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                    gettool()
                end
            end
        end
    end
end)

Rock:AddSwitch("Auto Punch Frost Rock (150K)", function(state)
    selectrock = "Frost Gym Rock"
    getgenv().autoFarm = state
    while getgenv().autoFarm do
        task.wait()
        if game:GetService("Players").LocalPlayer.Durability.Value >= 150000 then
            for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                if v.Name == "neededDurability" and v.Value == 150000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                    gettool()
                end
            end
        end
    end
end)

Rock:AddSwitch("Auto Punch Tiny Rock (0)", function(state)
    selectrock = "Tiny Island Rock"
    getgenv().autoFarm = state
    while getgenv().autoFarm do
        task.wait()
        if game:GetService("Players").LocalPlayer.Durability.Value >= 0 then
            for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                if v.Name == "neededDurability" and v.Value == 0 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                    firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                    gettool()
                end
            end
        end
    end
end)
--#endregion

--#region REBIRTH TAB
local Rebirth = window:AddTab("Rebirth")

local autoRebirth = false
Rebirth:AddSwitch("Auto Rebirth (None Stop Rebirth)", function(bool)
    autoRebirth = bool

    while autoRebirth do
        game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")
        wait(0.1)
    end
end)

local rebirthTarget = 0
Rebirth:AddTextBox("Rebirth Target", function(text)
    rebirthTarget = tonumber(text) or 0
end)

local rebirthingToTarget = false
Rebirth:AddSwitch("Rebirth Until Reach Target Amount", function(bool)
    rebirthingToTarget = bool

    while rebirthingToTarget do
        local player = game.Players.LocalPlayer
        local leaderstats = player:FindFirstChild("leaderstats")
        local rebirths = leaderstats and leaderstats:FindFirstChild("Rebirths")

        if rebirths and rebirths.Value >= rebirthTarget then
            rebirthingToTarget = false
            break
        end

        game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")
        wait(0.1)
    end
end)
--#endregion

--#region TELEPORTS TAB
local Teleport = window:AddTab("Teleports")
local locations = {
    ["Tiny Island"] = CFrame.new(-31.86, 6.05, 2087.88),
    ["Starter Island"] = CFrame.new(226.25, 8.15, 219.36),
    ["Legend Gym"] = CFrame.new(4446.91, 1004.46, -3983.76),
    ["Jungle Gym"] = CFrame.new(-8137, 28, 2820),
    ["Muscle King Gym"] = CFrame.new(-8772.97, 24.42, -5638.37)
}

for name, cf in pairs(locations) do
    Teleport:AddButton(name, function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = cf
        end
    end)
end
--#endregion

--#region AUTO FARM TAB
local AutoFarm = window:AddTab("Auto Farm")
local machines = {
    ["Jungle Bench"] = CFrame.new(-8629.88, 64.88, 1855.03),
    ["Muscle King Lift"] = CFrame.new(-8772.97, 24.42, -5638.37),
    ["Legend Lift"] = CFrame.new(4551.51, 997.72, -4018.90)
}

for name, cf in pairs(machines) do
    AutoFarm:AddSwitch("Auto "..name, function(state)
        while state and task.wait(0.1) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = cf
                rs.rEvents.machineInteractRemote:InvokeServer(
                    "useMachine",
                    workspace.machinesFolder[name].interactSeat
                )
            end
        end
    end)
end
--#endregion

--#region BRAWL TAB
local Brawl = window:AddTab("Brawl")

Brawl:AddSwitch("God Mode Brawl", function(state)
    while state and task.wait() do
        rs.rEvents.brawlEvent:FireServer("joinBrawl")
    end
end)

Brawl:AddSwitch("Free Auto Lift Gamepass", function(state)
    if state then
        for _,pass in pairs(rs.gamepassIds:GetChildren()) do
            if not player.ownedGamepasses:FindFirstChild(pass.Name) then
                local clone = pass:Clone()
                clone.Parent = player.ownedGamepasses
            end
        end
    else
        for _,pass in pairs(player.ownedGamepasses:GetChildren()) do
            pass:Destroy()
        end
    end
end)
--#endregion
