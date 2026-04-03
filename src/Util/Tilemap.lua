local Object = require("classic/classic")

---Class Tilemap : Object
local Tilemap = Object:extend()

---param imgPath : String
function Tilemap:new(imgPath, tileWidthX, tileWidthY, filterMode)
	filterMode = filterMode or "nearest"

	self.tilewidthx = tileWidthX
	self.tilewidthy = tileWidthY

	self.image = love.graphics.newImage(imgPath, {mipmaps = true})
	assert(self.image, "Image not found: " .. imgPath)
	self.image:setFilter(filterMode, filterMode)

	self.quad = love.graphics.newQuad(0, 0, tileWidthX, tileWidthY, self.image:getWidth(), self.image:getHeight())
end

function Tilemap:drawTile(tileX, tileY, x, y, r, sx, sy)
	r = r or 0
	sx = sx or 1
	sy = sy or 1

	self.quad:setViewport(tileX * self.tilewidthx, tileY * self.tilewidthy,
						  self.tilewidthx, self.tilewidthy, self.image:getWidth(), self.image:getHeight())

	love.graphics.draw(self.image, self.quad, x, y, r, sx / self.tilewidthx, sy / self.tilewidthy)
end

function Tilemap:__tostring()
	return "Tilemap"
end

return Tilemap