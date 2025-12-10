Object = require("classic/classic")

Player = Object:extend()

function Player:new()
	self.x = 0
	self.y = 0
	self.dx = 0
	self.dy = 0
	self.direction = 0

	self.speed = 10
end

function Player:__tostring()
  	return "Player"
end

function Player:move(dx, dy)
	self.dx = dx
	self.dy = dy
end

function Player:update(dt)
	if self.dx == 0 and self.dy == 0 then
		if love.keyboard.isDown("s") then
			self.dy = 1
			self.dx = 0
		end
		if love.keyboard.isDown("w") then
			self.dy = -1
			self.dx = 0
		end
		if love.keyboard.isDown("d") then
			self.dx = 1
			self.dy = 0
			self.y = math.floor(self.y)
		end
		if love.keyboard.isDown("a") then
			self.dx = -1
			self.dy = 0
		end
	end

	local mx = self.dx * self.speed * dt

	self.x = self.x + self.dx * self.speed * dt
	self.y = self.y + self.dy * self.speed * dt
end

function Player:draw(scale)
	love.graphics.setColor(1, 0.5, 0.5)

	love.graphics.circle("fill", self.x * scale, self.y * scale, scale / 2, scale / 2)
end

return Player