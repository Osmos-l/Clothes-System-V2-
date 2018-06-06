--[[-----------------[[--

	ADD RESSOURCE FILE

--]]-----------------]]--

if clothes.FastDLUsed then

	resource.AddFile("materials/clothes/search.png")

	resource.AddFile("resource/fonts/Lato-Light.ttf")

	resource.AddFile("materials/clothes/delete.png")
	
	resource.AddFile("materials/clothes/edit.png")

end

--[[-----------------[[--

	ADD NETWORK STRING

--]]-----------------]]--

util.AddNetworkString("Clothes-Server")

util.AddNetworkString("Clothes-Client")

--[[-----------------[[--

	ADD TABLE CREATION

--]]-----------------]]--

local function clothes_createdata()

	Msg("[ Clothes ] : Attempt to create data.. \n")

	if not sql.TableExists("clothees_data") then
		sql.Query("CREATE TABLE clothees_data(	id INTEGER PRIMARY KEY AUTOINCREMENT, type varchar(8), name varchar(150), model varchar(250), price tinyint(255), restrict varchar(2500), havebuy varchar(2500) )")
	end

	if not file.IsDir("clothes_data", "DATA") then
		file.CreateDir("clothes_data") 
	end

	if not file.IsDir("clothes_data/" .. game.GetMap(), "DATA") then
		file.CreateDir("clothes_data/" .. game.GetMap() )
	end

	if not file.Exists("clothes_data/" .. game.GetMap() .. "/npc.txt", "DATA") then
		file.Write("clothes_data/" .. game.GetMap() .."/npc.txt", "[]" )
	end

	if not file.Exists("clothes_data/" .. game.GetMap() .. "/wardrobe.txt", "DATA") then
		file.Write("clothes_data/" .. game.GetMap() .."/wardrobe.txt", "[]" )
	end

	Msg("[ Clothes ] : Data created with success !\n")
end

hook.Add("InitPostEntity", "Clothes-InitTable", timer.Simple(0.2,function() clothes_createdata() end) )

--[[-----------------[[--

	SPAWN ALL ENTITIES

--]]-----------------]]--

local function clothes_spawnent()

	timer.Simple(0.5,function() 
		Msg("[ Clothes ] : Attempt to spawn NPC !\n")

		for _, v in pairs(ents.FindByClass("clothes_npc") ) do
			v:Remove()
		end

		local fileread = file.Read("clothes_data/" .. game.GetMap() .. "/npc.txt", "DATA")
		local data = util.JSONToTable(fileread)

		local count = 0
		for k, v in pairs(data) do
			local spawnang = {}
			local spawnpos = {}
			count = count + 1

			for k, v in pairs(v.pos) do
				spawnpos[k] = v
			end
			for k, v in pairs (v.angle) do
				spawnang[k] = v
			end

				local npc = ents.Create("clothes_npc")
			npc:SetPos( Vector( tonumber(spawnpos[1]), tonumber(spawnpos[2]), tonumber(spawnpos[3]) ) )
			npc:SetAngles( Angle( tonumber(spawnang[1]), tonumber(spawnang[2]), tonumber(spawnang[3]) ) ) 
			npc:DropToFloor()
			npc:Spawn()
			npc:Activate()

		end
		Msg("[ Clothes ] : All NPC was spawned !(" .. count .. ")\n")
	end)

	timer.Simple(0.6,function() 
		Msg("[ Clothes ] : Attempt to spawn WARDROBE !\n")

		for _, v in pairs(ents.FindByClass("clothes_wardrobe") ) do
			v:Remove()
		end

		local fileread = file.Read("clothes_data/" .. game.GetMap() .. "/wardrobe.txt", "DATA")
		local data = util.JSONToTable(fileread)

		local count = 0
		for k, v in pairs(data) do
			local spawnang = {}
			local spawnpos = {}
			count = count + 1

			for k, v in pairs(v.pos) do
				spawnpos[k] = v
			end
			for k, v in pairs (v.angle) do
				spawnang[k] = v
			end

				local npc = ents.Create("clothes_wardrobe")
			npc:SetPos( Vector( tonumber(spawnpos[1]), tonumber(spawnpos[2]), tonumber(spawnpos[3] ) ) )
			npc:SetAngles( Angle( tonumber(spawnang[1]), tonumber(spawnang[2]), tonumber(spawnang[3]) ) ) 
			npc:Spawn()
			npc:Activate()

		end
		Msg("[ Clothes ] : All WARDROBE was spawned !(" .. count .. ")\n")
	end)

