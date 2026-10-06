--[[
	CombatSystem.lua
	Handles all combat mechanics: attacks, stamina, combos, and damage
]]

local CombatSystem = {}
local RunService = game:GetService("RunService")

-- Combat config
local COMBAT_CONFIG = {
	BASE_DAMAGE = 25,
	COMBO_MULTIPLIERS = {1, 1.2, 1.5}, -- 3-hit combo
	COMBO_TIMEOUT = 1.5, -- seconds before combo resets

	STAMINA_MAX = 100,
	STAMINA_REGEN = 15, -- per second
	STAMINA_DEPLETED_PENALTY = 0.5, -- 50% slower

	DODGE_COOLDOWN = 2,
	DODGE_DISTANCE = 15,
	DODGE_DURATION = 0.5,

	ATTACK_RANGE = 20, -- for melee
	DAMAGE_RANGE_BONUS = 0.1, -- 10% bonus at optimal range (15-25 studs)

	SPACING_OPTIMAL_MIN = 15,
	SPACING_OPTIMAL_MAX = 25,
}

local characterData = {}

function CombatSystem:SetupCharacter(character, classType, player)
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:WaitForChild("Humanoid")

	-- Initialize character combat data
	characterData[character] = {
		player = player,
		classType = classType,
		humanoid = humanoid,
		humanoidRootPart = humanoidRootPart,

		-- Stamina
		stamina = COMBAT_CONFIG.STAMINA_MAX,
		isStaminaDepleted = false,

		-- Combo
		comboCount = 0,
		lastComboHitTime = 0,

		-- Cooldowns
		lastAttackTime = 0,
		lastDodgeTime = 0,
		lastAbilityTime = 0,

		-- State
		isDodging = false,
		isBlocking = false,
		isInvulnerable = false,

		-- Abilities (will be set by class system)
		abilities = {},
	}

	-- Setup class-specific stats and abilities
	self:SetupClass(character, classType)

	-- Start combat loops
	self:StartStaminaRegen(character)
	self:StartInputHandler(character, player)

	-- Cleanup on death
	humanoid.Died:Connect(function()
		characterData[character] = nil
	end)
end

function CombatSystem:SetupClass(character, classType)
	local data = characterData[character]
	if not data then return end

	local classStats = {
		Warrior = {
			hp = 150,
			armor = 20,
			speed = 16,
			abilities = {
				{name = "PowerSlash", damage = 250, cooldown = 1.5, stamina = 30},
				{name = "DefensiveStance", cooldown = 3, stamina = 20},
				{name = "Whirlwind", damage = 150, cooldown = 4, stamina = 40, radius = 20},
			}
		},
		Assassin = {
			hp = 80,
			armor = 5,
			speed = 18,
			abilities = {
				{name = "QuickJab", damage = 100, cooldown = 0.5, stamina = 10},
				{name = "Backstab", damage = 300, cooldown = 3, stamina = 25, requiresBehind = true},
				{name = "ShadowDash", cooldown = 2, stamina = 35, distance = 20},
			}
		},
		Mage = {
			hp = 60,
			armor = 0,
			speed = 14,
			mana = 100,
			abilities = {
				{name = "Fireball", damage = 200, cooldown = 1.5, mana = 40, range = 40},
				{name = "FrostNova", cooldown = 4, mana = 50, range = 30, slow = 0.6},
				{name = "Teleport", cooldown = 3, mana = 50, distance = 15},
			}
		},
		Paladin = {
			hp = 200,
			armor = 40,
			speed = 15,
			abilities = {
				{name = "HolyStrike", damage = 180, cooldown = 1, stamina = 15},
				{name = "DivineShield", cooldown = 5, stamina = 30, blockPercent = 0.75},
				{name = "Blessing", cooldown = 4, stamina = 25, healAmount = 50},
			}
		}
	}

	local stats = classStats[classType] or classStats.Warrior

	-- Apply stats
	data.maxHp = stats.hp
	data.armor = stats.armor
	data.maxMana = stats.mana or 0
	data.mana = data.maxMana
	data.abilities = stats.abilities

	-- Set humanoid HP
	character:FindFirstChild("Humanoid").MaxHealth = stats.hp
	character:FindFirstChild("Humanoid").Health = stats.hp

	-- Set character speed
	character:FindFirstChild("Humanoid").WalkSpeed = stats.speed
end

