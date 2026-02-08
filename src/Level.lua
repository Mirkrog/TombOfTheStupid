local Object = require("classic/classic")
local Player = require("Player")
local Camera = require("Util/Camera")

local gameconfig = require("gameconfig")

---@class Level : Object
local Level = Object:extend()

function Level:new()
	self.grid = {}
	self.player = Player(self)
	self.camera = Camera(0.1)
	self.camera:setTarget(self.player)

	self.gencoroutine = nil
end

function Level:__tostring()
	return "Level"
end

function Level:update(dt)
	if self.gencoroutine and coroutine.status(self.gencoroutine) ~= "dead" then
		success, err =  coroutine.resume(self.gencoroutine)
		if not success then
			error(err)
		end
	else
		if self.gencoroutine then
			self.gencoroutine = nil
		end
		self.player:update(dt)
		self.camera:update(dt)
	end
end

function Level:clear()
	self.grid = {}
end

function Level:get(x, y)
	if self.grid[x] == nil then
		return
	end
	return self.grid[x][y]
end

local tilecache = {}
function Level:set(x, y, r, tileName)
	local Tile
	if tilecache[tileName] then
		Tile = tilecache[tileName]
	else
		Tile = require("Tiles/" .. tileName)
		if not Tile then
			error("Tile: \"" .. tileName .. "\" was not found")
		end
		tilecache[tileName] = Tile
	end

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
		tile:onTouch(player)

		local neighbors = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}}
		for _, neighbor in ipairs(neighbors) do
			local neighbortile = self:get(x + neighbor[1], y + neighbor[2])
			if neighbortile ~= nil then
				neighbortile:onTouch(player, tile)
			end
		end
	end
end

function Level:remove(x, y)
	if self.grid[x] == nil then
		return
	end
	self.grid[x][y] = nil
	if next(self.grid[x]) == nil then
		self.grid[x] = nil
	end
end

function Level:draw()
	if self.gencoroutine and coroutine.status(self.gencoroutine) ~= "dead" and not gameconfig.liveroomgenview then
		return
	end
	local clock = os.clock()

	self.camera:apply(50)

	for x, rows in pairs(self.grid) do
		for y, tile in pairs(rows) do
			if gameconfig.waveeffect then
				love.graphics.push()
				love.graphics.translate(0, math.sin(x + clock * 3) * 3) --cool Effect I guess, might cause nausea
			end
			if tile then
				tile:draw(gameconfig.drawscale)
			end
			if gameconfig.waveeffect then
				love.graphics.pop()
			end
		end
	end

	self.player:draw(gameconfig.drawscale) --renders the player

	self.camera:unapply()

	love.graphics.printf(self.player:getScore() + 100000, 0, 100, love.graphics.getWidth(), "center", 0)
end

local function getRooms()
	local rooms = {}
	for i, filename in pairs(love.filesystem.getDirectoryItems("Rooms")) do
		--[[
			these are hardcoded because there will only be ever three exceptions.
			Could clean it up, but I am too lazy
		]]
		if filename ~= "Room.lua" and filename ~= "Start.lua" and filename ~= "end.lua" then
			rooms[#rooms + 1] = require("Rooms/" .. filename:match("(.+)%.[^%.]+$"))
		end
	end

	return rooms
end

--[[
	Starts a coroutine to run the level generation on
	so the main thread doesn't get blocked
]]
function Level:startGenTask(levellenght)
	self.gencoroutine = coroutine.create(function()
		self:generate(levellenght)
	end)
end

--[[
	generates the level from level generation templates found in Rooms
]]
function Level:generate(targetcount)
	local startroom = require("Rooms/Start")
	local endroom = require("Rooms/End")

	math.randomseed(os.time() * math.random(1, 100)) --making roomgen more random
	self:clear() --clearing the level, else fun stuff happens :)

	local roomstemplates = getRooms()

	local generatedrooms = {}
	local x, y, r = 0, 0, math.random(0, 3)

	local watch
	if gameconfig.verboseroomgen then
		watch = os.clock() --only used for debugging
	end

	local lastyield = os.clock() --tracks last time coroutine yielded

	local tries = 0 --tracks how many room gen attempts where tried in a row
	local failedroomplacements = 0 --tracks how many rooms failed to generate

	local lastroom --contains the last selected room even when generation failed
	local room

	while #generatedrooms <= targetcount do
		if #generatedrooms >= 1 then
			if failedroomplacements > targetcount * gameconfig.maxfailedplacementsperroom then --triggers when rooms fail too often to generate
				if gameconfig.verboseroomgen then
					print("Too much attempts failed restarting generation")
				end
				self:clear()
				generatedrooms = {}
				x, y, r = 0, 0, math.random(0, 3)
				tries = 0
				failedroomplacements = 0
			else
				if gameconfig.verboseroomgen then
					print("Enough attempts failed reverting to last room")
				end
				local room = generatedrooms[#generatedrooms]
				room:revertTiles()
				x, y, r = room:getOrigin()
				generatedrooms[#generatedrooms] = nil
				tries = 0
			end
		end
		if #generatedrooms <= 0 then
			room = startroom(self)
			room:setOrigin(x, y, r)
			room:generate(3)
			generatedrooms[1] = room
			x, y, r = room:cursorGetData()
		end
		while tries < 5 and #generatedrooms <= targetcount do
			if #generatedrooms == targetcount then
				room = endroom(self)
			else
				while room == lastroom or room == generatedrooms[#generatedrooms] do
					room = roomstemplates[math.random(#roomstemplates)](self)
				end
				lastroom = room
			end
			room:setOrigin(x, y, r)

			local success, res = xpcall(room.generate, debug.traceback, room, 
										math.random(gameconfig.minroomlength, gameconfig.maxroomlength))
			if not success then
				if not string.find(res, "RoomOverlaps", 1, true) then
					error(res)
				end
				if gameconfig.verboseroomgen then
					print("Room failed to generate: " 
						  .. room:__tostring() 
						  .. " at: " .. x .. ", " .. y .. ", " .. r 
						  .. " Current length: " .. #generatedrooms)
				end
				room:revertTiles()
				tries = tries + 1
				failedroomplacements = failedroomplacements + 1
			else
				tries = 0
				generatedrooms[#generatedrooms + 1] = room
				x, y, r = room:cursorGetData()

				if gameconfig.liveroomgenview then
					self.camera:setPos(x, y)
				end
			end
			if gameconfig.liveroomgenview or os.clock() - lastyield > gameconfig.roomgenyield then
				coroutine.yield()
				lastyield = os.clock()
			end
		end
	end
	if gameconfig.verboseroomgen then
		print("Generation finished successfully in: " .. os.clock() - watch .. "s")
	end
end

return Level