--[[
	A config file for most of the "hidden" settings
]]

config = {
	nocollision = false,
	enforcemovementrestrictions = true, -- makes collision unreliable
	waveeffect = false, --very cool ;)

	drawscale = 50, -- scale in which the game(Level, Player) is drawn

	scoreforlevelcomplete = 100,

	levellenght = 20, --the lenght of a generated level
	minroomlength = 5,
	maxroomlength = 15,

	maxfailedplacementsperroom = 50, --how often a room can fail until generation is restarted entirely
	liveroomgenview = false,
	roomgenyield = 1, --in which interval the roomgen coroutine yields
	canroomsoverlap = false, --only for room gen debugging, has no fun factor
	verboseroomgen = false,

	initalinfestionspreadspeed = 5,
	infestionspeedrampup = 0.05, --multiplier for how fast the infestion spreads depending on score
	infestionmaxspreadspeed = 0.1, --cap of speed infestion can get
}

return config