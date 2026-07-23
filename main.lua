--// CONFIG
local CORRECT_KEY = "key1" -- change this to the key you want
local GET_KEY_URL = "https://pastebin.com/raw/u8bEZBXY" -- where players get the key

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// PREVENT OLD MULTIPLE KEY UIS (Just in case they rerun the old script)
if game.CoreGui:FindFirstChild("KeySystemGUI") then
    game.CoreGui.KeySystemGUI:Destroy()
end

--// LOAD FLUENT UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

--// WINDOW SETUP (Modern with Acrylic Blur)
local Window = Fluent:CreateWindow({
    Title = "Dragun Script Hub",
    SubTitle = "DragunHub | by Prahlad",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Enables the modern frosted glass effect
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl
})

--// INITIAL TABS (Only the Lock Screen is visible at first)
local Tabs = {
    KeySystem = Window:AddTab({ Title = "Authentication", Icon = "lock" })
}

Window:SelectTab(1)

local HubLoaded = false

--// MAIN HUB FUNCTION (Runs only after correct key)
local function LoadMainFeatures()
    if HubLoaded then return end
    HubLoaded = true

    -- Create the hidden tabs now that the user is authenticated
    Tabs.Main = Window:AddTab({ Title = "Home", Icon = "home" })
    Tabs.Paint = Window:AddTab({ Title = "Paint to hide", Icon = "brush" })

    -- Switch to the Main tab
    Window:SelectTab(2)

    Fluent:Notify({
        Title = "Executed Successfully",
        Content = "Welcome to Dragun Hub! UI fully loaded.",
        Duration = 3
    })

    local User = player

    --=========================================
    -- [HOME TAB] FEATURE: Noclip
    --=========================================
    local Noclip = false
    local ToggleNoclip = Tabs.Main:AddToggle("NoclipToggle", {
        Title = "Noclip",
        Description = "Walk through walls",
        Default = false
    })

    ToggleNoclip:OnChanged(function()
        Noclip = ToggleNoclip.Value
    end)

    RunService.Stepped:Connect(function()
        if Noclip and User.Character then
            for _, part in pairs(User.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)

    --=========================================
    -- [HOME TAB] FEATURES: WalkSpeed & JumpPower
    --=========================================
    local CustomWS, WSEnabled = 16, false
    local CustomJP, JPEnabled = 50, false

    local ToggleWS = Tabs.Main:AddToggle("WSToggle", { Title = "Enable Custom WalkSpeed", Default = false })
    local SliderWS = Tabs.Main:AddSlider("WSSlider", { Title = "WalkSpeed Value", Default = 16, Min = 16, Max = 250, Rounding = 0 })

    local ToggleJP = Tabs.Main:AddToggle("JPToggle", { Title = "Enable Custom JumpPower", Default = false })
    local SliderJP = Tabs.Main:AddSlider("JPSlider", { Title = "JumpPower Value", Default = 50, Min = 50, Max = 500, Rounding = 0 })

    SliderWS:OnChanged(function(Value) CustomWS = Value end)
    SliderJP:OnChanged(function(Value) CustomJP = Value end)

    ToggleWS:OnChanged(function()
        WSEnabled = ToggleWS.Value
        if not WSEnabled and User.Character and User.Character:FindFirstChild("Humanoid") then
            User.Character.Humanoid.WalkSpeed = 16
        end
    end)

    ToggleJP:OnChanged(function()
        JPEnabled = ToggleJP.Value
        if not JPEnabled and User.Character and User.Character:FindFirstChild("Humanoid") then
            User.Character.Humanoid.JumpPower = 50
        end
    end)

    RunService.Heartbeat:Connect(function()
        if User.Character and User.Character:FindFirstChild("Humanoid") then
            if WSEnabled then User.Character.Humanoid.WalkSpeed = CustomWS end
            if JPEnabled then
                User.Character.Humanoid.UseJumpPower = true
                User.Character.Humanoid.JumpPower = CustomJP
            end
        end
    end)

    --=========================================
    -- [HOME TAB] FEATURE: Infinite Jump
    --=========================================
    local InfiniteJumpEnabled = false
    local ToggleInfJump = Tabs.Main:AddToggle("InfJumpToggle", { Title = "Infinite Jump", Default = false })

    ToggleInfJump:OnChanged(function() InfiniteJumpEnabled = ToggleInfJump.Value end)

    UserInputService.JumpRequest:Connect(function()
        if InfiniteJumpEnabled and User.Character and User.Character:FindFirstChild("Humanoid") then
            User.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            User.Character.Humanoid:Move(Vector3.new(0, 100, 0))
        end
    end)

    --=========================================
    -- [HOME TAB] FEATURE: Fly Module
    --=========================================
    local FlySpeed = 100
    local FlyConnection = nil
    local CurrentVelocity = Vector3.new(0, 0, 0)
    local UserRootPart = nil

    local function UpdateCharacter(char)
        UserRootPart = char:WaitForChild("HumanoidRootPart", 5)
    end

    if User.Character then UpdateCharacter(User.Character) end
    User.CharacterAdded:Connect(UpdateCharacter)

    local SliderFlySpeed = Tabs.Main:AddSlider("FlySpeedSlider", { Title = "Fly Speed", Default = 100, Min = 16, Max = 500, Rounding = 0 })
    SliderFlySpeed:OnChanged(function(Value) FlySpeed = Value end)

    local ToggleFly = Tabs.Main:AddToggle("FlyToggle", { Title = "Enable Flight", Description = "Toggle flight.", Default = false })

    local FlightLogic = function(delta)
        local BaseVelocity = Vector3.new(0, 0, 0)
        if not UserInputService:GetFocusedTextBox() then
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then BaseVelocity = BaseVelocity + (Camera.CFrame.LookVector * FlySpeed) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then BaseVelocity = BaseVelocity - (Camera.CFrame.RightVector * FlySpeed) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then BaseVelocity = BaseVelocity - (Camera.CFrame.LookVector * FlySpeed) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then BaseVelocity = BaseVelocity + (Camera.CFrame.RightVector * FlySpeed) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then BaseVelocity = BaseVelocity + (Camera.CFrame.UpVector * FlySpeed) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then BaseVelocity = BaseVelocity * 3 end
        end

        if UserRootPart then
            local car = UserRootPart
            if car.Anchored then return end
            CurrentVelocity = CurrentVelocity:Lerp(BaseVelocity, math.clamp(delta * 4, 0, 1))
            car.Velocity = CurrentVelocity + Vector3.new(0, 2, 0)
        end
    end

    ToggleFly:OnChanged(function()
        if ToggleFly.Value then
            if UserRootPart then CurrentVelocity = UserRootPart.Velocity end
            FlyConnection = RunService.Heartbeat:Connect(FlightLogic)
            Fluent:Notify({ Title = "Flight Status", Content = "Flight Enabled", Duration = 1.5 })
        else
            if FlyConnection then
                FlyConnection:Disconnect()
                FlyConnection = nil
                Fluent:Notify({ Title = "Flight Status", Content = "Flight Disabled", Duration = 1.5 })
            end
        end
    end)

    --=========================================
    -- [PAINT TO HIDE TAB] ESP
    --=========================================
    local ESPEnabled = false
    local Drawings = {}
    local Config = { MaxDistance = 2000 }

    local function GetTeamColor(p)
        if p.Team == User.Team then
            return Color3.fromRGB(0, 255, 100)
        else
            return Color3.fromRGB(255, 60, 60)
        end
    end

    local function CreateESP(p)
        if p == User then return end
        local color = GetTeamColor(p)
        Drawings[p] = {
            box = Drawing.new("Square"),
            name = Drawing.new("Text"),
            healthBar = Drawing.new("Square"),
            healthFill = Drawing.new("Square"),
            tracer = Drawing.new("Line")
        }
        local d = Drawings[p]
        d.box.Thickness = 2; d.box.Filled = false; d.box.Color = color; d.box.Transparency = 1
        d.name.Size = 15; d.name.Center = true; d.name.Outline = true; d.name.Color = Color3.fromRGB(255, 255, 255)
        d.healthBar.Color = Color3.fromRGB(0, 0, 0); d.healthBar.Transparency = 0.6
        d.healthFill.Color = Color3.fromRGB(0, 255, 80)
        d.tracer.Thickness = 1.5; d.tracer.Color = color; d.tracer.Transparency = 0.75
    end

    local function UpdateESP()
        for p, d in pairs(Drawings) do
            if not p or not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then
                d.box.Visible = false; d.name.Visible = false; d.healthBar.Visible = false; d.healthFill.Visible = false; d.tracer.Visible = false
                continue
            end
            local char = p.Character
            local root = char.HumanoidRootPart
            local hum = char:FindFirstChildOfClass("Humanoid")
            local distance = (Camera.CFrame.Position - root.Position).Magnitude

            if distance > Config.MaxDistance or not hum or hum.Health <= 0 then
                d.box.Visible = false; d.name.Visible = false; d.healthBar.Visible = false; d.healthFill.Visible = false; d.tracer.Visible = false
                continue
            end

            local head = char:FindFirstChild("Head")
            local topPos = head and head.Position + Vector3.new(0, 3, 0) or root.Position
            local top, onScreen = Camera:WorldToViewportPoint(topPos)
            local bottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

            if not onScreen then
                d.box.Visible = false; d.name.Visible = false; d.healthBar.Visible = false; d.healthFill.Visible = false; d.tracer.Visible = false
                continue
            end

            local height = math.abs(top.Y - bottom.Y)
            local width = height / 2.1

            d.box.Size = Vector2.new(width, height)
            d.box.Position = Vector2.new(top.X - width / 2, top.Y)
            d.box.Visible = true

            d.name.Text = string.format("%s [%dm]", p.Name, math.floor(distance))
            d.name.Position = Vector2.new(top.X, top.Y - 22)
            d.name.Visible = true

            local hpRatio = hum.Health / hum.MaxHealth
            d.healthBar.Size = Vector2.new(5, height)
            d.healthBar.Position = Vector2.new(top.X - width / 2 - 10, top.Y)
            d.healthBar.Visible = true

            d.healthFill.Size = Vector2.new(5, height * hpRatio)
            d.healthFill.Position = Vector2.new(top.X - width / 2 - 10, top.Y + (height * (1 - hpRatio)))
            d.healthFill.Visible = true

            d.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            d.tracer.To = Vector2.new(top.X, top.Y + height / 2)
            d.tracer.Visible = true
        end
    end

    local ESPToggle = Tabs.Paint:AddToggle("ESPToggle", { Title = "Enable ESP", Default = false })
    ESPToggle:OnChanged(function()
        ESPEnabled = ESPToggle.Value
        if ESPEnabled then
            for _, p in ipairs(Players:GetPlayers()) do
                CreateESP(p)
            end
        else
            for _, d in pairs(Drawings) do
                for _, dr in pairs(d) do
                    dr:Remove()
                end
            end
            Drawings = {}
        end
    end)

    RunService.RenderStepped:Connect(function()
        if ESPEnabled then
            UpdateESP()
        end
    end)

    Players.PlayerAdded:Connect(function(p)
        if ESPEnabled then
            CreateESP(p)
        end
    end)

    player.CharacterAdded:Connect(function()
        task.wait(1)
        if ESPEnabled then
            for _, d in pairs(Drawings) do
                for _, dr in pairs(d) do
                    dr:Remove()
                end
            end
            Drawings = {}
            for _, p in ipairs(Players:GetPlayers()) do
                CreateESP(p)
            end
        end
    end)
end

--=========================================
-- KEY SYSTEM LOGIC (Fluent Style)
--=========================================

Tabs.KeySystem:AddParagraph({
    Title = "Key Required",
    Content = "You must enter a key to access Dragun Hub. Click below to copy the link."
})

Tabs.KeySystem:AddButton({
    Title = "Copy Key Link",
    Description = "Copies the link to get your key to your clipboard.",
    Callback = function()
        if setclipboard then
            setclipboard(GET_KEY_URL)
            Fluent:Notify({ Title = "Copied", Content = "Key link copied to clipboard!", Duration = 2 })
        else
            Fluent:Notify({ Title = "Error", Content = "Your executor does not support setclipboard.", Duration = 2 })
        end
    end
})

local KeyInput = Tabs.KeySystem:AddInput("KeyInput", {
    Title = "Enter Access Key",
    Description = "Type or paste your key here.",
    Default = "",
    Placeholder = "Enter key...",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        local userInput = string.lower(Value:gsub("^%s+", ""):gsub("%s+$", ""))
        local correct = string.lower(CORRECT_KEY:gsub("^%s+", ""):gsub("%s+$", ""))

        if userInput == correct then
            Fluent:Notify({
                Title = "Access Granted",
                Content = "Key correct! Loading script...",
                Duration = 1.5
            })
            task.delay(0.5, LoadMainFeatures)
        elseif userInput ~= "" then
            Fluent:Notify({
                Title = "Access Denied",
                Content = "Incorrect key. Please try again.",
                Duration = 2
            })
        end
    end
})
