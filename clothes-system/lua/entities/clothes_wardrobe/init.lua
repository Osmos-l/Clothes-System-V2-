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
	if name == "Use" && caller:IsPlayer() && !caller.ClothesPanelOpen then
		caller.ClothesPanelOpen = true

		local SendTable = sql.Query("SELECT * FROM clothees_data ")

		net.Start("Clothes-Client")
			net.WriteInt(-5, 4)
			net.WriteEntity(self)
			net.WriteTable( SendTable or {} )
		net.Send(caller)

		timer.Simple(2, function()
			caller.ClothesPanelOpen = nil
		end )
	end
end 

--[[
Addon by Osmos[FR] : https://steamcommunity.com/id/ThePsyca/
]]--