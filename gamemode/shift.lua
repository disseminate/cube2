NextCubeShift = 0;

function ShiftThink()
	
	if( CurTime() > NextCubeShift ) then
		
		CubeShift();
		NextCubeShift = CurTime() + math.random( 45, 75 );
		
	end
	
end
hook.Add( "Think", "ShiftThink", ShiftThink );

function CubeShift()
	
	local rec = RecipientFilter();
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v:GetPos().z < 0 ) then
			
			v:SetVelocity( Vector( math.random( -300, 300 ), math.random( -300, 300 ), math.random( 150, 300 ) ) );
			rec:AddPlayer( v );
			
		end
		
	end
	
	util.ScreenShake( Vector( 7156, 768, -4672 ), math.random( 100, 1000 ), math.random( 100, 200 ), math.random( 6, 14 ), 6000 );
	
	umsg.Start( "PlayClSound", rec );
		umsg.Short( 2 );
	umsg.End();
	
	for _, v in pairs( CUBESHIFT ) do
		
		for _, n in pairs( v ) do
			
			local targ = table.Random( v );
			ShiftSpecificCubes( n, targ );
			
		end
		
	end
	
end

function ShiftSpecificCubes( ent1, ent2 )
	
	local ents = ents.FindInBox( ent1.Min, ent1.Max ); -- todo - find width of one cube; hardcode this to reduce lag
	
	for _, v in pairs( ents ) do
		
		if( v:IsPlayer() or v:GetClass() == "cube_boot" ) then
			
			local off = ( ent1.Pos - v:GetPos() ) * ( 2 / 3 );
			v:SetPos( ent2.Pos - off );
			
			local ang = v:GetAngles();
			
			if( v:IsPlayer() ) then
				
				v:SetEyeAngles( Angle( ang.p, ang.y + ( 90 * math.random( 0, 3 ) ), ang.r ) );
				
			else
				
				v:SetAngles( Angle( ang.p, ang.y + ( 90 * math.random( 0, 3 ) ), ang.r ) );
				
			end
			
		end
		
	end
	
end
