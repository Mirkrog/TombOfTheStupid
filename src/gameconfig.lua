--[[
	A config file for most of the "hidden" setting
]]

config = {
	nocollision = false,
	enforcemovementrestrictions = true, -- makes collision unreliable
	waveeffect = false,
	scoreforlevelcomplete = 100,
	levellenght = 20,
	maxfailedplacementsperroom = 50, --how often a room can fail until generation is restarted entirely
	liveroomgenview = false,
	roomgenyield = 1,
	canroomsoverlap = false, --only for room gen debugging, has no fun factor
	verboseroomgen = false,
	minroomlength = 5,
	maxroomlength = 15,
}

return config