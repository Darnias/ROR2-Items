function PreSpawnInstance(classname, targetname){ // Unused, it just has to exist
	local keyvalues = {}
	return keyvalues
}

function PostSpawn(ents){ // Called when point_template spawns something
	foreach(name, handle in ents){
		switch(name){
			case "item_crystal_trigger":
			{
				local player = CrystalPlayers.pop();
				handle.SetOwner(player.handle);
				handle.SetOrigin(player.handle.GetOrigin());
				EntFireByHandle(handle, "SetParent", "!activator", 0.05, player.handle, player.handle);
				player.SetCrystal(handle);
			}break
		}
	}
}