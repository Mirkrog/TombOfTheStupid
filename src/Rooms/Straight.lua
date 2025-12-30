local Room = require("Rooms/Room")

--[[
	just a straight corridor
]]
---@class Straight : Room
local Straight = Room:extend()

function Straight:generate(length)
	for i = 1, length do
		self:cursorPlaceTileLeft("wall")
		self:cursorPlaceTileRight("wall")
		self:cursorPlaceTile("Path")
		self:moveCursorForward()
	end
end

function Straight:__tostring()
	return "Straight"
end

return Straight