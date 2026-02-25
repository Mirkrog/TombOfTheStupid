local Object = require("classic/classic")

---@class Tile : Object
local Tile = Object:extend()

function Tile:new(x, y, r)
	self.x = x 
	self.y = y 
	self.r = r 
	self.collision = false
	self.attributes = {}
end

function Tile:__tostring()
  	return "Tile"
end

---@diagnostic disable-next-line: unused-local
function Tile:draw(scale)
	return
end

--Appends an instance of the named attribute to the list
function Tile:addAttribute(attributeName)
	local attribute = require("Attributes/" .. attributeName)
	self.attributes[#self.attributes+1] = attribute(self)
end

--[[
	Called when Player touches this or a neighboring tile
	when it is this tile triggeredneighbour is nil
]]
function Tile:onTouch(player, triggeredneighbour)

end

function Tile:triggerTouch(player, triggeredneighbour)
	self:onTouch(player, triggeredneighbour)
	for i, attribute in pairs(self.attributes) do
		attribute:onParentTouched(player, triggeredneighbour)
	end
end

return Tile