local Tile = require("Tiles/Tile")

---@class PathTile : Tile
local Path = Tile:extend()

function Path:new(x, y, r, level)
    Path.super.new(self, x, y, r, level)

    self.steppedon = false
end

function Path:onTouch(player, triggeredneighbour)
	if not triggeredneighbour then
		self.steppedon = true

		self:addAttribute("Infestion")
	end
end

function Path:__tostring()
	return "Path" .. " At: " .. self.x .. ", " .. self.y
end

return Path