-- 🔐 Key Access
local allowedKey = "DA0ZA"
if getgenv().Key ~= allowedKey then
    return game.Players.LocalPlayer:Kick("❌ Invalid Key!")
end

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera

local targetPos = Vector3.new(-3166.98, 1.71, 2073.41)
local worldClickPos = Vector3.new(-3166.29, -1.21, 2083.25)
local shopPos = Vector3.new(-3187.37, 4.08, 2049.78)
local targetCail = 1000000 -- default jumlah cail

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "FishingHubGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Loading Animation (spinner)
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 100, 0, 100)
loadingFrame.Position = UDim2.new(0.5, -50, 0.5, -50)
loadingFrame.BackgroundTransparency = 1
loadingFrame.Visible = false
loadingFrame.Parent = gui

local spinner = Instance.new("ImageLabel")
spinner.Size = UDim2.new(1, 0, 1, 0)
spinner.Image = "rbxassetid://3926305904" -- contoh spinner gear icon
spinner.ImageRectOffset = Vector2.new(964, 324)
spinner.ImageRectSize = Vector2.new(36, 36)
spinner.BackgroundTransparency = 1
spinner.Parent = loadingFrame

local spinning = false
RunService.RenderStepped:Connect(function()
	if spinning then
		spinner.Rotation = (spinner.Rotation + 5) % 360
	end
end)


-- Main UI
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 250)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local tabPanel = Instance.new("Frame")
tabPanel.Size = UDim2.new(0, 100, 1, 0)
tabPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tabPanel.BackgroundTransparency = 0.5
tabPanel.Parent = mainFrame

local mainTab = Instance.new("TextButton")
mainTab.Size = UDim2.new(1, 0, 0, 40)
mainTab.Position = UDim2.new(0, 0, 0, 50)
mainTab.Text = "Main"
mainTab.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
mainTab.TextColor3 = Color3.new(1, 1, 1)
mainTab.Font = Enum.Font.SourceSansBold
mainTab.TextSize = 16
mainTab.Parent = tabPanel

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(1, 0, 0, 40)
logo.Position = UDim2.new(0, 0, 0, 5)
logo.Text = "YanaminHub"
logo.BackgroundTransparency = 1
logo.TextColor3 = Color3.new(1, 1, 1)
logo.Font = Enum.Font.GothamBold
logo.TextSize = 14
logo.Parent = tabPanel

local contentPanel = Instance.new("Frame")
contentPanel.Position = UDim2.new(0, 100, 0, 0)
contentPanel.Size = UDim2.new(1, -100, 1, 0)
contentPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
contentPanel.BackgroundTransparency = 0.5
contentPanel.Parent = mainFrame

local cailLabel = Instance.new("TextLabel")
cailLabel.Size = UDim2.new(0, 200, 0, 30)
cailLabel.Position = UDim2.new(0, 20, 0, 230)
cailLabel.BackgroundTransparency = 1
cailLabel.TextColor3 = Color3.new(1, 1, 1)
cailLabel.Text = "Jumlah Cail: 0"
cailLabel.Font = Enum.Font.Gotham
cailLabel.TextSize = 14
cailLabel.TextXAlignment = Enum.TextXAlignment.Left
cailLabel.Parent = contentPanel

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(0, 200, 0, 30)
targetLabel.Position = UDim2.new(0, 20, 0, 160)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.new(1, 1, 1)
targetLabel.Text = "Target Cail:"
targetLabel.Font = Enum.Font.GothamBold
targetLabel.TextSize = 14
targetLabel.Parent = contentPanel

local targetInput = Instance.new("TextBox")
targetInput.Size = UDim2.new(0, 200, 0, 30)
targetInput.Position = UDim2.new(0, 20, 0, 190)
targetInput.PlaceholderText = "Masukkan jumlah target"
targetInput.ClearTextOnFocus = false
targetInput.Text = tostring(targetCail)
targetInput.TextColor3 = Color3.new(0, 0, 0)
targetInput.BackgroundColor3 = Color3.new(1, 1, 1)
targetInput.Font = Enum.Font.SourceSans
targetInput.TextSize = 16
targetInput.BorderSizePixel = 1
targetInput.Parent = contentPanel

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Auto Fishing Control"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.Parent = contentPanel

