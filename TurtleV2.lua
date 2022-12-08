-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

-- Tables
local Library = {}
local WindowCount = 0
local Sizes = {}
local ListOffset = {}
local PastSliders = {}
local Dropdowns = {}
local ColorPickers = {}

-- Variables
local Mouse = Players.LocalPlayer:GetMouse()

-- Data Settings
local Success, Setting = pcall(function()
    if readfile then
        return HttpService:JSONDecode(readfile("TurtleSettings.json"))
    else
        return {
            Key = "LeftControl",
            UI = true
        }
    end
end)

if not Success and writefile then
    Setting = {
        Key = "LeftControl",
        UI = true
    }

    writefile("TurtleSettings.json", HttpService:JSONEncode(Setting))
end

-- Instance
pcall(function()
    OldInstance:Destroy()
end)

local NewInstance = Instance.new("ScreenGui")
NewInstance.Name = HttpService:GenerateGUID(false)

if gethui then
	NewInstance.Parent = gethui()
elseif not is_sirhurt_closure and (syn and syn.protect_gui) then
	syn.protect_gui(NewInstance)
	NewInstance.Parent = CoreGui
else
	NewInstance.Parent = CoreGui
end

getgenv().OldInstance = NewInstance

local XOffset = 20

function Lerp(a, b, c)
    return a + ((b - a) * c)
end

function Dragify(Obj)
    task.spawn(function()
        local Initial
        local MinInitial
        local IsDragging

        Obj.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                IsDragging = true
                MinInitial = Input.Position
                Initial = Obj.Position

                local Connection
                Connection = RunService.Stepped:Connect(function()
                    if IsDragging then
                        local Delta = Vector3.new(Mouse.X, Mouse.Y, 0) - MinInitial
                        Obj.Position = UDim2.new(Initial.X.Scale, Initial.X.Offset + Delta.X, Initial.Y.Scale, Initial.Y.Offset + Delta.Y)
                    else
                        Connection:Disconnect()
                    end
                end)

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        IsDragging = false
                    end
                end)
            end
        end)
    end)
end

function CheckEnum(Enum, Item)
    for _,v in ipairs(Enum:GetEnumItems()) do
        if v.Name == Item then
            return true
        end
    end

    return false
end

