local Object = require("classic/classic")

---@class Tile : Object
local Tile = Object:extend()

function Tile:new(x, y, r)
	self.x = x 
	self.y = y 
	self.r = r 
	self.collision = false
end

function Tile:__tostring()
  	return "Tile"
end

---@diagnostic disable-next-line: unused-local
function Tile:draw(scale)
	return
end

--[[
	Called when Player touches this or a neighboring tile
	when it is this tile triggeredneighbour is nil
]]
function Tile:onTouch(player, triggeredneighbour)

end

return Tile