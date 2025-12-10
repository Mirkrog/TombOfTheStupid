Object = require("classic/classic")

Tile = Object:extend()

function Tile:new(x, y, r)
	self.x = x 
	self.y = y 
	self.r = r 
end

function Tile:__tostring()
  	return "Tile"
end

function Tile:draw(scale)
	love.graphics.rectangle("line", self.x * scale - 0.5 * scale, self.y * scale - 0.5 * scale, scale, scale)
end

return Tile