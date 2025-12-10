Object = require("classic/classic")

Camera = Object:extend()

function Camera:new()
	self.x = 0 
	self.y = 0 

	self.lerp = 0.1

	self.target = nil
end

function Camera:__tostring()
	return "Camera"
end

function Camera:setPos(x, y)
	self.x = x 
	self.y = y
end

function Camera:setTarget(target)
	self.target = target
end

function Camera:move(x, y)
	self.x = self.x + x 
	self.y = self.y + y
end

function Camera:update(dt)
	self.x = self.x + (self.target.x - self.x) * self.lerp 
	self.y = self.y + (self.target.y - self.y) * self.lerp
end

function Camera:apply(scale)
	love.graphics.push()

	love.graphics.translate((-self.x * scale) + love.graphics.getWidth() / 2, (-self.y * scale) + love.graphics.getHeight() / 2)
end

function Camera:unapply()
	love.graphics.pop()
end

return Camera