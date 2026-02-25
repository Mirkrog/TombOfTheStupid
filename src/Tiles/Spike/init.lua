local Tile = require("Tiles/Tile")

local coloratlas = require("coloratlas")

--[[
	Kills the Player
]]
---@class SpikeTile : Tile
local Spike = Tile:extend()

function Spike:new(x, y, r)
	self.x = x 
	self.y = y 
	self.r = r 
	self.collision = false
	self.attributes = {}
end

function Spike:__tostring()
	return "Spike"
end

function Spike:draw(scale)
	love.graphics.setColor(coloratlas.cyan)

	love.graphics.rectangle("fill", self.x * scale - 0.5 * scale, self.y * scale - 0.5 * scale, scale, scale)
end

function Spike:onTouch(player, triggeredneighbour)
	if triggeredneighbour == nil then
		player:kill()
	end
end

return Spike