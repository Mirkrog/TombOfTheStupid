Tile = require("Tiles/Tile")

Wall = Tile:extend()

function Wall:new(x, y, r)
	self.x = x 
	self.y = y 
	self.r = r 
end

function Wall:__tostring()
	return "Wall"
end

function Wall:draw(scale)
	love.graphics.setColor(0, 0, 1)

	love.graphics.rectangle("fill", self.x * scale - 0.5 * scale, self.y * scale - 0.5 * scale, scale, scale)
end

return Wall