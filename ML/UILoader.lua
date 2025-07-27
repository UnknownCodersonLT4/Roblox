--[[
    This is a Moddfied Version of Vxyon Ui Loader I do not take Full Owner Ship ofer ths so its open source 
From : Slayerosn

--]]

local Loader = {}
Loader.__index = Loader

function Loader.new(cfg)
    local self = setmetatable({}, Loader)
    self.cfg = cfg
    local fluentOk, fluentLib = pcall(function()
        return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)
    if not fluentOk or not fluentLib then
        warn("[Script Loader] Failed to load Fluent UI library!")
        return self
    end
    self.libs = { Fluent = fluentLib }
    self:_initUI()
    return self
end

function Loader:_initUI()
    if not self.libs.Fluent then return end
    
    local win = self.libs.Fluent:CreateWindow({
        Title = "Slayerson's UI Loader",
        SubTitle = "Select a script to execute",
        TabWidth = 160,
        Size = UDim2.fromOffset(500, 350),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })
    
    self.window = win
    self.tabs = {
        Main = win:AddTab({ Title = "Scripts", Icon = "box" }),
        Info = win:AddTab({ Title = "Info", Icon = "info" })
    }
    
    
    self.tabs.Main:AddButton({
        Title = "Eternl Mobile Script",
        Description = "This is A Mobile Version. of the script Might not fully work, this is Also Good For Grinding This Has Less fetuers Tho.",
        Callback = function()
            self:_loadScript("https://raw.githubusercontent.com/UnknownCodersonLT4/Roblox/refs/heads/main/ML/bro.lua")
        end
    })
    
    self.tabs.Main:AddButton({
        Title = " Fluent Pc/Mobile Script",
        Description = "This is a Better Verion Meant For Pc But You can use it on Mobile. Add ing auto save Config For Afk grinding, More Fetuers.",
        Callback = function()
            self:_loadScript("https://raw.githubusercontent.com/UnknownCodersonLT4/Roblox/refs/heads/main/ML/FluentVerion.lua")
        end
    })
    
    
    self.tabs.Info:AddParagraph({
        Title = "Script Loader",
        Content = "Select a script to execute it immediately.\n\nEternl Mobile Script: Less Stuff But New stuff coming soon \nFluent Pc/Mobile Script: Has Better Stuff "
    })
end

function Loader:_loadScript(url)
    
    self.libs.Fluent:Notify({
        Title = "Loading Script",
        Content = "Please wait...",
        Duration = 2
    })
    
    
    if self.window then
        self.window:Destroy()
    end
    
    
    local success, err = pcall(function()
        loadstring(game:HttpGet(url, true))()
    end)
    
    if not success then
        warn("Script load error:", err)
    end
end


Loader.new()
