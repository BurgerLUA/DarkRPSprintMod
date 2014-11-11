function SVSprintThink()

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
		
		if ply:GetActiveWeapon():GetClass() == "arrest_stick" then
			RunSpeed = GAMEMODE.Config.runspeedcp or 300
		else
			RunSpeed = GAMEMODE.Config.runspeed or 300
		end

		if ply:KeyDown(IN_SPEED) and ply:GetVelocity():Length() > 0 then
			if ply.Energy >= 0.2 then 
				if ply.NextTick < CurTime() then 
					ply.NextTick = CurTime() + 0.1
					ply.Energy = ply.Energy - 0.025
					ply:SetRunSpeed(RunSpeed)
				end
			else
				ply:SetRunSpeed(WalkSpeed)
			end
		else
			if ply.Energy < ply.Stamina then
				if ply.NextTick < CurTime() then 
					ply.NextTick = CurTime() + 0.1
					
					if ply:GetVelocity():Length() > 0 then
						ply.Energy = ply.Energy + ply.Stamina*0.005
					else
						ply.Energy = ply.Energy + ply.Stamina*0.01
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