local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()

Mouse.KeyDown:Connect(function(Key)
	if Key == " " then
		local Active = true
		local Connection = Mouse.KeyUp:Connect(function(Key)
			if Key == " " then
				Active = false
			end
		end)
		while Active do
			script.Parent.Jump = true
			task.wait()
		end
		Connection:Disconnect()
	end
end)