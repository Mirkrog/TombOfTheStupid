local Room = require("Rooms/Room")

--[[
	just a turn
]]
---@class Turn : Room
local Turn = Room:extend()

function Turn:generate(length)
	length = length > 3 and length or 3
	local hasturned = false
	for i = 1, length do
		self:cursorPlaceTileLeft("wall")
		self:cursorPlaceTileRight("wall")
		self:cursorPlaceTile("Path")
		self:moveCursorForward()
		if not hasturned and i > math.floor(length / 2) then
			if math.random(0, 1) == 0 then
				self:turnCursorRight()
			else
				self:turnCursorLeft()
			end
			self:cursorPlaceTileBack("Wall")
			hasturned = true
		end
	end
end

function Turn:__tostring()
	return "Turn"
end

return Turn