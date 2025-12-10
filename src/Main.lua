function love.load()
	Level = require("Level")
	Player = require("Player")

	level = Level()
	player = Level:new()

	level:set(0, 0, 0, "Tile")

end

function love.update(dt)

end

function love.draw()
	level:draw()
end