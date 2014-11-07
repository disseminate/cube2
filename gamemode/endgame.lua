-- player:Deaths()
-- player:GetNWInt( "Finishes" )
-- player:GetNWInt( "BestTime" )

function GM:OnEndOfGame()
	
	if( GetConVar( "c2_classic" ):GetInt() == 0 ) then
		
		for _, v in pairs( player.GetAll() ) do
			
			v:Freeze( true );
			v:Fade( 1, 3 );
			timer.Simple( 1, function()
				
				v:SetCameraPos( CubeCams["intro"].Pos, CubeCams["intro"].Ang );
				
			end );
			
		end
		
		timer.Simple( 1, function()
			
			umsg.Start( "msgGameOver" );
			umsg.End();
			
		end );
		
	end

end

function EndPVS( ply, view )
	
	AddOriginToPVS( CubeCams["intro"].Pos );
	
end
hook.Add( "SetupPlayerVisibility", "EndPVS", EndPVS );
