while not game:IsLoaded() do
	task.wait(1)
end

print("Abysall Hub death farm for DOORS, created by FireBacon (bocaj111004)")
print("dsc.gg/abysallhub")

local Services = setmetatable({}, {
	__index = function(self, Key)
		return game:GetService(Key)
	end
})

local QueueTeleport = queue_on_teleport or queueonteleport
local TeleportCode = [==[
	loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Scripts/DeathFarm.luau"))()
]==]

local LocalPlayer = Services.Players.LocalPlayer
local RemotesFolder = Services.ReplicatedStorage.RemotesFolder
local CurrentRooms = Services.Workspace:FindFirstChild("CurrentRooms")

local function SendCaption(Text)
	if firesignal then
		firesignal(RemotesFolder.Caption.OnClientEvent, "[Abysall Hub] " .. Text)
	else
		RemotesFolder.CaptionClient:Fire("[Abysall Hub] " .. Text)
	end
end

if #CurrentRooms:GetChildren() > 1 or LocalPlayer.Character then
	SendCaption("Run has already started, joining a new run for best experience...")
	QueueTeleport(TeleportCode)
	RemotesFolder.PlayAgain:FireServer()
	return
end

while #CurrentRooms:GetChildren() < 1 or not LocalPlayer.Character do
	task.wait(1)
end

local MainUI = LocalPlayer.PlayerGui:WaitForChild("MainUI", 9e9)

if MainUI:FindFirstChild("ItemShop") then
	MainUI.ItemShop.Visible = false
	RemotesFolder.PreRunShop:FireServer({}, true)
end

task.wait(1)
fireproximityprompt(Services.Workspace:FindFirstChild("SkipPrompt", true))
Services.Workspace:FindFirstChild("Luggage_Cart_Crouch", true):Destroy()

if MainUI:FindFirstChild("ItemShop") then
	MainUI.ItemShop:Destroy()
end

local function WalkPosition(TargetPosition)
	local Path = Services.PathfindingService:CreatePath({
		AgentCanJump = true, AgentCanClimb = true, WaypointSpacing = 2,
		AgentRadius = 1, AgentHeight = 1
	})

	local RootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 9e9)
	local Humanoid = LocalPlayer.Character:WaitForChild("Humanoid", 9e9)

	local FoundPath = false
	local StuckConnection
	StuckConnection = Services.RunService.RenderStepped:Connect(function()
		Humanoid:MoveTo(TargetPosition)
		if FoundPath then
			StuckConnection:Disconnect()
		end
	end)

	while Path.Status ~= Enum.PathStatus.Success do
		Path = Services.PathfindingService:CreatePath({
			AgentCanJump = false, AgentCanClimb = false, WaypointSpacing = 2,
			AgentRadius = 2, AgentHeight = 2
		})

		Path:ComputeAsync(RootPart.Position, TargetPosition)
		task.wait()
	end

	FoundPath = true
	for Index, Waypoint in pairs(Path:GetWaypoints()) do
		local Finished = false
		local Connection = Services.RunService.RenderStepped:Connect(function()
			Humanoid:MoveTo(Waypoint.Position)
			if LocalPlayer:DistanceFromCharacter(Waypoint.Position) < 6 then
				Finished = true
			end
		end)

		while task.wait() do
			if Finished then
				Connection:Disconnect()
				break
			end
		end
		task.wait()
	end

	return true
end
task.wait(1)

SendCaption("Getting the key...")
local Key = CurrentRooms["0"]:FindFirstChild("KeyObtain", true)
WalkPosition(Key.Hitbox.Position)
fireproximityprompt(Key:FindFirstChild("ModulePrompt", true))

SendCaption("Got the key, opening the door...")
local Door = CurrentRooms["0"]:FindFirstChild("Door")
Door.Lock.CanCollide = false
WalkPosition(Door.Lock.Position)
fireproximityprompt(Door:FindFirstChild("UnlockPrompt", true))

while not CurrentRooms:FindFirstChild("2") do
	task.wait()
end

if replicatesignal then
	replicatesignal(LocalPlayer.Kill)
else
	SendCaption("Please wait around 20 seconds to die")
	RemotesFolder.Underwater:FireServer(true)
end

LocalPlayer:GetAttributeChangedSignal("Alive"):Wait()
SendCaption("Player has died, joining a new run...")

RemotesFolder.PlayAgain:FireServer()
QueueTeleport(TeleportCode)
