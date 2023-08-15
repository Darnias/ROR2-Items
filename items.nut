::SPEEDMOD <- Entities.FindByClassname(null, "player_speedmod");
::CLIENTCMD <- Entities.FindByName(null, "clientcmd");
::SERVERCMD <- Entities.FindByClassname(null, "point_servercommand");
::SCRIPT <- Entities.FindByName(null, "@main_script");
::TEXT_ITEMS <- Entities.FindByName(null, "items_text");
::TEXT_GOLD <- Entities.FindByName(null, "gold_text");
::AEGIS_EQUIP <- Entities.FindByName(null, "item_aegis_equip");
::HURT_CROWBAR <- Entities.FindByName(null, "weapon_crowbar");

// Return effect value of an item
::GetItemEffect <- function(input_item, input_count){ // Input is (X, Y) where X is item array
	if (input_count == 1){
		return items[input_item].effect_base // returns effect_base
	}
	else{
		// returns effect_base + (effect_add * count)
		return items[input_item].effect_base + ((items[input_item].effect_add * input_count)-items[input_item].effect_add)
	}
}

// Return duration value of an item
::GetItemDuration <- function(input_item, input_count){ // Input is (X, Y) where X is item array
	if (input_count == 1){
		return items[input_item].duration_base // returns duration_base
	}
	else{
		// returns duration_base + (duration_add * count)
		return items[input_item].duration_base + ((items[input_item].duration_add * input_count)-items[input_item].duration_add)
	}
}

// Return proc chance of an item
::GetItemProc <- function(input_item, input_count){ // Input is (X, Y) where X is item array
	if (input_count == 1){
		return items[input_item].proc_base // returns proc_base
	}
	else{
		// returns proc_base + (proc_add * count)
		return items[input_item].proc_base + ((items[input_item].proc_add * input_count)-items[input_item].proc_add)
	}
}

// Return cooldown of an item
::GetItemCooldown <- function(input_item, input_count){ // Input is (X, Y) where X is item array
	if (input_count == 1){
		return items[input_item].cooldown // returns cooldown
	}
	else{
		// returns cooldown - (cooldown_sub * count)
		return items[input_item].cooldown - ((items[input_item].cooldown_sub * input_count)-items[input_item].cooldown_sub)
	}
}

// Return max count of an item
::GetItemMax <- function(input_item){ // Input is (X, Y) where X is item array
	return items[ItemStringToIndex(input_item)].max
}

::ProcRNG <- function(proc_chance, clover = 0){ // Returns a true or false if % rng succeeded or not
	local rng = RandomFloat(1, 100);
	rng = format("%.1f", rng).tofloat();
//	printl("clover multi: "+clover);
//	printl("proc chance before clover: "+proc_chance);
	proc_chance = proc_chance * clover;
//	printl("proc chance after clover: "+proc_chance);
	DebugPrint("Ramdom number was: "+rng+" and proc chance was: "+proc_chance);
	if (rng <= proc_chance) return true
	return false
}

::DisplayItemsArray <- [];

::DisplayItems <- function(userid){
	if (!(userid in RORPlayers)) return
	DisplayItemsArray.push(userid);
}

::DisplayThink <- function(){ // This had to be done :(
	if (DisplayItemsArray.len() == 0) return FrameTime();

	local userid = DisplayItemsArray.pop();
	local player = VS.GetPlayerByUserid(userid);
	local message = "[Items]\n";
	local inventory = RORPlayers[userid].GetInventory();
	foreach(item, count in inventory){
		if (count > 0){
			message += (item+": "+count+"\n");
		}
	}
	TEXT_ITEMS.__KeyValueFromString("message", message);
	EntFireByHandle(TEXT_ITEMS, "Display", "", 0, player, player);

	return FrameTime();
}

::DisplayBonemerge <- function(userid){
	if (!(userid in RORPlayers)) return
	local player = VS.GetPlayerByUserid(userid);
	local rorplayer = RORPlayers[userid];
	local body = 0;
	local model = rorplayer.GetBonemerge();
	if (model == null) return
	local inventory = RORPlayers[userid].GetInventory();
	foreach(item, count in inventory){
		if (count > 0){
			if (items[ItemStringToIndex(item)].team == 2) continue // Skip T items
			body += items[ItemStringToIndex(item)].bodygroup_ct
		}
	}
	if (model == null) return
	model.__KeyValueFromInt("body", body);
}

::DisplayGold <- function(userid){
	if (!(userid in RORPlayers)) return
	local rorplayer = RORPlayers[userid];
	local player = VS.GetPlayerByUserid(userid);
	local message = "Gold: "+rorplayer.GetGold();

	TEXT_GOLD.__KeyValueFromString("message", message);
	EntFireByHandle(TEXT_GOLD, "Display", "", 0.1, player, player);
}

// Hopoo Feather
//::HopooTemplate <- Entities.FindByName(null, "item_hopoo_template"); // Template that has hopoo game_ui
::HopooMaker <- Entities.FindByName(null, "item_hopoo_maker"); // Hopoo maker
::HopooPlayers <- []; // Array of players that spawned hopoo game_ui (used for storing handle from jump event)


// Focus Crystal
//::CrystalTemplate <- Entities.FindByName(null, "item_crystal_template"); // Template that has crystal trigger
::CrystalMaker <- Entities.FindByName(null, "item_crystal_maker"); // crystal maker
::CrystalPlayers <- []; // Array of players that need crystal trigger

::CleanHopooUI <- function(){
	local ui = null;
	while (ui=Entities.FindByClassname(ui, "game_ui")){
	if (ui.GetName().find("hopoo") != null && ui.GetOwner() == null){
		ui.Destroy();
		}
	}
}