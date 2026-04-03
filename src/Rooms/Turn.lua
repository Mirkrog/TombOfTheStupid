local Room = require("Rooms/Room")

--[[
	just a turn
]]
---@class Turn : Room
local Turn = Room:extend()

function Turn:generate(length)
	length = length > 3 and length or 3 --shorter than 3 not allowed
	local hasturned = false --did we turned already?

	for i = 1, length do
		if not hasturned and i > math.floor(length / 2) then
			if math.random(0, 1) == 0 then
				self:cursorTurnRight()
			else
				self:cursorTurnLeft()
			end
			self:cursorPlaceTileBack("Wall")
			hasturned = true --prevents another turn
		end
		self:cursorPlaceTileLeft("Wall")
		self:cursorPlaceTileRight("Wall")
		self:cursorPlaceTile("Path"):addAttribute("Coin")
		self:cursorMoveForward()
	end
end

function Turn:__tostring()
	return "Turn"
end

return Turn