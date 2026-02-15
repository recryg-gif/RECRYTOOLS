local config = getgenv().ScriptConfig

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
local Window = Library:CreateWindow({
    Title = config["заголовок менюшки"],
    Footer = config["нижний заголовок"],
    NotifySide = "Right",
})

local player = game:GetService("Players").LocalPlayer


local Tab = Window:AddTab("Main", "user")

local groupbox = Tab:AddLeftGroupbox("Main")

local dupe_amount = 50

local dupe_slider = groupbox:AddSlider("d", {
    Text = "Amount to dupe",
    Default = dupe_amount,
    Min = 1,
    Max = 200,
    Rounding = 0,
    Suffix = " Items"
}):OnChanged(function(val)
    dupe_amount = val
end)

groupbox:AddButton({
    Text = "Start Dupe",
    Func = function()
        local depends = player.PlayerGui.MainGUI.Game.Inventory.Main.Weapons.Items.Container
        local containers = {
            depends.Classic,
            depends.Current,
            depends.Holiday.Container.Christmas,
            depends.Holiday.Container.Halloween
        }
        for _, category in pairs(containers) do
            local container = category:WaitForChild("Container")
            
            for _, item in pairs(container:GetChildren()) do
                if (item.Name == "NewItem") then
                    local item_name: string = item.ItemName.Label.Text
                    
                    local item_amount: number = 0

                    if not (item.Container.Amount.Text:find("x")) then
                        item_amount = 1
                    else 
                        item_amount = item.Container.Amount.Text:gsub("x", ""):gsub(",", "")
                        item_amount = tonumber(item_amount)
                    end

        
                    
                    task.spawn(function()
                        for i = 1, dupe_amount do
                            if not (item_name:find("Default")) then
                        
                                local new_amount = item_amount + i
                                local str_amount = "x"..tostring(new_amount)

                                item.Container.Amount.Text = str_amount
                                task.wait(math.random(250, 1000)/1000)
                            end
                        end
                    end)
                    
                end
                
            end
            
        end

    end

})
