Object = require("classic/classic")
Player = require("Player")
Camera = require("Util/Camera")

Level = Object:extend()

function Level:new()
	self.grid = {}
	self.player = Player(self)
	self.camera = Camera()
	self.camera:setTarget(self.player)
end

function Level:__tostring()
	return "Level"
end

function Level:update(dt)
	self.player:update(dt)
	self.camera:update(dt)
end

function Level:get(x, y)
	if self.grid[x] == nil then
		return
	end
	return self.grid[x][y]
end

function Level:set(x, y, r, tileName)
	Tile = require("Tiles/" .. tileName)

	if self.grid[x] == nil then
		self.grid[x] = {}
	end
	self.grid[x][y] = Tile(x, y, r)
end

function Level:remove(x, y)
	if self.grid[x] == nil then
		return
	end
	self.grid[x][y] = nil
end

function Level:draw()
	self.camera:apply(50)

	for x, rows in pairs(self.grid) do
		for y, tile in pairs(rows) do
			if tile then
				tile:draw(50)
			end
		end
	end

	self.player:draw(50)

	self.camera:unapply()
end

function Level:generate()

end

return Level