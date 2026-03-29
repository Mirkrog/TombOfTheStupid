local Attribute = require("Attributes/Attribute")

local coloratlas = require("coloratlas")

--[[
	A simple coin for the player to collect
]]
local Coin = Attribute:extend()

function Coin:new(parent)
	Coin.super.new(self, parent)
end

function Coin:draw(scale)
	if os.clock() % 0.2 < 0.1 then
		love.graphics.setColor(coloratlas.purple)
	else
		love.graphics.setColor(coloratlas.yellow)
	end

	local inset = 0.2

	local parent = self.parent

	love.graphics.rectangle("fill", parent.x * scale - 0.5 * scale + 0.2 * scale, parent.y * scale - 0.5 * scale + 0.2 * scale,
							scale * (1 - inset * 2), scale * (1 - inset * 2))
end

function Coin:onParentTouched(player, triggeredneighbour)
	if not triggeredneighbour then
		self.parent:removeAttribute(self)
		player:givePoints(1)
	end
end

function Coin:__tostring()
	return "Coin"
end

return Coin
