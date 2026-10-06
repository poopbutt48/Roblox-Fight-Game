--[[
	GameController.lua
	Main game controller - manages matches, player spawning, and game state
]]

local GameController = {}
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Game configuration
local CONFIG = {
	MATCH_DURATION = 180, -- 3 minutes
	SPAWN_INVULNERABILITY = 2,
	ROUND_WAIT_TIME = 5,
	MIN_PLAYERS = 1,
	ARENA_SIZE = 100,
}

-- Game state
local gameState = {
	matchActive = false,
	players = {},
	matchStartTime = 0,
	roundWinner = nil,
}

function GameController:Init()
	-- Create arena
	self:CreateArena()

	-- Handle player joining
	Players.PlayerAdded:Connect(function(player)
		self:OnPlayerJoined(player)
	end)

	-- Handle player leaving
	Players.PlayerRemoving:Connect(function(player)
		self:OnPlayerLeft(player)
	end)

	-- Start match management loop
	RunService.Heartbeat:Connect(function(deltaTime)
		self:UpdateGame(deltaTime)
	end)

	print("GameController initialized!")
end

function GameController:CreateArena()
	-- Create basic arena
	local arena = Instance.new("Part")
	arena.Name = "Arena"
	arena.Shape = Enum.PartType.Block
	arena.Material = Enum.Material.Concrete
	arena.BrickColor = BrickColor.new("Dark stone grey")
	arena.Size = Vector3.new(CONFIG.ARENA_SIZE, 1, CONFIG.ARENA_SIZE)
	arena.CanCollide = true
	arena.Anchored = true
	arena.Position = Vector3.new(0, 0, 0)
	arena.TopSurface = Enum.SurfaceType.Smooth
	arena.BottomSurface = Enum.SurfaceType.Smooth
	arena.Parent = Workspace

	-- Create walls
	local walls = {
		{pos = Vector3.new(CONFIG.ARENA_SIZE/2, 10, 0), size = Vector3.new(1, 20, CONFIG.ARENA_SIZE)},
		{pos = Vector3.new(-CONFIG.ARENA_SIZE/2, 10, 0), size = Vector3.new(1, 20, CONFIG.ARENA_SIZE)},
		{pos = Vector3.new(0, 10, CONFIG.ARENA_SIZE/2), size = Vector3.new(CONFIG.ARENA_SIZE, 20, 1)},
		{pos = Vector3.new(0, 10, -CONFIG.ARENA_SIZE/2), size = Vector3.new(CONFIG.ARENA_SIZE, 20, 1)},
	}

	for _, wallData in ipairs(walls) do
		local wall = Instance.new("Part")
		wall.Shape = Enum.PartType.Block
		wall.Material = Enum.Material.Concrete
		wall.BrickColor = BrickColor.new("Medium stone grey")
		wall.Size = wallData.size
		wall.CanCollide = true
		wall.Anchored = true
		wall.Position = wallData.pos
		wall.Parent = Workspace
	end

	print("Arena created!")
end

function GameController:OnPlayerJoined(player)
	print(player.Name .. " joined the game")

	-- Create player data
	gameState.players[player.UserId] = {
		player = player,
		character = nil,
		classType = "Warrior", -- Default class
		stats = {},
		isAlive = false,
	}

	-- Spawn the player
	player.CharacterAdded:Connect(function(character)
		self:OnCharacterSpawned(player, character)
	end)

	player:LoadCharacter()
end

function GameController:OnPlayerLeft(player)
	print(player.Name .. " left the game")
	gameState.players[player.UserId] = nil
end

function GameController:OnCharacterSpawned(player, character)
	local playerData = gameState.players[player.UserId]
	if not playerData then return end

	playerData.character = character
	playerData.isAlive = true

	-- Position player at random spawn point
	local spawnPos = Vector3.new(
		math.random(-CONFIG.ARENA_SIZE/2 + 10, CONFIG.ARENA_SIZE/2 - 10),
		10,
		math.random(-CONFIG.ARENA_SIZE/2 + 10, CONFIG.ARENA_SIZE/2 - 10)
	)
	character:MoveTo(spawnPos)

	-- Add combat system to character
	local combatModule = require(script.Parent:WaitForChild("CombatSystem"))
	combatModule:SetupCharacter(character, playerData.classType, player)

	-- Grant invulnerability
	self:GrantInvulnerability(character, CONFIG.SPAWN_INVULNERABILITY)

	-- Handle character death
	character.Humanoid.Died:Connect(function()
		playerData.isAlive = false
		self:OnPlayerDeath(player)
	end)

	print(player.Name .. " spawned as " .. playerData.classType)
end

function GameController:GrantInvulnerability(character, duration)
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end

	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			local tag = Instance.new("BoolValue")
			tag.Name = "Invulnerable"
			tag.Parent = part
		end
	end

	task.wait(duration)

	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			local tag = part:FindFirstChild("Invulnerable")
			if tag then tag:Destroy() end
		end
	end
end

function GameController:OnPlayerDeath(player)
	print(player.Name .. " was defeated!")

	-- Respawn after delay
	task.wait(CONFIG.ROUND_WAIT_TIME)
	if player.Parent then
		player:LoadCharacter()
	end
end

function GameController:UpdateGame(deltaTime)
	if not gameState.matchActive then
		-- Check if we have enough players to start
		local alivePlayers = 0
		for _, playerData in pairs(gameState.players) do
			if playerData.isAlive then
				alivePlayers = alivePlayers + 1
			end
		end

		if alivePlayers >= CONFIG.MIN_PLAYERS then
			self:StartMatch()
		end
	end
end

function GameController:StartMatch()
	gameState.matchActive = true
	gameState.matchStartTime = tick()
	print("Match started!")
end

return GameController
