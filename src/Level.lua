object = require("classic/classic")

Level = object:extend()

function Level:new()
	self.grid = {}
end

function Level:get(x, y)
	if grid[x] == nil then
		return
	end
	return grid[x][y]
end

function Level:set(x, y, r, tileName)

	Tile = require("Tiles/" .. tileName)

	if self.grid[x] == nil then
		self.grid[x] = {}
	end
	self.grid[x][y] = Tile:new(x, y, r)
end

function Level:draw()
	self.grid[0][0]:draw(50)
end

return Level