local Level = require("Level")

local gameconfig = require("gameconfig")

function love.load()
	level = Level()
	level:startGenTask(gameconfig.levellenght)
end

function love.update(dt)
	level:update(dt)
end

function love.draw()
	level:draw()
end