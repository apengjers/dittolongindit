-- 🔐 Key Access
local allowedKey = "DA0ZA"
if getgenv().Key ~= allowedKey then
    return game.Players.LocalPlayer:Kick("❌ Invalid Key!")
end

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera

local targetPos = Vector3.new(-3166.98, 1.71, 2073.41)
local worldClickPos = Vector3.new(-3166.29, -1.21, 2083.25)

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FishingHubGUI"
gui.ResetOnSpawn = false

-- Loading Animation (spinner)
local loadingFrame = Instance.new("Frame", gui)
loadingFrame.Size = UDim2.new(0, 100, 0, 100)
loadingFrame.Position = UDim2.new(0.5, -50, 0.5, -50)
loadingFrame.BackgroundTransparency = 1
loadingFrame.Visible = false

local spinner = Instance.new("ImageLabel", loadingFrame)
spinner.Size = UDim2.new(1, 0, 1, 0)
spinner.Image = "rbxassetid://3926305904" -- contoh spinner gear icon
spinner.ImageRectOffset = Vector2.new(964, 324)
spinner.ImageRectSize = Vector2.new(36, 36)
spinner.BackgroundTransparency = 1

-- Tweening animasi rotasi
local runService = game:GetService("RunService")
local spinning = false
runService.RenderStepped:Connect(function()
	if spinning then
		spinner.Rotation = spinner.Rotation + 5
	end
end)

-- Main UI
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 400, 0, 250)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 0

local tabPanel = Instance.new("Frame", mainFrame)
tabPanel.Size = UDim2.new(0, 100, 1, 0)
tabPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tabPanel.BackgroundTransparency = 0.5

local mainTab = Instance.new("TextButton", tabPanel)
mainTab.Size = UDim2.new(1, 0, 0, 40)
mainTab.Position = UDim2.new(0, 0, 0, 50)
mainTab.Text = "Main"
mainTab.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
mainTab.TextColor3 = Color3.new(1, 1, 1)
mainTab.Font = Enum.Font.SourceSansBold
mainTab.TextSize = 16

local logo = Instance.new("TextLabel", tabPanel)
logo.Size = UDim2.new(1, 0, 0, 40)
logo.Position = UDim2.new(0, 0, 0, 5)
logo.Text = "YanaminHub"
logo.BackgroundTransparency = 1
logo.TextColor3 = Color3.new(1, 1, 1)
logo.Font = Enum.Font.GothamBold
logo.TextSize = 14

local contentPanel = Instance.new("Frame", mainFrame)
contentPanel.Position = UDim2.new(0, 100, 0, 0)
contentPanel.Size = UDim2.new(1, -100, 1, 0)
contentPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
contentPanel.BackgroundTransparency = 0.5

local titleLabel = Instance.new("TextLabel", contentPanel)
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Auto Fishing Control"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18

-- Toggle Buttons
local toggleFishing = Instance.new("TextButton", contentPanel)
toggleFishing.Size = UDim2.new(0, 200, 0, 40)
toggleFishing.Position = UDim2.new(0, 20, 0, 60)
toggleFishing.Text = "Auto Fishing: OFF"
toggleFishing.BackgroundColor3 = Color3.fromRGB(180, 0, 200)
toggleFishing.TextColor3 = Color3.new(1, 1, 1)
toggleFishing.Font = Enum.Font.SourceSansBold
toggleFishing.TextSize = 16
toggleFishing.BorderSizePixel = 0

local toggleSell = Instance.new("TextButton", contentPanel)
toggleSell.Size = UDim2.new(0, 200, 0, 40)
toggleSell.Position = UDim2.new(0, 20, 0, 110)
toggleSell.Text = "Auto Sell: OFF"
toggleSell.BackgroundColor3 = Color3.fromRGB(180, 0, 200)
toggleSell.TextColor3 = Color3.new(1, 1, 1)
toggleSell.Font = Enum.Font.SourceSansBold
toggleSell.TextSize = 16
toggleSell.BorderSizePixel = 0

-- Tombol minimize
local btnMinimize = Instance.new("TextButton", contentPanel)
btnMinimize.Size = UDim2.new(0, 24, 0, 24)
btnMinimize.Position = UDim2.new(1, -28, 0, 8)
btnMinimize.Text = "—"
btnMinimize.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
btnMinimize.TextColor3 = Color3.new(1, 1, 1)
btnMinimize.Font = Enum.Font.SourceSansBold
btnMinimize.TextSize = 20
btnMinimize.BorderSizePixel = 0
btnMinimize.ZIndex = 10

