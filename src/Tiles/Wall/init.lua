local Tile = require("Tiles/Tile")

local coloratlas = require("coloratlas")

---@class WallTile : Tile
local Wall = Tile:extend()

function Wall:new(x, y, r)
	self.x = x 
	self.y = y 
	self.r = r 
	self.collision = true
	self.attributes = {}
end

function Wall:__tostring()
	return "Wall"
end

function Wall:draw(scale)
	love.graphics.setColor(coloratlas.purple)

	love.graphics.rectangle("fill", self.x * scale - 0.5 * scale, self.y * scale - 0.5 * scale, scale, scale)
end

return Wall