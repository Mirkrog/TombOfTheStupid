Object = require("classic/classic")

Player = Object:extend()

function Player:new(level)
	self.x = 0
	self.y = 0
	self.dx = 0
	self.dy = 0
	self.direction = 0

	self.speed = 10

	self.level = level
end

function Player:__tostring()
  	return "Player"
end

function Player:move(dx, dy)
	self.dx = dx
	self.dy = dy
end

local function bidirectionalceil(n)
	if n > 0 then
		return math.ceil(n)
	elseif n < 0 then
		return math.floor(n)
	else
		return 0
	end
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
	if self.dx ~= 0 or self.dy ~= 0 then
		local mx = self.dx * self.speed * dt
		local my = self.dy * self.speed * dt

		for x = self.x, self.x + mx, math.min(math.abs(mx), 1) * mx / math.abs(mx)  do
			for y = self.y, self.y + my, math.min(math.abs(my), 1) * my / math.abs(my) do

				local tile = self.level:get(bidirectionalceil(x), bidirectionalceil(y))
				print(mx, my)
				print(x, y)
				print(bidirectionalceil(x), bidirectionalceil(y))

				if tile and tile.collision == true then
					self.x = tile.x - (mx ~= 0 and (mx / math.abs(mx)) or 0)
					self.y = tile.y - (my ~= 0 and (my / math.abs(my)) or 0)
		
					self.dx = 0
					self.dy = 0
					break
				else
					self.x = x
					self.y = y
				end

				if my == 0 then
					break
				end
			end
			if mx == 0 then
				break
			end
			if self.dx == 0 and self.dy == 0 then
				break
			end
		end
	end
end

function Player:draw(scale)
	love.graphics.setColor(1, 0.5, 0.5)

	love.graphics.circle("fill", self.x * scale, self.y * scale, scale / 2, scale / 2)
end

return Player