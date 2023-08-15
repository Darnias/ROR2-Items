::SoundMaker <- Entities.FindByName(null, "snd_maker");

::sound_keyvalues <- {}

function PreSpawnInstance(classname, targetname){
	local keyvalues = sound_keyvalues
	return keyvalues
}

function PostSpawn(ents){ // Called when point_template spawns something
	foreach(name, handle in ents){
		EntFireByHandle(handle, "PlaySound", "", delay, null, null);
		EntFireByHandle(handle, "Kill", "", delay+0.01, null, null)
	}
}

::delay <- 0;

::PlaySound <- function(_position, _message, _radius, _delay = 0, _health=10, _SourceEntityName="", _spawnflags=48, _targetname=""){

	sound_keyvalues = {
		targetname = _targetname,
		message = _message,
		radius = _radius,
		health = _health,
		SourceEntityName =  _SourceEntityName,
		spawnflags = _spawnflags,
	}

	delay = _delay

	switch(typeof(_position)){
		case "null"		: 	SoundMaker.SpawnEntity();break
		case "instance"	: 	SoundMaker.SpawnEntityAtEntityOrigin(_position);break
		case "Vector"	: 	SoundMaker.SpawnEntityAtLocation(_position, Vector(null));break
		case "string"	: 	SoundMaker.SpawnEntityAtNamedEntityOrigin(_position);break
	}
}