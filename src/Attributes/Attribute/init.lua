local Object = require("classic/classic")

--[[
	Extends the functionality of any Tile by adding it to the Tiles Attribute list
	If the Level was a entity component system this would be a component of an entity(Tile)
]]
local Attribute = Object:extend()

function Attribute:new(parent)
	self.parent = parent
end

function Attribute:draw(scale)
end

function Attribute:onParentTouched(player, triggeredneighbour)
	print("Touched!")
end

function Attribute:__tostring()
	return "Attribute"
end

return Attribute