-- Tombol gabungan Auto Fishing & Sell
local toggleAuto = Instance.new("TextButton")
toggleAuto.Size = UDim2.new(0, 200, 0, 40)
toggleAuto.Position = UDim2.new(0, 20, 0, 60)
toggleAuto.Text = "Auto Fishing & Sell: OFF"
toggleAuto.BackgroundColor3 = Color3.fromRGB(180, 0, 200)
toggleAuto.TextColor3 = Color3.new(1, 1, 1)
toggleAuto.Font = Enum.Font.SourceSansBold
toggleAuto.TextSize = 16
toggleAuto.BorderSizePixel = 0
toggleAuto.Parent = contentPanel

local btnOkTarget = Instance.new("TextButton")
btnOkTarget.Size = UDim2.new(0, 50, 0, 30)
btnOkTarget.Position = UDim2.new(0, 230, 0, 190)
btnOkTarget.Text = "OK"
btnOkTarget.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
btnOkTarget.TextColor3 = Color3.new(1, 1, 1)
btnOkTarget.Font = Enum.Font.SourceSansBold
btnOkTarget.TextSize = 16
btnOkTarget.BorderSizePixel = 0
btnOkTarget.Parent = contentPanel

btnOkTarget.MouseEnter:Connect(function()
	btnOkTarget.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
end)
btnOkTarget.MouseLeave:Connect(function()
	btnOkTarget.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
end)

btnOkTarget.MouseButton1Click:Connect(function()
	local inputText = targetInput.Text
	local newTarget = tonumber(inputText)
	if newTarget and newTarget > 0 then
		targetCail = newTarget
		targetInput.Text = tostring(targetCail)
		print("Target Cail updated to:", targetCail)
	else
		targetInput.Text = tostring(targetCail)
		warn("Input target cail tidak valid!")
	end
end)

-- Tombol toggle GUI (pojok kiri atas)
local toggleGUIButton = Instance.new("ImageButton")
toggleGUIButton.Name = "ToggleGUIButton"
toggleGUIButton.Size = UDim2.new(0, 40, 0, 40)
toggleGUIButton.Position = UDim2.new(0, 10, 0, 10)
toggleGUIButton.Image = "rbxassetid://6031090994"
toggleGUIButton.BackgroundTransparency = 1
toggleGUIButton.BorderSizePixel = 0
toggleGUIButton.ZIndex = 999
toggleGUIButton.Parent = gui

toggleGUIButton.MouseEnter:Connect(function()
	toggleGUIButton.ImageTransparency = 0.2
end)

toggleGUIButton.MouseLeave:Connect(function()
	toggleGUIButton.ImageTransparency = 0
end)

toggleGUIButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
end)


local btnMinimize = Instance.new("TextButton")
btnMinimize.Size = UDim2.new(0, 24, 0, 24)
btnMinimize.Position = UDim2.new(1, -28, 0, 8)
btnMinimize.Text = "—"
btnMinimize.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
btnMinimize.TextColor3 = Color3.new(1, 1, 1)
btnMinimize.Font = Enum.Font.SourceSansBold
btnMinimize.TextSize = 20
btnMinimize.BorderSizePixel = 0
btnMinimize.Parent = mainFrame

btnMinimize.MouseEnter:Connect(function()
	btnMinimize.BackgroundColor3 = Color3.fromRGB(100, 0, 180)
end)
btnMinimize.MouseLeave:Connect(function()
	btnMinimize.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
end)

btnMinimize.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Function: Lempar Pancing
local function lemparPancing()
	local screenPos, onScreen = camera:WorldToViewportPoint(worldClickPos)
	if onScreen then
		VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 0)
		VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 0)
	end
end

-- Function: Bersihin UI Minigame
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

