local Room = require("Rooms/Room")

--[[
	Beginning of every stage
]]
---@class Start : Room
local Start = Room:extend()

function Start:generate(length)
	self:cursorPlaceTileBack("wall")
	self:cursorPlaceTileBackLeft("wall")
	self:cursorPlaceTileBackRight("wall")
	self:cursorPlaceTileLeft("wall")
	self:cursorPlaceTileRight("wall")
	self:cursorPlaceTile("Path")
	self:cursorMoveForward()
	for i = 1, 2 do
		self:cursorPlaceTileLeft("wall")
		self:cursorPlaceTileRight("wall")
		self:cursorPlaceTile("Path"):addAttribute("Coin")
		self:cursorMoveForward()
	end
end

function Start:__tostring()
	return "Start"
end

return Start