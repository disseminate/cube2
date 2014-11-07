--Quick function added due to request on the forums
function GM:PlayerCanHearPlayersVoice( rec, src )
	
	if( rec:GetPos():Distance( src:GetPos() ) < 400 ) then
		
		return true;
		
	end
	
	return false;
	
end
