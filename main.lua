local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🔥 Dragun Script Hub | Game 🔫",
   LoadingTitle = "🔫 Jailbreak 💥",
   LoadingSubtitle = "Prahlad",
   ConfigurationSaving = {
      Enabled = True,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Dragun Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Key | Jailbreak",
      Subtitle = "Key System",
      Note = "Enjoyy",
      FileName = "DragunHubKey1", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"https://pastebin.com/raw/8DyY2D7Y"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("🏠 Home", nil) -- Title, Image
local MainSection = MainTab:CreateSection("Main")

Rayfield:Notify({
   Title = "You executed the script",
   Content = "Very cool gui",
   Duration = 5,
   Image = 13047715178,
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "Okay!",
         Callback = function()
         print("The user tapped Okay!")
      end
   },
},
})

local Button = MainTab:CreateButton({
   Name = "Fly",
   Callback = function()
        local FlyKey = Enum.KeyCode.V
local SpeedKey = Enum.KeyCode.LeftControl

local SpeedKeyMultiplier = 3
local FlightSpeed = 100
local FlightAcceleration = 4
local TurnSpeed = 16


local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local User = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserCharacter = nil
local UserRootPart = nil
local Connection = nil


workspace.Changed:Connect(function()
    Camera = workspace.CurrentCamera
end)

local setCharacter = function(c)
    UserCharacter = c
    UserRootPart = c:WaitForChild("HumanoidRootPart")
end

User.CharacterAdded:Connect(setCharacter)
if User.Character then
    setCharacter(User.Character)
end

local CurrentVelocity = Vector3.new(0,0,0)
local Flight = function(delta)
    local BaseVelocity = Vector3.new(0,0,0)
    if not UserInputService:GetFocusedTextBox() then
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            BaseVelocity = BaseVelocity + (Camera.CFrame.LookVector * FlightSpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            BaseVelocity = BaseVelocity - (Camera.CFrame.RightVector * FlightSpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            BaseVelocity = BaseVelocity - (Camera.CFrame.LookVector * FlightSpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            BaseVelocity = BaseVelocity + (Camera.CFrame.RightVector * FlightSpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            BaseVelocity = BaseVelocity + (Camera.CFrame.UpVector * FlightSpeed)
        end
    	if UserInputService:IsKeyDown(SpeedKey) then
    		BaseVelocity = BaseVelocity * SpeedKeyMultiplier
    	end
    end
    if UserRootPart then
        local car = UserRootPart:GetRootPart()
        if car.Anchored then return end
        if not isnetworkowner(car) then return end
        CurrentVelocity = CurrentVelocity:Lerp(
            BaseVelocity,
            math.clamp(delta * FlightAcceleration, 0, 1)
        )
        car.Velocity = CurrentVelocity + Vector3.new(0,2,0)
        if car ~= UserRootPart then
            car.RotVelocity = Vector3.new(0,0,0)
            car.CFrame = car.CFrame:Lerp(CFrame.lookAt(
                car.Position,
                car.Position + CurrentVelocity + Camera.CFrame.LookVector
            ), math.clamp(delta * TurnSpeed, 0, 1))
        end
    end
end

UserInputService.InputBegan:Connect(function(userInput,gameProcessed)
    if gameProcessed then return end
    if userInput.KeyCode == FlyKey then
        if Connection then
            StarterGui:SetCore("SendNotification",{
                Title = "PrahladHub",
                Text = "Flight disabled"
            })
            Connection:Disconnect()
            Connection = nil
        else
            StarterGui:SetCore("SendNotification",{
                Title = "PrahladHub",
                Text = "Flight enabled"
            })
            CurrentVelocity = UserRootPart.Velocity
            Connection = RunService.Heartbeat:Connect(Flight)
        end
    end
end)

StarterGui:SetCore("SendNotification",{
    Title = "PrahladHub",
    Text = "Loaded successfully"
})   
   end,
})
