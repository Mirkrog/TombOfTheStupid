function love.load()
	Level = require("Level")
	Room = require("Rooms/Room")

	level = Level()
	room = Room(level)
	
end

function love.update(dt)
	level:update(dt)
end

function love.draw()
	level:draw()
end