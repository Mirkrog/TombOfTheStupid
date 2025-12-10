tile = require("Tiles/Tile")

Wall = tile:extend()

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

	love.graphics.rectangle("fill", self.x * scale + 5, self.y * scale + 5, scale - 10, scale - 10)
end

return Wall