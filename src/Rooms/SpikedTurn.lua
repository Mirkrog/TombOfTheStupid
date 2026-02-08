 local Room = require("Rooms/Room")

--[[
	just a turn
]]
---@class SpikedTurn : Room
local SpikedTurn = Room:extend()

function SpikedTurn:generate(length)
	length = length > 3 and length or 3 --shorter than 3 is impossible
	local hasturned = false --prevents more than one turn

	for i = 1, length + 1 do
		if not hasturned and i > math.floor(length / 2) then
			if math.random(0, 1) == 0 then --decides if the turn goes left or right
				self:cursorPlaceTileFrontLeft("Wall")
				self:cursorTurnRight()
			else
				self:cursorPlaceTileFrontRight("Wall")
				self:cursorTurnLeft()
			end
			self:cursorMoveBackwards(2) --we move back 2 to place a spike there
			self:cursorPlaceTile("Spike", self:cursorGetRot())
			self:cursorPlaceTileLeft("Wall")
			self:cursorPlaceTileRight("Wall")
			self:cursorMoveForward()
			hasturned = true --preventing another turn
		end
		self:cursorPlaceTileLeft("Wall")
		self:cursorPlaceTileRight("Wall")
		self:cursorPlaceTile("Path")
		self:cursorMoveForward()
	end
end

function SpikedTurn:__tostring()
	return "SpikedTurn"
end

return SpikedTurn