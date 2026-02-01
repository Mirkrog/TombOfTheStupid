local Tile = require("Tiles/Tile")

---@class PathTile : Tile
local Path = Tile:extend()

function Path:__tostring()
	return "Path"
end

return Path