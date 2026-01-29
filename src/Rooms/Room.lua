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

function Room:setCursorPos(x, y)
	self.cursor.x = x
	self.cursor.y = y
end

function Room:setCursorRot(r)
	self.cursor.r = r
end

function Room:setCursorToOrigin()
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

function Room:getCursorLookVectorX()
	return round(math.sin((math.pi * 2) * (self.cursor.r / 4)))
end

function Room:getCursorLookVectorY()
	return -round(math.cos((math.pi * 2) * (self.cursor.r / 4)))
end

function Room:getCursorLookVector()
	return self:getCursorLookVectorX(),
			self:getCursorLookVectorY()
end

function Room:getCursorPos()
	return self.cursor.x, self.cursor.y
end

function Room:getCursorPosX()
	return self.cursor.x
end

function Room:getCursorPosY()
	return self.cursor.y
end

function Room:getCursorRot()
	return self.cursor.r
end

function Room:getCursor()
	return self.cursor.x, self.cursor.y, self.cursor.r
end

function Room:moveCursorForward(amount)
	amount = amount or 1
	self.cursor.x = self.cursor.x + self:getCursorLookVectorX() * amount
	self.cursor.y = self.cursor.y + self:getCursorLookVectorY() * amount
end

function Room:moveCursorBackwards(amount)
	amount = amount or 1
	self.cursor.x = self.cursor.x - self:getCursorLookVectorX() * amount
	self.cursor.y = self.cursor.y - self:getCursorLookVectorY() * amount
end

function Room:moveCursorLeft(amount)
	amount = amount or 1
	self.cursor.x = self.cursor.x - self:getCursorLookVectorY() * amount
	self.cursor.y = self.cursor.y - self:getCursorLookVectorX() * amount
end

function Room:moveCursorRight(amount)
	amount = amount or 1
	self.cursor.x = self.cursor.x + self:getCursorLookVectorY() * amount
	self.cursor.y = self.cursor.y + self:getCursorLookVectorX() * amount
end

function Room:turnCursorRight(amount)
	amount = amount or 1
	self.cursor.r = (self.cursor.r + amount) % 4
end

function Room:turnCursorLeft(amount)
	amount = amount or 1
	self.cursor.r = (self.cursor.r - amount) % 4
end

-- I actually stole this from somewhere I don't remember
local function tableContains(table, element)
	for i, value in pairs(table) do
    	if value == element then
        	return true
    	end
	end
	return false
end

-- Inheriting Rooms can technically change this, but it is kinda risky
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
	self.tiles[#self.tiles + 1] = self.level:set(x, y, r, tileName)
end

function Room:cursorPlaceTile(tileName, r)
	r = r or 0
	self:trySetTile(self.cursor.x, self.cursor.y, r, tileName)
end

function Room:cursorPlaceTileFront(tileName, r)
	r = r or 0
	self:trySetTile(self.cursor.x + self:getCursorLookVectorX(), self.cursor.y + self:getCursorLookVectorY(), r, tileName)
end

function Room:cursorPlaceTileFrontLeft(tileName, r)
	r = r or 0
	local trans1x, trans1y = self.cursor.x + self:getCursorLookVectorX(), self.cursor.y + self:getCursorLookVectorY()
	self:trySetTile(trans1x + self:getCursorLookVectorY(), trans1y - self:getCursorLookVectorX(), r, tileName)
end

function Room:cursorPlaceTileFrontRight(tileName, r)
	r = r or 0
	local trans1x, trans1y = self.cursor.x + self:getCursorLookVectorX(), self.cursor.y + self:getCursorLookVectorY()
	self:trySetTile(trans1x - self:getCursorLookVectorY(), trans1y + self:getCursorLookVectorX(), r, tileName)
end

function Room:cursorPlaceTileBackLeft(tileName, r)
	r = r or 0
	local trans1x, trans1y = self.cursor.x - self:getCursorLookVectorX(), self.cursor.y - self:getCursorLookVectorY()
	self:trySetTile(trans1x + self:getCursorLookVectorY(), trans1y - self:getCursorLookVectorX(), r, tileName)
end

function Room:cursorPlaceTileBackRight(tileName, r)
	r = r or 0
	local trans1x, trans1y = self.cursor.x - self:getCursorLookVectorX(), self.cursor.y - self:getCursorLookVectorY()
	self:trySetTile(trans1x - self:getCursorLookVectorY(), trans1y + self:getCursorLookVectorX(), r, tileName)
end

function Room:cursorPlaceTileBack(tileName, r)
	r = r or 0
	self:trySetTile(self.cursor.x - self:getCursorLookVectorX(), self.cursor.y - self:getCursorLookVectorY(), r, tileName)
end

function Room:cursorPlaceTileRight(tileName, r)
	r = r or 0
	self:trySetTile(self.cursor.x + self:getCursorLookVectorY(), self.cursor.y + self:getCursorLookVectorX(), r, tileName)
end

function Room:cursorPlaceTileLeft(tileName, r)
	r = r or 0
	self:trySetTile(self.cursor.x - self:getCursorLookVectorY(), self.cursor.y - self:getCursorLookVectorX(), r, tileName)
end

return Room