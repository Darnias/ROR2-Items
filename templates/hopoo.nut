function PreSpawnInstance(classname, targetname){ // Unused, it just has to exist
	local keyvalues = {}
	return keyvalues
}

function PostSpawn(ents){ // Called when point_template spawns something
	foreach(name, handle in ents){
		switch(name){
			case "item_hopoo_gameui":
			{
				local player = HopooPlayers.pop();
				handle.SetOwner(player.handle);
				player.SetHopooUI(handle);
			}break
		}
	}
}