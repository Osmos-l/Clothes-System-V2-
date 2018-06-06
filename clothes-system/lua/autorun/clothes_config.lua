--[[-----------------[[--

	DON'T TOUCH HERE

--]]-----------------]]--

clothes = clothes or {}

clothes.lang = {}

clothes.theme = {}

--[[-----------------[[--

	ADMIN CONFIGURATION :
		- That restriction give access to the User at all command below, and User can delete or edit item on the shop.

--]]-----------------]]--

clothes.AdminTeam = {
	["superadmin"] = true,
	["admin"] = true,
}

--[[-----------------[[--

	LANGUAGE CONFIGURATION :
		- You can choose here the language do you want ( "FR" = french, "EN" = english ) 
		- For edit language go to the file : clothes_language.lua

--]]-----------------]]--

clothes.LanguageUsed = "EN"

--[[-----------------[[--

	THEME CONFIGURATION :
		- You can choose here the theme do you want.
		- For edit or create new theme go below on this file.
			- Theme existent :
				- GREEN
				- BLUE

--]]-----------------]]--

clothes.ThemeUsed = "GREEN"

--[[-----------------[[--

	FASTDL CONFIGURATION :
		- Do you want to use a FastDL for materials and font present in this addon ?
			- Yes = true 
			- No = false
				- If TRUE you need to do nothing.
				- If FALSE you need to add the content addon present on the workshop on you'r server collection. ( https://steamcommunity.com/sharedfiles/filedetails/?id=1402557868 )

--]]-----------------]]--

clothes.FastDLUsed = true

--[[-----------------[[--

	ENTITIES CONFIGURATION :
		- You can edit the name or model of entities ( NPC & WardRobe ) present on this script.

--]]-----------------]]--

// NPC : 

		clothes.NPCModel = "models/breen.mdl"

		clothes.NPCName = "Clothes V2"

// Wardrobe :

		clothes.WardrobeModel = "models/props_wasteland/controlroom_storagecloset001a.mdl"

		clothes.WardrobeName = "Garde-Robe"

--[[-----------------[[--

	COMMAND CONFIGURATION :
		- Command you need to write in the chat, you can edit him.

--]]-----------------]]--

// ENTITIES :

	clothes.SpawnNPC = "!clothesaddnpc"

	clothes.SpawnWardRobe = "!clothesaddwardrobe"

// SAVE ENTITIES POS : 

	clothes.SaveCommand = "!clothessave"

// ADD NEW CLOTHE : 

	clothes.AddModelCommand = "!clothesadd"

--[[-----------------[[--

	THEME CONFIGURATION :
		- You can create or edit theme.
		- You can use this WebSite : https://flatuicolors.com

--]]-----------------]]--

clothes.theme["GREEN"] = {

	background = Color(44, 62, 80, 100),
	up = Color(46, 204, 113),
	txt = Color(255, 255, 255),
	validate = Color(52, 152, 219),
	cancel = Color(192, 57, 43),
	cancelhover = Color(231, 76, 60),
	scroolbar = Color(39, 174, 96, 200),
	buy = Color(41, 128, 185),
	buyhover = Color(116, 185, 255),
	search = Color(255, 255, 255),
	searchhover = Color(18, 23 , 38),
	leave = Color(100, 0, 0),
}

clothes.theme["BLUE"] = {

	background = Color(44, 62, 80, 100),
	up = Color(52, 73, 94),
	txt = Color(255, 255, 255),
	validate = Color(52, 152, 219),
	cancel = Color(192, 57, 43),
	cancelhover = Color(231, 76, 60),
	scroolbar = Color(41, 128, 185),
	buy = Color(46, 204, 113),
	buyhover = Color(44, 62, 80),
	search = Color(255, 255, 255),
	searchhover = Color(18, 23, 38),
	leave = Color(100, 0, 0),
}
