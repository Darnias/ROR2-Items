::VisualMaker <- Entities.FindByName(null, "interactables_item_visual_maker");

::visual_keyvalues <- {}

function PreSpawnInstance(classname, targetname){
	local keyvalues = visual_keyvalues
	return keyvalues
}

function PostSpawn(ents){ // Called when point_template spawns something
	foreach(name, handle in ents){
		EntFireByHandle(handle, "Use", "", 0.5, player, player)
	}
}

::player <- null;

::SpawnVisual <- function(_position, _model, _player,){

	visual_keyvalues = {
		model = _model,
		gravity = "0.0005"
	}

	player = _player;

	switch(typeof(_position)){
		case "null"		: 	VisualMaker.SpawnEntity();break
		case "instance"	: 	VisualMaker.SpawnEntityAtEntityOrigin(_position);break
		case "Vector"	: 	VisualMaker.SpawnEntityAtLocation(_position, Vector(null));break
		case "string"	: 	VisualMaker.SpawnEntityAtNamedEntityOrigin(_position);break
	}
}