function CombatSystem:StartStaminaRegen(character)
	local data = characterData[character]
	if not data then return end

	local connection
	connection = RunService.Heartbeat:Connect(function(deltaTime)
		if not character.Parent or data.humanoid.Health <= 0 then
			connection:Disconnect()
			return
		end

		-- Regenerate stamina
		data.stamina = math.min(data.stamina + COMBAT_CONFIG.STAMINA_REGEN * deltaTime, COMBAT_CONFIG.STAMINA_MAX)

		-- Check if stamina depleted state should end
		if data.isStaminaDepleted and data.stamina > COMBAT_CONFIG.STAMINA_MAX * 0.3 then
			data.isStaminaDepleted = false
		end
	end)
end

function CombatSystem:StartInputHandler(character, player)
	local data = characterData[character]
	if not data then return end

	local userInputService = game:GetService("UserInputService")

	-- Left click = attack
	userInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not character.Parent or data.humanoid.Health <= 0 then return end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:PerformAttack(character)
		elseif input.KeyCode == Enum.KeyCode.Space then
			self:PerformDodge(character)
		elseif input.KeyCode == Enum.KeyCode.Q then
			self:PerformAbility(character, 1)
		elseif input.KeyCode == Enum.KeyCode.E then
			self:PerformAbility(character, 2)
		elseif input.KeyCode == Enum.KeyCode.R then
			self:PerformAbility(character, 3)
		end
	end)
end

function CombatSystem:PerformAttack(character)
	local data = characterData[character]
	if not data then return end

	-- Check if can attack
	if tick() - data.lastAttackTime < 0.5 then return end
	if data.stamina < 10 then return end
	if data.isDodging then return end

	-- Check stamina depletion
	local speedMultiplier = data.isStaminaDepleted and COMBAT_CONFIG.STAMINA_DEPLETED_PENALTY or 1

	data.lastAttackTime = tick()
	data.stamina = data.stamina - 10

	-- Update combo
	if tick() - data.lastComboHitTime > COMBAT_CONFIG.COMBO_TIMEOUT then
		data.comboCount = 1
	else
		data.comboCount = math.min(data.comboCount + 1, 3)
	end
	data.lastComboHitTime = tick()

	-- Get target
	local targetCharacter = self:FindNearestTarget(character)
	if not targetCharacter then return end

	-- Calculate damage
	local baseDamage = COMBAT_CONFIG.BASE_DAMAGE
	local comboMultiplier = COMBAT_CONFIG.COMBO_MULTIPLIERS[data.comboCount]
	local spacingBonus = self:GetSpacingBonus(character, targetCharacter)

	local finalDamage = baseDamage * comboMultiplier * spacingBonus

	-- Apply armor reduction
	local targetData = characterData[targetCharacter]
	if targetData then
		local damageReduction = 1 - (targetData.armor * 0.05 / 100)
		finalDamage = finalDamage * damageReduction
	end

	-- Deal damage
	self:DealDamage(targetCharacter, finalDamage)

	-- Visual feedback
	self:PlayAttackEffect(character, targetCharacter, data.comboCount)
end

function CombatSystem:PerformDodge(character)
	local data = characterData[character]
	if not data then return end

	-- Check if can dodge
	if tick() - data.lastDodgeTime < COMBAT_CONFIG.DODGE_COOLDOWN then return end
	if data.stamina < 15 then return end

	data.lastDodgeTime = tick()
	data.stamina = data.stamina - 15
	data.isDodging = true
	data.comboCount = 0 -- Reset combo on dodge

	-- Get direction
	local camera = workspace.CurrentCamera
	local moveDirection = (camera.CFrame.Position - data.humanoidRootPart.Position).Unit
	moveDirection = moveDirection * Vector3.new(1, 0, 1) -- Remove Y component

	-- Dash
	local startPos = data.humanoidRootPart.Position
	local endPos = startPos + moveDirection * COMBAT_CONFIG.DODGE_DISTANCE

	local startTime = tick()
	local connection
	connection = RunService.Heartbeat:Connect(function()
		local elapsed = tick() - startTime
		local progress = elapsed / COMBAT_CONFIG.DODGE_DURATION

		if progress >= 1 then
			connection:Disconnect()
			data.isDodging = false
			return
		end

		data.humanoidRootPart.CFrame = CFrame.new(startPos:Lerp(endPos, progress))
	end)
end

