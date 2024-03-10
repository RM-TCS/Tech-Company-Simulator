local ReplicatedStorage = game:GetService("ReplicatedStorage")

local loadModule = table.unpack(require(ReplicatedStorage.ZenithFramework))

local makeActionCreator = loadModule("makeActionCreator")

return makeActionCreator("addPlotItem", function(userId : Player, category : string, variation : string, itemIndex : string, itemData : table)
	return {
		userId = userId;
		category = category;
		variation = variation;
		itemIndex = itemIndex;
		itemData = itemData;
	}
end)