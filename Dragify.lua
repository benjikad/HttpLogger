local module = {}

local mouse = game:GetService('Players').LocalPlayer:GetMouse()

local DRAGGER_SIZE = 30
local DRAGGER_TRANSPARENCY = .5

local dragging = false

function module.makeResizable(obj:GuiObject, minSize)
	local resizer = script.Parent.resizer:Clone()
	local dragger = resizer.dragger
	
	resizer.Size = UDim2.fromOffset(DRAGGER_SIZE, DRAGGER_SIZE)
	resizer.Position = UDim2.new(1, -DRAGGER_SIZE, 1, -DRAGGER_SIZE)
	
	local duic = dragger.UICorner
	minSize = minSize or Vector2.new(160, 90)
	
	local startDrag, startSize
	local gui = obj:FindFirstAncestorWhichIsA("ScreenGui")
	resizer.Parent = obj

	local function finishResize(tr)
		if not script.Parent.Parent.mini.Value then
			dragger.Position = UDim2.new(0,0,0,0)
			dragger.Size = UDim2.new(2,0,2,0)
			dragger.Parent = resizer
			dragger.BackgroundTransparency = tr
			duic.Parent = dragger
			startDrag = nil
		else

			dragger.Position = UDim2.new(0,0,0,0)
			dragger.Size = UDim2.new(2,0,2,0)
			dragger.Parent = resizer
			dragger.BackgroundTransparency = 1
			duic.Parent = dragger
			startDrag = nil
		end
	end
	dragger.MouseButton1Down:Connect(function()
		if not startDrag then
			startSize = obj.AbsoluteSize			
			startDrag = Vector2.new(mouse.X, mouse.Y)
			dragger.BackgroundTransparency = 1
			dragger.Size = UDim2.fromOffset(gui.AbsoluteSize.X, gui.AbsoluteSize.Y)
			dragger.Position = UDim2.new(0,0,0,0)
			duic.Parent = nil
			dragger.Parent = gui
		end
	end)	
	dragger.MouseMoved:Connect(function()
		if startDrag and not script.Parent.Parent.mini.Value then		
			local m = Vector2.new(mouse.X, mouse.Y)
			local mouseMoved = Vector2.new(m.X - startDrag.X, m.Y - startDrag.Y)
			
			local s = startSize + mouseMoved
			local sx = math.max(minSize.X, s.X) 
			local sy = math.max(minSize.Y, s.Y)
			
			game:GetService("TweenService"):Create(obj, TweenInfo.new(0.25), {Size = UDim2.fromOffset(sx, sy)}):Play()
		end
	end)
	dragger.MouseEnter:Connect(function()
		finishResize(DRAGGER_TRANSPARENCY)				
	end)
	dragger.MouseLeave:Connect(function()
		finishResize(1)
	end)		
	dragger.MouseButton1Up:Connect(function()
		finishResize(DRAGGER_TRANSPARENCY)
	end)	
end

function module.makeDraggable(obj,objToMove)
	local UIS = game:GetService("UserInputService")
	local dragInput, dragStart
	local objToMove = objToMove or obj
	local startPos = objToMove.Position 
	local dragger = obj	
	local function updateInput(input)
		local offset = input.Position - dragStart
		local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + offset.X, startPos.Y.Scale, startPos.Y.Offset + offset.Y)
		game:GetService("TweenService"):Create(objToMove, TweenInfo.new(0.25), {Position = Position}):Play()
	end
	dragger.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not UIS:GetFocusedTextBox() then
			dragging = true
			dragStart = input.Position
			startPos = objToMove.Position
			module.dragged = obj
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	dragger.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			updateInput(input)
		end
	end)
end

return module