function CombatSystem:PerformAbility(character, abilityIndex)
	local data = characterData[character]
	if not data then return end

	local ability = data.abilities[abilityIndex]
	if not ability then return end

	-- Check cooldown
	if not data.abilityCooldowns then data.abilityCooldowns = {} end
	if tick() - (data.abilityCooldowns[abilityIndex] or 0) < ability.cooldown then return end

	-- Check resources
	if ability.stamina and data.stamina < ability.stamina then return end
	if ability.mana and data.mana < ability.mana then return end

	-- Consume resources
	if ability.stamina then data.stamina = data.stamina - ability.stamina end
	if ability.mana then data.mana = data.mana - ability.mana end

	data.abilityCooldowns[abilityIndex] = tick()

	-- Execute ability
	self:ExecuteAbility(character, ability)
end

function CombatSystem:ExecuteAbility(character, ability)
	local data = characterData[character]
	if not data then return end

	if ability.name == "PowerSlash" then
		-- Warrior ability: single target high damage
		local target = self:FindNearestTarget(character)
		if target then self:DealDamage(target, ability.damage) end

	elseif ability.name == "Backstab" then
		-- Assassin: bonus damage if behind
		local target = self:FindNearestTarget(character)
		if target then
			local behindBonus = self:IsBehindTarget(character, target) and 1.5 or 1
			self:DealDamage(target, ability.damage * behindBonus)
		end

	elseif ability.name == "ShadowDash" then
		-- Assassin: teleport dash
		local camera = workspace.CurrentCamera
		local direction = (camera.CFrame.Position - data.humanoidRootPart.Position).Unit
		direction = direction * Vector3.new(1, 0, 1)
		data.humanoidRootPart.CFrame = data.humanoidRootPart.CFrame + direction * ability.distance

	elseif ability.name == "Fireball" then
		-- Mage: projectile attack
		self:CreateProjectile(character, ability)

	elseif ability.name == "DivineShield" then
		-- Paladin: shield
		data.isBlocking = true
		task.wait(3)
		data.isBlocking = false

	elseif ability.name == "Blessing" then
		-- Paladin: heal nearby allies
		self:HealNearby(character, ability.healAmount)
	end
end

function CombatSystem:FindNearestTarget(character)
	local data = characterData[character]
	if not data then return nil end

	local nearestTarget = nil
	local nearestDistance = COMBAT_CONFIG.ATTACK_RANGE

	for otherCharacter, otherData in pairs(characterData) do
		if otherCharacter ~= character and otherData.humanoid.Health > 0 then
			local distance = (otherCharacter.HumanoidRootPart.Position - data.humanoidRootPart.Position).Magnitude
			if distance < nearestDistance then
				nearestTarget = otherCharacter
				nearestDistance = distance
			end
		end
	end

	return nearestTarget
end

function CombatSystem:GetSpacingBonus(character, target)
	local data = characterData[character]
	local distance = (character.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude

	if distance >= COMBAT_CONFIG.SPACING_OPTIMAL_MIN and distance <= COMBAT_CONFIG.SPACING_OPTIMAL_MAX then
		return 1 + COMBAT_CONFIG.DAMAGE_RANGE_BONUS
	end
	return 1
end

function CombatSystem:IsBehindTarget(character, target)
	local data = characterData[character]
	local targetData = characterData[target]
	if not targetData then return false end

	local targetFacing = targetData.humanoidRootPart.CFrame.LookVector
	local directionToAttacker = (data.humanoidRootPart.Position - targetData.humanoidRootPart.Position).Unit

	return targetFacing:Dot(directionToAttacker) < -0.5
end

function CombatSystem:DealDamage(targetCharacter, damage)
	local targetData = characterData[targetCharacter]
	if not targetData then return end
	if targetData.isInvulnerable then return end
	if targetData.isBlocking then damage = damage * 0.25 end

	targetData.humanoid:TakeDamage(damage)
end

function CombatSystem:HealNearby(character, healAmount)
	local data = characterData[character]
	local healRadius = 30

	for otherCharacter, otherData in pairs(characterData) do
		if otherCharacter ~= character then
			local distance = (otherCharacter.HumanoidRootPart.Position - data.humanoidRootPart.Position).Magnitude
			if distance < healRadius then
				otherData.humanoid.Health = math.min(otherData.humanoid.Health + healAmount, otherData.maxHp)
			end
		end
	end
end

function CombatSystem:PlayAttackEffect(attacker, target, comboCount)
	-- Visual feedback for attacks (can add particles/sounds here)
	print(attacker:FindFirstChild("Humanoid") and attacker.Name .. " combo: " .. comboCount or "")
end

function CombatSystem:CreateProjectile(character, ability)
	-- Placeholder for projectile creation
end

return CombatSystem
