object = require("classic/classic")

Player = object:extend()

function Player:new()
	self.x = 0 
	self.y = 0 
	self.dx = 0
	self.dy = 0
	self.direction = 0

	self.speed = 50
end

function Player:move(dx, dy)
	self.dx = dx
	self.dy = dy
	
end

function Player:update(dt)
	self.x = self.x + self.dx * self.speed
	self.y = self.y + self.dy * self.speed
end

function Player:draw()
	love.graphics.circle("line", self.x * scale + scale * 0.5, self.y * scale + scale * 0.5, scale / 2, scale / 2)
end