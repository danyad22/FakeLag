workspace[game.Players.LocalPlayer.Name].Archivable = true
local clonedchar = workspace[game.Players.LocalPlayer.Name]:Clone()
local orig = game.Players.LocalPlayer.Character
local root = orig.HumanoidRootPart
local invis = false
local mouse = game.Players.LocalPlayer:GetMouse()
clonedchar.Parent = workspace
game.Players.LocalPlayer.Character = orig
workspace.CurrentCamera.CameraSubject = clonedchar.Humanoid
local follow = true
local down = false
local descendants = clonedchar:GetDescendants()
game:GetService("RunService").Heartbeat:Connect(function()
	clonedchar.Humanoid:Move(orig.Humanoid.MoveDirection)
	clonedchar.Humanoid.Jump = orig.Humanoid.Jump
	if invis then
		clonedchar.HumanoidRootPart.CFrame += orig.Humanoid.MoveDirection
		if orig.Humanoid.MoveDirection ~= Vector3.new(0,0,0) then
			clonedchar.HumanoidRootPart.CFrame = CFrame.new(clonedchar.HumanoidRootPart.Position, clonedchar.HumanoidRootPart.Position + orig.Humanoid.MoveDirection)
		end
		if orig.Humanoid.Jump then
			clonedchar.HumanoidRootPart.CFrame += Vector3.new(0,0.1,0)
		end
		if down then
			clonedchar.HumanoidRootPart.CFrame += Vector3.new(0,-0.1,0)
		end
	end
end)
mouse.KeyDown:Connect(function(key)
	if key == "2" then
		down = true
	end
end)
mouse.KeyUp:Connect(function(key)
	if key == "2" then
		down = false
	end
end)

mouse.KeyDown:Connect(function(key)
	if key == "x" then
		if not invis then
			invis = true
			follow = false
			spawn(function()
				while true do
					task.wait()
					root.Velocity = Vector3.new(math.random(500,5000),math.random(500,50000),math.random(-9500,9500))
					root.AssemblyAngularVelocity = Vector3.new(math.random(-9500,9500),math.random(-9500,9500),math.random(-9500,10000))
					root.CFrame = CFrame.new(Vector3.new(math.random(-500,500),5000,math.random(-500,500)))
					if not invis then
						break
					end
				end
			end)
		else
			invis = false
			follow = true
		end
	end
end)

for i,v in pairs(descendants) do
	if v:IsA("BasePart") then
		v.Transparency = 0.7
		v.Material = Enum.Material.Neon
	end
end
game:GetService("RunService").Heartbeat:Connect(function()
	clonedchar.Humanoid:ChangeState(Enum.HumanoidStateType.StrafingNoPhysics)
	if clonedchar.Humanoid.Jump then
		clonedchar.HumanoidRootPart.CFrame = clonedchar.HumanoidRootPart.CFrame + Vector3.new(0,1,0)
	end
	for i,v in pairs(descendants) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end
end)
task.spawn(function() -- Swap pos
	while true do
		if not invis then
			if follow then
				root.CFrame = clonedchar.HumanoidRootPart.CFrame
			end
			root.Velocity = clonedchar.HumanoidRootPart.Velocity
			root.AssemblyAngularVelocity = clonedchar.HumanoidRootPart.AssemblyAngularVelocity
			root.AssemblyLinearVelocity = clonedchar.HumanoidRootPart.AssemblyLinearVelocity
			orig.Humanoid:ChangeState(Enum.HumanoidStateType.StrafingNoPhysics)
			for i,v in pairs(orig:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
		task.wait()
	end
end)
task.spawn(function() -- fake lag
	while true do
		if not invis then
			root.Anchored = true
			follow = false
			task.wait(math.random(60,180)/130)
			root.Anchored = false
			follow = true
			task.wait()
		end
		task.wait()
	end
end)
