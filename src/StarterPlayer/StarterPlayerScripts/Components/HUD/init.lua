local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local loadModule, getDataStream, loadComponent = table.unpack(require(ReplicatedStorage.ZenithFramework))

local React = loadModule("React")
local RoactTemplate = loadModule("RoactTemplate")
local BuildModeSystem = loadModule("BuildModeSystem")
local PlotSelection = loadModule("PlotSelection")

local CurrencyDisplay = loadComponent("CurrencyDisplay")

local openResearchUI = getDataStream("OpenResearchUI", "BindableEvent")

local buildModeButton = RoactTemplate.fromInstance(React, ReplicatedStorage.Assets.ReactTemplates.HUD.BuildModeButton)
local researchButton = RoactTemplate.fromInstance(React, ReplicatedStorage.Assets.ReactTemplates.HUD.ResearchButton)

local e = React.createElement
local useEffect = React.useEffect
local useBinding = React.useBinding

local player = Players.LocalPlayer

local function hud(props)
	if not props.visible then return end

	local buildButtonVisible, setBuildButtonVisible = useBinding(false)

	useEffect(function()
		task.spawn(function()
			while true do
				task.wait(0.1)

				if not PlotSelection.myPlot then continue end

				local char = player.Character
				if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

				local distance = (char.HumanoidRootPart.Position - PlotSelection.myPlot.Position).Magnitude
				if distance <= math.max(PlotSelection.myPlot.Size.X / 2, PlotSelection.myPlot.Size.Z / 2) then
					setBuildButtonVisible(true)
				else
					setBuildButtonVisible(false)
					BuildModeSystem.exit()
				end
			end
		end)
	end)

	return e("ScreenGui", {
		Name = "HUD";
	}, {
		BuildModeButton = e(buildModeButton, {
			[RoactTemplate.Root] = {
				[React.Event.MouseButton1Click] = function()
					BuildModeSystem.enter()
				end;
				Visible = buildButtonVisible;
			};
		});

		CurrencyDisplay = e(CurrencyDisplay, {
			
		});

		ResearchButton = e(researchButton, {
			[RoactTemplate.Root] = {
				[React.Event.MouseButton1Click] = function()
					openResearchUI:Fire()
				end;
			};
		})
	})
end

return hud