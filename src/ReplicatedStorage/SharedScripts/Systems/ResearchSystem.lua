local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local loadModule, getDataStream = table.unpack(require(ReplicatedStorage.ZenithFramework))

local CurrencyManager = loadModule("CurrencyManager")
local Llama = loadModule("Llama")
local RoduxStore = loadModule("RoduxStore")
local MachineUtility = loadModule("MachineUtility")
local PlayerDataManager = RunService:IsServer() and loadModule("PlayerDataManager")

local completeResearch = loadModule("completeResearch")
local incrementResearchProgress = loadModule("incrementResearchProgress")

local incrementResearchRemote = getDataStream("incrementResearch", "RemoteFunction")

local ResearchSystem = {}

function ResearchSystem.getPlayerLevel(player : Player, machineType : string) : (number, table)
	local playerData = RoduxStore:waitForValue("playerData")[tostring(player.UserId)] or {}
	local researchLevels = playerData.ResearchLevels

	if not researchLevels then return end

	local playerLevel = researchLevels[string.lower(machineType)]

	return playerLevel.Level, playerLevel.Progress
end

function ResearchSystem.hasPlayerResearched(player : Player, machineType : string, level : number) : boolean
	local playerLevel, _ = ResearchSystem.getPlayerLevel(player, machineType)

	return playerLevel >= level
end

function ResearchSystem.getResearchCosts(machineType : string, level : number) : table?
	local researchCostValues = RoduxStore:waitForValue("gameValues", "researchCosts")[string.lower(machineType)]

	if not researchCostValues then
		warn("Research costs not found for machine type: " .. machineType)
		return
	end

	local researchCosts = researchCostValues[level]

	if not researchCostValues then
		warn("Research costs not found for machine type: " .. machineType .. " at level: " .. level)
		return
	end

	return researchCosts
end

function ResearchSystem.isResearchCompleted(player : Player, machineType : string) : boolean
	local playerLevel, playerProgress = ResearchSystem.getPlayerLevel(player, machineType)
	local researchCosts = ResearchSystem.getResearchCosts(machineType, playerLevel + 1)

	return Llama.Dictionary.length(playerProgress) == #researchCosts
end

function ResearchSystem.incrementResearch(player : Player, machineType : string, researchIndex : number) : boolean?
	local playerLevel, playerProgress = ResearchSystem.getPlayerLevel(player, machineType)

	if playerProgress[researchIndex] then
		warn("Research already completed for player: " .. player.Name .. " for machine type: " .. machineType .. " with index: " .. researchIndex)
		return
	end

	local researchCosts = ResearchSystem.getResearchCosts(machineType, playerLevel + 1)
	if not researchCosts then return end

	local priceInfo = researchCosts[researchIndex]

	if not priceInfo then
		warn("Research costs not found for machine type: " .. machineType .. " at level: " .. playerLevel + 1 .. " with index: " .. researchIndex)
		return
	end

	local cost = if typeof(priceInfo) == "table" then priceInfo.cost else priceInfo
	local currency = if typeof(priceInfo) == "table" then priceInfo.currency else "Coins"

	if CurrencyManager:hasAmount(player, currency, cost) then
		if RunService:IsServer() then
			local success = CurrencyManager:transact(player, currency, -cost)

			if success then
				-- Increment the player researchProgress
				PlayerDataManager:updatePlayerData(player, incrementResearchProgress, machineType, researchIndex)

				-- If they have done all research steps then increment their research level
				if ResearchSystem.isResearchCompleted(player, machineType) then
					PlayerDataManager:updatePlayerData(player, completeResearch, machineType, playerLevel + 1)
				end
			end

			return success
		else
			return incrementResearchRemote:InvokeServer(machineType, researchIndex)
		end
	end
end

return ResearchSystem