end

hook.Add("InitPostEntity", "Clothes-InitSpawnNpc", clothes_spawnent() )
hook.Add("PostCleanupMap", "Clothes-CleanUpSpawn", clothes_spawnent() )

--[[-----------------[[--

	ADD NEW NPC 

--]]-----------------]]--

local function clothes_addnpc(ply)
	if not clothes.AdminTeam[ ply:GetUserGroup() ] then return end
	if not IsValid(ply) then return end

	if not file.Exists("clothes_data/"..game.GetMap().."/npc.txt", "DATA") then
		clothes_createdata()
	end

	local NpcPos = string.Explode(" ", tostring( ply:GetEyeTrace().HitPos ) )
	local NpcAngles = string.Explode(" ", tostring( ply:GetAngles() + Angle(0, -180, 0) ) )

	local olddata = file.Read("clothes_data/"..game.GetMap().."/npc.txt", "DATA")
	local oldtable = util.JSONToTable(olddata)
	local newdata = { 
		pos = NpcPos, 
		angle = NpcAngles
	}
	table.insert(oldtable, newdata)
	local newstring = util.TableToJSON(oldtable)

	file.Write("clothes_data/"..game.GetMap().."/npc.txt", "" .. newstring .. "")

	clothes_spawnent()
end

--[[-----------------[[--

	ADD NEW WARDROBE

--]]-----------------]]--

local function clothes_addwardrobe(ply)
	if not clothes.AdminTeam[ ply:GetUserGroup() ] then return end
	if not IsValid(ply) then return end

	if not file.Exists("clothes_data/"..game.GetMap().."/wardrobe.txt", "DATA") then
		clothes_createdata()
	end

	local NpcPos = string.Explode(" ", tostring( ply:GetEyeTrace().HitPos ) )
	local NpcAngles = string.Explode(" ", tostring( ply:GetAngles() + Angle(0, -180, 0) ) )

	local olddata = file.Read("clothes_data/"..game.GetMap().."/wardrobe.txt", "DATA")
	local oldtable = util.JSONToTable(olddata)
	local newdata = { 
		pos = NpcPos, 
		angle = NpcAngles
	}
	table.insert(oldtable, newdata)
	local newstring = util.TableToJSON(oldtable)

	file.Write("clothes_data/"..game.GetMap().."/wardrobe.txt", "" .. newstring .. "")

	clothes_spawnent()
end


--[[-----------------[[--

	DELETE NPC

--]]-----------------]]--

local function clothes_save()

	if not file.Exists("clothes_data/"..game.GetMap().."/npc.txt", "DATA") then
		clothes_createdata()
	end

	local alldata = {} 
	for _, ent in pairs (ents.FindByClass("clothes_npc") ) do
		local NpcPos = string.Explode(" ", tostring( ent:GetPos() ) )
		local NpcAngles = string.Explode(" ", tostring( ent:GetAngles() ) )

		local newdata = {
			pos = NpcPos, 
			angle = NpcAngles
		}
		table.insert(alldata, newdata)
	end

	local sendtable = util.TableToJSON(alldata)

	file.Write("clothes_data/"..game.GetMap().."/npc.txt", "" .. sendtable .. "")


	if not file.Exists("clothes_data/"..game.GetMap().."/wardrobe.txt", "DATA") then
		clothes_createdata()
	end

	local alldataw = {} 
	for _, ent in pairs (ents.FindByClass("clothes_wardrobe") ) do
		local NpcPosw = string.Explode(" ", tostring( ent:GetPos() ) )
		local NpcAnglesw = string.Explode(" ", tostring( ent:GetAngles() ) )

		local newdataw = {
			pos = NpcPosw, 
			angle = NpcAnglesw
		}
		table.insert(alldataw, newdataw)
	end

	local sendtablew = util.TableToJSON(alldataw)

	file.Write("clothes_data/"..game.GetMap().."/wardrobe.txt", "" .. sendtablew .. "")

	clothes_spawnent()
