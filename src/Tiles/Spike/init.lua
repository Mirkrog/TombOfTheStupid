local Tile = require("Tiles/Tile")
local Tilemap = require("Util/Tilemap")

local gameconfig = require("gameconfig")
local coloratlas = require("coloratlas")
local tilemap = Tilemap("Assets/Spike-Tilemap.png", gameconfig.tilescale,
							gameconfig.tilescale)

--[[
	Kills the Player
]]
---@class SpikeTile : Tile
local Spike = Tile:extend()

function Spike:new(x, y, r, level)
	self.super.new(self, x, y, r, level)

	self.tilemap = tilemap
end

function Spike:__tostring()
	return "Spike" .. " At: " .. self.x .. self.y
end

function Spike:draw(scale)
	love.graphics.setColor(coloratlas.cyan)

	local offset = gameconfig.tilescale / 2

	self.tilemap:drawTile(0, 0, self.x * scale, self.y * scale,
						  self.r * math.pi / 2, scale, scale, offset, offset)
end

function Spike:onTouch(player, triggeredneighbour)
	if triggeredneighbour == nil then
		player:kill()
	end
end

return Spike