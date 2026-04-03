local Tile = require("Tiles/Tile")
local Tilemap = require("Util/Tilemap")

local gameconfig = require("gameconfig")
local coloratlas = require("coloratlas")
local tilemap = Tilemap("Assets/Wall-Tilemap.png", gameconfig.tilescale,
							gameconfig.tilescale)

---@class WallTile : Tile
local Wall = Tile:extend()

function Wall:new(x, y, r)
	self.super.new(self, x, y, r, level)

	self.tilemap = tilemap
	self.collision = true
end

function Wall:__tostring()
	return "Wall" .. " At: " .. self.x .. self.y
end

function Wall:draw(scale)
	love.graphics.setColor(coloratlas.purple)

	local level = self.level

	--[[
		The following code defines some tiling rules in a dynamic way,
		it determins which tiles to choose depending on the surrounding tiles
	]]
	--these corrospond to the position of the Texture of this Tile in the current state in Tilemap coordinates
	local tileposx = 1
	local tileposy = 1

	--checks weather the tiles to the left and right of this Tile are Paths, if they are it adds their x coordinates
	local directions = {1, -1}
	for i, direction in ipairs(directions) do
		local neighbortile = level:get(self.x + direction, self.y)
		if neighbortile and (neighbortile:isExact(require("Tiles/Path")) or
			neighbortile:isExact(require("Tiles/End"))) then

			tileposx = tileposx + direction
		end
	end
	--does the same as the above but for the y axis
	for i, direction in ipairs(directions) do
		local neighbortile = level:get(self.x, self.y + direction)
		if neighbortile and (neighbortile:isExact(require("Tiles/Path")) or
			neighbortile:isExact(require("Tiles/End"))) then

			tileposy = tileposy + direction
		end
	end

	self.tilemap:drawTile(tileposx or 0, tileposy or 0, (self.x - 0.5) * scale, (self.y - 0.5) * scale,
						  0, scale, scale)
end

return Wall