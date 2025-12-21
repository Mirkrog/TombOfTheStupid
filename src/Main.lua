
function love.load()
	Level = require("Level")

	level = Level()

	level:set(1, 0, 0, "Wall")
	level:set(1, 1, 0, "Wall")
	level:set(1, 2, 0, "Wall")
	level:set(-2, 0, 0, "Wall")
	level:set(-2, 1, 0, "Wall")
	level:set(-2, 2, 0, "Wall")
	level:set(0, 3, 0, "Wall")
	level:set(0, -1, 0, "Wall")
	level:set(-1, 3, 0, "Wall")
	level:set(-1, -1, 0, "Wall")

end

function love.update(dt)
	level:update(dt)
end

function love.draw()
	level:draw()
end