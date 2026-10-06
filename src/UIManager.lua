--[[
	UIManager.lua
	Manages all in-game UI: health bars, stamina bars, cooldowns, combat feedback
]]

local UIManager = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

function UIManager:CreatePlayerHUD(player, character)
	local playerGui = player:WaitForChild("PlayerGui")

	-- Create main HUD screen
	local hudScreen = Instance.new("ScreenGui")
	hudScreen.Name = "CombatHUD"
	hudScreen.ResetOnSpawn = false
	hudScreen.IgnoreGuiInset = true
	hudScreen.Parent = playerGui

	-- Health bar background
	local healthBg = Instance.new("Frame")
	healthBg.Name = "HealthBarBg"
	healthBg.Size = UDim2.new(0, 250, 0, 30)
	healthBg.Position = UDim2.new(0, 20, 0, 20)
	healthBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	healthBg.BorderSizePixel = 2
	healthBg.BorderColor3 = Color3.fromRGB(100, 100, 100)
	healthBg.Parent = hudScreen

	-- Health bar fill
	local healthBar = Instance.new("Frame")
	healthBar.Name = "HealthBar"
	healthBar.Size = UDim2.new(1, -4, 1, -4)
	healthBar.Position = UDim2.new(0, 2, 0, 2)
	healthBar.BackgroundColor3 = Color3.fromRGB(34, 180, 76)
	healthBar.BorderSizePixel = 0
	healthBar.Parent = healthBg

	-- Health text
	local healthText = Instance.new("TextLabel")
	healthText.Name = "HealthText"
	healthText.Size = UDim2.new(1, 0, 1, 0)
	healthText.BackgroundTransparency = 1
	healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
	healthText.TextSize = 14
	healthText.TextXAlignment = Enum.TextXAlignment.Center
	healthText.TextYAlignment = Enum.TextYAlignment.Center
	healthText.Font = Enum.Font.GothamBold
	healthText.Text = "100/100"
	healthText.Parent = healthBg

	-- Stamina bar background
	local staminaBg = Instance.new("Frame")
	staminaBg.Name = "StaminaBarBg"
	staminaBg.Size = UDim2.new(0, 250, 0, 20)
	staminaBg.Position = UDim2.new(0, 20, 0, 55)
	staminaBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	staminaBg.BorderSizePixel = 2
	staminaBg.BorderColor3 = Color3.fromRGB(100, 100, 100)
	staminaBg.Parent = hudScreen

	-- Stamina bar fill
	local staminaBar = Instance.new("Frame")
	staminaBar.Name = "StaminaBar"
	staminaBar.Size = UDim2.new(1, -4, 1, -4)
	staminaBar.Position = UDim2.new(0, 2, 0, 2)
	staminaBar.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
	staminaBar.BorderSizePixel = 0
	staminaBar.Parent = staminaBg

	-- Ability cooldowns
	local cooldownContainer = Instance.new("Frame")
	cooldownContainer.Name = "CooldownContainer"
	cooldownContainer.Size = UDim2.new(0, 250, 0, 120)
	cooldownContainer.Position = UDim2.new(0, 20, 0, 85)
	cooldownContainer.BackgroundTransparency = 1
	cooldownContainer.Parent = hudScreen

	-- Create 3 ability slots
	for i = 1, 3 do
		local abilitySlot = Instance.new("Frame")
		abilitySlot.Name = "AbilitySlot" .. i
		abilitySlot.Size = UDim2.new(0, 70, 0, 70)
		abilitySlot.Position = UDim2.new(0, (i-1) * 80, 0, 0)
		abilitySlot.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		abilitySlot.BorderSizePixel = 2
		abilitySlot.BorderColor3 = Color3.fromRGB(100, 100, 100)
		abilitySlot.Parent = cooldownContainer

		-- Key label (Q, E, R)
		local keyLabel = Instance.new("TextLabel")
		keyLabel.Name = "KeyLabel"
		keyLabel.Size = UDim2.new(1, 0, 0, 20)
		keyLabel.Position = UDim2.new(0, 0, 0, 0)
		keyLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		keyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		keyLabel.TextSize = 12
		keyLabel.Font = Enum.Font.GothamBold
		keyLabel.BorderSizePixel = 0
		keyLabel.Text = ({[1]="Q", [2]="E", [3]="R"})[i]
		keyLabel.Parent = abilitySlot

		-- Cooldown overlay
		local cooldownOverlay = Instance.new("Frame")
		cooldownOverlay.Name = "CooldownOverlay"
		cooldownOverlay.Size = UDim2.new(1, 0, 1, 0)
		cooldownOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		cooldownOverlay.BackgroundTransparency = 0.7
		cooldownOverlay.BorderSizePixel = 0
		cooldownOverlay.Parent = abilitySlot

		-- Cooldown text
		local cooldownText = Instance.new("TextLabel")
		cooldownText.Name = "CooldownText"
		cooldownText.Size = UDim2.new(1, 0, 1, 0)
		cooldownText.BackgroundTransparency = 1
		cooldownText.TextColor3 = Color3.fromRGB(255, 255, 255)
		cooldownText.TextSize = 16
		cooldownText.Font = Enum.Font.GothamBold
		cooldownText.TextXAlignment = Enum.TextXAlignment.Center
		cooldownText.TextYAlignment = Enum.TextYAlignment.Center
		cooldownText.Text = "0.0s"
		cooldownText.Parent = cooldownOverlay
	end

	-- Combo counter
	local comboCounter = Instance.new("TextLabel")
	comboCounter.Name = "ComboCounter"
	comboCounter.Size = UDim2.new(0, 200, 0, 60)
	comboCounter.Position = UDim2.new(0.5, -100, 0, 20)
	comboCounter.BackgroundTransparency = 0.3
	comboCounter.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	comboCounter.TextColor3 = Color3.fromRGB(255, 215, 0)
	comboCounter.TextSize = 40
	comboCounter.Font = Enum.Font.GothamBold
	comboCounter.TextXAlignment = Enum.TextXAlignment.Center
	comboCounter.TextYAlignment = Enum.TextYAlignment.Center
	comboCounter.Text = "COMBO x1"
	comboCounter.Visible = false
	comboCounter.BorderSizePixel = 2
	comboCounter.BorderColor3 = Color3.fromRGB(255, 215, 0)
	comboCounter.Parent = hudScreen

	-- Target info
	local targetInfo = Instance.new("TextLabel")
	targetInfo.Name = "TargetInfo"
	targetInfo.Size = UDim2.new(0, 250, 0, 50)
	targetInfo.Position = UDim2.new(1, -270, 0, 20)
	targetInfo.BackgroundTransparency = 0.3
	targetInfo.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	targetInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
	targetInfo.TextSize = 14
	targetInfo.Font = Enum.Font.Gotham
	targetInfo.TextXAlignment = Enum.TextXAlignment.Left
	targetInfo.TextYAlignment = Enum.TextYAlignment.Top
	targetInfo.TextWrapped = true
	targetInfo.Text = "No target"
	targetInfo.BorderSizePixel = 2
	targetInfo.BorderColor3 = Color3.fromRGB(100, 100, 100)
	targetInfo.Padding = UDim.new(0, 5)
	targetInfo.Parent = hudScreen

	-- Instructions
	local instructionsLabel = Instance.new("TextLabel")
	instructionsLabel.Name = "Instructions"
	instructionsLabel.Size = UDim2.new(0, 300, 0, 100)
	instructionsLabel.Position = UDim2.new(1, -320, 1, -120)
	instructionsLabel.BackgroundTransparency = 0.3
	instructionsLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	instructionsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	instructionsLabel.TextSize = 12
	instructionsLabel.Font = Enum.Font.Gotham
	instructionsLabel.TextXAlignment = Enum.TextXAlignment.Left
	instructionsLabel.TextYAlignment = Enum.TextYAlignment.Top
	instructionsLabel.TextWrapped = true
	instructionsLabel.Text = "CONTROLS\nLeft Click - Attack\nSpace - Dodge\nQ/E/R - Abilities\nShift - Sprint"
	instructionsLabel.BorderSizePixel = 2
	instructionsLabel.BorderColor3 = Color3.fromRGB(100, 100, 100)
	instructionsLabel.Parent = hudScreen

	return hudScreen
