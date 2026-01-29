local Object = require("classic/classic")

local gameconfig = require("gameconfig")

---@class Player : Object
local Player = Object:extend()

function Player:new(level)
	self.x = 0
	self.y = 0
	self.dx = 0
	self.dy = 0
	self.direction = 0

	self.alive = true
	self.canmove = true

	self.speed = 50

	self.level = level
end

function Player:__tostring()
  	return "Player"
end

function Player:kill()
	self.alive = false
	self:reset()
	self.alive = true
end

function Player:move(dx, dy)
	self.dx = dx
	self.dy = dy
end

function Player:stop()
	self.dx = 0
	self.dy = 0
end

function Player:reset()
	self:stop()
	self.x = 0
	self.y = 0
end

local function ceilindir(n, dir)
	if dir == 1 then
		return math.ceil(n)
	elseif dir == -1 then
		return math.floor(n)
	else
		error("Invalid direction" .. dir)
	end
end

function Player:update(dt)
	if self.canmove and (self.dx == 0 and self.dy == 0 or not require("gameconfig").enforcemovementrestrictions) then
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
	if self.dx == 0 and self.dy == 0 then
		return
	end

	local mx = self.dx * self.speed * dt
	local my = self.dy * self.speed * dt

	local distance = math.abs(mx + my)

	for i = 1, math.ceil(distance) + 0.1 do
		local step = math.min(1, math.abs(distance - (i - 1)))

		local nextx, nexty = self.x, self.y
		local direction = 0

		if mx ~= 0 then
			direction = (mx / math.abs(mx))
			nextx = self.x + step * direction
		else
			direction = (my / math.abs(my))
			nexty = self.y + step * direction
		end

		local tile = self.level:get(ceilindir(nextx, direction), ceilindir(nexty, direction))

		if not gameconfig.nocollision and tile and tile.collision == true then
			self.x = tile.x - (mx ~= 0 and (mx / math.abs(mx)) or 0)
			self.y = tile.y - (my ~= 0 and (my / math.abs(my)) or 0)

			self.dx = 0
			self.dy = 0
			return
		else
			self.x = nextx
			self.y = nexty
		end
		if tile then
			self.level:touchTile(self, tile.x, tile.y)
		end
	end
end

function Player:draw(scale)
	love.graphics.setColor( 255 / 255,201 / 255,51 / 255)

	love.graphics.circle("fill", self.x * scale, self.y * scale, scale / 2, scale / 2)
end

return Player