local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/UnknownCodersonLT4/Roblox/refs/heads/main/Gamelist/Games.lua"))()

for PlaceID, Execute in pairs(Games) do
    if PlaceID == game.PlaceId then
        loadstring(game:HttpGet(Execute))()
    end
end
