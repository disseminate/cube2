local meta = FindMetaTable( "Player" );

function meta:Win( tp )
	
	if( GetConVar( "c2_classic" ):GetInt() == 0 ) then
		
		local t = CurTime() - self.StartTime;
		
		if( self:GetNWInt( "BestTime" ) > t ) then
			
			self:SetNWInt( "BestTime", t );
			self:PrintMessage( 3, "New best time! " .. string.ToMinutesSecondsMilliseconds( t ) .. "!" );
			
		end
		
	end
	
	umsg.Start( "PlayClSound", self );
		umsg.Short( 1 );
	umsg.End();
	
	self:Fade( 1, 1 );
	timer.Simple( 1, function()
		
		if( GetConVar( "c2_classic" ):GetInt() == 0 or !tp ) then
			
			self:Spawn();
			
		else
			
			local enttab = ents.FindByName( tp );
			local target = enttab[1];
			
			self:SetPos( target:GetPos() );
			
		end
		
	end );
	
end
