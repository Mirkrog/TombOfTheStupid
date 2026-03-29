local Object = require("classic/classic")

---@class Tile : Object
local Tile = Object:extend()

function Tile:new(x, y, r, level)
	self.x = x 
	self.y = y 
	self.r = r 
	self.collision = false
	self.attributes = {}
	self.level = level
end

function Tile:__tostring()
  	return "Tile" .. " At: " .. self.x .. self.y
end

---@diagnostic disable-next-line: unused-local
function Tile:draw(scale)
	return
end

--Appends an instance of the named attribute to the list, used as builder function so they can be stacked
function Tile:addAttribute(attributeName)
	local newattribute = require("Attributes/" .. attributeName)
	if not newattribute then
		error("Attribute not found:" .. attributeName)
	end
	for i, attribute in pairs(self.attributes) do
		if attribute:isExact(newattribute) then
			return self
		end
	end
	table.insert(self.attributes, newattribute(self))
	return self
end

function Tile:removeAttribute(targetAttribute)
	for i, attribute in pairs(self.attributes) do
		if attribute == targetAttribute then
			table.remove(self.attributes, i)
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