end

function UIManager:UpdatePlayerHUD(character, hudScreen, combatData)
	if not hudScreen.Parent or not character.Parent then return end

	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end

	-- Update health bar
	local healthBg = hudScreen:FindFirstChild("HealthBarBg")
	if healthBg then
		local healthBar = healthBg:FindFirstChild("HealthBar")
		local healthText = healthBg:FindFirstChild("HealthText")
		if healthBar and healthText then
			local healthPercent = humanoid.Health / humanoid.MaxHealth
			healthBar:TweenSize(UDim2.new(healthPercent, -4, 1, -4), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.1, true)
			healthText.Text = math.ceil(humanoid.Health) .. "/" .. humanoid.MaxHealth
		end
	end

	-- Update stamina bar
	local staminaBg = hudScreen:FindFirstChild("StaminaBarBg")
	if staminaBg and combatData then
		local staminaBar = staminaBg:FindFirstChild("StaminaBar")
		if staminaBar then
			local staminaPercent = combatData.stamina / 100
			staminaBar:TweenSize(UDim2.new(staminaPercent, -4, 1, -4), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.05, true)
		end
	end

	-- Update combo counter
	if combatData and combatData.comboCount > 1 then
		local comboCounter = hudScreen:FindFirstChild("ComboCounter")
		if comboCounter then
			comboCounter.Text = "COMBO x" .. combatData.comboCount
			comboCounter.Visible = true
		end
	else
		local comboCounter = hudScreen:FindFirstChild("ComboCounter")
		if comboCounter then
			comboCounter.Visible = false
		end
	end
end

function UIManager:UpdateCooldowns(hudScreen, abilityCooldowns, abilities)
	if not hudScreen.Parent then return end

	local cooldownContainer = hudScreen:FindFirstChild("CooldownContainer")
	if not cooldownContainer then return end

	for i = 1, 3 do
		local abilitySlot = cooldownContainer:FindFirstChild("AbilitySlot" .. i)
		if abilitySlot and abilities[i] then
			local ability = abilities[i]
			local cooldownOverlay = abilitySlot:FindFirstChild("CooldownOverlay")
			local cooldownText = cooldownOverlay and cooldownOverlay:FindFirstChild("CooldownText")

			if cooldownOverlay and cooldownText then
				local timeSinceAbility = tick() - (abilityCooldowns[i] or 0)
				local remainingCooldown = math.max(0, ability.cooldown - timeSinceAbility)

				if remainingCooldown > 0 then
					cooldownOverlay.Visible = true
					cooldownText.Text = string.format("%.1f", remainingCooldown) .. "s"
				else
					cooldownOverlay.Visible = false
				end
			end
		end
	end
end

return UIManager
