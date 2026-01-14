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
	assert(math.floor(x) == x, "x can't be a float it must be an int")
	assert(math.floor(y) == y, "y can't be a float it must be an int")
	if self.grid[x] == nil then
		return
	end
	return self.grid[x][y]
end

function Level:set(x, y, r, tileName)
	assert(math.floor(x) == x, "x can't be a float it must be an int")
	assert(math.floor(y) == y, "y can't be a float it must be an int")
	assert(math.floor(r) == r, "r can't be a float it must be an int")

	Tile = require("Tiles/" .. tileName)

	if self.grid[x] == nil then
		self.grid[x] = {}
	end
	local tile = Tile(x, y, r)
	self.grid[x][y] = tile
	return tile
end

--[[
	triggers the onTouch function of the tile at the location
	and the neighboring
]]
function Level:touchTile(player, x, y)
	local tile = self:get(x, y)
	if tile then
		tile:onTouch(player, tile)

		tile = self:get(x + 1, y)
		if tile ~= nil then
			tile:onTouch(player, tile)
		end
		tile = self:get(x, y - 1)
		if tile ~= nil then
			tile:onTouch(player, tile)
		end
		tile = self:get(x - 1, y)
		if tile ~= nil then
			tile:onTouch(player, tile)
		end
		tile = self:get(x, y + 1)
		if tile ~= nil then
			tile:onTouch(player, tile)
		end
	end
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
		if filename == "Room.lua" or filename == "Start.lua" then
			goto continue
		end
		rooms[#rooms + 1] = require("Rooms/" .. filename:match("(.+)%.[^%.]+$"))
	    ::continue::
	end

	return rooms
end

function Level:generate(roomcount)
	local roomstemplates = getRooms()

	local generatedrooms = {}
	local x, y, r = 0, 0, math.random(0, 3)

	local watch = os.clock()
	while #generatedrooms < roomcount do
		if #generatedrooms >= 1 then
			print("Enough attempts failed reverting to last room")
			local room = generatedrooms[#generatedrooms]
			room:revertTiles()
			x, y, r = room:getOrigin()
			generatedrooms[#generatedrooms] = nil
		else
			local room = require("Rooms/Start")(self)
			room:generate(3)
			generatedrooms[1] = room
			x, y, r = room:getCursor()
		end
		local tries = 0
		while tries < 5 and #generatedrooms < roomcount do
			local room = roomstemplates[math.random(#roomstemplates)](self)
			room:setOrigin(x, y, r)

			local success, res = xpcall(room.generate, debug.traceback, room, 10) -- the "10" is a magic number and its existence must be respected
			if not success then
				if not string.find(res, "RoomOverlaps", 1, true) then
					error(res)
				end
				print("Room failed to generate: " .. room:__tostring() .. " at: " .. x .. ", " .. y .. ", " .. r)
				room:revertTiles()
				tries = tries + 1
			else
				generatedrooms[#generatedrooms + 1] = room
				x, y, r = room:getCursor()
			end
		end
	end
	print("Generation finished successfully in: " .. os.clock() - watch .. "s")
end

return Level