-- Elements
function Library:Window(WindowText, FrameColor, HeaderColor, TextColor)
    WindowText = WindowText or "Turtle UI"
    FrameColor = FrameColor or Color3.fromRGB(0, 151, 230)
    HeaderColor = HeaderColor or Color3.fromRGB(0, 168, 255)
    TextColor = TextColor or Color3.fromRGB(47, 54, 64)

    WindowCount = WindowCount + 1

    local WinCount = WindowCount
    local ZIndex = WindowCount * 7

    local UIWindow = Instance.new("Frame")
    UIWindow.Name = "UIWindow"
    UIWindow.BackgroundColor3 = FrameColor
    UIWindow.BorderSizePixel = 0
    UIWindow.Position = UDim2.new(0, XOffset, 0, 20)
    UIWindow.Size = UDim2.new(0, 207, 0, 33)
    UIWindow.ZIndex = 4 + ZIndex
    UIWindow.Active = true
    UIWindow.Parent = NewInstance
    Dragify(UIWindow)

    XOffset = XOffset + 230

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundColor3 = HeaderColor
    Header.BorderSizePixel = 0
    Header.Position = UDim2.new(0, 0, -0.0202544238, 0)
    Header.Size = UDim2.new(0, 207, 0, 26)
    Header.ZIndex = 5 + ZIndex
    Header.Parent = UIWindow

    local HeaderText = Instance.new("TextLabel")
    HeaderText.Name = "HeaderText"
    HeaderText.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    HeaderText.BackgroundTransparency = 1.000
    HeaderText.Position = UDim2.new(0, 0, -0.0020698905, 0)
    HeaderText.Size = UDim2.new(0, 206, 0, 33)
    HeaderText.ZIndex = 6 + ZIndex
    HeaderText.Font = Enum.Font.SourceSans
    HeaderText.Text = WindowText
    HeaderText.TextColor3 = TextColor
    HeaderText.TextSize = 17.000
    HeaderText.Parent = Header

    local Window = Instance.new("Frame")
    Window.Name = "Window"
    Window.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
    Window.BorderColor3 = Color3.fromRGB(47, 54, 64)
    Window.Position = UDim2.new(0, 0, 0, 0)
    Window.Size = UDim2.new(0, 207, 0, 33)
    Window.ZIndex = 1 + ZIndex
    Window.Parent = Header

    local Minimise = Instance.new("TextButton")
    Minimise.Name = "Minimise"
    Minimise.BackgroundTransparency = 1
    Minimise.Position = UDim2.new(0, 185, 0, 2)
    Minimise.Size = UDim2.new(0, 22, 0, 22)
    Minimise.ZIndex = 7 + ZIndex
    Minimise.Font = Enum.Font.SourceSansLight
    Minimise.Text = "-"
    Minimise.TextColor3 = TextColor
    Minimise.TextSize = 20.000
    Minimise.Parent = Header
    Minimise.MouseButton1Down:Connect(function()
        Window.Visible = not Window.Visible
        Minimise.Text = Window.Visible and "-" or "+"
    end)

    local Functions = {}

    Sizes[WinCount] = 33
    ListOffset[WinCount] = 10

    function Functions:Label(LabelText, Color)
        LabelText = LabelText or "Label"
        Color = Color or Color3.fromRGB(220, 221, 225)

        Sizes[WinCount] = Sizes[WinCount] + 32
        ListOffset[WinCount] = ListOffset[WinCount] + 32
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}

        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.BackgroundColor3 = Color3.fromRGB(220, 221, 225)
        Label.BackgroundTransparency = 1.000
        Label.BorderColor3 = Color3.fromRGB(27, 42, 53)
        Label.Position = UDim2.new(0, 0, 0, ListOffset[WinCount])
        Label.Size = UDim2.new(0, 206, 0, 29)
        Label.Font = Enum.Font.SourceSans
        Label.Text = LabelText
        Label.TextSize = 16.000
        Label.ZIndex = 2 + ZIndex
        Label.Parent = Window

        if typeof(Color) == "boolean" and Color then
            task.spawn(function()
                while NewInstance.Parent do
                    local Hue = tick() % 5 / 5
                    Label.TextColor3 = Color3.fromHSV(Hue, 1, 1)
                    task.wait()
                end
            end)
        else
            Label.TextColor3 = Color
        end

        function Func:SetText(Value)
            Label.Text = Value
        end

        function Func:GetText()
            return Label.Text
        end

        function Func:SetVisible(Value)
            Label.Visible = Value
        end

        function Func:GetVisible()
            return Label.Visible
        end

        PastSliders[WinCount] = false

        return Func
    end

    function Functions:Button(ButtonText, Callback)
        ButtonText = ButtonText or "Button"
        Callback = Callback or function() end

        Sizes[WinCount] = Sizes[WinCount] + 32
        ListOffset[WinCount] = ListOffset[WinCount] + 32
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}

        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.BackgroundColor3 = Color3.fromRGB(53, 59, 72)
        Button.BorderColor3 = Color3.fromRGB(113, 128, 147)
        Button.Position = UDim2.new(0, 12, 0, ListOffset[WinCount])
        Button.Size = UDim2.new(0, 182, 0, 26)
        Button.ZIndex = 2 + ZIndex
        Button.Selected = true
        Button.Font = Enum.Font.SourceSans
        Button.TextColor3 = Color3.fromRGB(245, 246, 250)
        Button.TextSize = 16.000
        Button.TextStrokeTransparency = 123.000
        Button.TextWrapped = true
        Button.Text = ButtonText
        Button.Parent = Window
        Button.MouseButton1Down:Connect(function()
            pcall(Callback, Func)
        end)

        function Func:SetText(Value)
            Button.Text = Value
        end

        function Func:GetText()
            return Button.Text
        end

        function Func:SetVisible(Value)
            Button.Visible = Value
        end

        function Func:GetVisible()
            return Button.Visible
        end

        function Func:Click()
            pcall(Callback, Func)
        end

        PastSliders[WinCount] = false

        return Func
    end

    function Functions:Toggle(ToggleText, Enabled, Callback, Disable)
        ToggleText = ToggleText or "Toggle"
        Enabled = Enabled or false
        Callback = Callback or function() end
        Disable = Disable or true

        Sizes[WinCount] = Sizes[WinCount] + 32
        ListOffset[WinCount] = ListOffset[WinCount] + 32
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}

        local ToggleDescription = Instance.new("TextLabel")
        ToggleDescription.Name = "ToggleDescription"
        ToggleDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleDescription.BackgroundTransparency = 1.000
        ToggleDescription.Position = UDim2.new(0, 14, 0, ListOffset[WinCount])
        ToggleDescription.Size = UDim2.new(0, 131, 0, 26)
        ToggleDescription.Font = Enum.Font.SourceSans
        ToggleDescription.Text = ToggleText
        ToggleDescription.TextColor3 = Color3.fromRGB(245, 246, 250)
        ToggleDescription.TextSize = 16.000
        ToggleDescription.TextWrapped = true
        ToggleDescription.TextXAlignment = Enum.TextXAlignment.Left
        ToggleDescription.ZIndex = 2 + ZIndex
        ToggleDescription.Parent = Window

        local ToggleFiller = Instance.new("Frame")
        ToggleFiller.Name = "ToggleFiller"
        ToggleFiller.BackgroundColor3 = Color3.fromRGB(88, 214, 141)--68, 189, 50)
        ToggleFiller.BorderColor3 = Color3.fromRGB(47, 54, 64)
        ToggleFiller.Position = UDim2.new(0, 5, 0, 5)
        ToggleFiller.Size = UDim2.new(0, 12, 0, 12)
        ToggleFiller.Visible = Enabled
        ToggleFiller.ZIndex = 2 + ZIndex

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
        ToggleButton.BorderColor3 = Color3.fromRGB(113, 128, 147)
        ToggleButton.Position = UDim2.new(1.2061069, 0, 0.0769230798, 0)
        ToggleButton.Size = UDim2.new(0, 22, 0, 22)
        ToggleButton.Font = Enum.Font.SourceSans
        ToggleButton.Text = ""
        ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        ToggleButton.TextSize = 14.000
        ToggleButton.ZIndex = 2 + ZIndex
        ToggleButton.Parent = ToggleDescription
        ToggleFiller.Parent = ToggleButton
        ToggleButton.MouseButton1Down:Connect(function()
            Enabled = not Enabled

            ToggleFiller.Visible = Enabled
            pcall(Callback, Enabled, Func)
        end)

        local Connection
        Connection = NewInstance:GetPropertyChangedSignal("Parent"):Connect(function()
            if not NewInstance.Parent then
                if Enabled and Disable then
                    Enabled = false
                    pcall(Callback, Enabled, Func)
                    Connection:Disconnect()
                else
                    Connection:Disconnect()
                end
            end
        end)

        if Enabled then
            pcall(Callback, Enabled, Func)
        end

        if ToggleText == "Minimise Windows" then
            Window:SetAttribute("MinimiseButton", true)
        end

        function Func:SetText(Value)
            ToggleDescription.Text = Value
        end

        function Func:GetText()
            return ToggleDescription.Text
        end

        function Func:SetState(Value)
            Enabled = Value
            ToggleFiller.Visible = Enabled
            pcall(Callback, Enabled, Func)
        end

        function Func:GetState()
            return Enabled
        end

        function Func:SetVisible(Value)
            ToggleDescription.Visible = Value
        end

        function Func:GetVisible()
            return ToggleDescription.Visible
        end

        PastSliders[WinCount] = false

        return Func
    end

    function Functions:Bind(BindText, Bind, Enabled, Callback, ExCallback)
        BindText = BindText or "Bind"
        Bind = Bind or Enum.KeyCode.A
        Enabled = Enabled or false
        Callback = Callback or function() end
        ExCallback = ExCallback or false

        if typeof(Bind) == "string" and CheckEnum(Enum.KeyCode, Bind) then
            Bind = Enum.KeyCode[Bind]
        end

        Sizes[WinCount] = Sizes[WinCount] + 32
        ListOffset[WinCount] = ListOffset[WinCount] + 32
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}
        local KeyCode = Bind.Name

        local BindDescription = Instance.new("TextLabel")
        BindDescription.Name = "BindDescription"
        BindDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BindDescription.BackgroundTransparency = 1.000
        BindDescription.Position = UDim2.new(0, 14, 0, ListOffset[WinCount])
        BindDescription.Size = UDim2.new(0, 131, 0, 26)
        BindDescription.Font = Enum.Font.SourceSans
        BindDescription.Text = BindText
        BindDescription.TextColor3 = Color3.fromRGB(245, 246, 250)
        BindDescription.TextSize = 16.000
        BindDescription.TextWrapped = true
        BindDescription.TextXAlignment = Enum.TextXAlignment.Left
        BindDescription.ZIndex = 2 + ZIndex
        BindDescription.Parent = Window

        local BindButton = Instance.new("TextButton")
        BindButton.Name = "BindButton"
        BindButton.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
        BindButton.BorderColor3 = Color3.fromRGB(113, 128, 147)
        BindButton.Position = UDim2.new(0, 115, 0, 0)
        BindButton.Size = UDim2.new(0, 70, 0, 22)
        BindButton.Font = Enum.Font.SourceSans
        BindButton.Text = KeyCode
        BindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        BindButton.TextSize = 14.000
        BindButton.ZIndex = 2 + ZIndex
        BindButton.Parent = BindDescription
        BindButton.MouseButton1Click:Connect(function()
            BindButton.Text = "Ã‚Â·Ã‚Â·Ã‚Â·"

            local Input = UserInputService.InputBegan:Wait()

            if Input.KeyCode.Name == "Unknown" then
                KeyCode = nil
                BindButton.Text = "None"
            else
                KeyCode = Input.KeyCode.Name
                BindButton.Text = Input.KeyCode.Name
            end
        end)

        local Connection
        Connection = UserInputService.InputBegan:Connect(function(Input, GameProcessedEvent)
            if Input.KeyCode.Name == KeyCode and not GameProcessedEvent then
                if NewInstance.Parent then
                    Enabled = not Enabled

                    pcall(Callback, Enabled, KeyCode, Func)
                else
                    Connection:Disconnect()
                end
            end
        end)

        if ExCallback then
            pcall(Callback, Enabled, KeyCode, Func)
        end

        function Func:SetText(Value)
            BindDescription.Text = Value
        end

        function Func:GetText()
            return BindDescription.Text
        end

        function Func:SetState(Value)
            Enabled = Value
            pcall(Callback, Enabled, Func)
        end

        function Func:GetState()
            return Enabled
        end

        function Func:SetBind(Value)
           KeyCode = (typeof(Value) == "string" and CheckEnum(Enum.KeyCode, Bind)) and Value or typeof(Value) == "EnumItem" and Value.Name or KeyCode
           BindButton.Text = KeyCode
        end

        function Func:GetBind()
            return KeyCode
        end

        function Func:SetVisible(Value)
            BindDescription.Visible = Value
        end

        function Func:GetVisible()
            return BindDescription.Visible
        end

        return Func
    end

    function Functions:Box(BoxText, Default, InputType, Callback)
        BoxText = BoxText or "Box"
        Callback = Callback or function() end

        Sizes[WinCount] = Sizes[WinCount] + 32
        ListOffset[WinCount] = ListOffset[WinCount] + 32
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}

        local TextBox = Instance.new("TextBox")
        TextBox.BackgroundColor3 = Color3.fromRGB(53, 59, 72)
        TextBox.BorderColor3 = Color3.fromRGB(113, 128, 147)
        TextBox.Position = UDim2.new(0, 99, 0, ListOffset[WinCount])
        TextBox.Size = UDim2.new(0, 95, 0, 26)
        TextBox.Font = Enum.Font.SourceSans
        TextBox.PlaceholderColor3 = Color3.fromRGB(220, 221, 225)
        TextBox.PlaceholderText = "Ã‚Â·Ã‚Â·Ã‚Â·"
        TextBox.Text = ""
        TextBox.TextColor3 = Color3.fromRGB(245, 246, 250)
        TextBox.TextSize = 16.000
        TextBox.TextStrokeColor3 = Color3.fromRGB(245, 246, 250)
        TextBox.ZIndex = 2 + ZIndex
        TextBox.Parent = Window
        TextBox:GetPropertyChangedSignal("Text"):Connect(function()
            if TextBox.Text ~= "" then
                pcall(Callback, TextBox.Text, false, Func)
            end
        end)

        TextBox.FocusLost:Connect(function()
            if TextBox.Text ~= "" then
                pcall(Callback, TextBox.Text, true, Func)
            end
        end)

        local BoxDescription = Instance.new("TextLabel")
        BoxDescription.Name = "BoxDescription"
        BoxDescription.Parent = TextBox
        BoxDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BoxDescription.BackgroundTransparency = 1.000
        BoxDescription.Position = UDim2.new(-0.894736826, 0, 0, 0)
        BoxDescription.Size = UDim2.new(0, 75, 0, 26)
        BoxDescription.Font = Enum.Font.SourceSans
        BoxDescription.Text = BoxText
        BoxDescription.TextColor3 = Color3.fromRGB(245, 246, 250)
        BoxDescription.TextSize = 16.000
        BoxDescription.TextXAlignment = Enum.TextXAlignment.Left
        BoxDescription.ZIndex = 2 + ZIndex

        PastSliders[WinCount] = false

        function Func:SetText(Type, Value)
            Type = Type or "Title"

            if Value ~= "" then
                if Type == "Title" then
                    BoxDescription.Text = Value
                elseif Type == "Text" then
                    TextBox.Text = Value
                end
            end
        end

        function Func:GetText(Type)
            Type = Type or "Title"

            return Type == "Title" and BoxDescription.Text or Type == "Text" and TextBox.Text
        end

        function Func:SetInputType(Type)
            Type = CheckEnum(Enum.TextInputType, Type) and Type or TextBox.TextInputType

            TextBox.TextInputType = Enum.TextInputType[Type]
        end

        function Func:GetVisible()
            return TextBox.Visible
        end

        function Func:GetPlayer(Input)
            if typeof(Input) == "string" then
				local Found = {}
				local Method = Input:lower()

				if Method == "me" then
					table.insert(Found, Players.LocalPlayer.Name)
				elseif Method == "random" then
					table.insert(Found, Players:GetPlayers()[math.random(1, #Players:GetPlayers())])
				end

				for _,v in pairs(Players:GetPlayers()) do
					if Method == "others" then
						if v ~= Players.LocalPlayer then
							table.insert(Found, v)
						end
					elseif Method == "all" then
						table.insert(Found, v)
					elseif Method == "nonfriends" then
						if not v:GetFriendStatus(Players.LocalPlayer) == Enum.FriendStatus.NotFriend and v ~= Players.LocalPlayer then
							table.insert(Found, v)
						end
					elseif Method == "friends" then
						if v:GetFriendStatus(Players.LocalPlayer) == Enum.FriendStatus.NotFriend then
							table.insert(Found, v)
						end
					elseif Method == "enemies" then
						if v.Team ~= Players.LocalPlayer.Team then
							table.insert(Found, v)
						end
					elseif Method == "allies" then
						if v.Team == Players.LocalPlayer.Team then
							table.insert(Found, v)
						end
					else
						if v.Name:lower():sub(1, #Input) == Input:lower() or v.DisplayName:lower():sub(1, #Input) == Input:lower() then
							table.insert(Found, v)
						end
					end
				end

				if table.maxn(Found) > 0 then
					return Found
				end

				return nil
			end
        end

        return Func
    end

    function Functions:Slider(SliderText, Min, Max, Default, Callback)
        SliderText = SliderText or "Slider"
        Min = Min or 1
        Max = Max or 100
        Default = Default or Max / 2
        Callback = Callback or function() end

        local Offset = 70

        local Initial
        local IsDragging

        if Default > Max then
            Default = Max
        elseif Default < Min then
            Default = Min
        end

        if PastSliders[WinCount] then
            Offset = 60
        end

        Sizes[WinCount] = Sizes[WinCount] + Offset
        ListOffset[WinCount] = ListOffset[WinCount] + Offset
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}

        local Slider = Instance.new("Frame")
        local SliderButton = Instance.new("Frame")
        local Description = Instance.new("TextLabel")
        local SilderFiller = Instance.new("Frame")
        local Current = Instance.new("TextLabel")
        local Min_ = Instance.new("TextLabel")
        local Max_ = Instance.new("TextLabel")

        local function SliderMovement(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                IsDragging = true
                Initial = SliderButton.Position.X.Offset

                local Delta = SliderButton.AbsolutePosition.X - Initial

                local Connection
                Connection = RunService.Stepped:Connect(function()
                    if IsDragging then
                        local xOffset = Mouse.X - Delta - 3

                        if xOffset > 175 then
                            xOffset = 175
                        elseif xOffset < 0 then
                            xOffset = 0
                        end

                        SliderButton.Position = UDim2.new(0, xOffset , -1.33333337, 0)
                        SilderFiller.Size = UDim2.new(0, xOffset, 0, 6)
                        local Value = Lerp(Min, Max, SliderButton.Position.X.Offset / (Slider.Size.X.Offset - 5))
                        Current.Text = tostring(math.round(Value))
                    else
                        Connection:Disconnect()
                    end
                end)

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        IsDragging = false
                    end
                end)
            end
        end

        local function SliderEnd(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                local Value = Lerp(Min, Max, SliderButton.Position.X.Offset / (Slider.Size.X.Offset - 5))
                pcall(Callback, math.round(Value), Func)
            end
        end

        Slider.Name = "Slider"
        Slider.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
        Slider.BorderColor3 = Color3.fromRGB(113, 128, 147)
        Slider.Position = UDim2.new(0, 13, 0, ListOffset[WinCount])
        Slider.Size = UDim2.new(0, 180, 0, 6)
        Slider.ZIndex = 2 + ZIndex
        Slider.Parent = Window
        Slider.InputBegan:Connect(SliderMovement)
        Slider.InputEnded:Connect(SliderEnd)

        SliderButton.Position = UDim2.new(0, (Slider.Size.X.Offset - 5) * ((Default - Min) / (Max - Min)), -1.333337, 0)
        SliderButton.Name = "SliderButton"
        SliderButton.BackgroundColor3 = Color3.fromRGB(53, 59, 72)
        SliderButton.BorderColor3 = Color3.fromRGB(113, 128, 147)
        SliderButton.Size = UDim2.new(0, 6, 0, 22)
        SliderButton.ZIndex = 3 + ZIndex
        SliderButton.Parent = Slider
        SliderButton.InputBegan:Connect(SliderMovement)
        SliderButton.InputEnded:Connect(SliderEnd)

        Current.Name = "Current"
        Current.BackgroundTransparency = 1.000
        Current.Position = UDim2.new(0, 3, 0, 22)
        Current.Size = UDim2.new(0, 0, 0, 18)
        Current.Font = Enum.Font.SourceSans
        Current.Text = tostring(Default)
        Current.TextColor3 = Color3.fromRGB(220, 221, 225)
        Current.TextSize = 14.000
        Current.ZIndex = 2 + ZIndex
        Current.Parent = SliderButton

        Description.Name = "Description"
        Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Description.BackgroundTransparency = 1.000
        Description.Position = UDim2.new(0, -10, 0, -35)
        Description.Size = UDim2.new(0, 200, 0, 21)
        Description.Font = Enum.Font.SourceSans
        Description.Text = SliderText
        Description.TextColor3 = Color3.fromRGB(245, 246, 250)
        Description.TextSize = 16.000
        Description.ZIndex = 2 + ZIndex
        Description.Parent = Slider

        SilderFiller.Name = "SilderFiller"
        SilderFiller.BackgroundColor3 = Color3.fromRGB(76, 209, 55)
        SilderFiller.BorderColor3 = Color3.fromRGB(47, 54, 64)
        SilderFiller.Size = UDim2.new(0, (Slider.Size.X.Offset - 5) * ((Default - Min) / (Max - Min)), 0, 6)
        SilderFiller.ZIndex = 2 + ZIndex
        SilderFiller.BorderMode = Enum.BorderMode.Inset
        SilderFiller.Parent = Slider

        Min_.Name = "Min"
        Min_.Parent = Slider
        Min_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Min_.BackgroundTransparency = 1.000
        Min_.Position = UDim2.new(-0.00555555569, 0, -7.33333397, 0)
        Min_.Size = UDim2.new(0, 77, 0, 50)
        Min_.Font = Enum.Font.SourceSans
        Min_.Text = tostring(Min)
        Min_.TextColor3 = Color3.fromRGB(220, 221, 225)
        Min_.TextSize = 14.000
        Min_.TextXAlignment = Enum.TextXAlignment.Left
        Min_.ZIndex = 2 + ZIndex

        Max_.Name = "Max"
        Max_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Max_.BackgroundTransparency = 1.000
        Max_.Position = UDim2.new(0.577777743, 0, -7.33333397, 0)
        Max_.Size = UDim2.new(0, 77, 0, 50)
        Max_.Font = Enum.Font.SourceSans
        Max_.Text = tostring(Max)
        Max_.TextColor3 = Color3.fromRGB(220, 221, 225)
        Max_.TextSize = 14.000
        Max_.TextXAlignment = Enum.TextXAlignment.Right
        Max_.ZIndex = 2 + ZIndex
        Max_.Parent = Slider

        function Func:SetText(Value)
            Description.Text = Value
        end

        function Func:GetText()
            return Description.Text
        end

        function Func:SetValue(Value)
            Value = math.clamp(Value, Min, Max)
            local xOffset = (Value - Min)/ Max * (Slider.Size.X.Offset)
            SliderButton.Position = UDim2.new(0, xOffset , -1.33333337, 0)
            SilderFiller.Size = UDim2.new(0, xOffset, 0, 6)
            Current.Text = tostring(math.round(Value))
        end

        function Func:GetValue()
            return Current.Text
        end

        function Func:SetVisible(Value)
            Slider.Visible = Value
        end

        function Func:GetVisible()
            return Slider.Visible
        end

        PastSliders[WinCount] = true

        return Func
    end

    function Functions:Dropdown(DropText, List, Callback, Selective)
        DropText = DropText or "Dropdown"
        List = List or {}
        Callback = Callback or function() end
        Selective = Selective or false

        Sizes[WinCount] = Sizes[WinCount] + 32
        ListOffset[WinCount] = ListOffset[WinCount] + 32
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}

        local Dropdown = Instance.new("TextButton")
        Dropdown.Name = "Dropdown"
        Dropdown.BackgroundColor3 = Color3.fromRGB(53, 59, 72)
        Dropdown.BorderColor3 = Color3.fromRGB(113, 128, 147)
        Dropdown.Position = UDim2.new(0, 12, 0, ListOffset[WinCount])
        Dropdown.Size = UDim2.new(0, 182, 0, 26)
        Dropdown.Selected = true
        Dropdown.Font = Enum.Font.SourceSans
        Dropdown.Text = tostring(DropText)
        Dropdown.TextColor3 = Color3.fromRGB(245, 246, 250)
        Dropdown.TextSize = 16.000
        Dropdown.TextStrokeTransparency = 123.000
        Dropdown.TextWrapped = true
        Dropdown.ZIndex = 3 + ZIndex
        Dropdown.Parent = Window

        local DownSign = Instance.new("TextLabel")
        DownSign.Name = "DownSign"
        DownSign.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DownSign.BackgroundTransparency = 1.000
        DownSign.Position = UDim2.new(0, 155, 0, 2)
        DownSign.Size = UDim2.new(0, 27, 0, 22)
        DownSign.Font = Enum.Font.SourceSans
        DownSign.Text = "^"
        DownSign.TextColor3 = Color3.fromRGB(220, 221, 225)
        DownSign.TextSize = 20.000
        DownSign.ZIndex = 4 + ZIndex
        DownSign.TextYAlignment = Enum.TextYAlignment.Bottom
        DownSign.Parent = Dropdown

        local DropdownFrame = Instance.new("ScrollingFrame")
        DropdownFrame.Name = "DropdownFrame"
        DropdownFrame.Active = true
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(53, 59, 72)
        DropdownFrame.BorderColor3 = Color3.fromRGB(53, 59, 72)
        DropdownFrame.Position = UDim2.new(0, 0, 0, 28)
        DropdownFrame.Size = UDim2.new(0, 182, 0, 0)
        DropdownFrame.Visible = false
        DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        DropdownFrame.ScrollBarThickness = 4
        DropdownFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
        DropdownFrame.ZIndex = 5 + ZIndex
        DropdownFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        DropdownFrame.ScrollBarImageColor3 = Color3.fromRGB(220, 221, 225)
        DropdownFrame.Parent = Dropdown

        Dropdown.MouseButton1Down:Connect(function()
            for _,v in pairs(Dropdowns) do
                if v ~= DropdownFrame then
                    v.Visible = false
                    DownSign.Rotation = 0
                end
            end

            DownSign.Rotation = DropdownFrame.Visible and 0 or 180
            DropdownFrame.Visible = not DropdownFrame.Visible
        end)

        table.insert(Dropdowns, DropdownFrame)

        local CanvasSize = 0

        function Func:Button(ButtonText)
            ButtonText = ButtonText or ""

            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.BackgroundColor3 = Color3.fromRGB(53, 59, 72)
            Button.BorderColor3 = Color3.fromRGB(113, 128, 147)
            Button.Position = UDim2.new(0, 6, 0, CanvasSize + 1)
            Button.Size = UDim2.new(0, 170, 0, 26)
            Button.Selected = true
            Button.Font = Enum.Font.SourceSans
            Button.TextColor3 = Color3.fromRGB(245, 246, 250)
            Button.TextSize = 16.000
            Button.TextStrokeTransparency = 123.000
            Button.ZIndex = 6 + ZIndex
            Button.Text = ButtonText
            Button.TextWrapped = true
            Button.Parent = DropdownFrame

            CanvasSize = CanvasSize + 27

            DropdownFrame.CanvasSize = UDim2.new(0, 182, 0, CanvasSize + 1)

            if #DropdownFrame:GetChildren() < 8 then
                DropdownFrame.Size = UDim2.new(0, 182, 0, DropdownFrame.Size.Y.Offset + 27)
            end

            Button.MouseButton1Down:Connect(function()
                pcall(Callback, ButtonText, Func)
                DropdownFrame.Visible = false

                if Selective then
                    Dropdown.Text = ButtonText
                end
            end)
        end

        function Func:Remove(ButtonText)
            local Item

            for _,v in ipairs(DropdownFrame:GetChildren()) do
                if Item then
                    CanvasSize = CanvasSize - 27
                    v.Position = UDim2.new(0, 6, 0, v.Position.Y.Offset - 27)
                    DropdownFrame.CanvasSize = UDim2.new(0, 182, 0, CanvasSize + 1)
                end

                if v.Text == ButtonText then
                    Item = true
                    v:Destroy()

                    if #DropdownFrame:GetChildren() < 8 then
                        DropdownFrame.Size = UDim2.new(0, 182, 0, DropdownFrame.Size.Y.Offset - 27)
                    end
                end
            end

            if not Item then
                warn("The button you tried to remove didn't exist!")
            end
        end

        for _,v in pairs(List) do
            Func:Button(v)
        end

        return Func
    end

    function Functions:ColorPicker(ColorText, Default, Callback)
        ColorText = ColorText or "ColorPicker"
        Default = Default or Color3.fromRGB(255, 255, 255)
        Callback = Callback or function() end

        Sizes[WinCount] = Sizes[WinCount] + 32
        ListOffset[WinCount] = ListOffset[WinCount] + 32
        Window.Size = UDim2.new(0, 207, 0, Sizes[WinCount] + 10)

        local Func = {}

        local ColorPicker = Instance.new("TextButton")
        local PickerCorner = Instance.new("UICorner")
        local PickerDescription = Instance.new("TextLabel")
        local ColorPickerFrame = Instance.new("Frame")
        local ToggleRGB = Instance.new("TextButton")
        local ToggleFiller_2 = Instance.new("Frame")
        local TextLabel = Instance.new("TextLabel")
        local ClosePicker = Instance.new("TextButton")
        local Canvas = Instance.new("Frame")
        local CanvasGradient = Instance.new("UIGradient")
        local Cursor = Instance.new("ImageLabel")
        local Color = Instance.new("Frame")
        local ColorGradient = Instance.new("UIGradient")
        local ColorSlider = Instance.new("Frame")
        local Title = Instance.new("TextLabel")
        local UICorner = Instance.new("UICorner")
        local ColorCorner = Instance.new("UICorner")
        local BlackOverlay = Instance.new("ImageLabel")

        ColorPicker.Name = "ColorPicker"
        ColorPicker.Position = UDim2.new(0, 137, 0, ListOffset[WinCount])
        ColorPicker.Size = UDim2.new(0, 57, 0, 26)
        ColorPicker.Font = Enum.Font.SourceSans
        ColorPicker.Text = ""
        ColorPicker.TextColor3 = Color3.fromRGB(0, 0, 0)
        ColorPicker.TextSize = 14.000
        ColorPicker.ZIndex = 2 + ZIndex
        ColorPicker.Parent = Window
        ColorPicker.MouseButton1Down:Connect(function()
            for _,v in pairs(ColorPickers) do
                v.Visible = false
            end

            ColorPickerFrame.Visible = not ColorPickerFrame.Visible
        end)

        PickerCorner.Name = "PickerCorner"
        PickerCorner.CornerRadius = UDim.new(0, 2)
        PickerCorner.Parent = ColorPicker

        PickerDescription.Name = "PickerDescription"
        PickerDescription.Parent = ColorPicker
        PickerDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        PickerDescription.BackgroundTransparency = 1.000
        PickerDescription.Position = UDim2.new(-2.15789509, 0, 0, 0)
        PickerDescription.Size = UDim2.new(0, 116, 0, 26)
        PickerDescription.Font = Enum.Font.SourceSans
        PickerDescription.Text = ColorText
        PickerDescription.TextColor3 = Color3.fromRGB(245, 246, 250)
        PickerDescription.TextSize = 16.000
        PickerDescription.TextXAlignment = Enum.TextXAlignment.Left
        PickerDescription.ZIndex = 2 + ZIndex

        ColorPickerFrame.Name = "ColorPickerFrame"
        ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
        ColorPickerFrame.BorderColor3 = Color3.fromRGB(47, 54, 64)
        ColorPickerFrame.Position = UDim2.new(1.40350854, 0, -2.84615374, 0)
        ColorPickerFrame.Size = UDim2.new(0, 158, 0, 155)
        ColorPickerFrame.ZIndex = 3 + ZIndex
        ColorPickerFrame.Visible = false
        ColorPickerFrame.Parent = ColorPicker

        ToggleRGB.Name = "ToggleRGB"
        ToggleRGB.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
        ToggleRGB.BorderColor3 = Color3.fromRGB(113, 128, 147)
        ToggleRGB.Position = UDim2.new(0, 125, 0, 127)
        ToggleRGB.Size = UDim2.new(0, 22, 0, 22)
        ToggleRGB.Font = Enum.Font.SourceSans
        ToggleRGB.Text = ""
        ToggleRGB.TextColor3 = Color3.fromRGB(0, 0, 0)
        ToggleRGB.TextSize = 14.000
        ToggleRGB.ZIndex = 4 + ZIndex
        ToggleRGB.Parent = ColorPickerFrame

        ToggleFiller_2.Name = "ToggleFiller"
        ToggleFiller_2.BackgroundColor3 = Color3.fromRGB(76, 209, 55)
        ToggleFiller_2.BorderColor3 = Color3.fromRGB(47, 54, 64)
        ToggleFiller_2.Position = UDim2.new(0, 5, 0, 5)
        ToggleFiller_2.Size = UDim2.new(0, 12, 0, 12)
        ToggleFiller_2.ZIndex = 4 + ZIndex
        ToggleFiller_2.Visible = false
        ToggleFiller_2.Parent = ToggleRGB

        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 1.000
        TextLabel.Position = UDim2.new(-5.13636351, 0, 0, 0)
        TextLabel.Size = UDim2.new(0, 106, 0, 22)
        TextLabel.Font = Enum.Font.SourceSans
        TextLabel.Text = "Rainbow"
        TextLabel.TextColor3 = Color3.fromRGB(245, 246, 250)
        TextLabel.TextSize = 16.000
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.ZIndex = 4 + ZIndex
        TextLabel.Parent = ToggleRGB

        ClosePicker.Name = "ClosePicker"
        ClosePicker.Parent = ColorPickerFrame
        ClosePicker.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
        ClosePicker.BorderColor3 = Color3.fromRGB(47, 54, 64)
        ClosePicker.Position = UDim2.new(0, 132, 0, 5)
        ClosePicker.Size = UDim2.new(0, 21, 0, 21)
        ClosePicker.Font = Enum.Font.SourceSans
        ClosePicker.Text = "X"
        ClosePicker.TextColor3 = Color3.fromRGB(245, 246, 250)
        ClosePicker.TextSize = 18.000
        ClosePicker.ZIndex = 4 + ZIndex
        ClosePicker.Parent = ColorPickerFrame
        ClosePicker.MouseButton1Down:Connect(function()
            ColorPickerFrame.Visible = not ColorPickerFrame.Visible
        end)

        CanvasGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
        CanvasGradient.Name = "CanvasGradient"
        CanvasGradient.Parent = Canvas

        BlackOverlay.Name = "BlackOverlay"
        BlackOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BlackOverlay.BackgroundTransparency = 1.000
        BlackOverlay.Size = UDim2.new(1, 0, 1, 0)
        BlackOverlay.Image = "rbxassetid://5107152095"
        BlackOverlay.ZIndex = 5 + ZIndex
        BlackOverlay.Parent = Canvas

        UICorner.Name = "UICorner"
        UICorner.CornerRadius = UDim.new(0, 2)
        UICorner.Parent = Canvas

        Cursor.Name = "Cursor"
        Cursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Cursor.BackgroundTransparency = 1.000
        Cursor.Size = UDim2.new(0, 8, 0, 8)
        Cursor.Image = "rbxassetid://5100115962"
        Cursor.ZIndex = 5 + ZIndex
        Cursor.Parent = Canvas

        local _Color3
        local DraggingColor = false
        local Hue, Sat, Brightness = 0, 1, 1

        local Connection
        ToggleRGB.MouseButton1Down:Connect(function()
            ToggleFiller_2.Visible = not ToggleFiller_2.Visible

            if ToggleFiller_2.Visible then
                Connection = RunService.Stepped:Connect(function()
                    if ToggleFiller_2.Visible then
                        local Hue2 = tick() % 5 / 5
                        _Color3 = Color3.fromHSV(Hue2, 1, 1)
                        pcall(Callback, _Color3, true, Func)
                        ColorPicker.BackgroundColor3 = _Color3
                    else
                        Connection:Disconnect()
                    end
                end)
            end
        end)

        if Default and typeof(Default) == "boolean" then
            ToggleFiller_2.Visible = true

            if ToggleFiller_2.Visible then
                Connection = RunService.Stepped:Connect(function()
                    if ToggleFiller_2.Visible then
                        local Hue2 = tick() % 5 / 5
                        _Color3 = Color3.fromHSV(Hue2, 1, 1)
                        pcall(Callback, _Color3, true, Func)
                        ColorPicker.BackgroundColor3 = _Color3
                    else
                        Connection:Disconnect()
                    end
                end)
            end
        else
            ColorPicker.BackgroundColor3 = Default
        end

        Canvas.Name = "Canvas"
        Canvas.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Canvas.Position = UDim2.new(0, 5, 0, 34)
        Canvas.Size = UDim2.new(0, 148, 0, 64)
        Canvas.ZIndex = 4 + ZIndex
        Canvas.Parent = ColorPickerFrame

        local CanvasSize, CanvasPosition = Canvas.AbsoluteSize, Canvas.AbsolutePosition

        Canvas.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                local Initial = Vector2.new(Cursor.Position.X.Offset, Cursor.Position.Y.Offset)
                local Delta = Cursor.AbsolutePosition - Initial

                local _Connection
                local IsDragging = true

                _Connection = RunService.Stepped:Connect(function()
                    if IsDragging then
                        local Delta2 = Vector2.new(Mouse.X, Mouse.Y) - Delta
                        local X = math.clamp(Delta2.X, 2, Canvas.Size.X.Offset - 2)
                        local Y = math.clamp(Delta2.Y, 2, Canvas.Size.Y.Offset - 2)

                        Sat = 1 - math.clamp((Mouse.X - CanvasPosition.X) / CanvasSize.X, 0, 1)
				        Brightness = 1 - math.clamp((Mouse.Y - CanvasPosition.Y) / CanvasSize.Y, 0, 1)

                        _Color3 = Color3.fromHSV(Hue, Sat, Brightness)

                        Cursor.Position = UDim2.fromOffset(X - 4, Y - 4)
                        ColorPicker.BackgroundColor3 = _Color3
                        pcall(Callback, _Color3, Func)
                    else
                        _Connection:Disconnect()
                    end
                end)

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        IsDragging = false
                    end
                end)
            end
        end)

        Color.Name = "Color"
        Color.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Color.Position = UDim2.new(0, 5, 0, 105)
        Color.Size = UDim2.new(0, 148, 0, 14)
        Color.BorderMode = Enum.BorderMode.Inset
        Color.ZIndex = 4 + ZIndex
        Color.Parent = ColorPickerFrame
        Color.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                DraggingColor = true
                local Initial  = ColorSlider.Position.X.Offset
                local Delta = ColorSlider.AbsolutePosition.X - Initial

                local _Connection
                _Connection = RunService.Stepped:Connect(function()
                    if DraggingColor then
                        local ColorPosition, ColorSize = Color.AbsolutePosition, Color.AbsoluteSize
                        Hue = 1 - math.clamp(1 - ((Mouse.X - ColorPosition.X) / ColorSize.X), 0, 1)
                        CanvasGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromHSV(Hue, 1, 1)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}

                        local xOffset = math.clamp(Mouse.X - Delta, 0, Color.Size.X.Offset - 3)
                        ColorSlider.Position = UDim2.new(0, xOffset, 0, 0);

                        _Color3 = Color3.fromHSV(Hue, Sat, Brightness)
                        ColorPicker.BackgroundColor3  = _Color3
                        pcall(Callback, _Color3, Func)
                    else
                        _Connection:Disconnect()
                    end
                end)
            end
        end)

        Color.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                DraggingColor = false
            end
        end)

        ColorGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.82, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
        })
        ColorGradient.Name = "ColorGradient"
        ColorGradient.Parent = Color

        ColorCorner.Name = "ColorCorner"
        ColorCorner.CornerRadius = UDim.new(0, 2)
        ColorCorner.Parent = Color

        ColorSlider.Name = "ColorSlider"
        ColorSlider.BackgroundColor3 = Color3.fromRGB(245, 246, 250)
        ColorSlider.BorderColor3 = Color3.fromRGB(245, 246, 250)
        ColorSlider.Size = UDim2.new(0, 2, 0, 14)
        ColorSlider.ZIndex = 5 + ZIndex
        ColorSlider.Parent = Color

        Title.Name = "Title"
        Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Title.BackgroundTransparency = 1.000
        Title.Position = UDim2.new(0, 10, 0, 5)
        Title.Size = UDim2.new(0, 118, 0, 21)
        Title.Font = Enum.Font.SourceSans
        Title.Text = ColorText
        Title.TextColor3 = Color3.fromRGB(245, 246, 250)
        Title.TextSize = 16.000
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.ZIndex = 4 + ZIndex
        Title.Parent = ColorPickerFrame

        table.insert(ColorPickers, ColorPickerFrame)

        function Func:SetText(Value)
            Title.Text = Value
        end

        function Func:GetText()
            return Title.Text
        end

        function Func:UpdateColorPicker(Value)
            if type(Value) == "userdata" then
                ToggleFiller_2.Visible = false
                ColorPicker.BackgroundColor3 = Value
            elseif Value and type(Value) == "boolean" and not Connection then
                ToggleFiller_2.Visible = true

                Connection = RunService.Stepped:Connect(function()
                    if ToggleFiller_2.Visible then
                        local hue2 = tick() % 5 / 5
                        _Color3 = Color3.fromHSV(hue2, 1, 1)
                        pcall(Callback, _Color3, Func)
                        ColorPicker.BackgroundColor3 = _Color3
                    else
                        Connection:Disconnect()
                    end
                end)
            end
	    end

        function Func:SetVisible(Value)
            ColorPicker.Visible = Value
        end

        function Func:GetVisible()
            return ColorPicker.Visible
        end

        return Func
    end

    function Functions:DestroyUI()
        Functions:Button("Destroy UI", function()
            NewInstance:Destroy()
        end)
    end

    function Functions:HideUI(Bind)
        Bind = Bind or Setting.Key

        Functions:Bind("Hide UI", Bind, Setting.UI, function(State, Key)
            Setting.UI = State

            NewInstance.Enabled = Setting.UI

            if writefile then
                Setting.Key = Key
                writefile("TurtleSettings.json", HttpService:JSONEncode(Setting))
            end
        end, true)
    end

    function Functions:MinimiseWindows()
        Functions:Toggle("Minimise Windows", false, function(State)
            for _,v in pairs(NewInstance:GetChildren()) do
                if not v.Header.Window:GetAttribute("MinimiseButton") then
                    v.Header.Window.Visible = not State
                    v.Header.Minimise.Text = v.Header.Window.Visible and "-" or "+"
                end
            end
        end, false)
    end

    function Functions:SetTitle(Value)
        HeaderText.Text = Value
    end

    function Functions:GetTitle()
        return Header.Text
    end

    return Functions
end

return Library
