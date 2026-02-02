local Room = require("Rooms/Room")

--[[
	End of every stage
]]
---@class End : Room
local End = Room:extend()

function End:generate(length)
	for i = 1, 2 do
		self:cursorPlaceTileLeft("wall")
		self:cursorPlaceTileRight("wall")
		if i == 1 then
			self:cursorPlaceTile("Path")
		else
			self:cursorPlaceTile("End")
		end
		self:cursorPlaceTileFront("wall")
		self:moveCursorForward()
	end
	self:cursorPlaceTileLeft("Wall")
	self:cursorPlaceTileRight("wall")
end

function End:__tostring()
	return "End"
end

return End