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

--Appends an instance of the named attribute to the list, used as builder function so they can be stacked
function Tile:addAttribute(attributeName)
	local attribute = require("Attributes/" .. attributeName)
	self.attributes[#self.attributes+1] = attribute(self)
	return self
end

function Tile:removeAttribute(targetAttribute)
	for i, attribute in pairs(self.attributes) do
		if attribute == targetAttribute then
			self.attributes[i] = nil
		end
	end
end

--[[
	Called when Player touches this or a neighboring tile
	when it is this tile triggeredneighbour is nil
]]
function Tile:onTouch(player, triggeredneighbour)
	return
end

function Tile:triggerTouch(player, triggeredneighbour)
	self:onTouch(player, triggeredneighbour)
	for i, attribute in pairs(self.attributes) do
		attribute:onParentTouched(player, triggeredneighbour)
	end
end

return Tile