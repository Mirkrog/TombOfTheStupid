local Level = require("Level")

local level

function love.load()
	level = Level()
	level:generate(20)
end

function love.update(dt)
	level:update(dt)
end

function love.draw()
	level:draw()
end