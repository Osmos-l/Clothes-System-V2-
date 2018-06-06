--[[
Addon by Osmos[FR] : https://steamcommunity.com/id/ThePsyca/
]]--

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( clothes.NPCModel )
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetBloodColor(BLOOD_COLOR_RED)
end 

function ENT:AcceptInput(name, caller)
	if name == "Use" and  caller:IsPlayer() then
		local sendtable = sql.Query("SELECT * FROM clothees_data ")

		if sendtable then
			net.Start("Clothes-Client")
			net.WriteInt(-7, 4)
			net.WriteEntity(self)
			net.WriteTable(sendtable)
			net.Send(caller)
		else
		local uselesstable = {}
			net.Start("Clothes-Client")
			net.WriteInt(-7, 4)
			net.WriteEntity(self)
			net.WriteTable(uselesstable)
			net.Send(caller)
		end
	end
end 

--[[
Addon by Osmos[FR] : https://steamcommunity.com/id/ThePsyca/
]]--