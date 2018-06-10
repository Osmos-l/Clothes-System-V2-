--[[-----------------[[--

	CREATE FONT

--]]-----------------]]--

surface.CreateFont("Clothes_Font1", {
	font = "Lato-Light",
	size = "18"
} )

surface.CreateFont("Clothes_Price", {
	font = "Lato-Light",
	size = "13"
} )

surface.CreateFont("Clothes_Close", {
	font = "Lato-Light",
	size = "48"
} )

--[[-----------------[[--

	LOCAL VARIABLE

--]]-----------------]]--

local firstp
local onlytype
local wardrobeonly
local lvr = clothes.LanguageUsed // clothes.lang[lvr].cl
local pdr = clothes.ThemeUsed // clothes.theme[pdr].

--[[-----------------[[--

	BLUR FUNCTION

--]]-----------------]]--

local blur = Material("pp/blurscreen")

local function blurPanel(firstp, amount)
    local x, y = firstp:LocalToScreen(0, 0)
    local scrW, scrH = ScrW(), ScrH()
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)

    for i = 1, 6 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
    end
end

--[[-----------------[[--

	NOTIFY PANEL FUNCTION

--]]-----------------]]--

local function clothes_notify(what, itemname, itemkey, entity)
local txt1
local txt2
local send

	if what == 1 then
		txt1 = clothes.lang[lvr].cl1
		txt2 = clothes.lang[lvr].cl2 .. " " .. itemname .. " ?"
		send = -6
	elseif what == 2 then
		txt1 = clothes.lang[lvr].cl3
		txt2 = clothes.lang[lvr].cl4 .. " " .. itemname .. " ?"
		send = -5
	elseif what == 3 then
		txt1 = clothes.lang[lvr].cl5
		txt2 = clothes.lang[lvr].cl6 .. " " .. itemname .. " ?"
		send = 2
	elseif what == 4 then
		txt1 = clothes.lang[lvr].cl7
		txt2 = clothes.lang[lvr].cl8 .. " " .. itemname .. " ?"
		send = 3
	elseif what == 5 then -- Refound clothe
		txt1 = clothes.lang[lvr].cl26
		txt2 = clothes.lang[lvr].cl27 .. " " .. itemname .. " ?"
		send = 4
	end

	local notifyp = vgui.Create("DFrame")
	notifyp:SetSize(400, 150)
	notifyp:SetTitle("")
	notifyp:SetDraggable(true)
	notifyp:ShowCloseButton(false)
	notifyp:MakePopup()
	notifyp:Center()

	function notifyp:Paint(w, h)
		blurPanel(self, 5)
		draw.RoundedBox(3, 0, 0, w, h, clothes.theme[pdr].background)
       	draw.RoundedBox(5, 0, 0, w, 30, clothes.theme[pdr].up)
       	draw.SimpleText(txt1,"Trebuchet24", 200, 5, clothes.theme[pdr].txt, TEXT_ALIGN_CENTER)
       	draw.SimpleText(txt2,"Trebuchet18", 200, 50, clothes.theme[pdr].txt, TEXT_ALIGN_CENTER)
	end

	local validate = vgui.Create("DButton", notifyp)
	validate:SetSize(150, 30)
	validate:SetPos(25, 100)
	validate:SetText(clothes.lang[lvr].cl9)
	validate:SetTextColor( clothes.theme[pdr].txt )

	function validate:Paint(w, h)
		draw.RoundedBox(3, 0, 0, w, h, clothes.theme[pdr].validate )
	end

	validate.DoClick = function()
		notifyp:Remove()
		firstp:Remove()
		net.Start("Clothes-Server")
		net.WriteInt(send, 4)
		net.WriteInt(itemkey, 16)
		net.WriteEntity(entity)
		net.SendToServer()
	end

	local cancel = vgui.Create("DButton", notifyp)
	cancel:SetSize(150, 30)
	cancel:SetPos(225, 100)
	cancel:SetText(clothes.lang[lvr].cl10)
	cancel:SetTextColor( clothes.theme[pdr].txt  )

	function cancel:Paint(w , h)
		draw.RoundedBox(3, 0, 0, w, h, clothes.theme[pdr].cancel)
	end

	cancel.DoClick = function()
		notifyp:Remove()
	end

