-- Load Rayfield UI library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window Setup
local Window = Rayfield:CreateWindow({
   Name = "🔥 Dragun Script Hub | Game 🔫",
   LoadingTitle = "🔫 Dragun Hub 💥",
   LoadingSubtitle = "Prahlad",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Folder for saving configurations
      FileName = "Dragun Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- Discord invite link
      RememberJoins = true
   },
   KeySystem = true, -- Key system setup
   KeySettings = {
      Title = "Key | Jailbreak",
      Subtitle = "Key System",
      Note = "Enjoyy",
      FileName = "DragunHubKey1",
      SaveKey = true,
      GrabKeyFromSite = true,
      Key = {"https://pastebin.com/raw/8DyY2D7Y"} -- Key source
   }
})

-- Main Tab Setup
local MainTab = Window:CreateTab("🏠 Home", nil)
local MainSection = MainTab:CreateSection("Main")

-- Notification when the script executes
Rayfield:Notify({
   Title = "You executed the script",
   Content = "Very cool gui",
   Duration = 5,
   Image = 13047715178,
   Actions = {
      Ignore = {
         Name = "Okay!",
         Callback = function()
            print("The user tapped Okay!")
         end
      }
   }
})

-- Noclip Feature
local Noclip = false
local RunService = game:GetService("RunService")

local Toggle = MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      Noclip = Value
   end
})

-- Noclip toggle functionality (Handles collision every frame)
RunService.Stepped:Connect(function()
   if Noclip then
      local character = game.Players.LocalPlayer.Character
      if character then
         for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
               part.CanCollide = false
            end
         end
      end
   end
end)

-- WalkSpeed Slider
local WalkSpeed = 16
local Slider = MainTab:CreateSlider({
   Name = "WalkSpeed Slider",
   Range = {1, 250},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = WalkSpeed,
   Flag = "sliderws", -- Unique ID for saving configurations
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      if player.Character and player.Character:FindFirstChild("Humanoid") then
         player.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- JumpPower Slider
local JumpPower = 50
local JumpSlider = MainTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 500},
   Increment = 10,
   Suffix = "Power",
   CurrentValue = JumpPower,
   Flag = "JumpSlider", -- Unique ID for config saving
   Callback = function(Value)
      local character = game.Players.LocalPlayer.Character
      if character and character:FindFirstChild("Humanoid") then
         character.Humanoid.UseJumpPower = true
         character.Humanoid.JumpPower = Value
      end
   end,
})

-- Infinite Jump Feature
local InfiniteJumpEnabled = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        -- Trigger the jump when the user presses space, even if in mid-air
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            player.Character.Humanoid:Move(Vector3.new(0, 100, 0))
        end
    end
end)

-- Infinite Jump Toggle Button
local InfiniteJumpToggle = MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfiniteJumpToggle",
   Callback = function(Value)
      InfiniteJumpEnabled = Value
   end
})

-- Fly Speed Slider (added)
local FlySpeed = 100  -- Default fly speed
local FlySpeedSlider = MainTab:CreateSlider({
   Name = "Fly Speed",
   Range = {16, 500},  -- Min and max values for fly speed
   Increment = 1,      -- Adjust speed in increments of 1
   Suffix = "Speed",   -- Unit label for the slider
   CurrentValue = FlySpeed, -- Default value set to 100
   Flag = "FlySpeedSlider", -- Unique ID for saving configurations
   Callback = function(Value)
      FlySpeed = Value  -- Update the fly speed when slider changes
   end,
})

-- Fly Feature
local Button = MainTab:CreateButton({
   Name = "Fly",
   Callback = function()
      local FlyKey = Enum.KeyCode.V
      local SpeedKey = Enum.KeyCode.LeftControl

      local SpeedKeyMultiplier = 3
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

      -- Set character on spawn
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

      local CurrentVelocity = Vector3.new(0, 0, 0)

      local Flight = function(delta)
          local BaseVelocity = Vector3.new(0, 0, 0)
          if not UserInputService:GetFocusedTextBox() then
              if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                  BaseVelocity = BaseVelocity + (Camera.CFrame.LookVector * FlySpeed)
              end
              if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                  BaseVelocity = BaseVelocity - (Camera.CFrame.RightVector * FlySpeed)
              end
              if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                  BaseVelocity = BaseVelocity - (Camera.CFrame.LookVector * FlySpeed)
              end
              if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                  BaseVelocity = BaseVelocity + (Camera.CFrame.RightVector * FlySpeed)
              end
              if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                  BaseVelocity = BaseVelocity + (Camera.CFrame.UpVector * FlySpeed)
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
              car.Velocity = CurrentVelocity + Vector3.new(0, 2, 0)
              if car ~= UserRootPart then
                  car.RotVelocity = Vector3.new(0, 0, 0)
                  car.CFrame = car.CFrame:Lerp(CFrame.lookAt(
                      car.Position,
                      car.Position + CurrentVelocity + Camera.CFrame.LookVector
                  ), math.clamp(delta * TurnSpeed, 0, 1))
              end
          end
      end

      UserInputService.InputBegan:Connect(function(userInput, gameProcessed)
          if gameProcessed then return end
          if userInput.KeyCode == FlyKey then
              if Connection then
                  StarterGui:SetCore("SendNotification", {
                      Title = "DragunHub",
                      Text = "Flight disabled"
                  })
                  Connection:Disconnect()
                  Connection = nil
              else
                  StarterGui:SetCore("SendNotification", {
                      Title = "DragunHub",
                      Text = "Flight enabled"
                  })
                  CurrentVelocity = UserRootPart.Velocity
                  Connection = RunService.Heartbeat:Connect(Flight)
              end
          end
      end)

      StarterGui:SetCore("SendNotification", {
          Title = "DragunHub",
          Text = "Loaded successfully"
      })
   end,
})
