local Room = require("Rooms/Room")

--[[
	just a turn
]]
---@class SpikedTurn : Room
local SpikedTurn = Room:extend()

function SpikedTurn:generate(length)
	length = length > 3 and length or 3
	local hasturned = false
	for i = 1, length + 1 do
		if not hasturned and i > math.floor(length / 2) then
			if math.random(0, 1) == 0 then
				self:cursorPlaceTileFrontLeft("Wall")
				self:turnCursorRight()
			else
				self:cursorPlaceTileFrontRight("Wall")
				self:turnCursorLeft()
			end
			self:moveCursorBackwards(2)
			self:cursorPlaceTile("Spike", self:getCursorRot())
			self:cursorPlaceTileBack("Wall")
			self:cursorPlaceTileBackLeft("Wall")
			self:cursorPlaceTileBackRight("Wall")
			self:cursorPlaceTileLeft("Wall")
			self:cursorPlaceTileRight("Wall")
			self:moveCursorForward()
			hasturned = true
		end
		self:cursorPlaceTileLeft("Wall")
		self:cursorPlaceTileRight("Wall")
		self:cursorPlaceTile("Path")
		self:moveCursorForward()
	end
end

function SpikedTurn:__tostring()
	return "SpikedTurn"
end

return SpikedTurn