end

--[[-----------------[[--

	NETWORK FUNCTION

--]]-----------------]]--

local searchicon = Material("clothes/search.png")
local delicon = Material("clothes/delete.png")
local editicon = Material("clothes/edit.png")

net.Receive("Clothes-Client", function(len, pl)
	local where = net.ReadInt(4)

		if where == -7 then
			local npc = net.ReadEntity()
			local data = net.ReadTable()
			local wpos = ScrW() / 2 - 450
			local hpos = ScrH() / 2 - 300

				firstp = vgui.Create("DFrame")
			firstp:SetSize(900, 600)
			firstp:SetPos(wpos, ScrH())
			firstp:SetTitle("")
			firstp:SetDraggable(true)
			firstp:ShowCloseButton(false)
			firstp:MakePopup()
			firstp:MoveTo(wpos, hpos, 0.25, 0, 10)

			function firstp:Paint( w, h)
				blurPanel(self, 5)
				draw.RoundedBox(3, 0, 0, w, h, clothes.theme[pdr].background)
				draw.RoundedBox(0, 0, 0, w, 100, clothes.theme[pdr].up)
       			draw.SimpleText(clothes.lang[lvr].cl11,"Trebuchet24", 450, 5, clothes.theme[pdr].txt, TEXT_ALIGN_CENTER)
       			draw.SimpleText(clothes.lang[lvr].cl12, "Clothes_Font1", 425, 60, clothes.theme[pdr].txt)
       			draw.SimpleText(clothes.lang[lvr].cl13, "Clothes_Font1", 575, 60, clothes.theme[pdr].txt)
       			draw.SimpleText(clothes.lang[lvr].cl14, "Clothes_Font1", 725, 60, clothes.theme[pdr].txt)
			end

				local closeb = vgui.Create("DButton", firstp)
			closeb:SetSize(20, 20)
			closeb:SetPos(870, 10)
			closeb:SetText("X")
			closeb:SetTextColor( clothes.theme[pdr].leave )
			closeb:SetFont("Clothes_Close")

			closeb.DoClick = function()
				firstp:Remove()
			end

			function closeb:Paint(w, h)
			end

			local scroolbar = vgui.Create("DScrollPanel", firstp)
			scroolbar:DockMargin(0, 72, 0, 0)
			scroolbar:Dock( FILL )

			 local scrollbar = scroolbar:GetVBar()

       		function scrollbar:Paint(w, h)
            	draw.RoundedBox(0, 0, 0, w, h, clothes.theme[pdr].scroolbar)
        	end

       		function scrollbar.btnUp:Paint(w, h)
            	draw.RoundedBox(0, 6, 0, 8, h, clothes.theme[pdr].background)
        	end

        	function scrollbar.btnDown:Paint(w, h)
            	draw.RoundedBox(0, 6, 0, 8, h, clothes.theme[pdr].background)
        	end

        	function scrollbar.btnGrip:Paint(w, h)
            	draw.RoundedBox(3, 6, 0, 8, h, clothes.theme[pdr].background)
        	end

			local List = vgui.Create("DIconLayout", scroolbar)
			List:DockMargin(65, 0, 5, 2)
			List:Dock(FILL)
			List:SetSpaceY(5)
			List:SetSpaceX(5)

			local searchbar = vgui.Create("DTextEntry", firstp)
			searchbar:SetSize(200, 30)
			searchbar:SetPos(100 , 60)
			searchbar:SetText(clothes.lang[lvr].cl15)
			searchbar:SetDrawLanguageID(false)

			searchbar.OnGetFocus = function()
				if searchbar:GetValue() == clothes.lang[lvr].cl15 then 
					searchbar:SetValue("")
				end
			end

			local function clothes_draw()
				List:Clear()
				for k, v in pairs(data) do
				local show = true

					if searchbar:GetValue() != ( clothes.lang[lvr].cl15 or nil ) then
						if not string.find( string.lower(v.name) , string.lower( searchbar:GetValue() ) ) then
							show = false
						end
					end

					local buybtext
					local buybcolor
					local colorhover
					local netsend 
					if table.HasValue( util.JSONToTable(v.havebuy), LocalPlayer():SteamID64() ) then
						buybtext = clothes.lang[lvr].cl16 -- have buy
						netsend = 5
						buybcolor = clothes.theme[pdr].cancel
						colorhover = clothes.theme[pdr].cancelhover
					else
						buybtext = clothes.lang[lvr].cl17 -- buy
						netsend = 1
						buybcolor = clothes.theme[pdr].buy
						colorhover = clothes.theme[pdr].buyhover
						
					end

					if onlytype and v.type != onlytype then
						show = false
					end

					if v.restrict != "[]" then
						local justrestrict = util.JSONToTable( v.restrict )
						if table.Count( justrestrict["groups"] ) >= 1 and not table.HasValue(justrestrict["groups"], LocalPlayer():GetUserGroup() ) then
							show = false
						end
						if table.Count( justrestrict["jobs"]  ) >= 1 and not table.HasValue(justrestrict["jobs"], team.GetName( LocalPlayer():Team() ) ) then
							show = false
						end
					end

					if show then
						local listmodel = List:Add("DModelPanel")
						listmodel:SetSize(250, 400)
						listmodel:SetFOV(65)
						listmodel:SetCamPos( Vector(50, 0 , 50) )
						listmodel:SetModel(v.model)

						function listmodel:PaintOver(w, h)
							draw.RoundedBox(5, 0, 0, w, 30,	clothes.theme[pdr].scroolbar)
							draw.RoundedBox(0, 0, 0, 1, 365, clothes.theme[pdr].scroolbar)
							draw.RoundedBox(0, w-1, 0, 1, 365, clothes.theme[pdr].scroolbar)
							draw.RoundedBox(0, 0, 364, w, 1, clothes.theme[pdr].scroolbar)
							draw.SimpleText(v.name,"Clothes_Font1", 125, 8, clothes.theme[pdr].txt, TEXT_ALIGN_CENTER)
							draw.SimpleText(DarkRP.formatMoney( tonumber(v.price) ),"Clothes_Price", 210, 345, clothes.theme[pdr].txt)
						end
				
						local buyb = vgui.Create("DButton", listmodel)
						buyb:SetSize(250, 30)
						buyb:SetPos(0, 370)
						buyb:SetText(buybtext)
						buyb:SetTextColor( clothes.theme[pdr].txt )

						buyb.OnCursorEntered = function(self)
								self.hover = true
						end
						buyb.OnCursorExited = function(self)
								self.hover = false 
						end

						function buyb:Paint(w, h)
							local kcol 
							if self.hover then
								kcol = colorhover
							else 
								kcol = buybcolor
							end
							draw.RoundedBox(0, 0, 0, w, h, kcol )
						end

						buyb.DoClick = function()
							clothes_notify(netsend, v.name , v.id, npc)
						end

						if clothes.AdminTeam[ LocalPlayer():GetUserGroup() ] then
							local deleteb = vgui.Create("DButton", listmodel)
							deleteb:SetSize(20, 20)
							deleteb:SetPos(220, 40)
							deleteb:SetText("")

							function deleteb:Paint(w, h)
								surface.SetDrawColor(255, 255, 255, 255)
                      			surface.SetMaterial(delicon)
                    			surface.DrawTexturedRect(0, 0, w, h)
							end

							deleteb.DoClick = function()
								clothes_notify(2, v.name , v.id, npc)
							end

							local editb = vgui.Create("DButton", listmodel)
							editb:SetSize(20, 20)
							editb:SetPos(190, 40)
							editb:SetText("")

							function editb:Paint(w, h)
								surface.SetDrawColor(255, 255, 255, 255)
                     			surface.SetMaterial(editicon)
                    			surface.DrawTexturedRect(0, 0, w, h)
                  	  		end

                   			editb.DoClick = function()
                   			net.Start("Clothes-Server")
                   			net.WriteInt(-2, 4)
                   			net.WriteInt(v.id, 16)
                   			net.WriteEntity(npc)
                   			net.SendToServer()

                    		end
						end
					end
				end
			end
			clothes_draw()

				local startsearch = vgui.Create("DButton", firstp)
			startsearch:SetSize(28, 28)
			startsearch:SetPos(299, 61)
			startsearch:SetText("")

			startsearch.OnCursorEntered = function(self)
				self.hover = true
			end

			startsearch.OnCursorExited = function(self)
				self.hover = false
			end

			startsearch.DoClick = function()
				clothes_draw()
			end

			function startsearch:Paint(w , h)
				local kcol 
				if self.hover then
					kcol = clothes.theme[pdr].searchhover
				else
					kcol =  clothes.theme[pdr].search
				end
				draw.RoundedBox(0, 0, 0, w, h, kcol)
				surface.SetDrawColor( 255, 255, 255)
				surface.SetMaterial( searchicon	)
				surface.DrawTexturedRect( 0, 0, w, h )
			end

			local onlyman = vgui.Create("DCheckBox", firstp)
			onlyman:SetSize(15, 15)
			onlyman:SetPos(400, 60)

			if onlytype == "male" then
				onlyman:SetValue(true)
			end

			onlyman.OnChange = function()
				if onlytype == "male" then
					onlytype = nil 
				else
					onlytype = "male"
				end
				clothes_draw()
			end

			local onlyfemale = vgui.Create("DCheckBox", firstp)
			onlyfemale:SetSize(15, 15)
			onlyfemale:SetPos(550, 60)

			if onlytype == "female" then
				onlyfemale:SetValue(true)
			end

			onlyfemale.OnChange = function()
				if onlytype == "female" then
					onlytype = nil 
				else
					onlytype = "female"
				end
				clothes_draw()
			end

			local onlychild = vgui.Create("DCheckBox", firstp)
			onlychild:SetSize(15, 15)
			onlychild:SetPos(700, 60)

			if onlytype == "children" then
				onlychild:SetValue(true)
			end

			onlychild.OnChange = function()
				if onlytype == "children" then
					onlytype = nil 
				else
					onlytype = "children"
				end
				clothes_draw()
			end
		elseif where == -6 then
			local data = net.ReadTable()
			local npc = net.ReadEntity()

			for k, v in pairs(data) do
				local wpos = ScrW() / 2 - 225
				local hpos = ScrH() / 2 - 200
				local justrestrict
				if v.restrict == "[]" then
					justrestrict = {}
					justrestrict["groups"] = {}
					justrestrict["jobs"] = {}
				else
					justrestrict = util.JSONToTable( v.restrict )
				end

					local pedit = vgui.Create("DFrame")
				pedit:SetSize(450, 400)
				pedit:SetPos(wpos, ScrH())
				pedit:SetTitle("")
				pedit:SetDraggable(true)
				pedit:ShowCloseButton(false)
				pedit:MakePopup()
				pedit:MoveTo(wpos, hpos, 0.25, 0, 10)

				function pedit:Paint(w, h)
					blurPanel(self, 5)
					draw.RoundedBox(3, 0, 0, w,  h, clothes.theme[pdr].background)
					draw.RoundedBox(3, 0, 0, w, 30, clothes.theme[pdr].up)
					draw.SimpleText(clothes.lang[lvr].cl18, "Trebuchet18", 225, 8, clothes.theme[pdr].txt, TEXT_ALIGN_CENTER)
					draw.SimpleText(clothes.lang[lvr].cl19, "Trebuchet18", 225, 50, clothes.theme[pdr].txt, TEXT_ALIGN_CENTER)
					draw.SimpleText(clothes.lang[lvr].cl20, "Trebuchet18", 85, 220, clothes.theme[pdr].txt, TEXT_ALIGN_CENTER)
					draw.SimpleText(clothes.lang[lvr].cl21, "Trebuchet18", 350, 220, clothes.theme[pdr].txt, TEXT_ALIGN_CENTER)
				end

					local modeltype = vgui.Create("DComboBox", pedit)
				modeltype:SetSize(100, 20)
				modeltype:SetPos(175, 70)
				modeltype:SetValue(v.type)
				modeltype:AddChoice("female")
				modeltype:AddChoice("male")
				modeltype:AddChoice("children")

					local modelname = vgui.Create("DTextEntry", pedit)
				modelname:SetSize(200, 30)
				modelname:SetPos(125, 102)
				modelname:SetText(v.name)
				modelname:SetDrawLanguageID(false)

					local model = vgui.Create("DTextEntry", pedit)
				model:SetSize(200, 30)
				model:SetPos(125, 134)
				model:SetText(v.model)
				model:SetDrawLanguageID(false)

					local modelprice = vgui.Create("DTextEntry", pedit)
				modelprice:SetSize(200, 30)
				modelprice:SetPos(125, 166)
				modelprice:SetText(v.price)
				modelprice:SetDrawLanguageID(false)

					local groupadd = vgui.Create("DComboBox", pedit)
				groupadd:SetSize(150, 30)
				groupadd:SetPos(10, 236)

				for k, v in pairs( xgui.data.groups ) do
					if not table.HasValue(justrestrict["groups"],  v) then
						groupadd:AddChoice( v )
					end
				end

				groupadd.OnSelect = function()
					net.Start("Clothes-Server")
					net.WriteInt(-4, 4)
					net.WriteInt(v.id, 16)
					net.WriteString( groupadd:GetValue() )
					net.WriteEntity(npc)
					net.SendToServer()
					groupadd:SetValue("")
					pedit:Remove()
				end

					local groupdelete = vgui.Create("DComboBox", pedit)
				groupdelete:SetSize(150, 30)
				groupdelete:SetPos(10, 268)

				for k, v in pairs(justrestrict["groups"]) do
					groupdelete:AddChoice( v )
				end

				groupdelete.OnSelect = function()
					net.Start("Clothes-Server")
					net.WriteInt(-3, 4)
					net.WriteInt(v.id, 16)
					net.WriteString( groupdelete:GetValue() )
					net.WriteEntity(npc)
					net.SendToServer()
					groupdelete:SetValue("")
					pedit:Remove()
				end

					local jobadd = vgui.Create("DComboBox", pedit)
				jobadd:SetSize(150, 30)
				jobadd:SetPos(275, 236)

				for k, v in pairs(RPExtraTeams) do
					if not table.HasValue(justrestrict["jobs"], v.name) then
						jobadd:AddChoice(v.name)
					end
				end

				jobadd.OnSelect = function()
					net.Start("Clothes-Server")
					net.WriteInt(-1, 4)
					net.WriteInt(v.id, 16)
					net.WriteString( jobadd:GetValue() )
					net.WriteEntity(npc)
					net.SendToServer()
					jobadd:SetValue("")
					pedit:Remove()
				end
					local jobdelete = vgui.Create("DComboBox", pedit)
				jobdelete:SetSize(150, 30)
				jobdelete:SetPos(275, 268)

				for k, v in pairs(justrestrict["jobs"]) do
					jobdelete:AddChoice( v )
				end

				jobdelete.OnSelect = function()
					net.Start("Clothes-Server")
					net.WriteInt(0, 4)
					net.WriteInt(v.id, 16)
					net.WriteString( jobdelete:GetValue() )
					net.WriteEntity(npc)
					net.SendToServer()
					jobdelete:SetValue("")
					pedit:Remove()
				end

					local validate = vgui.Create("DButton", pedit)
				validate:SetSize(200, 30)
				validate:SetPos(125, 330)
				validate:SetText(clothes.lang[lvr].cl9)
				validate:SetTextColor( clothes.theme[pdr].txt )

				function validate:Paint(w, h)
					draw.RoundedBox(3, 0, 0, w, h, clothes.theme[pdr].validate)
				end

				validate.DoClick = function()
					local tablesend = {
					type = modeltype:GetValue(),
					name = modelname:GetValue(),
					model = model:GetValue(),
					price = modelprice:GetValue(),
					}
					net.Start("Clothes-Server")
					net.WriteInt(1, 4)
					net.WriteInt(v.id, 16)
					net.WriteTable(tablesend)
					net.WriteEntity(npc)
					net.SendToServer()
					pedit:Remove()
					firstp:Remove()
				end

					local cancel = vgui.Create("DButton", pedit)
				cancel:SetSize(200, 30)
				cancel:SetPos(125, 362)
				cancel:SetText(clothes.lang[lvr].cl10)
				cancel:SetTextColor( clothes.theme[pdr].txt )

				function cancel:Paint(w, h)
					draw.RoundedBox(3, 0, 0, w, h, clothes.theme[pdr].cancel)
				end

				cancel.DoClick = function()
					pedit:Remove()
				end
			end
		elseif where == -5 then -- [[ WARDROBE PANEL ]] --
			local npc = net.ReadEntity()
			local data = net.ReadTable()
			local wpos = ScrW() / 2 - 450
			local hpos = ScrH() / 2 - 300

				firstp = vgui.Create("DFrame")
			firstp:SetSize(900, 600)
			firstp:SetPos(wpos, ScrH())
			firstp:SetTitle("")
			firstp:SetDraggable(true)
			firstp:ShowCloseButton(false)
			firstp:MakePopup()
			firstp:MoveTo(wpos, hpos, 0.25, 0, 10)

			function firstp:Paint( w, h)
				blurPanel(self, 5)
				draw.RoundedBox(3, 0, 0, w, h, clothes.theme[pdr].background)
				draw.RoundedBox(0, 0, 0, w, 100, clothes.theme[pdr].up)
       			draw.SimpleText(clothes.lang[lvr].cl22,"Trebuchet24", 450, 5, clothes.theme[pdr].txt, TEXT_ALIGN_CENTER)
       			draw.SimpleText(clothes.lang[lvr].cl12, "Clothes_Font1", 425, 60, clothes.theme[pdr].txt)
       			draw.SimpleText(clothes.lang[lvr].cl3, "Clothes_Font1", 575, 60, clothes.theme[pdr].txt)
       			draw.SimpleText(clothes.lang[lvr].cl14, "Clothes_Font1", 725, 60, clothes.theme[pdr].txt)
			end

				local closeb = vgui.Create("DButton", firstp)
			closeb:SetSize(20, 20)
			closeb:SetPos(870, 10)
			closeb:SetText("X")
			closeb:SetTextColor( clothes.theme[pdr].leave )
			closeb:SetFont("Clothes_Close")

			closeb.DoClick = function()
				firstp:Remove()
			end

			function closeb:Paint(w, h)
			end

			local scroolbar = vgui.Create("DScrollPanel", firstp)
			scroolbar:DockMargin(0, 72, 0, 0)
			scroolbar:Dock( FILL )

			 local scrollbar = scroolbar:GetVBar()

       		function scrollbar:Paint(w, h)
            	draw.RoundedBox(0, 0, 0, w, h, clothes.theme[pdr].scroolbar)
        	end

       		function scrollbar.btnUp:Paint(w, h)
            	draw.RoundedBox(0, 6, 0, 8, h, clothes.theme[pdr].background)
        	end

        	function scrollbar.btnDown:Paint(w, h)
            	draw.RoundedBox(0, 6, 0, 8, h, clothes.theme[pdr].background)
        	end

        	function scrollbar.btnGrip:Paint(w, h)
            	draw.RoundedBox(3, 6, 0, 8, h, clothes.theme[pdr].background)
        	end

			local List = vgui.Create("DIconLayout", scroolbar)
			List:DockMargin(65, 0, 5, 2)
			List:Dock(FILL)
			List:SetSpaceY(5)
			List:SetSpaceX(5)

			local searchbar = vgui.Create("DTextEntry", firstp)
			searchbar:SetSize(200, 30)
			searchbar:SetPos(100 , 60)
			searchbar:SetText(clothes.lang[lvr].cl15)
			searchbar:SetDrawLanguageID(false)

			searchbar.OnGetFocus = function()
				if searchbar:GetValue() == clothes.lang[lvr].cl15 then 
					searchbar:SetValue("")
				end
			end

			local function wardrobe_draw()
				List:Clear()
				for k, v in pairs(data) do
				local show = true

					if searchbar:GetValue() != ( clothes.lang[lvr].cl15 or nil ) then
						if not string.find( string.lower(v.name) , string.lower( searchbar:GetValue() ) ) then
							show = false
						end
					end

					if not table.HasValue( util.JSONToTable(v.havebuy), LocalPlayer():SteamID64() ) then
						show = false
					end

					if wardrobeonly and v.type != wardrobeonly then
						show = false
					end

					if v.restrict != "[]" then
						local justrestrict = util.JSONToTable( v.restrict )
						if table.Count( justrestrict["groups"] ) >= 1 and not table.HasValue(justrestrict["groups"], LocalPlayer():GetUserGroup() ) then
							show = false
						end
						if table.Count( justrestrict["jobs"]  ) >= 1 and not table.HasValue(justrestrict["jobs"], team.GetName( LocalPlayer():Team() ) ) then
							show = false
						end
					end
					
					if show then
						local buybtext
						local netsend
						local buybcolor
						local colorhover
						if LocalPlayer():GetModel() == v.model then
							buybtext = clothes.lang[lvr].cl23
							netsend = 4
							buybcolor = clothes.theme[pdr].cancel
							colorhover = clothes.theme[pdr].cancelhover
						else
							buybtext = clothes.lang[lvr].cl24
							netsend = 3
							buybcolor = clothes.theme[pdr].buy
							colorhover = clothes.theme[pdr].buyhover
						end

						local listmodel = List:Add("DModelPanel")
						listmodel:SetSize(250, 400)
						listmodel:SetFOV(65)
						listmodel:SetCamPos( Vector(50, 0 , 50) )
						listmodel:SetModel(v.model)

						function listmodel:PaintOver(w, h)
							draw.RoundedBox(5, 0, 0, w, 30, clothes.theme[pdr].scroolbar)
							draw.RoundedBox(0, 0, 0, 1, 365, clothes.theme[pdr].scroolbar)
							draw.RoundedBox(0, w-1, 0, 1, 365, clothes.theme[pdr].scroolbar)
							draw.RoundedBox(0, 0, 364, w, 1, clothes.theme[pdr].scroolbar)
							draw.SimpleText(v.name,"Clothes_Font1", 125, 8, clothes.theme[pdr].txt, TEXT_ALIGN_CENTER)
						end
				
						local buyb = vgui.Create("DButton", listmodel)
						buyb:SetSize(250, 30)
						buyb:SetPos(0, 370)
						buyb:SetText(buybtext)
						buyb:SetTextColor( clothes.theme[pdr].txt )

						buyb.OnCursorEntered = function(self)
								self.hover = true
						end
						buyb.OnCursorExited = function(self)
								self.hover = false 
						end

						function buyb:Paint(w, h)
							local kcol 
							if self.hover then
								kcol = colorhover
							else 
								kcol = buybcolor
							end
							draw.RoundedBox(0, 0, 0, w, h, kcol )
						end

						buyb.DoClick = function()
							clothes_notify(netsend, v.name , v.id, npc)
						end
					end
				end
			end
			wardrobe_draw()

				local startsearch = vgui.Create("DButton", firstp)
			startsearch:SetSize(28, 28)
			startsearch:SetPos(299, 61)
			startsearch:SetText("")

			startsearch.OnCursorEntered = function(self)
				self.hover = true
			end

			startsearch.OnCursorExited = function(self)
				self.hover = false
			end

			startsearch.DoClick = function()
				wardrobe_draw()
			end

			function startsearch:Paint(w , h)
				local kcol 
				if self.hover then
					kcol = clothes.theme[pdr].searchhover
				else
					kcol =  clothes.theme[pdr].search
				end
				draw.RoundedBox(0, 0, 0, w, h, kcol)
				surface.SetDrawColor( 255, 255, 255)
				surface.SetMaterial( searchicon	)
				surface.DrawTexturedRect( 0, 0, w, h )
			end

			local onlyman = vgui.Create("DCheckBox", firstp)
			onlyman:SetSize(15, 15)
			onlyman:SetPos(400, 60)

			if wardrobeonly == "male" then
				onlyman:SetValue(true)
			end

			onlyman.OnChange = function()
				if wardrobeonly == "male" then
					wardrobeonly = nil 
				else
					wardrobeonly = "male"
				end
				wardrobe_draw()
			end

			local onlyfemale = vgui.Create("DCheckBox", firstp)
			onlyfemale:SetSize(15, 15)
			onlyfemale:SetPos(550, 60)

			if wardrobeonly == "female" then
				onlyfemale:SetValue(true)
			end

			onlyfemale.OnChange = function()
				if wardrobeonly == "female" then
					wardrobeonly = nil 
				else
					wardrobeonly = "female"
				end
				wardrobe_draw()
			end

			local onlychild = vgui.Create("DCheckBox", firstp)
			onlychild:SetSize(15, 15)
			onlychild:SetPos(700, 60)

			if wardrobeonly == "children" then
				onlychild:SetValue(true)
			end

			onlychild.OnChange = function()
				if wardrobeonly == "children" then
					wardrobeonly = nil 
				else
					wardrobeonly = "children"
				end
				wardrobe_draw()
			end
		elseif where == -4 then -- [[ PANEL ADD MODEL]]
			local wpos = ScrW() / 2 - 150
			local hpos = ScrH() / 2 - 200

				local firstp = vgui.Create("DFrame")
			firstp:SetSize(300, 350)
			firstp:SetPos(wpos, ScrH())
			firstp:SetTitle("")
			firstp:SetDraggable(true)
			firstp:ShowCloseButton(false)
			firstp:MakePopup()
			firstp:MoveTo(wpos, hpos, 0.25, 0, 10)

			function firstp:Paint(w, h)
				blurPanel(self, 5)
				draw.RoundedBox(3, 0, 0, w,  h, clothes.theme[pdr].background)
				draw.RoundedBox(3, 0, 0, w, 30, clothes.theme[pdr].up)
				draw.SimpleText(clothes.lang[lvr].cl25, "Trebuchet18", 150, 8, clothes.theme[pdr].txt, TEXT_ALIGN_CENTER)
				draw.SimpleText(clothes.lang[lvr].cl19, "Trebuchet18", 150, 50, clothes.theme[pdr].txt, TEXT_ALIGN_CENTER)
			end

				local modeltype = vgui.Create("DComboBox", firstp)
			modeltype:SetSize(100, 20)
			modeltype:SetPos(100, 70)
			modeltype:AddChoice("female")
			modeltype:AddChoice("male")
			modeltype:AddChoice("children")

				local modelname = vgui.Create("DTextEntry", firstp)
			modelname:SetSize(200, 30)
			modelname:SetPos(50, 102)
			modelname:SetText(clothes.lang[lvr].serv1)
			modelname:SetDrawLanguageID(false)

			modelname.OnGetFocus = function()
				modelname:SetValue("")
			end

				local model = vgui.Create("DTextEntry", firstp)
			model:SetSize(200, 30)
			model:SetPos(50, 134)
			model:SetText(clothes.lang[lvr].serv3)
			model:SetDrawLanguageID(false)

			model.OnGetFocus = function()
				model:SetValue("")
			end

				local modelprice = vgui.Create("DTextEntry", firstp)
			modelprice:SetSize(200, 30)
			modelprice:SetPos(50, 166)
			modelprice:SetText(clothes.lang[lvr].serv5)
			modelprice:SetDrawLanguageID(false)

			modelprice.OnGetFocus = function()
				modelprice:SetValue("")
			end

				local validate = vgui.Create("DButton", firstp)
			validate:SetSize(200, 30)
			validate:SetPos(50, 212)
			validate:SetText(clothes.lang[lvr].cl9)
			validate:SetTextColor( clothes.theme[pdr].txt )

			function validate:Paint(w, h)
				draw.RoundedBox(3, 0, 0, w, h, clothes.theme[pdr].validate)
			end

			validate.DoClick = function()
				local tablesend = {
					name = modelname:GetValue(),
					model = model:GetValue(),
					price = modelprice:GetValue(),
					type = modeltype:GetValue()
				}
				net.Start("Clothes-Server")
				net.WriteInt(-7, 4)
				net.WriteTable(tablesend)
				net.SendToServer()
				firstp:Remove()
			end

				local cancel = vgui.Create("DButton", firstp)
			cancel:SetSize(200, 30)
			cancel:SetPos(50, 244)
			cancel:SetText(clothes.lang[lvr].cl10)
			cancel:SetTextColor( clothes.theme[pdr].txt )

			function cancel:Paint(w, h)
				draw.RoundedBox(3, 0, 0, w, h,clothes.theme[pdr].cancel)
			end

			cancel.DoClick = function()
				firstp:Remove()
			end
		end
end)