local Object = require("classic/classic")

local gameconfig = require("gameconfig")

--[[
	Utility to make generation of Rooms easier
	by having a object you can apply operations to.
	It feels clean, but what do I know.
	I attempted to make it somewhat debuggable,
	still extremely frustrating to work with
]]
---@class Room : Object
local Room = Object:extend()

function Room:new(level)
	self.level = level
	self.tiles = {}
	self.origin = {
		x = 0,
		y = 0,
		r = 0,
	}
	self.cursor = {
		x = 0,
		y = 0,
		r = 0,
	}
end

function Room:__tostring()
	return "Room"
end

function Room:revertTiles()
	for i, tile in pairs(self.tiles) do
		self.level:remove(tile.x, tile.y)
	end
	self.tiles = {}
end

function Room:setOrigin(x, y, r)
	self.origin.x = x
	self.origin.y = y
	self.origin.r = r
	self.cursor.x = x
	self.cursor.y = y
	self.cursor.r = r
end

function Room:getOrigin(x, y, r)
	return self.origin.x,
			self.origin.y,
			self.origin.r
	
end

function Room:cursorSetPos(x, y)
	self.cursor.x = x
	self.cursor.y = y
end

function Room:cursorSetRot(r)
	self.cursor.r = r
end

function Room:cursorSetToOrigin()
	self.cursor.x = self.origin.x
	self.cursor.y = self.origin.y 
	self.cursor.r = self.origin.r
end

local function round(n)
	if n > 0 then
		return math.floor(n + 0.5)
	elseif n < 0 then
		return math.ceil(n - 0.5)
	else
		return 0
	end
end

function Room:cursorGetLookVectorX()
	return round(math.sin((math.pi * 2) * (self.cursor.r / 4)))
end

function Room:cursorGetLookVectorY()
	return -round(math.cos((math.pi * 2) * (self.cursor.r / 4)))
end

function Room:cursorGetLookVector()
	return self:cursorGetLookVectorX(),
			self:cursorGetLookVectorY()
end

function Room:cursorGetPos()
	return self.cursor.x, self.cursor.y
end

function Room:cursorGetPosX()
	return self.cursor.x
end

function Room:cursorGetPosY()
	return self.cursor.y
end

function Room:cursorGetRot()
	return self.cursor.r
end

function Room:cursorGetData()
	return self.cursor.x, self.cursor.y, self.cursor.r
end

function Room:cursorMoveForward(amount)
	amount = amount or 1
	self.cursor.x = self.cursor.x + self:cursorGetLookVectorX() * amount
	self.cursor.y = self.cursor.y + self:cursorGetLookVectorY() * amount
end

function Room:cursorMoveBackwards(amount)
	amount = amount or 1
	self.cursor.x = self.cursor.x - self:cursorGetLookVectorX() * amount
	self.cursor.y = self.cursor.y - self:cursorGetLookVectorY() * amount
end

function Room:cursorMoveLeft(amount)
	amount = amount or 1
	self.cursor.x = self.cursor.x - self:cursorGetLookVectorY() * amount
	self.cursor.y = self.cursor.y - self:cursorGetLookVectorX() * amount
end

function Room:cursorMoveRight(amount)
	amount = amount or 1
	self.cursor.x = self.cursor.x + self:cursorGetLookVectorY() * amount
	self.cursor.y = self.cursor.y + self:cursorGetLookVectorX() * amount
end

function Room:cursorTurnRight(amount)
	amount = amount or 1
	self.cursor.r = (self.cursor.r + amount) % 4
end

function Room:cursorTurnLeft(amount)
	amount = amount or 1
	self.cursor.r = (self.cursor.r - amount) % 4
end

--actually stole this from somewhere, hope they don't mind
local function tableContains(table, element)
	for i, value in pairs(table) do
    	if value == element then
        	return true
    	end
	end
	return false
end

-- Inheriting Rooms can technically change this, but it is kinda risky and not recommended
function Room:trySetTile(x, y, r, tileName)
	r = r or 0
	if self.level:get(x, y) ~= nil then
		if tableContains(self.tiles, self.level:get(x, y)) then
			if self.level:get(x, y):isExact(require("Tiles/Path")) then --hardcoded because paths are way markers and should never be overridden
				return
			end
		else
			if not gameconfig.canroomsoverlap then
				error("RoomOverlaps")
			end
		end
	end
	local tile = self.level:set(x, y, r, tileName)
	self.tiles[#self.tiles + 1] = tile
	tile:addAttribute("Attribute")
	return tile
end

function Room:cursorPlaceTile(tileName, r)
	r = r or 0
	return self:trySetTile(self.cursor.x, self.cursor.y, r, tileName)
end

function Room:cursorPlaceTileFront(tileName, r)
	r = r or 0
	return self:trySetTile(self.cursor.x + self:cursorGetLookVectorX(), self.cursor.y + self:cursorGetLookVectorY(), r, tileName)
end

function Room:cursorPlaceTileFrontLeft(tileName, r)
	r = r or 0
	local trans1x, trans1y = self.cursor.x + self:cursorGetLookVectorX(), self.cursor.y + self:cursorGetLookVectorY()
	return self:trySetTile(trans1x + self:cursorGetLookVectorY(), trans1y - self:cursorGetLookVectorX(), r, tileName)
end

function Room:cursorPlaceTileFrontRight(tileName, r)
	r = r or 0
	local trans1x, trans1y = self.cursor.x + self:cursorGetLookVectorX(), self.cursor.y + self:cursorGetLookVectorY()
	return self:trySetTile(trans1x - self:cursorGetLookVectorY(), trans1y + self:cursorGetLookVectorX(), r, tileName)
end

function Room:cursorPlaceTileBackLeft(tileName, r)
	r = r or 0
	local trans1x, trans1y = self.cursor.x - self:cursorGetLookVectorX(), self.cursor.y - self:cursorGetLookVectorY()
	return self:trySetTile(trans1x + self:cursorGetLookVectorY(), trans1y - self:cursorGetLookVectorX(), r, tileName)
end

function Room:cursorPlaceTileBackRight(tileName, r, distance)
	distance = distance or 1
	r = r or 0
	local trans1x, trans1y = self.cursor.x - self:cursorGetLookVectorX(), self.cursor.y - self:cursorGetLookVectorY()
	return self:trySetTile(trans1x - self:cursorGetLookVectorY() * distance, trans1y + self:cursorGetLookVectorX() * distance, r, tileName)
end

function Room:cursorPlaceTileBack(tileName, r, distance)
	distance = distance or 1
	r = r or 0
	return self:trySetTile(self.cursor.x - self:cursorGetLookVectorX() * distance, self.cursor.y - self:cursorGetLookVectorY() * distance, r, tileName)
end

function Room:cursorPlaceTileRight(tileName, r, distance)
	distance = distance or 1
	r = r or 0
	return self:trySetTile(self.cursor.x + self:cursorGetLookVectorY() * distance, self.cursor.y + self:cursorGetLookVectorX() * distance, r, tileName)
end

function Room:cursorPlaceTileLeft(tileName, r, distance)
	distance = distance or 1
	r = r or 0
	return self:trySetTile(self.cursor.x - self:cursorGetLookVectorY() * distance, self.cursor.y - self:cursorGetLookVectorX() * distance, r, tileName)
end

return Room