end

--[[-----------------[[--

	NETWORK FUNCTION

--]]-----------------]]--

local lvr = clothes.LanguageUsed // clothes.lang[lvr].serv

net.Receive("Clothes-Server", function(len, ply)
	local where = net.ReadInt(4)

		if where == -7 then -- [[ ADD MODEL TO THE DATA ]] --
			local info = net.ReadTable()

			if not clothes.AdminTeam[ ply:GetUserGroup() ] then return end

			if  info.name == ( nil or clothes.lang[lvr].serv1 )  then
				DarkRP.notify(ply, 1 , 1, clothes.lang[lvr].serv2)
				return
			elseif info.model == ( nil or clothes.lang[lvr].serv3 ) then
				DarkRP.notify(ply, 1 , 1, clothes.lang[lvr].serv4)
				return
			elseif info.price == ( nil or clothes.lang[lvr].serv5 ) then
				DarkRP.notify(ply, 1, 1, clothes.lang[lvr].serv6)
				return
			elseif info.type == nil then
				DarkRP.notify(ply, 1, 1, clothes.lang[lvr].serv7)
				return
			end

			sql.Query("INSERT INTO clothees_data VALUES( NULL,'" .. info.type .."','" .. info.name .. "','" .. info.model .. "','" .. tonumber(info.price) .. "','[]' , '[]' ) ")
			DarkRP.notify(ply, 0, 1, clothes.lang[lvr].serv8)

		elseif where == -6 then -- [[ PLAYER BUY CLOTHE ]]
			local key = net.ReadInt(16) 
			local npc = net.ReadEntity()

			if not npc:GetClass() == "clothes_npc" then return end
			if ply:GetPos():Distance(npc:GetPos()) > 100 then return end

			local data = sql.Query("SELECT * FROM clothees_data WHERE id =" .. key)
			
			for k , v in pairs ( data ) do

				if ply:getDarkRPVar("money") < tonumber(v.price) then
					DarkRP.notify(ply, 1, 2, clothes.lang[lvr].serv9)
					return
				end

				local buyer
				if v.havebuy == "[]" then
					buyer = {}
				else 
					buyer = util.JSONToTable(v.havebuy)
				end
				
				if table.HasValue(buyer, ply:SteamID64() ) then 
					DarkRP.notify(ply, 1 , 2, clothes.lang[lvr].serv10)
					return
				end

				if v.restrict != "[]" then
					local justrestrict = util.JSONToTable( v.restrict )
					if table.Count( justrestrict["groups"] ) >= 1 and not table.HasValue(justrestrict["groups"], ply:GetUserGroup() ) then
						DarkRP.notify(ply, 1 , 2, clothes.lang[lvr].serv11)
						return
					end
					if table.Count( justrestrict["jobs"]  ) >= 1 and not table.HasValue(justrestrict["jobs"], team.GetName( ply:Team() ) )then
						DarkRP.notify(ply, 1 , 2, clothes.lang[lvr].serv12)
						return
					end
				end

				table.insert(buyer, ply:SteamID64() )
				local insertbuyer = util.TableToJSON(buyer)

				sql.Query([[UPDATE clothees_data SET havebuy = ']] .. insertbuyer .. [[' WHERE id = ]] .. key )
				ply:addMoney("-" .. v.price)
				DarkRP.notify(ply, 0, 2, clothes.lang[lvr].serv13)

			end

		elseif where == -5 then	 --[[ ADMIN DELETE CLOTHE ]]
			if not clothes.AdminTeam[ ply:GetUserGroup() ] then return end
			local key = net.ReadInt(16)

			local currentdata = sql.Query("SELECT * FROM clothees_data")
				if not currentdata then
					return
				end

			local xdz = sql.Query("DELETE FROM clothees_data WHERE id =" .. tonumber(key) )
			DarkRP.notify(ply, 0, 2, clothes.lang[lvr].serv14)

			local itemsend = sql.Query("SELECT * FROM clothees_data ")
			if not itemsend then
				return
			end

			net.Start("Clothes-Client")
			net.WriteInt(-7, 4)
			net.WriteEntity(npc)
			net.WriteTable(itemsend)
			net.Send(ply)

		elseif where == -4 then -- [[ ADD USER GROUP TO THE WHITELIST ]] --
			if not clothes.AdminTeam[ ply:GetUserGroup() ] then return end
			local itemkey = net.ReadInt(16)
			local groupadd = net.ReadString()
			local npc = net.ReadEntity()

			local itemdata = sql.Query("SELECT * FROM clothees_data WHERE id =" .. itemkey )
			if not itemdata then
				return
			end

			local justrestrict
			for k, v in pairs(itemdata) do 
				if v.restrict == "[]" then
					justrestrict = {}
					justrestrict["groups"] = {}
					justrestrict["jobs"] = {}
				else
					justrestrict = util.JSONToTable( v.restrict )
				end
			end

			if table.HasValue(justrestrict["groups"], groupadd) then 
				DarkRP.notify(ply, 1, 2, clothes.lang[lvr].serv15)
				return
			end

			table.insert(justrestrict["groups"], groupadd)
			sql.Query([[UPDATE clothees_data SET restrict = ']] .. util.TableToJSON(justrestrict) ..[[' WHERE  id = ]] .. itemkey)
			DarkRP.notify(ply, 0, 2, clothes.lang[lvr].serv16)

			local itemsend = sql.Query("SELECT * FROM clothees_data WHERE id =" .. itemkey )
			if not itemsend then
				return
			end

			net.Start("Clothes-Client")
			net.WriteInt(-6, 4)
			net.WriteTable(itemsend)
			net.WriteEntity(npc)
			net.Send(ply)

		elseif where == -3 then -- [[ REMOVE USER GROUP FROM THE WHITELIST ]] --
			if not clothes.AdminTeam[ ply:GetUserGroup() ] then return end
			local itemkey = net.ReadInt(16)
			local groupdelete = net.ReadString()
			local npc = net.ReadEntity()

			local itemdata = sql.Query("SELECT * FROM clothees_data WHERE id =" .. itemkey )
			if not itemdata then
				return
			end

			local justrestrict 
			for k, v in pairs(itemdata) do
				if v.restrict == "[]" then
					DarkRP.notify(ply, 1, 2, clothes.lang[lvr].serv17)
					return
				else
					justrestrict = util.JSONToTable( v.restrict )
				end
			end

			if not table.HasValue(justrestrict["groups"], groupdelete) then 
				DarkRP.notify(ply, 1, 2, clothes.lang[lvr].serv17)
				return
			end

			table.RemoveByValue(justrestrict["groups"], groupdelete)
			sql.Query([[UPDATE clothees_data SET restrict = ']] .. util.TableToJSON(justrestrict) ..[[' WHERE  id = ]] .. itemkey)
			DarkRP.notify(ply, 0, 2, clothes.lang[lvr].serv18)

			local itemsend = sql.Query("SELECT * FROM clothees_data WHERE id =" .. itemkey )
			if not itemsend then
				return
			end

			net.Start("Clothes-Client")
			net.WriteInt(-6, 4)
			net.WriteTable(itemsend)
			net.WriteEntity(npc)
			net.Send(ply)

		elseif where == -2 then -- [[ RECOVER DATA FOR OPEN EDIT ITEM PANEL ]] -- 
			if not clothes.AdminTeam[ ply:GetUserGroup() ] then return end
			local itemkey = net.ReadInt(16)
			local npc = net.ReadEntity()

			local itemdata = sql.Query("SELECT * FROM clothees_data WHERE id =" .. itemkey )
			if not itemdata then
				return
			end

			net.Start("Clothes-Client")
			net.WriteInt(-6, 4)
			net.WriteTable(itemdata)
			net.WriteEntity(npc)
			net.Send(ply)
		elseif where == -1 then -- [[ ADD JOB TO THE WHITELIST ]] --
			if not clothes.AdminTeam[ ply:GetUserGroup() ] then return end
			local itemkey = net.ReadInt(16)
			local jobadd = net.ReadString()
			local npc = net.ReadEntity()

			local itemdata = sql.Query("SELECT * FROM clothees_data WHERE id =" .. itemkey )
			if not itemdata then
				return
			end

			local justrestrict
			for k, v in pairs(itemdata) do
				if v.restrict == "[]" then
					justrestrict = {}
					justrestrict["groups"] = {}
					justrestrict["jobs"] = {}
				else
					justrestrict = util.JSONToTable( v.restrict )
				end
			end

			if table.HasValue(justrestrict["jobs"], jobadd) then
				DarkRP.notify(ply, 1, 2, clothes.lang[lvr].serv19)
				return
			end

			table.insert(justrestrict["jobs"], jobadd)
			sql.Query([[UPDATE clothees_data SET restrict = ']] .. util.TableToJSON(justrestrict) ..[[' WHERE  id = ]] .. itemkey)
			DarkRP.notify(ply, 0, 2, clothes.lang[lvr].serv20)

			local itemsend = sql.Query("SELECT * FROM clothees_data WHERE id =" .. itemkey )
			if not itemsend then
				return
			end

			net.Start("Clothes-Client")
			net.WriteInt(-6, 4)
			net.WriteTable(itemsend)
			net.WriteEntity(npc)
			net.Send(ply)

		elseif where == 0 then -- [[ DELETE JOB FROM THE WHITELIST ]] --
			if not clothes.AdminTeam[ ply:GetUserGroup() ] then return end
			local itemkey = net.ReadInt(16)
			local jobdelete = net.ReadString()
			local npc = net.ReadEntity()

			local itemdata = sql.Query("SELECT * FROM clothees_data WHERE id =" .. itemkey )
			if not itemdata then
				return
			end

			local justrestrict 
			for k, v in pairs(itemdata) do
				if v.restrict == "[]" then
					DarkRP.notify(ply, 1, 2, clothes.lang[lvr].serv21)
					return
				else
					justrestrict = util.JSONToTable( v.restrict )
				end
			end

			if not table.HasValue(justrestrict["jobs"], jobdelete) then 
				DarkRP.notify(ply, 1, 2, clothes.lang[lvr].serv21)
				return
			end

			table.RemoveByValue(justrestrict["jobs"], jobdelete)
			sql.Query([[UPDATE clothees_data SET restrict = ']] .. util.TableToJSON(justrestrict) ..[[' WHERE  id = ]] .. itemkey)
			DarkRP.notify(ply, 0, 2, clothes.lang[lvr].serv22)

			local itemsend = sql.Query("SELECT * FROM clothees_data WHERE id =" .. itemkey )
			if not itemsend then
				return
			end

			net.Start("Clothes-Client")
			net.WriteInt(-6, 4)
			net.WriteTable(itemsend)
			net.WriteEntity(npc)
			net.Send(ply)
		elseif where == 1 then -- [[ EDIT ITEM ( PRICE, NAME, MODELS, TYPE ) ]] -- 
			if not clothes.AdminTeam[ ply:GetUserGroup() ] then return end
			local itemkey = net.ReadInt(16)
			local newdata = net.ReadTable()
			local npc = net.ReadEntity()

			if newdata.name == nil then
				DarkRP.notify(ply, 1 , 1, clothes.lang[lvr].serv2)
				return
			elseif newdata.model == nil then
				DarkRP.notify(ply, 1 , 1, clothes.lang[lvr].serv4)
				return
			elseif newdata.price == nil then
				DarkRP.notify(ply, 1, 1, clothes.lang[lvr].serv6)
				return
			elseif newdata.type == nil then
				DarkRP.notify(ply, 1, 1, clothes.lang[lvr].serv7)
				return
			end

			local xdz = sql.Query([[UPDATE clothees_data SET name = ']] .. newdata.name .. [[', model = ']] .. newdata.model .. [[', price = ']] .. tonumber(newdata.price) .. [[', type = ']] .. newdata.type .. [[' WHERE  id = ]] .. itemkey)
			DarkRP.notify(ply, 0, 2, clothes.lang[lvr].serv23)

			local itemsend = sql.Query("SELECT * FROM clothees_data ")
			if not itemsend then
				return
			end

			net.Start("Clothes-Client")
			net.WriteInt(-7, 4)
			net.WriteEntity(npc)
			net.WriteTable(itemsend)
			net.Send(ply)
		elseif where == 2 then -- [[ PLAYER EQUIP CLOTHE ]] --
		local itemkey = net.ReadInt(16)
		local npc = net.ReadEntity()

			if not npc:GetClass() == "clothes_npc" then return end
			if ply:GetPos():Distance(npc:GetPos()) > 100 then return end

			local itemdata = sql.Query("SELECT * FROM clothees_data WHERE id =" .. itemkey)
			if not itemdata then
				return
			end

			for k, v in pairs (itemdata) do
				if not table.HasValue( util.JSONToTable(v.havebuy), ply:SteamID64() ) then
					DarkRP.notify(ply, 1, 2, clothes.lang[lvr].serv24)
					return
				end

				if v.restrict != "[]" then
				local justrestrict = util.JSONToTable( v.restrict )
					if table.Count( justrestrict["groups"] ) >= 1 and not table.HasValue(justrestrict["groups"], ply:GetUserGroup() ) then
						DarkRP.notify(ply, 1 , 2, clothes.lang[lvr].serv11)
						return
					end
					if table.Count( justrestrict["jobs"]  ) >= 1 and not table.HasValue(justrestrict["jobs"], team.GetName( ply:Team() ) )then
						DarkRP.notify(ply, 1 , 2, clothes.lang[lvr].serv12)
						return
					end
				end
				if ply:GetModel() == v.model then
					DarkRP.notify(ply, 1 , 2, clothes.lang[lvr].serv10)
					return
				end
				ply:SetModel(v.model)
				DarkRP.notify(ply, 0, 2, clothes.lang[lvr].serv25)

			end
		elseif where == 3 then -- [[ PLAYER UNEQUIP CLOTHE ]] -- 
		local itemkey = net.ReadInt(16) -- Useless var
		local npc = net.ReadEntity()

			if not npc:GetClass() == "clothes_npc" then return end
			if ply:GetPos():Distance(npc:GetPos()) > 100 then return end

			local jobmdl 
			for k, v in pairs(RPExtraTeams) do
				if v.name == team.GetName( ply:Team() ) then
					if istable(v.model) then
						jobmdl = table.Random(v.model)
					else
						jobmdl = v.model
					end
					if jobmdl == ply:GetModel() then 
						DarkRP.notify(ply, 0, 2, clothes.lang[lvr].serv26)
						return
					end
					ply:SetModel(jobmdl)
					DarkRP.notify(ply, 0, 2, clothes.lang[lvr].serv26)
				end
			end

		end

end)

--[[-----------------[[--

	ON PLAYER SAY 

--]]-----------------]]--

hook.Add("PlayerSay", "Clothes-CommandServer", function(ply, text)

	text = string.lower( text )

	if clothes.AdminTeam[ ply:GetUserGroup() ] and text == clothes.SpawnNPC then
		clothes_addnpc(ply)
		return " "
	end
	
	if clothes.AdminTeam[ ply:GetUserGroup() ] and text == clothes.SaveCommand then
		clothes_save()
		return " "
	end

	if clothes.AdminTeam[ ply:GetUserGroup() ] and text == clothes.SpawnWardRobe then
		clothes_addwardrobe(ply)
		return " "
	end


	if clothes.AdminTeam[ ply:GetUserGroup() ] and text == clothes.AddModelCommand then
		net.Start("Clothes-Client")
		net.WriteInt(-4, 4)
		net.Send(ply)
		return " "
	end

end)
