object = require("classic/classic")

Camera = object:extend()

function Camera:new()
	self.x = 0 
	self.y = 0 
end

function Camera:setPos(x, y)
	self.x = x 
	self.y = y
end

function Camera:move(x, y)
	self.x = self.x + x 
	self.y = self.y + y
end

function Camera:apply()
	love.graphics.push()

	love.graphics.translate(-self.x, -self.y)
end

function Camera:unapply()
	love.graphics.pop()
end

return Camera