Room = require("Rooms/Room")

--[[]
	A Looping
]]
--@class Loop: Room
Loop = Room:extend()

function Loop:generate(length)
	length = length > 7 and length or 7 --smaller than 7 doesn't work
    length = math.floor((length - 2) / 4) * 4 + 2 --conmverted so lenght / 4 always is an int

    local looplength = math.floor((length - 2) / 4) * 4
	local sidelength = looplength / 4
	local turndirection = math.random(0, 1) * 2 - 1

	self:cursorPlaceTileLeft("wall")
	self:cursorPlaceTileRight("wall")
	self:cursorPlaceTile("Path"):addAttribute("Coin")
	self:cursorMoveForward()

	for i = 1, length do
		if i > 1 and (i - 1) % sidelength == 0 and i < looplength then
			if turndirection == 1 then
				self:cursorPlaceTileFrontLeft("wall")
				self:cursorTurnRight()
			else
				self:cursorPlaceTileFrontRight("wall")
				self:cursorTurnLeft()
			end
			self:cursorPlaceTileBack("wall")
		end

		self:cursorPlaceTileLeft("wall")
		self:cursorPlaceTileRight("wall")
		self:cursorPlaceTile("Path"):addAttribute("Coin")
		self:cursorMoveForward()
	end
end

function Loop:__tostring()
	return "Loop"
end

return Loop