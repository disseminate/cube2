local meta = FindMetaTable( "Player" );

function meta:Fade( t, o )
	
	umsg.Start( "Fade", self );
		umsg.Short( t );
		umsg.Short( o );
	umsg.End();
	
end