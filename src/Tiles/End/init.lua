local Tile = require("Tiles/Tile")

local coloratlas = require("coloratlas")

---@class EndTile : Tile
local End = Tile:extend()

function End:new(x, y, r)
	self.x = x 
	self.y = y 
	self.r = r 
	self.collision = false
	self.clock = 0
end

function End:__tostring()
	return "End"
end

function End:draw(scale)
	self.clock = self.clock + 1
	if self.clock % 20 <= 10 then
		love.graphics.setColor(coloratlas.yellow)
	else
		love.graphics.setColor(coloratlas.purple)
	end

	love.graphics.rectangle("fill", self.x * scale - 0.5 * scale, self.y * scale - 0.5 * scale, scale, scale)
end

function End:onTouch(player, triggeredneighbour)
	if triggeredneighbour == nil then
		player.x = self.x
		player.y = self.y
		player.canmove = false
		player:completeLevel()
	end
end

return End