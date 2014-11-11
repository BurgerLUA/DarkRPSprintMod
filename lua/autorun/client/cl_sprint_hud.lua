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

local function BurgerBulletHUD()
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

		draw.DrawText("STAMINA","SprintFont",XPos,YPos - BarHeight/2,Color(255,255,255,255),TEXT_ALIGN_CENTER)
			
	end

end
hook.Add("HUDPaint", "BB_HUDPAINT", BurgerBulletHUD)


