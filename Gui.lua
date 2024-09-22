local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Header = Instance.new("Frame")
local HeaderUICorner = Instance.new("UICorner")
local CloseButton = Instance.new("TextButton")
local ShowButton = Instance.new("TextButton")
local ShowButtonUICorner = Instance.new("UICorner")
local HeaderLabel = Instance.new("TextLabel") -- Добавляем TextLabel для надписи

-- Устанавливаем свойства ScreenGui
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false -- Делаем GUI не сбрасываемым при возрождении

-- Устанавливаем свойства Frame
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Черный цвет
Frame.BackgroundTransparency = 0.1 -- Прозрачность 10%
Frame.Size = UDim2.new(0.42, 0, 0.42, 0) -- Увеличиваем размер на 40%
Frame.Position = UDim2.new(0.29, 0, 0.29, 0) -- Устанавливаем позицию Frame, чтобы оно занимало 30% экрана

-- Устанавливаем свойства UICorner
UICorner.Parent = Frame
UICorner.CornerRadius = UDim.new(0.03, 0) -- Уменьшенное свойство corner на 40%

-- Создаем и настраиваем шапку
Header.Parent = Frame
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Черный цвет
Header.BackgroundTransparency = 0.1 -- Прозрачность 10%
Header.Size = UDim2.new(1, 0, 0.065, 0) -- Высота шапки увеличена на 30%
Header.Position = UDim2.new(0, 0, 0, 0) -- Шапка вверху Frame

-- Устанавливаем свойства HeaderUICorner
HeaderUICorner.Parent = Header
HeaderUICorner.CornerRadius = UDim.new(0.03, 0) -- Устанавливаем такое же свойство corner

-- Создаем надпись "SD Hub"
HeaderLabel.Parent = Header
HeaderLabel.Text = "SD Hub"
HeaderLabel.Size = UDim2.new(0.2, 0, 1, 0)
HeaderLabel.Position = UDim2.new(0, 5, 0, 0) -- Позиция слева с небольшим отступом
HeaderLabel.BackgroundTransparency = 1 -- Прозрачный фон
HeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый цвет текста
HeaderLabel.TextScaled = true
HeaderLabel.Font = Enum.Font.Cartoon -- Устанавливаем шрифт

