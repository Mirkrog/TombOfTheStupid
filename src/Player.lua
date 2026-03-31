local Object = require("classic/classic")

local coloratlas = require("coloratlas")
local gameconfig = require("gameconfig")

---@class Player : Object
local Player = Object:extend()

function Player:new(level)
	self.x = 0
	self.y = 0
	self.dx = 0
	self.dy = 0

	--[[
		will be written to if the user inputs to early so movement feels smoother
		0 = up; 1 = right; 2 = down; 3 = left
	]]
	self.bufferdirection = 0
	self.lastbuffdirwrite = -1000 --keeps track of last write to bufferdirection with os.clock()
	self.buffdirexpirancy = 0.05 --how early a user can be for the input to count

	self.score = 0

	self.alive = true
	self.canmove = true

	self.speed = 40

	self.level = level
end

function Player:__tostring()
  	return "Player"
end

function Player:kill()
	self.canmove = false
	self.alive = false
	self.score = 0
	self.level:startGenTask(gameconfig.levellenght)
	self:reset()
	self.alive = true
end

function Player:completeLevel()
	self.canmove = false
	self.level:startGenTask(gameconfig.levellenght)
	self.score = self.score + gameconfig.scoreforlevelcomplete
	self:reset()
end

function Player:givePoints(count)
	count = count or 1
	self.score = self.score + count
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
	self.canmove = true
end

function Player:getScore()
	return self.score
end

local function ceilindir(n, dir)
	if dir == 1 then
		return math.ceil(n)
	elseif dir == -1 then
		return math.floor(n)
	else
		error("Invalid direction: " .. dir)
	end
end

function Player:moveUp()
	self.dx = 0
	self.dy = -1
end

function Player:moveDown()
	self.dx = 0
	self.dy = 1
end

function Player:moveLeft()
	self.dx = -1
	self.dy = 0
end

function Player:moveRight()
	self.dx = 1
	self.dy = 0
end

--[[
	moves the player into the specified direction
	0 = up; 1 = right; 2 = down; 3 = left
]]
function Player:moveInDirection(direction)
	if direction == 0 then
		self:moveUp()
	elseif direction == 1 then
		self:moveRight()
	elseif direction == 2 then
		self:moveDown()
	elseif direction == 3 then
		self:moveLeft()
	else
		error("Invalid Direction" .. direction)
	end
end

function Player:update(dt)
	local canmove = self.canmove and (self.dx == 0 and self.dy == 0 or
					not require("gameconfig").enforcemovementrestrictions) -- this will be reused so we save it to a variable
	if canmove and os.clock() - self.lastbuffdirwrite < self.buffdirexpirancy then
		self:moveInDirection(self.bufferdirection)
	end	
	if love.keyboard.isDown("s") then
		if canmove then
			self:moveDown()
		else
			self.bufferdirection = 2
			self.lastbuffdirwrite = os.clock()
		end
	end
	if love.keyboard.isDown("w") then
		if canmove then
			self:moveUp()
		else
			self.bufferdirection = 0
			self.lastbuffdirwrite = os.clock()
		end
	end
	if love.keyboard.isDown("d") then
		if canmove then
			self:moveRight()
		else
			self.bufferdirection = 1
			self.lastbuffdirwrite = os.clock()
		end
	end
	if love.keyboard.isDown("a") then
		if canmove then
			self:moveLeft()
		else
			self.bufferdirection = 3
			self.lastbuffdirwrite = os.clock()
		end
	end

	if self.dx == 0 and self.dy == 0 then
		self.level:touchTile(self, self.x, self.y)
		return --we can end early here as the player hasn't made any inputs so we don't have to calculate movement
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
	love.graphics.setColor(coloratlas.yellow)

	love.graphics.circle("fill", self.x * scale, self.y * scale, scale / 2, scale / 2)
end

return Player