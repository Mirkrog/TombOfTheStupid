
function love.load()
	Level = require("Level")
	Room = require("Rooms/Room")

	level = Level()
	room = Room(level)

	room:cursorPlaceTile("Wall", 0)
	room:moveCursorForward(2)
	room:cursorPlaceTile("Wall", 0)
	room:turnCursorRight()
	room:moveCursorForward()
	room:cursorPlaceTile("Wall", 0)
end

function love.update(dt)
	level:update(dt)
end

function love.draw()
	level:draw()
end