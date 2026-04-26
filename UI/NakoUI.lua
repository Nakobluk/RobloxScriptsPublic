-- NakoUI Library v1.0
-- Modern UI Library for Roblox with animations

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local NakoUI = {}

-- Utility Functions
local function Tween(object, properties, duration, style, direction)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.1)
        end
    end)
end

-- Key System
local function CheckKey(keySettings)
    if not keySettings then return true end
    
    local keyFile = keySettings.FileName or "Key"
    local savedKey
    
    if keySettings.SaveKey then
        pcall(function()
            savedKey = readfile(keyFile .. ".txt")
        end)
    end
    
    if keySettings.GrabKeyFromSite and type(keySettings.Key[1]) == "string" and keySettings.Key[1]:match("^http") then
        local success, result = pcall(function()
            return game:HttpGet(keySettings.Key[1])
        end)
        if success then
            keySettings.Key = {result:gsub("%s+", "")}
        end
    end
    
    if savedKey then
        for _, key in ipairs(keySettings.Key) do
            if savedKey == key then
                return true
            end
        end
    end
    
    return false
end

-- Create Window
function NakoUI:CreateWindow(config)
    local WindowManager = {}
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NakoUI_" .. HttpService:GenerateGUID(false)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    -- Shadow Effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar
    
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Size = UDim2.new(1, 0, 0, 12)
    TopBarFix.Position = UDim2.new(0, 0, 1, -12)
    TopBarFix.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.Name or "NakoUI"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -40, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 24
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 140, 1, -55)
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabContainer
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)
    TabPadding.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -170, 1, -55)
    ContentContainer.Position = UDim2.new(0, 160, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    
    -- Make draggable
    MakeDraggable(MainFrame, TopBar)
    
    -- Toggle UI Keybind
    if config.ToggleUIKeybind then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode[config.ToggleUIKeybind] then
                MainFrame.Visible = not MainFrame.Visible
            end
        end)
    end
    
    -- Key System
    if config.KeySystem and config.KeySettings then
        if not CheckKey(config.KeySettings) then
            MainFrame.Visible = false
            
            -- Key System UI
            local KeyFrame = Instance.new("Frame")
            KeyFrame.Name = "KeyFrame"
            KeyFrame.Size = UDim2.new(0, 400, 0, 250)
            KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
            KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            KeyFrame.BorderSizePixel = 0
            KeyFrame.Parent = ScreenGui
            
            local KeyCorner = Instance.new("UICorner")
            KeyCorner.CornerRadius = UDim.new(0, 12)
            KeyCorner.Parent = KeyFrame
            
            local KeyShadow = Shadow:Clone()
            KeyShadow.Parent = KeyFrame
            
            local KeyTitle = Instance.new("TextLabel")
            KeyTitle.Size = UDim2.new(1, -40, 0, 40)
            KeyTitle.Position = UDim2.new(0, 20, 0, 15)
            KeyTitle.BackgroundTransparency = 1
            KeyTitle.Text = config.KeySettings.Title or "Key System"
            KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeyTitle.TextSize = 20
            KeyTitle.Font = Enum.Font.GothamBold
            KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
            KeyTitle.Parent = KeyFrame
            
            local KeyNote = Instance.new("TextLabel")
            KeyNote.Size = UDim2.new(1, -40, 0, 30)
            KeyNote.Position = UDim2.new(0, 20, 0, 55)
            KeyNote.BackgroundTransparency = 1
            KeyNote.Text = config.KeySettings.Note or ""
            KeyNote.TextColor3 = Color3.fromRGB(200, 200, 200)
            KeyNote.TextSize = 14
            KeyNote.Font = Enum.Font.Gotham
            KeyNote.TextXAlignment = Enum.TextXAlignment.Left
            KeyNote.TextWrapped = true
            KeyNote.Parent = KeyFrame
            
            local KeyInput = Instance.new("TextBox")
            KeyInput.Size = UDim2.new(1, -40, 0, 40)
            KeyInput.Position = UDim2.new(0, 20, 0, 95)
            KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            KeyInput.BorderSizePixel = 0
            KeyInput.PlaceholderText = "Enter Key..."
            KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            KeyInput.Text = ""
            KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeyInput.TextSize = 14
            KeyInput.Font = Enum.Font.Gotham
            KeyInput.Parent = KeyFrame
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 8)
            InputCorner.Parent = KeyInput
            
            local SubmitButton = Instance.new("TextButton")
            SubmitButton.Size = UDim2.new(0.48, 0, 0, 40)
            SubmitButton.Position = UDim2.new(0, 20, 0, 145)
            SubmitButton.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
            SubmitButton.Text = "Submit"
            SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            SubmitButton.TextSize = 15
            SubmitButton.Font = Enum.Font.GothamBold
            SubmitButton.BorderSizePixel = 0
            SubmitButton.Parent = KeyFrame
            
            local SubmitCorner = Instance.new("UICorner")
            SubmitCorner.CornerRadius = UDim.new(0, 8)
            SubmitCorner.Parent = SubmitButton
            
            SubmitButton.MouseEnter:Connect(function()
                Tween(SubmitButton, {BackgroundColor3 = Color3.fromRGB(90, 130, 255)}, 0.2)
            end)
            
            SubmitButton.MouseLeave:Connect(function()
                Tween(SubmitButton, {BackgroundColor3 = Color3.fromRGB(80, 120, 255)}, 0.2)
            end)
            
            if config.KeySettings.ButtonJoin then
                local JoinButton = Instance.new("TextButton")
                JoinButton.Size = UDim2.new(0.48, 0, 0, 40)
                JoinButton.Position = UDim2.new(0.52, 0, 0, 145)
                JoinButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
                JoinButton.Text = "Join Discord"
                JoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                JoinButton.TextSize = 15
                JoinButton.Font = Enum.Font.GothamBold
                JoinButton.BorderSizePixel = 0
                JoinButton.Parent = KeyFrame
                
                local JoinCorner = Instance.new("UICorner")
                JoinCorner.CornerRadius = UDim.new(0, 8)
                JoinCorner.Parent = JoinButton
                
                JoinButton.MouseButton1Click:Connect(function()
                    if config.KeySettings.ButtonLink then
                        setclipboard(config.KeySettings.ButtonLink)
                    end
                end)
                
                JoinButton.MouseEnter:Connect(function()
                    Tween(JoinButton, {BackgroundColor3 = Color3.fromRGB(98, 111, 252)}, 0.2)
                end)
                
                JoinButton.MouseLeave:Connect(function()
                    Tween(JoinButton, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}, 0.2)
                end)
            end
            
            SubmitButton.MouseButton1Click:Connect(function()
                local enteredKey = KeyInput.Text
                local validKey = false
                
                for _, key in ipairs(config.KeySettings.Key) do
                    if enteredKey == key then
                        validKey = true
                        break
                    end
                end
                
                if validKey then
                    if config.KeySettings.SaveKey then
                        writefile((config.KeySettings.FileName or "Key") .. ".txt", enteredKey)
                    end
                    
                    Tween(KeyFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                    wait(0.3)
                    KeyFrame:Destroy()
                    MainFrame.Visible = true
                    Tween(MainFrame, {Size = UDim2.new(0, 550, 0, 400)}, 0.4, Enum.EasingStyle.Back)
                else
                    KeyInput.Text = ""
                    KeyInput.PlaceholderText = "Invalid Key!"
                    Tween(KeyFrame, {Position = UDim2.new(0.5, -210, 0.5, -125)}, 0.05)
                    wait(0.05)
                    Tween(KeyFrame, {Position = UDim2.new(0.5, -190, 0.5, -125)}, 0.05)
                    wait(0.05)
                    Tween(KeyFrame, {Position = UDim2.new(0.5, -200, 0.5, -125)}, 0.05)
                    wait(1)
                    KeyInput.PlaceholderText = "Enter Key..."
                end
            end)
            
            -- Entrance animation
            KeyFrame.Size = UDim2.new(0, 0, 0, 0)
            Tween(KeyFrame, {Size = UDim2.new(0, 400, 0, 250)}, 0.4, Enum.EasingStyle.Back)
        else
            -- Entrance animation
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            Tween(MainFrame, {Size = UDim2.new(0, 550, 0, 400)}, 0.4, Enum.EasingStyle.Back)
        end
    else
        -- Entrance animation
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        Tween(MainFrame, {Size = UDim2.new(0, 550, 0, 400)}, 0.4, Enum.EasingStyle.Back)
    end
    
    WindowManager.Tabs = {}
    WindowManager.CurrentTab = nil

    
    -- Create Tab
    function WindowManager:CreateTab(name, icon)
        local TabManager = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        TabButton.Text = ""
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 8)
        TabButtonCorner.Parent = TabButton
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = "rbxassetid://" .. (icon or "0")
        TabIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
        TabIcon.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -45, 1, 0)
        TabLabel.Position = UDim2.new(0, 40, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabLabel.TextSize = 14
        TabLabel.Font = Enum.Font.GothamBold
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, -10, 1, -10)
        TabContent.Position = UDim2.new(0, 5, 0, 5)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 255)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 8)
        ContentList.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(WindowManager.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
                Tween(tab.Icon, {ImageColor3 = Color3.fromRGB(200, 200, 200)}, 0.2)
                Tween(tab.Label, {TextColor3 = Color3.fromRGB(200, 200, 200)}, 0.2)
            end
            
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(80, 120, 255)}, 0.2)
            Tween(TabIcon, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
            Tween(TabLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
            WindowManager.CurrentTab = TabManager
        end)
        
        TabButton.MouseEnter:Connect(function()
            if WindowManager.CurrentTab ~= TabManager then
                Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if WindowManager.CurrentTab ~= TabManager then
                Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
            end
        end)
        
        TabManager.Button = TabButton
        TabManager.Content = TabContent
        TabManager.Icon = TabIcon
        TabManager.Label = TabLabel
        
        table.insert(WindowManager.Tabs, TabManager)
        
        if #WindowManager.Tabs == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Create Button
        function TabManager:CreateButton(config)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Size = UDim2.new(1, -10, 0, 40)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = ButtonFrame
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = config.Name or "Button"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.Font = Enum.Font.GothamBold
            Button.Parent = ButtonFrame
            
            Button.MouseButton1Click:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(80, 120, 255)}, 0.1)
                wait(0.1)
                Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.1)
                
                if config.Callback then
                    config.Callback()
                end
            end)
            
            Button.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
            end)
            
            return Button
        end
        
        -- Create Toggle
        function TabManager:CreateToggle(config)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = config.Name or "Toggle"
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.GothamBold
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 45, 0, 24)
            ToggleButton.Position = UDim2.new(1, -55, 0.5, -12)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            ToggleButton.Text = ""
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
            ToggleCircle.Position = UDim2.new(0, 3, 0.5, -9)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local toggled = config.CurrentValue or false
            
            local function UpdateToggle(value)
                toggled = value
                if toggled then
                    Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(80, 120, 255)}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}, 0.2)
                end
                
                if config.Callback then
                    config.Callback(toggled)
                end
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                UpdateToggle(not toggled)
            end)
            
            ToggleFrame.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
            end)
            
            ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
            end)
            
            UpdateToggle(toggled)
            
            return {
                Set = function(self, value)
                    UpdateToggle(value)
                end
            }
        end

        
        -- Create Slider
        function TabManager:CreateSlider(config)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -10, 0, 60)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
            SliderLabel.Position = UDim2.new(0, 15, 0, 8)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = config.Name or "Slider"
            SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.GothamBold
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0.3, -15, 0, 20)
            SliderValue.Position = UDim2.new(0.7, 0, 0, 8)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(config.CurrentValue or config.Range[1]) .. (config.Suffix or "")
            SliderValue.TextColor3 = Color3.fromRGB(80, 120, 255)
            SliderValue.TextSize = 14
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBackground = Instance.new("Frame")
            SliderBackground.Size = UDim2.new(1, -30, 0, 6)
            SliderBackground.Position = UDim2.new(0, 15, 1, -18)
            SliderBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            SliderBackground.BorderSizePixel = 0
            SliderBackground.Parent = SliderFrame
            
            local SliderBgCorner = Instance.new("UICorner")
            SliderBgCorner.CornerRadius = UDim.new(1, 0)
            SliderBgCorner.Parent = SliderBackground
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBackground
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = SliderBackground
            
            local dragging = false
            local minValue = config.Range[1]
            local maxValue = config.Range[2]
            local increment = config.Increment or 1
            local currentValue = config.CurrentValue or minValue
            
            local function UpdateSlider(value)
                value = math.clamp(value, minValue, maxValue)
                value = math.floor((value - minValue) / increment + 0.5) * increment + minValue
                currentValue = value
                
                local percentage = (value - minValue) / (maxValue - minValue)
                Tween(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                SliderValue.Text = tostring(value) .. (config.Suffix or "")
                
                if config.Callback then
                    config.Callback(value)
                end
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            SliderButton.MouseMoved:Connect(function(x)
                if dragging then
                    local percentage = math.clamp((x - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                    local value = minValue + (maxValue - minValue) * percentage
                    UpdateSlider(value)
                end
            end)
            
            SliderFrame.MouseEnter:Connect(function()
                Tween(SliderFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
            end)
            
            SliderFrame.MouseLeave:Connect(function()
                Tween(SliderFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
            end)
            
            UpdateSlider(currentValue)
            
            return {
                Set = function(self, value)
                    UpdateSlider(value)
                end
            }
        end
        
        -- Create Input
        function TabManager:CreateInput(config)
            local InputFrame = Instance.new("Frame")
            InputFrame.Size = UDim2.new(1, -10, 0, 70)
            InputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            InputFrame.BorderSizePixel = 0
            InputFrame.Parent = TabContent
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 8)
            InputCorner.Parent = InputFrame
            
            local InputLabel = Instance.new("TextLabel")
            InputLabel.Size = UDim2.new(1, -30, 0, 20)
            InputLabel.Position = UDim2.new(0, 15, 0, 8)
            InputLabel.BackgroundTransparency = 1
            InputLabel.Text = config.Name or "Input"
            InputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputLabel.TextSize = 14
            InputLabel.Font = Enum.Font.GothamBold
            InputLabel.TextXAlignment = Enum.TextXAlignment.Left
            InputLabel.Parent = InputFrame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(1, -30, 0, 32)
            InputBox.Position = UDim2.new(0, 15, 0, 30)
            InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            InputBox.BorderSizePixel = 0
            InputBox.PlaceholderText = config.PlaceholderText or "Enter text..."
            InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            InputBox.Text = config.CurrentValue or ""
            InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputBox.TextSize = 13
            InputBox.Font = Enum.Font.Gotham
            InputBox.ClearTextOnFocus = false
            InputBox.Parent = InputFrame
            
            local InputBoxCorner = Instance.new("UICorner")
            InputBoxCorner.CornerRadius = UDim.new(0, 6)
            InputBoxCorner.Parent = InputBox
            
            local InputPadding = Instance.new("UIPadding")
            InputPadding.PaddingLeft = UDim.new(0, 10)
            InputPadding.PaddingRight = UDim.new(0, 10)
            InputPadding.Parent = InputBox
            
            InputBox.FocusLost:Connect(function(enterPressed)
                if config.RemoveTextAfterFocusLost then
                    InputBox.Text = ""
                end
                
                if config.Callback then
                    config.Callback(InputBox.Text)
                end
            end)
            
            InputBox.Focused:Connect(function()
                Tween(InputBox, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2)
            end)
            
            InputBox:GetPropertyChangedSignal("Text"):Connect(function()
                Tween(InputBox, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, 0.2)
            end)
            
            InputFrame.MouseEnter:Connect(function()
                Tween(InputFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
            end)
            
            InputFrame.MouseLeave:Connect(function()
                Tween(InputFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
            end)
            
            return InputBox
        end

        
        -- Create Dropdown
        function TabManager:CreateDropdown(config)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, -10, 0, 70)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -30, 0, 20)
            DropdownLabel.Position = UDim2.new(0, 15, 0, 8)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = config.Name or "Dropdown"
            DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownLabel.TextSize = 14
            DropdownLabel.Font = Enum.Font.GothamBold
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, -30, 0, 32)
            DropdownButton.Position = UDim2.new(0, 15, 0, 30)
            DropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Text = ""
            DropdownButton.Parent = DropdownFrame
            
            local DropdownButtonCorner = Instance.new("UICorner")
            DropdownButtonCorner.CornerRadius = UDim.new(0, 6)
            DropdownButtonCorner.Parent = DropdownButton
            
            local DropdownText = Instance.new("TextLabel")
            DropdownText.Size = UDim2.new(1, -40, 1, 0)
            DropdownText.Position = UDim2.new(0, 10, 0, 0)
            DropdownText.BackgroundTransparency = 1
            DropdownText.Text = config.CurrentOption[1] or "Select..."
            DropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownText.TextSize = 13
            DropdownText.Font = Enum.Font.Gotham
            DropdownText.TextXAlignment = Enum.TextXAlignment.Left
            DropdownText.Parent = DropdownButton
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
            DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = Color3.fromRGB(200, 200, 200)
            DropdownArrow.TextSize = 10
            DropdownArrow.Font = Enum.Font.Gotham
            DropdownArrow.Parent = DropdownButton
            
            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Size = UDim2.new(1, -30, 0, 0)
            DropdownList.Position = UDim2.new(0, 15, 0, 68)
            DropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            DropdownList.BorderSizePixel = 0
            DropdownList.ScrollBarThickness = 4
            DropdownList.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 255)
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
            DropdownList.Visible = false
            DropdownList.Parent = DropdownFrame
            
            local DropdownListCorner = Instance.new("UICorner")
            DropdownListCorner.CornerRadius = UDim.new(0, 6)
            DropdownListCorner.Parent = DropdownList
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 2)
            ListLayout.Parent = DropdownList
            
            local isOpen = false
            local selectedOptions = config.CurrentOption or {}
            
            local function UpdateDropdown()
                if config.MultipleOptions then
                    DropdownText.Text = #selectedOptions > 0 and table.concat(selectedOptions, ", ") or "Select..."
                else
                    DropdownText.Text = selectedOptions[1] or "Select..."
                end
                
                if config.Callback then
                    config.Callback(selectedOptions)
                end
            end
            
            for _, option in ipairs(config.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, -8, 0, 30)
                OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                OptionButton.TextSize = 13
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Parent = DropdownList
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 4)
                OptionCorner.Parent = OptionButton
                
                OptionButton.MouseButton1Click:Connect(function()
                    if config.MultipleOptions then
                        local found = false
                        for i, selected in ipairs(selectedOptions) do
                            if selected == option then
                                table.remove(selectedOptions, i)
                                found = true
                                Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, 0.2)
                                break
                            end
                        end
                        if not found then
                            table.insert(selectedOptions, option)
                            Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(80, 120, 255)}, 0.2)
                        end
                    else
                        selectedOptions = {option}
                        for _, btn in ipairs(DropdownList:GetChildren()) do
                            if btn:IsA("TextButton") then
                                Tween(btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, 0.2)
                            end
                        end
                        Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(80, 120, 255)}, 0.2)
                        
                        wait(0.1)
                        isOpen = false
                        DropdownList.Visible = false
                        Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 70)}, 0.2)
                        Tween(DropdownArrow, {Rotation = 0}, 0.2)
                    end
                    
                    UpdateDropdown()
                end)
                
                OptionButton.MouseEnter:Connect(function()
                    if not config.MultipleOptions or not table.find(selectedOptions, option) then
                        Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2)
                    end
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    local isSelected = table.find(selectedOptions, option)
                    if isSelected then
                        Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(80, 120, 255)}, 0.2)
                    else
                        Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, 0.2)
                    end
                end)
                
                -- Set initial state
                if table.find(selectedOptions, option) then
                    OptionButton.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
                end
            end
            
            ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 8)
            end)
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                DropdownList.Visible = isOpen
                
                if isOpen then
                    local listHeight = math.min(120, ListLayout.AbsoluteContentSize.Y + 8)
                    Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 70 + listHeight + 6)}, 0.2)
                    Tween(DropdownList, {Size = UDim2.new(1, -30, 0, listHeight)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 180}, 0.2)
                else
                    Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 70)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 0}, 0.2)
                end
            end)
            
            DropdownFrame.MouseEnter:Connect(function()
                Tween(DropdownFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
            end)
            
            DropdownFrame.MouseLeave:Connect(function()
                Tween(DropdownFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
            end)
            
            UpdateDropdown()
            
            return {
                Set = function(self, options)
                    selectedOptions = type(options) == "table" and options or {options}
                    UpdateDropdown()
                end
            }
        end

        
        -- Create ColorPicker
        function TabManager:CreateColorPicker(config)
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Size = UDim2.new(1, -10, 0, 40)
            ColorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            ColorFrame.BorderSizePixel = 0
            ColorFrame.Parent = TabContent
            
            local ColorCorner = Instance.new("UICorner")
            ColorCorner.CornerRadius = UDim.new(0, 8)
            ColorCorner.Parent = ColorFrame
            
            local ColorLabel = Instance.new("TextLabel")
            ColorLabel.Size = UDim2.new(1, -60, 1, 0)
            ColorLabel.Position = UDim2.new(0, 15, 0, 0)
            ColorLabel.BackgroundTransparency = 1
            ColorLabel.Text = config.Name or "Color Picker"
            ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ColorLabel.TextSize = 14
            ColorLabel.Font = Enum.Font.GothamBold
            ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
            ColorLabel.Parent = ColorFrame
            
            local ColorDisplay = Instance.new("TextButton")
            ColorDisplay.Size = UDim2.new(0, 35, 0, 24)
            ColorDisplay.Position = UDim2.new(1, -45, 0.5, -12)
            ColorDisplay.BackgroundColor3 = config.Color or Color3.fromRGB(255, 255, 255)
            ColorDisplay.Text = ""
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Parent = ColorFrame
            
            local ColorDisplayCorner = Instance.new("UICorner")
            ColorDisplayCorner.CornerRadius = UDim.new(0, 6)
            ColorDisplayCorner.Parent = ColorDisplay
            
            local currentColor = config.Color or Color3.fromRGB(255, 255, 255)
            
            ColorDisplay.MouseButton1Click:Connect(function()
                -- Simple color picker (you can expand this with a full color wheel)
                local colors = {
                    Color3.fromRGB(255, 0, 0),
                    Color3.fromRGB(255, 127, 0),
                    Color3.fromRGB(255, 255, 0),
                    Color3.fromRGB(0, 255, 0),
                    Color3.fromRGB(0, 0, 255),
                    Color3.fromRGB(75, 0, 130),
                    Color3.fromRGB(148, 0, 211),
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(0, 0, 0)
                }
                
                local index = 1
                for i, color in ipairs(colors) do
                    if currentColor == color then
                        index = i
                        break
                    end
                end
                
                index = index % #colors + 1
                currentColor = colors[index]
                
                Tween(ColorDisplay, {BackgroundColor3 = currentColor}, 0.2)
                
                if config.Callback then
                    config.Callback(currentColor)
                end
            end)
            
            ColorFrame.MouseEnter:Connect(function()
                Tween(ColorFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
            end)
            
            ColorFrame.MouseLeave:Connect(function()
                Tween(ColorFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
            end)
            
            return {
                Set = function(self, color)
                    currentColor = color
                    Tween(ColorDisplay, {BackgroundColor3 = color}, 0.2)
                end
            }
        end
        
        -- Create Keybind
        function TabManager:CreateKeybind(config)
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Size = UDim2.new(1, -10, 0, 40)
            KeybindFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Parent = TabContent
            
            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 8)
            KeybindCorner.Parent = KeybindFrame
            
            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(1, -80, 1, 0)
            KeybindLabel.Position = UDim2.new(0, 15, 0, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = config.Name or "Keybind"
            KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindLabel.TextSize = 14
            KeybindLabel.Font = Enum.Font.GothamBold
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = KeybindFrame
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 60, 0, 24)
            KeybindButton.Position = UDim2.new(1, -70, 0.5, -12)
            KeybindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            KeybindButton.Text = config.CurrentKeybind or "None"
            KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindButton.TextSize = 12
            KeybindButton.Font = Enum.Font.GothamBold
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Parent = KeybindFrame
            
            local KeybindButtonCorner = Instance.new("UICorner")
            KeybindButtonCorner.CornerRadius = UDim.new(0, 6)
            KeybindButtonCorner.Parent = KeybindButton
            
            local currentKeybind = config.CurrentKeybind or "None"
            local listening = false
            
            KeybindButton.MouseButton1Click:Connect(function()
                listening = true
                KeybindButton.Text = "..."
                Tween(KeybindButton, {BackgroundColor3 = Color3.fromRGB(80, 120, 255)}, 0.2)
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening then
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        currentKeybind = input.KeyCode.Name
                        KeybindButton.Text = currentKeybind
                        listening = false
                        Tween(KeybindButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, 0.2)
                    end
                elseif not gameProcessed and currentKeybind ~= "None" then
                    if input.KeyCode.Name == currentKeybind then
                        if config.HoldToInteract then
                            if config.Callback then
                                config.Callback(true)
                            end
                        else
                            if config.Callback then
                                config.Callback()
                            end
                        end
                    end
                end
            end)
            
            if config.HoldToInteract then
                UserInputService.InputEnded:Connect(function(input, gameProcessed)
                    if not gameProcessed and currentKeybind ~= "None" and input.KeyCode.Name == currentKeybind then
                        if config.Callback then
                            config.Callback(false)
                        end
                    end
                end)
            end
            
            KeybindFrame.MouseEnter:Connect(function()
                Tween(KeybindFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
            end)
            
            KeybindFrame.MouseLeave:Connect(function()
                Tween(KeybindFrame, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
            end)
            
            return {
                Set = function(self, keybind)
                    currentKeybind = keybind
                    KeybindButton.Text = keybind
                end
            }
        end
        
        -- Create Label
        function TabManager:CreateLabel(text, icon, color, ignoreTheme)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Size = UDim2.new(1, -10, 0, 35)
            LabelFrame.BackgroundColor3 = ignoreTheme and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(30, 30, 35)
            LabelFrame.BackgroundTransparency = ignoreTheme and 1 or 0
            LabelFrame.BorderSizePixel = 0
            LabelFrame.Parent = TabContent
            
            if not ignoreTheme then
                local LabelCorner = Instance.new("UICorner")
                LabelCorner.CornerRadius = UDim.new(0, 8)
                LabelCorner.Parent = LabelFrame
            end
            
            if icon and icon ~= 0 then
                local LabelIcon = Instance.new("ImageLabel")
                LabelIcon.Size = UDim2.new(0, 20, 0, 20)
                LabelIcon.Position = UDim2.new(0, 10, 0.5, -10)
                LabelIcon.BackgroundTransparency = 1
                LabelIcon.Image = "rbxassetid://" .. icon
                LabelIcon.ImageColor3 = color or Color3.fromRGB(255, 255, 255)
                LabelIcon.Parent = LabelFrame
            end
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, icon and -45 or -20, 1, 0)
            Label.Position = UDim2.new(0, icon and 40 or 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text or "Label"
            Label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            Label.Parent = LabelFrame
            
            return {
                Set = function(self, newText)
                    Label.Text = newText
                end
            }
        end
        
        return TabManager
    end
    
    return WindowManager
end

return NakoUI
