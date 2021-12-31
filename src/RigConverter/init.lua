--[[
File name: RigComverter.luau
Author: RadiatedExodus (ItzEthanPlayz_YT/RealEthanPlayzDev)
Created at: December 31 2021

Used for converting between R15 and R6
TODO Change sound script because it's buggy
TODO Use GetCharacterAppearenceInfoAsync
--]]

local serv = { Players = game:GetService("Players") }
local RigConverter = {}
local assets = {
	[script.Health] = "rigroot";
	[script.Respawn] = "humanoid";
	[script.Jump] = "humanoid";
	[script.Sound] = "rigroot";
}

local function CloneAssets(rig)
	for assetinst, placement in next, assets do
		if placement == "rigroot" then
			local c = assetinst:Clone()
			if c:IsA("Script") or c:IsA("LocalScript") then c.Disabled = false end
			if c.Name == "Sound" and c:IsA("Script") and c:FindFirstChild("LocalSound") and c:FindFirstChild("LocalSound"):IsA("LocalScript") then c:FindFirstChild("LocalSound").Disabled = false end
			c.Parent = rig
		elseif placement == "humanoid" then
			local hum = if rig:FindFirstChildWhichIsA("Humanoid") then rig:FindFirstChildWhichIsA("Humanoid") else nil
			if not hum then continue end
			local c = assetinst:Clone()
			if c:IsA("Script") or c:IsA("LocalScript") then c.Disabled = false end
			c.Parent = hum
		end
	end
end

function RigConverter.R6(plr: number | string | Player)
	plr = if tonumber(plr) then serv.Players:GetPlayerByUserId(plr) elseif typeof(plr) == "Instance" and plr:IsA("Player") then plr elseif typeof(plr) == "string" and serv.Players:FindFirstChild(plr) and serv.Players:FindFirstChild(plr):IsA("Player") then serv.Players:FindFirstChild(plr) else nil
	assert(typeof(plr) == "Instance" and plr:IsA("Player"), "player not found")
	local R6_Rig = script:WaitForChild("R6_Rig"):Clone()
	local realChar = plr.Character or plr.CharacterAdded:Wait()
	
	local plrOriginalAppearence = serv.Players:GetCharacterAppearanceAsync(plr.UserId):Clone()
	local FaceID = if realChar:WaitForChild("Head"):FindFirstChild("face") then realChar:WaitForChild("Head"):FindFirstChild("face").Texture else "http://www.roblox.com/asset/?id=144080495"
	local accessories = {}
	R6_Rig:WaitForChild("Head"):WaitForChild("face").Texture = FaceID
	R6_Rig:SetPrimaryPartCFrame(realChar:WaitForChild("HumanoidRootPart").CFrame)
	for _, accesory in pairs(plrOriginalAppearence:GetDescendants()) do
		if accesory:IsA("Accessory") or accesory:IsA("BodyColors") or accesory:IsA("CharacterMesh")or accesory:IsA("Pants") or accesory:IsA("Shirt") or accesory:IsA("ShirtGraphic") or accesory:IsA("Tool") then
			table.insert(accessories, accesory:Clone())
		end
	end
	realChar:ClearAllChildren()
	for _, r6rigparts in pairs(R6_Rig:GetChildren()) do
		r6rigparts.Parent = plr.Character
	end
	for _, accessory in pairs(accessories) do
		accessory.Parent = plr.Character
	end
	CloneAssets(realChar)
	return true
end

function RigConverter.R15(plr: number | string | Player)
	plr = if tonumber(plr) then serv.Players:GetPlayerByUserId(plr) elseif typeof(plr) == "Instance" and plr:IsA("Player") then plr elseif typeof(plr) == "string" and serv.Players:FindFirstChild(plr) and serv.Players:FindFirstChild(plr):IsA("Player") then serv.Players:FindFirstChild(plr) else nil
	assert(typeof(plr) == "Instance" and plr:IsA("Player"), "player not found")
	local realChar = plr.Character or plr.CharacterAdded:Wait()
	local R15_Rig = serv.Players:CreateHumanoidModelFromUserId(plr.UserId)
	R15_Rig:SetPrimaryPartCFrame(realChar:WaitForChild("HumanoidRootPart").CFrame)
	realChar:ClearAllChildren()
	for _, instance in pairs(R15_Rig:GetChildren()) do
		instance.Parent = realChar
	end
	CloneAssets(realChar)
	return true
end

return RigConverter