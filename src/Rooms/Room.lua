Object = require("classic/classic")

--[[
Utility to make generation of Rooms easier
by having a object you can apply operations to
]]
Room = Object:extend()

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
	for tile in pairs(self.tiles) do
		self.level:remove(tile.x, tile.y)
	end
end

function Room:setOrigin(x, y, r)
	self.anchor.x = x
	self.anchor.y = y
	self.cursor.x = x
	self.cursor.y = y
end

function Room:setCursorPos(x, y)
	self.cursor.x = x
	self.cursor.y = y
end

function Room:setCursorRot(r)
	self.cursor.r = r
end

local function round(n)
	if n > 0 then
		return math.floor(n + 0.5)
	elseif n < 0 then
		return math.floor(n - 0.5)
	else
		return 0
	end
end

function Room:getCursorLookVector()
	return round(math.sin((math.pi * 2) * (self.cursor.r / 4))),
			-round(math.cos((math.pi * 2) * (self.cursor.r / 4)))
end

function Room:getCursorLookVectorX()
	return round(math.sin((math.pi * 2) * (self.cursor.r / 4)))
end

function Room:getCursorLookVectorY()
	return -round(math.cos((math.pi * 2) * (self.cursor.r / 4)))
end

function Room:moveCursorForward(amount)
	amount = amount or 1
	self.cursor.x = self.cursor.x + self:getCursorLookVectorX() * amount
	self.cursor.y = self.cursor.y + self:getCursorLookVectorY() * amount
end

function Room:moveCursorBackwards(amount)
	amount = amount or 1
	self.cursor.x = self.cursor.x + self.x + self:getCursorLookVectorX() * amount
	self.cursor.y = self.cursor.y + self.y + self:getCursorLookVectorY() * amount
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

function Room:trySetTile(x, y, r, tileName)
	r = r or 0
	if self.level:get(x, y) ~= nil and self.level:get(x, y):is(require("Tiles/Tile")) then
		error("RoomOverlaps")
	else
		self.level:set(x, y, r, tileName)
	end
end

function Room:cursorPlaceTile(tileName, r)
	r = r or 0
	self:trySetTile(self.cursor.x, self.cursor.y, r, tileName)
end

function Room:cursorPlaceTileFront(tileName, r)
	r = r or 0
	self:trySetTile(self.cursor.x + self:getCursorLookVectorX(), self.cursor.y + self:getCursorLookVectorY(), r, tileName)
end

function Room:cursorPlaceTileBack(tileName, r)
	r = r or 0
	self:trySetTile(self.cursor.x - self:getCursorLookVectorX(), self.cursor.y - self:getCursorLookVectorY(), r, tileName)
end

function Room:cursorPlaceTileRight(tileName, r)
	r = r or 0
	self:trySetTile(self.cursor.x + self:getCursorLookVectorY(), self.cursor.y + self:getCursorLookVectorX(), r, tileName)
end

function Room:cursorPlaceTileRight(tileName, r)
	r = r or 0
	self:trySetTile(self.cursor.x - self:getCursorLookVectorY(), self.cursor.y - self:getCursorLookVectorX(), r, tileName)
end

return Room