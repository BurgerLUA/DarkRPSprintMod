AddCSLuaFile()

function SVSprintThink()

	if CLIENT then return end

	local PlayerTable = player.GetAll()

	for i=1, table.Count(player.GetAll()) do
		local ply = PlayerTable[i]
		local plyteam = ply:Team()

		ply.Stamina = 10
		
		if not ply.NextTick then
			ply.NextTick = 0
		end
		
		if not ply.Energy then
			ply.Energy = ply.Stamina
		end
		
		local RunSpeed
		local WalkSpeed = GAMEMODE.Config.walkspeed or 200
		
		if ply:GetActiveWeapon():IsValid() then
		
			if ply:GetActiveWeapon():GetClass() == "arrest_stick" then
				RunSpeed = GAMEMODE.Config.runspeedcp or 300
			else
				RunSpeed = GAMEMODE.Config.runspeed or 300
			end
			
		else
			RunSpeed = WalkSpeed
		end
		
		local accur = 0.025

		if ply:KeyDown(IN_SPEED) and ply:GetVelocity():Length() > 0 then
			if ply.Energy >= accur then 
				if ply.NextTick < CurTime() then 
					ply.NextTick = CurTime() + accur
					ply.Energy = ply.Energy - accur
					ply:SetRunSpeed(RunSpeed)
				end
			else
				ply:SetRunSpeed(WalkSpeed)
			end
		else
			if ply.Energy < ply.Stamina then
				if ply.NextTick < CurTime() then 
					ply.NextTick = CurTime() + 0.025
					
					if ply:GetVelocity():Length() > 0 then
						ply.Energy = ply.Energy + (accur * 0.5)
					else
						ply.Energy = ply.Energy + (accur * 0.5)
					end

				end
			else
				ply.Energy = ply.Stamina
			end
		end
		
		ply:SetNWFloat("Energy",ply.Energy)
		ply:SetNWInt("MaxEnergy",ply.Stamina)

	end
end

hook.Add("Think", "Serverside Sprint Think", SVSprintThink)

if CLIENT then
	squaremat = Material("vgui/hsv-brightness")
	
	surface.CreateFont( "SprintFont", {
	font = "roboto condensed", 
	size = 24, 
	weight = 0, 
	blursize = 0, 
	scanlines = 0, 
	antialias = true, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = true, 
	additive = false, 
	outline = false, 
	} )

end

function BurgerBulletHUD()
	if SERVER then return end
	
	local ply = LocalPlayer()
	
	if ScrW() == 640 then Scale = 0.5
	elseif ScrW() == 800 then Scale = 0.75
	elseif ScrW() == 1024 then Scale = 1
	elseif ScrW() == 1280 then Scale = 1
	else Scale = 1 end

	Basefade = 255

	BarWidth=25*Scale
	BarHeight=25*Scale
	
	local energy = ply:GetNWFloat("Energy",0)
	local maxenergy = ply:GetNWInt("MaxEnergy",0)

	if energy > 0 then
		
		local OPercent = 5/maxenergy
		local Percent = energy/maxenergy
		local SizeScale = 1
		
		
		local XPos = ScrW()/2
		local YPos = ScrH() - BarHeight*2
		local XSize = BarWidth*10
		local YSize = BarHeight
	
		local Mod = maxenergy
			
		surface.SetMaterial( squaremat )
		surface.SetDrawColor(0,0,0,Basefade/2)
		surface.DrawTexturedRectRotated(XPos,YPos,XSize,YSize,0)
			
		surface.SetMaterial( squaremat )
		surface.SetDrawColor(Mod,255 - (Mod),0,Basefade)
		surface.DrawTexturedRectRotated(XPos,YPos,XSize*0.9*Percent,YSize*0.5,0)

		draw.DrawText("STAMINA","SprintFont",XPos,YPos - BarHeight/2,Color(255,255,255,255*Percent),TEXT_ALIGN_CENTER)
			
	end

end

hook.Add("HUDPaint", "BB_HUDPAINT", BurgerBulletHUD)
