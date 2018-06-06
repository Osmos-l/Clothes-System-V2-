--[[
Addon by Osmos[FR] : https://steamcommunity.com/id/ThePsyca/
]]--

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel (clothes.WardrobeModel )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
end 

function ENT:AcceptInput(name, caller)
	if name == "Use" and caller:IsPlayer() then
		local sendtable = sql.Query("SELECT * FROM clothees_data ")

		if sendtable then
			net.Start("Clothes-Client")
			net.WriteInt(-5, 4)
			net.WriteEntity(self)
			net.WriteTable(sendtable)
			net.Send(caller)
		else
		local uselesstable = {}
			net.Start("Clothes-Client")
			net.WriteInt(-5, 4)
			net.WriteEntity(self)
			net.WriteTable(uselesstable)
			net.Send(caller)
		end
	end
end 

--[[
Addon by Osmos[FR] : https://steamcommunity.com/id/ThePsyca/
]]--