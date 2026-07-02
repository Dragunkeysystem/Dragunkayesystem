--// CONFIG
local CORRECT_KEY = "key1" -- change this to the key you want
local GET_KEY_URL = "https://pastebin.com/raw/u8bEZBXY" -- where players get the key

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// PREVENT MULTIPLE KEY UIS
if game.CoreGui:FindFirstChild("KeySystemGUI") then
    game.CoreGui.KeySystemGUI:Destroy()
end

--// KEY SYSTEM UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeySystemGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.35, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 320, 0, 230)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Text = "Fx P4lad Key System"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 32)

local KeyBox = Instance.new("TextBox")
KeyBox.Parent = Frame
KeyBox.PlaceholderText = "Enter your key..."
KeyBox.Text = ""
KeyBox.Font = Enum.Font.SourceSans
KeyBox.TextSize = 18
KeyBox.Position = UDim2.new(0.08, 0, 0.30, 0)
KeyBox.Size = UDim2.new(0.84, 0, 0, 32)
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.ClearTextOnFocus = false

local VerifyButton = Instance.new("TextButton")
VerifyButton.Parent = Frame
VerifyButton.Text = "Verify Key"
VerifyButton.Font = Enum.Font.SourceSansBold
VerifyButton.TextSize = 18
VerifyButton.Position = UDim2.new(0.08, 0, 0.52, 0)
VerifyButton.Size = UDim2.new(0.84, 0, 0, 32)
VerifyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Parent = Frame
GetKeyButton.Text = "Get Key"
GetKeyButton.Font = Enum.Font.SourceSansBold
GetKeyButton.TextSize = 18
GetKeyButton.Position = UDim2.new(0.08, 0, 0.70, 0)
GetKeyButton.Size = UDim2.new(0.84, 0, 0, 32)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local Notification = Instance.new("TextLabel")
Notification.Parent = Frame
Notification.Text = ""
Notification.Font = Enum.Font.SourceSansBold
Notification.TextSize = 16
Notification.Position = UDim2.new(0.08, 0, 0.88, 0)
Notification.Size = UDim2.new(0.84, 0, 0, 24)
Notification.TextColor3 = Color3.fromRGB(255, 255, 255)
Notification.BackgroundTransparency = 1
Notification.TextWrapped = true

--// HELPER: notification
local function notify(msg, duration)
    Notification.Text = msg
    task.delay(duration or 1.5, function()
        if Notification then
            Notification.Text = ""
        end
    end)
end

--// GET KEY BUTTON (copies link for executors with setclipboard)
GetKeyButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(GET_KEY_URL)
        notify("Key link copied to clipboard!", 1.5)
    else
        notify("Open this link for key:\n" .. GET_KEY_URL, 3)
    end
end)

--// MAIN HUB FUNCTION (runs after correct key)
local function LoadDragunHub()
    -- destroy key UI first
    if ScreenGui then
        ScreenGui:Destroy()
    end

    -- load Fluent
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    local User = player

    -- Window Setup
    local Window = Fluent:CreateWindow({
        Title = "Dragun Script Hub",
        SubTitle = "AI Edition | by Prahlad",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = false,
        Theme = "Dark",
        MinSize = Vector2.new(470, 380)
    })

    -- Tabs Setup
    local Tabs = {
        Main = Window:AddTab({ Title = "Home", Icon = "home" }),
        Paint = Window:AddTab({ Title = "Paint to hide", Icon = "brush" })
    }

    Fluent:Notify({
        Title = "Executed Successfully",
        Content = "Welcome to Dragun Hub! UI fully loaded.",
        Duration = 3
    })

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

--// VERIFY KEY BUTTON LOGIC
VerifyButton.MouseButton1Click:Connect(function()
    local userInput = tostring(KeyBox.Text or "")

    -- trim spaces and ignore case
    userInput = userInput:gsub("^%s+", ""):gsub("%s+$", "")
    local correct = CORRECT_KEY:gsub("^%s+", ""):gsub("%s+$", "")
    userInput = string.lower(userInput)
    correct = string.lower(correct)

    if userInput == "" then
        notify("Please enter a key.", 1.5)
        return
    end

    if userInput == correct then
        notify("Key correct! Loading script...", 1.5)
        task.delay(0.5, LoadDragunHub)
    else
        notify("Incorrect key!", 1.5)
    end
end)
