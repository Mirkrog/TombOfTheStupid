object = require("classic/classic")

Tile = object:extend()

function Tile:new(x, y, r)
	self.x = x 
	self.y = y 
	self.r = r 
end

function Tile:draw(scale)
	love.graphics.rectangle("line", self.x * scale, self.y * scale, scale, scale)
end

return Tile