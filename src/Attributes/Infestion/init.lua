local Attribute = require("Attributes/Attribute")

local coloratlas = require("coloratlas")
local gameconfig = require("gameconfig")

--[[
	Infests the level over time, preventing the player from waiting too long
]]
local Infestion = Attribute:extend()

function Infestion:new(parent, reproductionsleft)
	Infestion.super.new(self, parent)

	self.reproductions = 10

	self.reproductionsleft = reproductionsleft or self.reproductions --how far it can spread until it stops

	local level = parent.level
	local player = level.player

	self.spreadspeed = 0.1
	self.primeage = math.max(gameconfig.infestionmaxspreadspeed,
							 gameconfig.initalinfestionspreadspeed
							 / (player:getScore() * gameconfig.infestionspeedrampup)) --time in seconds after which the infestion kills a player
	self.age = os.clock() + (self.reproductions - self.reproductionsleft) * self.spreadspeed

	if self.reproductionsleft > 0 then
		local directions = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}}
		for i, direction in ipairs(directions) do
			--the following checks prevent Infestion from blocking still required Path Tiles
			if level:get(parent.x + direction[1],
				parent.y + direction[2]).steppedon == false then
				goto continue
			end
			for j, subdirection in ipairs(directions) do
				if level:get(parent.x + direction[1] + subdirection[1],
							parent.y + direction[2] + subdirection[2]).steppedon == false then
					goto continue
				end
			end

			level:get(parent.x + direction[1], parent.y + direction[2])
					:addAttribute("Infestion", false, self.reproductionsleft - 1)
			::continue::
		end
	end
end

function Infestion:draw(scale)
	local level = self.parent.level
	local directions = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}}
	local alivetiles = 0
	for i, direction in ipairs(directions) do
		if level:get(self.parent.x + direction[1],
			self.parent.y + direction[2]).steppedon == false then
			alivetiles = alivetiles + 1
		end
	end
	if alivetiles >= 2 then
		self.age = os.clock() + self.primeage
		return
	end
	if os.clock() - self.age < self.primeage / 2 then
		return
	end

	if os.clock() % 0.2 < 0.1 then
		love.graphics.setColor(coloratlas.cyan)
	else
		love.graphics.setColor(coloratlas.yellow)
	end

	local parent = self.parent

	local fillamount = math.max(0, math.min(1, (os.clock() - self.age - 0.5) / (self.primeage / 2)))

	love.graphics.rectangle("fill", (parent.x - 0.5 + (1 - fillamount) * 0.5) * scale,
						    (parent.y - 0.5 + (1 - fillamount) * 0.5) * scale,
							scale * fillamount, scale * fillamount)
end

function Infestion:onParentTouched(player, triggeredneighbour)
	if os.clock() - self.age < self.primeage then
		return
	end
	if not triggeredneighbour then
		player:kill()
	end
end

function Infestion:__tostring()
	return "Infestion"
end

return Infestion