-- Создаем кнопку закрытия
CloseButton.Parent = Header
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0.05, 0, 1, 0)
CloseButton.Position = UDim2.new(0.95, 0, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.Cartoon -- Устанавливаем шрифт

-- Создаем кнопку показа
ShowButton.Parent = ScreenGui
ShowButton.Text = "🌸"
ShowButton.Size = UDim2.new(0.033, 0, 0.033, 0) -- Уменьшаем размер в 3 раза и делаем квадратной
ShowButton.Position = UDim2.new(0.485, 0, 0.485, -400) -- Центрируем кнопку и поднимаем на 400 пикселей выше
ShowButton.BackgroundTransparency = 1 -- Делаем кнопку невидимой
ShowButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ShowButton.TextScaled = true
ShowButton.Visible = false
ShowButton.Font = Enum.Font.Cartoon -- Устанавливаем шрифт

-- Устанавливаем свойства ShowButtonUICorner
ShowButtonUICorner.Parent = ShowButton
ShowButtonUICorner.CornerRadius = UDim.new(0.03, 0)

-- Создаем таблицу с вкладками
local tabs = {"Main", "Misc", "Scripts"}
local tabHeight = 0.1
local tabFrames = {}

-- Создаем TextLabel для отображения названия текущей вкладки
local TabTitleLabel = Instance.new("TextLabel")
TabTitleLabel.Parent = Frame
TabTitleLabel.Size = UDim2.new(1, 0, 0.1, 0)
TabTitleLabel.Position = UDim2.new(0, 0, 0, -8)
TabTitleLabel.BackgroundTransparency = 1
TabTitleLabel.TextColor3 = Color3.fromRGB(169, 169, 169) -- Серый цвет текста
TabTitleLabel.TextScaled = true
TabTitleLabel.Font = Enum.Font.Cartoon -- Устанавливаем шрифт
TabTitleLabel.Text = "Main" -- Изначально показываем "Main"

for i, tabName in ipairs(tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Parent = Frame
    TabButton.Text = tabName
    TabButton.Size = UDim2.new(0.2, 0, tabHeight, 0)
    TabButton.Position = UDim2.new(-0.2, 0, (i - 1) * tabHeight, 0) -- Позиция за основным фреймом
    TabButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TabButton.BackgroundTransparency = 0.1
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextScaled = true
    TabButton.Font = Enum.Font.Cartoon -- Устанавливаем шрифт

    local TabFrame = Instance.new("Frame")
    TabFrame.Parent = Frame
    TabFrame.Size = UDim2.new(1, 0, 1 - tabHeight, 0)
    TabFrame.Position = UDim2.new(0, 0, tabHeight, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = false
    tabFrames[tabName] = TabFrame

    TabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(tabFrames) do
            frame.Visible = false
        end
        TabFrame.Visible = true
        TabTitleLabel.Text = tabName -- Обновляем текст названия вкладки
    end)

    TabButton.MouseEnter:Connect(function()
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundTransparency = 0.1
    end)

    TabButton.MouseLeave:Connect(function()
        TabButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        TabButton.BackgroundTransparency = 0.1
    end)
end

-- Функция для добавления кнопок в вкладки
local function addButtonToTab(tabName, buttonText, callback)
    local tabFrame = tabFrames[tabName]
    if not tabFrame then return end

    local buttonCount = #tabFrame:GetChildren()
    local button = Instance.new("TextButton")
    button.Parent = tabFrame
    button.Text = buttonText
    button.Size = UDim2.new(1, 0, 0.1, 0) -- Растягиваем кнопку по всей ширине
    button.Position = UDim2.new(0, 0, (buttonCount - 1) * 0.1 + 0.065, 0) -- Располагаем кнопки сверху вниз, начиная под шапкой
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.BackgroundTransparency = 0.1
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.Cartoon -- Устанавливаем шрифт

    button.MouseButton1Click:Connect(callback)
end

-- Добавляем кнопку "Print Test" во вкладку "Main"
addButtonToTab("Main", "Print Test", function()
    print("Test")
end)

-- Добавляем кнопку "Invisible H (999k, 500, 0)" во вкладку "Main"
addButtonToTab("Main", "Invisible H (999k, 500, 0)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VernonMoore54/invis/refs/heads/main/invis.lua"))()
end)

-- Добавляем кнопку "ctrl + click = tp" во вкладку "Main"
addButtonToTab("Main", "ctrl + click = tp", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VernonMoore54/invis/refs/heads/main/ctrl.lua"))()
end)

-- Добавляем кнопку "Right Click (hold, near player)" во вкладку "Main"
addButtonToTab("Main", "Right Click (hold, near player)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VernonMoore54/invis/refs/heads/main/RCM.lua"))()
end)

-- Добавляем кнопку "IY Reborn" во вкладку "Scripts"
addButtonToTab("Scripts", "IY Reborn", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/uksfx/infiniteyield-reborn-reborn/master/source"))()
end)

-- Добавляем кнопку "Devas moonstone farm" во вкладку "Scripts"
addButtonToTab("Scripts", "Devas moonstone farm", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VernonMoore54/invis/refs/heads/main/Devas%20moonstone%20Farm.lua"))()
end)

-- Скрипт для перемещения GUI
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

-- Скрипт для скрытия и показа GUI
CloseButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
    ShowButton.Visible = true
end)

ShowButton.MouseButton1Click:Connect(function()
    Frame.Position = UDim2.new(0.29, 0, 0.29, 0) -- Позиция по центру экрана
    Frame.Visible = true
    ShowButton.Visible = false
end)

-- Добавляем функциональность для скрытия/показа GUI с помощью клавиши Insert
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Insert and not gameProcessed then
        Frame.Visible = not Frame.Visible
        ShowButton.Visible = not Frame.Visible
    end
end)

-- Изначально показываем вкладку "Main"
tabFrames["Main"].Visible = true
