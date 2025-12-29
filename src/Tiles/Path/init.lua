local Tile = require("Tiles/Tile")

---@class Path : Tile
local Path = Tile:extend()

function Path:__tostring()
	return "Wall"
end

return Path