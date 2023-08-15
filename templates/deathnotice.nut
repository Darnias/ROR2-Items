//::hurt_template <- Entities.FindByName(null, "item_deathnotice_template");
::hurt_maker <- Entities.FindByName(null, "item_deathnotice_maker");

::hurt_keyvalues <- {}

function PreSpawnInstance(classname, targetname){
	local keyvalues = hurt_keyvalues
	return keyvalues
}

function PostSpawn(ents){ // Called when point_template spawns something
	foreach(name, handle in ents){
		EntFireByHandle(handle, "Hurt", "", 0, killer, null);
		handle.Destroy();
	}
}

::killer <- null;

::ItemKillDeathnotice <- function(_victim, _killer, _damage, _weapon){
	//printl("Spawning hurt thats gonna hurt for: "+_damage+" and victim is: "+_victim+" and attacker is: "+_killer)
	hurt_keyvalues = {
		targetname = _weapon,
		classname = _weapon
		damage = _damage,
		damageTarget = _victim,
	}

	killer = _killer

	hurt_maker.SpawnEntity()
	//EntFireByHandle(hurt_template, "Forcespawn", "", 0, null, null);
}