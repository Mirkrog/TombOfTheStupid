local Object = require("classic/classic")

--[[
	Extends the functionality of any Tile by adding it to the Tiles Attribute list
]]
local Attribute = Object:extend()

function Attribute:new(parent)
	self.parent = parent
end

function Attribute:draw(scale)
	local insetamount = 0.2
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", self.parent.x * scale + scale * (insetamount) - scale / 2,
							 self.parent.y * scale + scale * (insetamount) - scale / 2,
							scale * (1 - insetamount * 2), scale * (1 - insetamount * 2), 1, 1)
end

function Attribute:onParentTouched(player, triggeredneighbour)
	print("Touched!")
end

return Attribute