-- Function: Get Jumlah Cail dari UI
local function getCailAmount()
	local success, headerText = pcall(function()
		return player:WaitForChild("PlayerGui"):WaitForChild("Event"):WaitForChild("Shop"):WaitForChild("Frame"):WaitForChild("HeaderText")
	end)
	if success and headerText and headerText:IsA("TextLabel") then
		local textValue = headerText.Text:gsub(",", "")
		local cailAmount = tonumber(textValue)
		return cailAmount or 0
	end
	return 0
end

-- Function: Auto Sell yang asli
local autoSell = false
local autoSellThread = nil
local itemsToSell = { "ShadAxe", "ShadHat", "Door", "Tire", "Bumper" }
local eventSellShop = ReplicatedStorage:WaitForChild("NetworkContainer"):WaitForChild("RemoteEvents"):WaitForChild("EventSellShop")

local function doAutoSell()
	while autoSell do
		local sold = false
		for _, item in ipairs(itemsToSell) do
			local success, _ = pcall(function()
				eventSellShop:FireServer(item)
			end)
			if success then
				sold = true
			end
			task.wait(0.05)
		end

		if not sold then
			autoSell = false
			break
		end

		task.wait(1)
	end
end

-- Variable autoAll untuk toggle combined Auto Fishing & Sell
local autoAll = false
local autoAllThread = nil

toggleAuto.MouseEnter:Connect(function()
	toggleAuto.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
end)
toggleAuto.MouseLeave:Connect(function()
	toggleAuto.BackgroundColor3 = autoAll and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(180, 0, 200)
end)

toggleAuto.MouseButton1Click:Connect(function()
	autoAll = not autoAll
	toggleAuto.Text = "Auto Fishing & Sell: " .. (autoAll and "ON" or "OFF")
	toggleAuto.BackgroundColor3 = autoAll and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(180, 0, 200)

	if autoAll then
		spinning = true
		loadingFrame.Visible = true

		autoAllThread = task.spawn(function()
			camera.FieldOfView = 100
			local hrp = character:WaitForChild("HumanoidRootPart")
			hrp.CFrame = CFrame.new(targetPos)
			task.wait(3)

			local tool = player.Backpack:FindFirstChildWhichIsA("Tool")
			if tool then
				tool.Parent = character
			end

			task.wait(1)
			bersihinUI()

			loadingFrame.Visible = false
			spinning = false

			while autoAll do
				local currentCail = getCailAmount()
				cailLabel.Text = "Jumlah Cail: " .. tostring(currentCail)

				if currentCail >= targetCail then
					print("Jumlah cail sudah tercapai. Auto fishing berhenti dan player dikeluarkan.")
					autoAll = false
					pcall(function()
						player:Kick("Jumlah cail sudah tercapai, bye!")
					end)
					break
				end

				-- Lempar pancing
				lemparPancing()

				-- Auto sell loop
				for _, item in ipairs(itemsToSell) do
					pcall(function()
						eventSellShop:FireServer(item)
					end)
					task.wait(0.05)
				end

				task.wait(3)
			end
		end)
	else
		spinning = false
		loadingFrame.Visible = false
		if autoAllThread then
			task.cancel(autoAllThread)
			autoAllThread = nil
		end
	end
end)

-- Tombol teleport ke shop
local tpShopButton = Instance.new("TextButton")
tpShopButton.Size = UDim2.new(0, 200, 0, 40)
tpShopButton.Position = UDim2.new(0, 20, 0, 150)
tpShopButton.Text = "Teleport ke Shop"
tpShopButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
tpShopButton.TextColor3 = Color3.new(1, 1, 1)
tpShopButton.Font = Enum.Font.SourceSansBold
tpShopButton.TextSize = 16
tpShopButton.BorderSizePixel = 0
tpShopButton.Parent = contentPanel

tpShopButton.MouseEnter:Connect(function()
	tpShopButton.BackgroundColor3 = Color3.fromRGB(0, 100, 220)
end)
tpShopButton.MouseLeave:Connect(function()
	tpShopButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
end)

tpShopButton.MouseButton1Click:Connect(function()
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = CFrame.new(shopPos)
		print("Teleported to shop position!")
	else
		warn("HumanoidRootPart not found!")
	end
end)
