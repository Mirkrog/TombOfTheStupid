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
		self:cursorPlaceTile("Path")
		self:cursorPlaceTileFront("wall")
		self:moveCursorForward()
	end
end

function End:__tostring()
	return "End"
end

return End