btnMinimize.MouseEnter:Connect(function()
	btnMinimize.BackgroundColor3 = Color3.fromRGB(180, 0, 200)
end)
btnMinimize.MouseLeave:Connect(function()
	btnMinimize.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
end)
btnMinimize.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- Toggle GUI button (icon)
local toggleGUIButton = Instance.new("ImageButton")
toggleGUIButton.Name = "ToggleGUIButton"
toggleGUIButton.Parent = gui
toggleGUIButton.Size = UDim2.new(0, 40, 0, 40)
toggleGUIButton.Position = UDim2.new(0, 10, 0, 10)
toggleGUIButton.Image = "rbxassetid://6031090994"
toggleGUIButton.BackgroundTransparency = 1
toggleGUIButton.BorderSizePixel = 0
toggleGUIButton.AutoButtonColor = true
toggleGUIButton.ZIndex = 999

toggleGUIButton.MouseEnter:Connect(function()
	toggleGUIButton.ImageTransparency = 0.2
end)
toggleGUIButton.MouseLeave:Connect(function()
	toggleGUIButton.ImageTransparency = 0
end)
toggleGUIButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- === LOGIC ===

-- Fishing
local autoFishing = false
local autoFishingThread

local function lemparPancing()
	local screenPos, onScreen = camera:WorldToViewportPoint(worldClickPos)
	if onScreen then
		VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 0)
		VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 0)
	end
end

-- Clean Fishing UI
local function bersihinUI()
	local fishingUI = player:WaitForChild("PlayerGui"):FindFirstChild("FishingMinigameUI")
	if fishingUI then
		for _, obj in ipairs(fishingUI:GetDescendants()) do
			if obj:IsA("GuiObject") then
				obj.BackgroundTransparency = 1
				if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
					obj.ImageTransparency = 1
				end
				if string.find(obj.Name:lower(), "bar") or string.find(obj.Name:lower(), "fill") then
					local oldSize = obj.Size
					obj.Size = UDim2.new(10000, 0, oldSize.Y.Scale, oldSize.Y.Offset)
				end
			end
			if obj:IsA("UIStroke") or obj:IsA("UICorner") or obj:IsA("UIGradient") or obj:IsA("UIAspectRatioConstraint") then
				obj:Destroy()
			end
		end
	end
end

-- Eksekusi saat Auto Fishing ON
toggleFishing.MouseButton1Click:Connect(function()
	autoFishing = not autoFishing
	toggleFishing.Text = "Auto Fishing: " .. (autoFishing and "ON" or "OFF")
	toggleFishing.BackgroundColor3 = autoFishing and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(180, 0, 200)

	if autoFishing then
		spinning = true
		loadingFrame.Visible = true

		task.spawn(function()
			character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(targetPos)
			task.wait(3)

			local tool = player.Backpack:FindFirstChildWhichIsA("Tool")
			if tool then
				tool.Parent = character
			end

			task.wait(1)
			bersihinUI()

			loadingFrame.Visible = false
			spinning = false

			autoFishingThread = task.spawn(function()
				while autoFishing do
					lemparPancing()
					task.wait(3)
				end
			end)
		end)
	else
		if autoFishingThread then
			task.cancel(autoFishingThread)
		end
	end
end)

-- Auto Sell
local autoSell = false
local autoSellThread
local itemsToSell = { "ShadAxe", "ShadHat", "Door", "Tire", "Bumper" }
local eventSellShop = ReplicatedStorage:WaitForChild("NetworkContainer"):WaitForChild("RemoteEvents"):WaitForChild("EventSellShop")

local function doAutoSell()
	while autoSell do
		local sold = false
		for _, item in ipairs(itemsToSell) do
			local success = pcall(function()
				eventSellShop:FireServer(item)
			end)
			if success then sold = true end
			task.wait(0.05)
		end
		if not sold then
			autoSell = false
			toggleSell.Text = "Auto Sell: OFF"
			toggleSell.BackgroundColor3 = Color3.fromRGB(180, 0, 200)
			break
		end
		task.wait(1)
	end
end

toggleSell.MouseButton1Click:Connect(function()
	autoSell = not autoSell
	toggleSell.Text = "Auto Sell: " .. (autoSell and "ON" or "OFF")
	toggleSell.BackgroundColor3 = autoSell and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(180, 0, 200)

	if autoSell then
		autoSellThread = task.spawn(doAutoSell)
	elseif autoSellThread then
		task.cancel(autoSellThread)
	end
end)
