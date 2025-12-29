local Object = require("classic/classic")
local Player = require("Player")
local Camera = require("Util/Camera")

---@class Level : Object
local Level = Object:extend()

function Level:new()
	self.grid = {}
	self.player = Player(self)
	self.camera = Camera(0.1)
	self.camera:setTarget(self.player)
end

function Level:__tostring()
	return "Level"
end

function Level:update(dt)
	self.player:update(dt)
	self.camera:update(dt)
end

function Level:get(x, y)
	if self.grid[x] == nil then
		return
	end
	return self.grid[x][y]
end

function Level:set(x, y, r, tileName)
	Tile = require("Tiles/" .. tileName)

	if self.grid[x] == nil then
		self.grid[x] = {}
	end
	local tile = Tile(x, y, r)
	self.grid[x][y] = tile
	return tile
end

function Level:remove(x, y)
	if self.grid[x] == nil then
		return
	end
	self.grid[x][y] = nil
end

function Level:draw()
	self.camera:apply(50)

	for x, rows in pairs(self.grid) do
		for y, tile in pairs(rows) do
			if tile then
				tile:draw(50)
			end
		end
	end

	self.player:draw(50)

	self.camera:unapply()
end

local function getRooms()
	local rooms = {}
	for i, filename in pairs(love.filesystem.getDirectoryItems("Rooms")) do
		rooms[#rooms + 1] = require("Rooms/" .. filename:match("(.+)%.[^%.]+$"))
	end

	return rooms
end

function Level:generate()
	local roomstemplates = getRooms()

	local generatedrooms = {}
	local x, y, r = 0, 0, math.random(0, 3)

	for i = 0, 10 do
		local success = false
		local tries = 0
		while not success and tries < 5 do
			local room = roomstemplates[math.random(#roomstemplates)](self)
			room:setOrigin(x, y, r)

			local res
			success, res = xpcall(room.generate, debug.traceback, room, 10)
			if not success then
				if res ~= "RoomOverlaps" then
					error("Error generating room: " .. room:__tostring() .. "\nError: " .. res)
				end
				room:revertTiles()
			else
				generatedrooms[#generatedrooms + 1] = room
				x, y, r = room:getCursorData()
			end
		end
	end
end

return Level