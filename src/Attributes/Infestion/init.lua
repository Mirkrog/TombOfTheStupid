local Attribute = require("Attributes/Attribute")

local coloratlas = require("coloratlas")

--[[
	Infests the level over time, preventing the player from waiting too long
]]
local Infestion = Attribute:extend()

function Infestion:new(parent)
	Infestion.super.new(self, parent)

	self.age = os.clock()
	self.primeage = 1 --time in seconds after which the infestion kills a player
end

function Infestion:draw(scale)
	if os.clock() - self.age < self.primeage then
		return
	end

	if os.clock() % 0.2 < 0.1 then
		love.graphics.setColor(coloratlas.cyan)
	else
		love.graphics.setColor(coloratlas.yellow)
	end

	local parent = self.parent

	love.graphics.rectangle("fill", parent.x * scale - 0.5 * scale, parent.y * scale - 0.5 * scale,
							scale, scale)
end

function Infestion:onParentTouched(player, triggeredneighbour)
	if os.clock() - self.age < self.primeage then
		return
	end
	if not triggeredneighbour then
		player:kill()
	end
end

function Infestion:__tostring()
	return "Infestion"
end

return Infestion
