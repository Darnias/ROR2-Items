IncludeScript("darnias/ror2/vs_library.nut");
//IncludeScript("darnias/ror2/items.nut");
IncludeScript("darnias/ror2/items_table.nut");
IncludeScript("darnias/ror2/items/magazine.nut");

::HUMAN_MODEL <- "models/player/custom_player/darnias/ror2/commando/ctm_fbi_varianth_commando.mdl";
::HUMAN_MODEL_ITEMS <- "models/player/custom_player/darnias/ror2/commando/commando_items.mdl";
::ZOMBIE_MODEL <- "models/player/custom_player/darnias/ror2/imp/ctm_fbi_varianth_imp.mdl";
::MAPPER_STEAMID <- ["STEAM_1:1:17483079", "STEAM_1:1:124231807"];

::DEBUG <- true;

::DebugPrint<-function(text){
	if (GetDeveloperLevel() <1 )return
	printl(">["+Time()+"]: "+text);
}

function OnPostSpawn(){
	if (!("RORPlayers" in getroottable())){ //Create locals only once
		::RORPlayers <- {};
	}
}

try { // the fuck
	IncludeScript("ze_ror2_server_settings.nut");
} catch (e){
	::CUSTOM_SETTINGS <- false;
	printl("@[VSCRIPT:WARNING] SERVER HAS NOT ADDED server_settings.nut TO THEIR SERVER - NOT USING CUSTOM SETTINGS FOR THIS SESSION!!!");
	printl("@[VSCRIPT:WARNING] SERVER HAS NOT ADDED server_settings.nut TO THEIR SERVER - NOT USING CUSTOM SETTINGS FOR THIS SESSION!!!");
	printl("@[VSCRIPT:WARNING] SERVER HAS NOT ADDED server_settings.nut TO THEIR SERVER - NOT USING CUSTOM SETTINGS FOR THIS SESSION!!!");
}

::RORPlayer <- class{
	// Player entity info
	name = null;
	targetname = null;
	networkid = null;
	userid = 0;
	entindex = 0;
	handle = null;
	// ROR2 gameplay info
	inventory = {};
	gold = 0;
	jumps = 0;
	runboost = 1.0;
	runslow = 1.0;
	runspeed = 1.0;
	gravity = 1.0;
	hopooui = null;
	ignited = false;
	slowed = false;
	seed = 0;
	steps = 0;
	aegis = true;
	medkit = true;
	microbots = true;
	bonemerge = null;
	blood = 0;
	chance = 0;
	chance_items = 0;
	stealthkit = true;
	crystal = null;
	constructor(_name, _targetname,_networkid, _userid, _entindex, _handle,_inventory, _gold, _jumps, _runboost, _runslow, _runspeed, _gravity, _hopooui, _ignited, _slowed, _seed, _steps, _aegis, _medkit, _microbots, _bonemerge, _blood, _chance, _chance_items, _stealthkit, _crystal){
		name = _name;
		targetname = _targetname;
		networkid = _networkid;
		userid = _userid;
		entindex = _entindex;
		handle = _handle;
		inventory = _inventory;
		gold = _gold;
		jumps = _jumps;
		runboost = _runboost;
		runslow = _runslow;
		runspeed = _runspeed;
		gravity = _gravity;
		hopooui = _hopooui;
		ignited = _ignited;
		slowed = _slowed;
		seed = _seed;
		steps = _steps;
		aegis = _aegis;
		medkit = _medkit;
		microbots = _microbots;
		bonemerge = _bonemerge;
		blood = _blood;
		chance = _chance;
		chance_items = _chance_items;
		stealthkit = _stealthkit;
		crystal = _crystal;
	}
	function DumpValues(){ // Dumps players class values
		printl("")
		printl("> name: " + this.name);
		printl("> targetname: " + this.targetname);
		printl("> networkid: " + this.networkid);
		printl("> userid: " + this.userid);
		printl("> entindex: " + this.entindex);
		printl("> handle: " + this.handle);
		printl("> inventory: " + this.inventory);
		printl("> gold: " + this.gold);
		printl("> jumps: " + this.jumps);
		printl("> runboost: " + this.runboost);
		printl("> runslow: " + this.runslow);
		printl("> runspeed: " + this.runspeed);
		printl("> gravity: " + this.gravity);
		printl("> hopooUI: " + this.hopooui);
		printl("> ignited: " + this.ignited);
		printl("> slowed: " + this.slowed);
		printl("> seed: " + this.seed);
		printl("> steps: " + this.steps);
		printl("> aegis: " + this.aegis);
		printl("> medkit: " + this.medkit);
		printl("> microbots: " + this.microbots);
		printl("> bonemerge: " + this.bonemerge);
		printl("> Shrine Blood: " + this.blood);
		printl("> Shrine Chance: " + this.chance);
		printl("> Chance items: " + this.chance_items);
		printl("> stealthkit: " + this.stealthkit);
		printl("> focus crystal: " + this.crystal);
	}
	function GetPlayerTeam(){
		return this.handle.GetTeam();
	}
	function GetInventory(){ // Returns table with all players items
		return this.inventory
	}
	function SetInventory(input_inventory){
		return this.inventory = input_inventory;
	}
	function GetItemCount(input_item){ // Returns individual item
		foreach(item, count in this.inventory){
			if (item == input_item) return count
		}
	}
	function SetItemCount(input_item, input_count){ // Sets item count in players inventory
		foreach(item, count in this.inventory){
			if(item == input_item){
				return this.inventory[item] = input_count;
			}
		}
	}
	function GetGold(){ // Returns players gold
		return this.gold;
	}
	function SetGold(input_gold){ // Sets players gold
		return this.gold = input_gold
	}
	function GetJumps(){ // Returns players jumps (used for Hopoo Feather)
		return this.jumps
	}
	function SetJumps(input_jumps){ // Sets players jumps (used for Hopoo Feather)
		return this.jumps = input_jumps
	}
	function GetRunBoost(){ // Returns players bonus speed (default 1)
		return this.runboost
	}
	function SetRunBoost(input_runboost){ // Sets players bonus speed
		return this.runboost = input_runboost
	}
	function GetRunSlow(){ // Returns players bonus slow (default 1)
		return this.runslow
	}
	function SetRunSlow(input_runslow){ // Sets players bonus slow
		return this.runslow = input_runslow
	}
	function GetRunSpeed(){ // Returns players total move speed (default 1/1 = 1)
		return this.runspeed
	}
	function SetRunSpeed(input_runspeed){ // Sets players runspeed
		return this.runspeed = input_runspeed
	}
	function CalculateRunSpeed(){ // Calculate RunSpeed (runboost / runslow)
		return runboost / runslow
	}
	function GetGravity(){ // Returns players gravity (default 1)
		return this.gravity
	}
	function SetGravity(input_gravity){ // Sets players gravity
		return this.gravity = input_gravity
	}
	function GetHP(){ // Get players HP
		return this.handle.GetHealth()
	}
	function SetHP(input_health){ // Set players HP
		return this.handle.SetHealth(input_health)
	}
	function GetMaxHP(){ // Get players max HP
		return this.handle.GetMaxHealth()
	}
	function SetMaxHP(input_health){ // Set players max HP
		return this.handle.SetMaxHealth(input_health)
	}
	function GetHopooUI(){ // Get players hopoo UI
		return this.hopooui
	}
	function SetHopooUI(input_ui){ // Set players hopoo UI
		return this.hopooui = input_ui
	}
	function GetIgnited(){ // Get players ignited
		return this.ignited
	}
	function SetIgnited(input_ignited){ // Set players ignited
		return this.ignited = input_ignited
	}
	function GetSlowed(){ // Get players slowed
		return this.slowed
	}
	function SetSlowed(input_slowed){ // Set players slowed
		return this.slowed = input_slowed
	}
	function GetSeed(){ // Get players seed damage value
		return this.seed
	}
	function SetSeed(input_seed){ // Set players seed damage value
		return this.seed = input_seed
	}
	function GetSteps(){ // Get players steps
		return this.steps
	}
	function SetSteps(input_steps){ // Set players steps
		return this.steps = input_steps
	}
	function GetAegis(){ // Get players aegis
		return this.aegis
	}
	function SetAegis(input_aegis){ // Set players aegis
		return this.aegis = input_aegis
	}
	function GetMedkit(){ // Get players medkit
		return this.medkit
	}
	function SetMedkit(input_medkit){ // Set players medkit
		return this.medkit = input_medkit
	}
	function GetMicrobots(){ // Get microbots
		return this.microbots
	}
	function SetMicrobots(input_microbots){ // Set players microbots
		return this.microbots = input_microbots
	}
	function ToggleNoclip(){
		if (this.handle.IsNoclipping()){
			return EntFireByHandle(this.handle, "AddOutput", "movetype 2", 0, null, null);
		}
		else{
			return EntFireByHandle(this.handle, "AddOutput", "movetype 8", 0, null, null);
		}
	}
	function GetBonemerge(){ // Get players bonemerge model
		return this.bonemerge
	}
	function SetBonemerge(input_bonemerge){ // Set players bonemerge model
		return this.bonemerge = input_bonemerge
	}
	function GetBlood(){ // Get players Blood shrine usage count
		return this.blood
	}
	function SetBlood(input_blood){ // Set players Blood shrine usage count
		return this.blood = input_blood
	}
	function GetChance(){ // Get players Chance shrine cost
		return this.chance
	}
	function SetChance(input_chance){ // Set players Chance shrine cost
		return this.chance = input_chance
	}
	function GetChanceItems(){ // Get players Chance shrine item count
		return this.chance_items
	}
	function SetChanceItems(input_chance_items){ // Set players Chance shrine item count
		return this.chance_items = input_chance_items
	}
	function GetStealthkit(){ // Get players stealthkit cooldown
		return this.stealthkit
	}
	function SetStealthkit(input_stealthkit){ // Set players stealthkit cooldown
		return this.stealthkit = input_stealthkit
	}
	function GetCrystal(){ // Get players crystal entity
		return this.crystal
	}
	function SetCrystal(input_crystal){ // Set players crystal entity
		return this.crystal = input_crystal
	}
}

function DumpPlayers(){ // Dump class values for ALL players
	foreach (player in RORPlayers){
		player.DumpValues()
	}
}

function DumpPlayer(userid){ // Dump class values for SPECIFIC player
	RORPlayers[userid].DumpValues()
}

function DumpPlayerInventory(userid){ // Dump SPECIFIC player inventory
	local inventory = RORPlayers[userid].GetInventory();

	foreach(item, count in inventory) printl(item +" = "+ count);
}

::SetPlayerItemCount <- function(userid, input_item, input_count){ // Change players item count value

	if (input_count < 0){ // Prevent negative amount
		input_count = 0
	}

	if (GetItemMax(input_item) > 0){
		local Input_Count_Clamp = clamp(input_count, 0, GetItemMax(input_item));
		RORPlayers[userid].SetItemCount(input_item, Input_Count_Clamp);
	}
	else{
		RORPlayers[userid].SetItemCount(input_item, input_count);
	}

	UpdatePlayer(userid);
}

::GivePlayerItem <- function(userid, input_item, input_count){ // Add items to player
	local PlayerItemCount = RORPlayers[userid].GetItemCount(input_item);
	local player = VS.GetPlayerByUserid(userid);

	if (PlayerItemCount == null) return // Don't try to set invalid item
	if (GetItemMax(input_item) > 0){
		local Input_Count_Clamp = clamp(input_count, 0, GetItemMax(input_item)-PlayerItemCount);
		RORPlayers[userid].SetItemCount(input_item, PlayerItemCount + Input_Count_Clamp);
	}
	else{
		RORPlayers[userid].SetItemCount(input_item, PlayerItemCount + input_count);
	}

	ShowItemHudHint(input_item, player, true);

	UpdatePlayer(userid);
}

::AddPlayerGold <- function(userid, amount){ // Add gold to player
	local rorplayer = RORPlayers[userid];
	local player_gold = rorplayer.GetGold();

	rorplayer.SetGold(player_gold + amount);

	UpdatePlayer(userid);
}

::RemovePlayerGold <- function(userid, amount){ // Remove gold from player
	local rorplayer = RORPlayers[userid];
	local player_gold = rorplayer.GetGold();

	rorplayer.SetGold(player_gold - amount);

	UpdatePlayer(userid);
}

::RemoveTeamItems <- function(userid){	// Remove team only items from player
	if (!(userid in RORPlayers)) return
	local inventory = RORPlayers[userid].GetInventory();
	local userid_team = RORPlayers[userid].GetPlayerTeam();
	foreach(item, count in inventory){
		if (count > 0){
			local index = ItemStringToIndex(item);
			if (items[index].team != userid_team && items[index].team != 0){
				SetPlayerItemCount(userid, item, 0);
				DebugPrint("[LOGIC] Removed "+item+" from player("+userid+") because it wasn't for his team");
			}
		}
	}
}

::UpdatePlayer <- function(userid){ // Main update function for players
	local player = VS.GetPlayerByUserid(userid);
	RemoveTeamItems(userid);
	DisplayItems(userid);
	DisplayGold(userid);
	DisplayBonemerge(userid);
}

//-----------------------------------------------------------------------------
// Looping think function for items
//-----------------------------------------------------------------------------
function rorThink(){
	if (ScriptIsWarmupPeriod()){
		ScriptPrintMessageChatAll("Warmup - map functions halted")
		return 15
	}
	foreach(player in RORPlayers){
		if (player.handle.IsValid() == false) return
		if (player.GetPlayerTeam() == 1 || player.GetPlayerTeam() == 0) return

		// Check if player has bonemerge model
		if (player.handle.GetHealth() > 0 && player.handle.GetHealth() < 1000 && player.GetBonemerge() == null || player.handle.GetHealth() > 0 && player.handle.GetHealth() < 1000 && player.GetBonemerge().IsValid() == false){
			local bonemerge_model = CreateProp("prop_dynamic", Vector(null), HUMAN_MODEL_ITEMS, 0);
			player.SetBonemerge(bonemerge_model);
			bonemerge_model.__KeyValueFromInt("solid", 0);
			bonemerge_model.__KeyValueFromInt("DisableBoneFollowers", 1);
			EntFireByHandle(bonemerge_model, "SetParent", "!activator", 0, player.handle, player.handle);
//			EntFireByHandle(bonemerge_model, "SetParentAttachment", "facemask", FrameTime(), null, null);
			bonemerge_model.SetOwner(player.handle);
			bonemerge_model.__KeyValueFromInt("effects", 1);
		}
		// Hopoo Feather (Deactivate and reset jumps)
		if (player.GetItemCount(ITEMS.hopoo) > 0){ // Spawn and assign Hopoo game_ui to players
			if (player.GetHopooUI() == null || player.GetHopooUI().IsValid() == false){
				HopooPlayers.append(player); // Add player to array so PostSpawn knows who to add it to
				HopooMaker.SpawnEntity();
			}
			if (player.GetHopooUI() != null && player.GetHopooUI().IsValid() != false){ // Do stuff if player has UI
				local trace_start = player.handle.GetOrigin();
				local trace_end = trace_start - Vector(0,0,512);
				if (TraceLinePlayersIncluded(trace_start, trace_end, player.handle) < 0.033){ // Player is/was standing on floor, reset jumps
					local player_ui = player.GetHopooUI();
					player_ui.ValidateScriptScope();
					local player_ui_scope = player_ui.GetScriptScope();
					if (player_ui_scope.ALLOW == true){ // Deactivate UI if player is on floor
						player_ui_scope.ALLOW <- false;
						if (player_ui_scope.INIT == true && player.GetJumps() != 0){
							EntFireByHandle(player.GetHopooUI(), "Deactivate", "", 0.0, player.handle, player.handle);
						}
						if (player_ui_scope.INIT == false){ // First setup
							player_ui_scope.INIT <- true;
						}
						player.SetJumps(player.GetItemCount(ITEMS.hopoo)); // Set player jumps to their item count
					}
				}
			}
		}
		// Focus Crystal trigger assignment
		if (player.GetItemCount(ITEMS.crystal) > 0 && player.GetPlayerTeam() == 2){ // Player has crystal item
			if (player.GetCrystal() == null || player.GetCrystal().IsValid() == false){
				CrystalPlayers.append(player); // Add player to array so PostSpawn knows who to add it to
				CrystalMaker.SpawnEntity();
			}
		}
		// Bison Steak health update
		if (player.GetItemCount(ITEMS.steak) > 0){
			if (player.GetMaxHP() != ( 100+GetItemEffect(0, player.GetItemCount(ITEMS.steak)))){
				local hp = player.GetHP();
				local hpmax = player.GetMaxHP();
				local bonus_hp = 100+GetItemEffect(0, player.GetItemCount(ITEMS.steak));
				local add = (bonus_hp - hpmax);
				player.SetMaxHP(bonus_hp);
				player.SetHP(hp + add);
			}
		}
		// Paul's Goat Hoof speed stuff
		if (player.GetItemCount(ITEMS.hoof) > 0){
			if (player.GetRunBoost() != 1+GetItemEffect(3, player.GetItemCount(ITEMS.hoof))){ // Set players 'runboost' variable to hoof speed multiplier
				player.SetRunBoost((1+GetItemEffect(3, player.GetItemCount(ITEMS.hoof))));
				DebugPrint("[ITEM] Set players 'runboost' to: "+(1+GetItemEffect(3, player.GetItemCount(ITEMS.hoof))));
			}
		}
		/* Paul's Goat Hoof speed stuff (Reset speed to 1 if player has 0 hoofs)
		else if(player.GetItemCount(ITEMS.hoof) == 0){
			if (player.GetRunBoost() != 1.0){
				player.SetRunBoost(1.0);
				DebugPrint("[LOGIC] Set players 'runboost' to: 1");
				player.SetRunSpeed(player.CalculateRunSpeed());
				DebugPrint("[LOGIC] Set players "+player.handle+" 'runspeed' to: "+ player.CalculateRunSpeed());
			}
		}*/
		// Calculate real run speed after boost/slow math
		if (player.CalculateRunSpeed() != player.GetRunSpeed()){
			player.SetRunSpeed(player.CalculateRunSpeed());
			DebugPrint("[LOGIC] Set players "+player.handle+" 'runspeed' to: "+ player.CalculateRunSpeed());
			EntFireByHandle(SPEEDMOD, "modifyspeed", player.GetRunSpeed(), 0, player.handle, null);
		}
		// Restock players armor if they own Aegis
		if (player.GetItemCount(ITEMS.aegis) > 0 && player.GetAegis()){
			local cooldown = GetItemCooldown(13, player.GetItemCount(ITEMS.aegis));
			DebugPrint("[ITEM] Aegis restocked players Armor");
			player.SetAegis(false); // Set Aegis on cooldown
			EntFireByHandle(AEGIS_EQUIP, "Use", "", 0, player.handle, player.handle);
			EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+player.userid+"].SetAegis("+true+")", cooldown, null, null); // Reset cooldown
		}
	}
	return 0.05 // Make function tick 20x a second (probably good performance interval)
}

//-----------------------------------------------------------------------------
// Player disconnect event
//-----------------------------------------------------------------------------
VS.ListenToGameEvent( "player_disconnect", function( event ){
	CleanHopooUI();
	if (!(event.userid in RORPlayers)) return
	DebugPrint("[LOGIC] DISCONNECT! deleting "+RORPlayers[event.userid]);
	delete RORPlayers[event.userid];
	CleanHopooUI();
}, "event_player_disconnect" );

//-----------------------------------------------------------------------------
// Player team change event
//-----------------------------------------------------------------------------
VS.ListenToGameEvent( "player_team", function( event ){
	if (event.disconnect) return
	UpdatePlayer(event.userid);
}, "event_player_team" );

//-----------------------------------------------------------------------------
// Player spawn event
//-----------------------------------------------------------------------------
VS.ListenToGameEvent( "player_spawn", function( event ){

	local inventory =
	{
		steak = 		0,
		hopoo = 		0,
		wax = 			0,
		hoof = 			0,
		gasoline =		0,
		potion = 		0,
		glasses = 		0,
		gastank = 		0,
		tentabauble = 	0,
		chronobauble = 	0,
		seed =			0,
		crowbar = 		0,
		fungus = 		0,
		aegis = 		0,
		magazine = 		0,
		raincoat = 		0,
		clover = 		0,
		medkit = 		0,
		microbots = 	0,
		stungrenade =	0,
		stealthkit =	0,
		razorwire =		0,
		crystal =		0,
	}

	local player = VS.GetPlayerByUserid(event.userid);
	local player_scope = null;
	local entindex = null;
	local player_userid = null;
	if (player.IsValid()){
		player.ValidateScriptScope();
		player_scope = player.GetScriptScope();
		entindex = player.entindex();
		player_userid = player_scope.userid;
	}

	// Add players to ROR Players only once
	if((player_userid in RORPlayers) == false){
		RORPlayers[event.userid] <- RORPlayer(
			player_scope.name,		// Name
			"player_"+entindex,		// Targetname
			player_scope.networkid,	// Steam ID
			player_scope.userid,	// User ID
			entindex,				// Entindex
			player,					// Handle
			inventory,				// Inventory table
			0,						// Gold
			1,						// Jumps
			1,						// Run Boost
			1,						// Run Slow
			1,						// Run Speed
			1,						// Gravity
			null,					// Hopoo UI
			false,					// Ignited
			false,					// Slowed
			500,					// Seed damage value
			0,						// steps
			true,					// Aegis cooldown
			true,					// Medkit cooldown
			true,					// Microbots cooldown
			null,					// Bonemerge model
			0,						// Blood shrine use count
			17,						// Chance shrine cost
			0,						// Chance shrine item count
			true,					// Stealthkit cooldown
			null					// Crystal trigger entity
		)
	}

	player.__KeyValueFromString("targetname", RORPlayers[event.userid].targetname);

	try { // holy fuck what
		if (CUSTOM_SETTINGS == true && CUSTOM_PLAYER_MODELS == false){
			// stuff
		}else{
			if (player.GetHealth() < 500){
				player.SetModel(HUMAN_MODEL);
			}
			else {
				player.SetModel(ZOMBIE_MODEL);
			}
		}
	} catch (exception){
		if (player.GetHealth() < 500){
			player.SetModel(HUMAN_MODEL);
		}
		else {
			player.SetModel(ZOMBIE_MODEL);
		}
	}

	EntFireByHandle(SCRIPT, "RunScriptCode", "UpdatePlayer("+event.userid+")", 0.2, null, null);

}, "event_player_spawn" );

//-----------------------------------------------------------------------------
// Round start event
//-----------------------------------------------------------------------------
VS.ListenToGameEvent( "round_start", function( event ){
	ScriptPrintMessageChatAll("Round start");
	SendToConsole("mp_disconnect_kills_players 0"); // Don't kill players on disconnect
	SendToConsoleServer("mp_disconnect_kills_players 0"); // Don't kill players on disconnect

	if (CUSTOM_SETTINGS){
		SendToConsoleServer("sv_falldamage_scale "+FALL_DAMAGE_SCALE); // Reduce fall damage
		SendToConsoleServer("sv_disable_radar "+DISABLE_RADAR); // Hide radar
	}
	else {
		SendToConsoleServer("sv_falldamage_scale 0.20"); // Reduce fall damage
		SendToConsoleServer("sv_disable_radar 1"); // Hide radar
	}


	// Reset player values
	foreach(player in RORPlayers){
		local inventory =
		{
			steak = 		2,
			hopoo = 		500,
			wax = 			3,
			hoof = 			1,
			gasoline =		0,
			potion = 		1,
			glasses = 		2,
			gastank = 		0,
			tentabauble = 	0,
			chronobauble = 	0,
			seed =			0,
			crowbar = 		3,
			fungus = 		0,
			aegis = 		0,
			magazine = 		0,
			raincoat = 		0,
			clover = 		0,
			medkit = 		1,
			microbots = 	0,
			stungrenade =	0,
			stealthkit = 	0,
			razorwire =		0,
			crystal =		0,
		}

		CUSTOM_SETTINGS == true ? player.SetInventory(PLAYER_START_ITEMS) : player.SetInventory(inventory);
		CUSTOM_SETTINGS == true ? player.SetGold(PLAYER_START_GOLD) : player.SetGold(5000);
		player.SetJumps(1);
		player.SetRunBoost(1);
		player.SetRunSlow(1);
		player.SetRunSpeed(1);
		player.SetGravity(1);
		player.SetIgnited(false);
		player.SetSlowed(false);
		player.SetSeed(500);
		player.SetSteps(0);
		player.SetAegis(true);
		player.SetMedkit(true);
		player.SetMicrobots(true);
		player.SetBonemerge(null);
		player.SetBlood(0);
		player.SetChance(17);
		player.SetChanceItems(0);
		player.SetStealthkit(true);
		player.SetCrystal(null);

		EntFireByHandle(CLIENTCMD, "Command", "cam_idealdistup 0", 0, player.handle, player.handle); // Set Shrine of blood frame to 0
		EntFireByHandle(CLIENTCMD, "Command", "cam_idealdistright 1", 0, player.handle, player.handle); // Chance shrine ones digits
		EntFireByHandle(CLIENTCMD, "Command", "cam_idealdist 7", 0, player.handle, player.handle); // Chance shrine tens digits
		EntFireByHandle(CLIENTCMD, "Command", "cam_idealyaw 10", 0, player.handle, player.handle); // Chance shrine hundreds digits
	}

}, "event_round_start" );

//-----------------------------------------------------------------------------
// Player say event
//-----------------------------------------------------------------------------
VS.ListenToGameEvent( "player_say", function( event ){
	if(event.text[0] != '.') return // Only react to text messages that start with '.'

	local text = event.text.tolower(); // Make text lower
	local player = VS.GetPlayerByUserid(event.userid);

	switch(text){ // .say commands
		case ".inventory": // Print players inventory in his console
		{
			local inventory = RORPlayers[event.userid].GetInventory();
			EntFireByHandle(CLIENTCMD, "command", "echo [INVENTORY]", 0, player);
			foreach(item, count in inventory){
				EntFireByHandle(CLIENTCMD, "command", "echo "+item+":"+count, 0, player);
			}
		}break
		case ".userid": // Print UserID from chatting for easier debugging
		{
			ScriptPrintMessageChatAll("^^^ UserID of player: "+event.userid.tostring());
		}break
	}

	// Exit out if person doesn't have mapper steamid
	local player_steamid = RORPlayers[event.userid].networkid;
	local rorplayer = RORPlayers[event.userid];
	if (player_steamid != MAPPER_STEAMID[0] && player_steamid != MAPPER_STEAMID[1]) return

	// Give item
	if (text.find(".give") != null){
		local split = split(text, " ");
		if (split.len() == 4){
			local userid = split[1];
			local item = split[2];
			local count = split[3];

			if (userid == "self"){
				GivePlayerItem(event.userid, item, count.tointeger());
			}
			else if (userid == "all"){
				foreach (player in RORPlayers){
					GivePlayerItem(player.userid, item, count.tointeger());
				}
			}
			else if (userid == "ct"){
				foreach (player in RORPlayers){
					if (player.GetPlayerTeam() == 3){
						GivePlayerItem(player.userid, item, count.tointeger());
					}
				}
			}
			else if (userid == "t"){
				foreach (player in RORPlayers){
					if (player.GetPlayerTeam() == 2){
						GivePlayerItem(player.userid, item, count.tointeger());
					}
				}
			}
			else if (userid.tointeger() in RORPlayers){
				GivePlayerItem(userid.tointeger(), item, count.tointeger());
			}
		}
	}

	// Give gold
	if (text.find(".gold") != null){
		local split = split(text, " ");
		if (split.len() == 3){
			local userid = split[1];
			local count = split[2];

			if (userid == "self"){
				AddPlayerGold(event.userid, count.tointeger());
			}
			else if (userid == "all"){
				foreach (player in RORPlayers){
					AddPlayerGold(player.userid, count.tointeger());
				}
			}
			else if (userid == "ct"){
				foreach (player in RORPlayers){
					if (player.GetPlayerTeam() == 3){
						AddPlayerGold(player.userid, count.tointeger());
					}
				}
			}
			else if (userid == "t"){
				foreach (player in RORPlayers){
					if (player.GetPlayerTeam() == 2){
						AddPlayerGold(player.userid, count.tointeger());
					}
				}
			}
			else{
				AddPlayerGold(userid.tointeger(), count.tointeger());
			}
		}
	}

	if (text.find(".noclip") != null){
		if (CUSTOM_SETTINGS == true && DISABLE_MAPPER_NOCLIP == true){
			return
		}
		rorplayer.ToggleNoclip();
	}



}, "event_player_say" );

//-----------------------------------------------------------------------------
// Player jump event
//-----------------------------------------------------------------------------
VS.ListenToGameEvent( "player_jump", function( event ){
	if (ScriptIsWarmupPeriod()) return
	local player = VS.GetPlayerByUserid(event.userid);
	local rorplayer = RORPlayers[event.userid];

	// Hopoo Feather item check
	if (rorplayer.GetItemCount(ITEMS.hopoo) > 0){ // If player owns at least 1 Hopoo feather do the stuff
		local player_ui = rorplayer.GetHopooUI();
		if (player_ui == null) return
		player_ui.ValidateScriptScope();
		local player_ui_scope = player_ui.GetScriptScope();
		player_ui_scope.ALLOW <- true; // Allow HopooPlayerOff to trigger
		EntFireByHandle(rorplayer.GetHopooUI(), "Activate", "", 0.0, player, player);
	}
	// Wax Quail item check
	if (rorplayer.GetItemCount(ITEMS.wax) > 0){ // If player owns at least 1 Wax Quail do the stuff
		local vel = player.GetVelocity();
		if (vel.LengthSqr() < 450*450){ // Cap bunny hopping
			EntFireByHandle(CLIENTCMD, "command", "play "+items[2].sound1, 0, player);
			local boost_mult = 1 + GetItemEffect(2,rorplayer.GetItemCount(ITEMS.wax));
			//DebugPrint("[ITEM] Wax Quail boost: "+boost_mult);
			local velocity_boosted = Vector(vel.x * boost_mult, vel.y * boost_mult, vel.z);
			player.SetVelocity(velocity_boosted);
		}
	}
}, "event_player_jump" );

//-----------------------------------------------------------------------------
// Player footstep event
//-----------------------------------------------------------------------------
VS.ListenToGameEvent( "player_footstep", function( event ){
	if (ScriptIsWarmupPeriod()) return
	local player = VS.GetPlayerByUserid(event.userid);
	local rorplayer = RORPlayers[event.userid];

	// Weeping Fungus item check
	if (rorplayer.GetItemCount(ITEMS.fungus) > 0){ // If player owns at least 1 Weeping Fungus do the stuff
		local steps = rorplayer.GetSteps();
		local steps_cap = GetItemEffect(12, rorplayer.GetItemCount(ITEMS.fungus));

		rorplayer.SetSteps(steps += 1); // Player did a step, add 1 step to him
		if (steps >= steps_cap){ // Player did enough steps to proc heal, heal and reset steps to 0
			local hp = player.GetHealth().tofloat();
			local hpmax = player.GetMaxHealth().tofloat();
			local hp_p = (hp / hpmax * 100);

			if (hp_p < 100){
				if (hp_p + 5 >= 100){ // Player is missing less than 5% of hp
					player.SetHealth(player.GetMaxHealth()); // Full heal = set to max hp
				}
				else{ // Player is missing more than 5% of hp
					player.SetHealth(player.GetHealth() + (0.05 * player.GetMaxHealth())); // Current health + 5%
				}
				EntFireByHandle(CLIENTCMD, "command", "play "+items[12].sound1, 0, player);
			}

			rorplayer.SetSteps(0);
		}
	}

}, "event_player_footstep" );

//-----------------------------------------------------------------------------
// Weapon reload event
//-----------------------------------------------------------------------------
VS.ListenToGameEvent( "weapon_reload", function( event ){
	local player = VS.GetPlayerByUserid(event.userid);
	local rorplayer = RORPlayers[event.userid];

	if (rorplayer.GetItemCount(ITEMS.magazine) > 0){
		local weapon_name = GetHeldWeaponName(player);
		if (weapon_name == "weapon_nova" || weapon_name == "weapon_xm1014" || weapon_name == "weapon_sawedoff") return // It's buggy for shotguns
		local weapon_handle = GetHeldWeaponHandle(player);
		local ammo_base = weapon_mag_size[weapon_name];
		local ammo_mult = GetItemEffect(14,rorplayer.GetItemCount(ITEMS.magazine));
		local ammo = ceil(ammo_base * ammo_mult);
		if (ammo > 250) ammo = 250; // Cap max number
		local delay = weapon_reload_time[weapon_name] + FrameTime();
		EntFireByHandle(weapon_handle, "SetAmmoAmount", ammo, delay, null, null);
	}

}, "event_weapon_reload" );

//-----------------------------------------------------------------------------
// Player hurt event
//-----------------------------------------------------------------------------
VS.ListenToGameEvent( "player_hurt", function( event ){
	if (event.weapon == "crowbar") return // Don't chain proc crowbar

	local player_victim = VS.GetPlayerByUserid(event.userid);
	local rorplayer_victim = RORPlayers[event.userid];

	local player_attacker = null;
	local rorplayer_attacker = null;
	if (event.attacker != 0){ // Ignore non player damage
		player_attacker = VS.GetPlayerByUserid(event.attacker);
		rorplayer_attacker = RORPlayers[event.attacker];
	}

	// Power elixir stuff
	if (rorplayer_victim.GetItemCount(ITEMS.potion) > 0){
		local victim_hpmax = player_victim.GetMaxHealth().tofloat();
		local victim_hp = player_victim.GetHealth().tofloat();
		if ((victim_hp / victim_hpmax * 100) <= 25){ // Player is at or lower than 25% hp
			player_victim.SetHealth(victim_hp + victim_hpmax * GetItemEffect(5,1)); // Set HP to (Current Health + (Max HP * 0.75) )
			SetPlayerItemCount(event.userid, ITEMS.potion, rorplayer_victim.GetItemCount(ITEMS.potion)-1);
			switch(RandomInt(1, 4)){ // Play random potion sound
				case 1: EntFireByHandle(CLIENTCMD, "command", "play "+items[5].sound1, 0, player_victim);break
				case 2: EntFireByHandle(CLIENTCMD, "command", "play "+items[5].sound2, 0, player_victim);break
				case 3: EntFireByHandle(CLIENTCMD, "command", "play "+items[5].sound3, 0, player_victim);break
				case 4: EntFireByHandle(CLIENTCMD, "command", "play "+items[5].sound4, 0, player_victim);break
			}
			DebugPrint("[ITEM] Set players item 'potion' to: "+rorplayer_victim.GetItemCount(ITEMS.potion));
		}
	}

	//  Medkit stuff
	if (rorplayer_victim.GetItemCount(ITEMS.medkit) > 0 && player_victim.GetHealth() > 0 && rorplayer_victim.GetMedkit() == true){
		local victim_hpmax = player_victim.GetMaxHealth().tofloat();
		local victim_hp = player_victim.GetHealth().tofloat();

		// Get medkits cooldown
		local cooldown = GetItemCooldown(17, rorplayer_victim.GetItemCount(ITEMS.medkit));

		local medkit_effect = GetItemEffect(17, rorplayer_victim.GetItemCount(ITEMS.medkit));
		local medkit_heal = victim_hpmax * medkit_effect;
		local heal = clamp(victim_hp + medkit_heal, 0.0, victim_hpmax);

		// Set medkit on cooldown
		rorplayer_victim.SetMedkit(false);
		// Set medkit off cooldown after 'cooldown'
		EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+rorplayer_victim.userid+"].SetMedkit("+true+")", cooldown, null, null);

		//DebugPrint("[ITEM] Medkit heal: "+medkit_heal);
		// Heal player
		player_victim.SetHealth(heal);
		// Play medkit sound
		EntFireByHandle(CLIENTCMD, "command", "playvol "+items[17].sound1+" 0.4", 0, player_victim);
	}

	// Stealthkit stuff
	if (rorplayer_victim.GetItemCount(ITEMS.stealthkit) > 0 && player_victim.GetHealth() > 0 && rorplayer_victim.GetStealthkit() == true){
		local victim_hpmax = player_victim.GetMaxHealth().tofloat();
		local victim_hp = player_victim.GetHealth().tofloat();

		if ((victim_hp / victim_hpmax * 100) <= 25){ // Player is at or lower than 25% hp
			local cooldown = GetItemCooldown(20, rorplayer_victim.GetItemCount(ITEMS.stealthkit));
			local effect = GetItemEffect(20, rorplayer_victim.GetItemCount(ITEMS.stealthkit));
			local speed = rorplayer_victim.GetRunBoost() + effect;

			player_victim.__KeyValueFromInt("skin", 1); // Set to invisible skin
			rorplayer_victim.SetRunBoost(speed); // Give him movement speed boost
			rorplayer_victim.SetStealthkit(false); // Set stealthkit on cooldown


			EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+rorplayer_victim.userid+"].SetStealthkit("+true+")", cooldown, null, null); // Reset cooldown after cooldown dur
			EntFireByHandle(player_victim, "Skin", "0", 5, null, null); // Reset invisible skin
			EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+rorplayer_victim.userid+"].SetRunBoost("+(rorplayer_victim.GetRunBoost()-effect)+")", 5, null, null); // Reset movement boost

			EntFireByHandle(CLIENTCMD, "command", "play "+items[20].sound1, 0, player_victim);

			DebugPrint("[ITEM] Stealthkit procced, cooldown:"+cooldown);
		}
	}

	if (event.userid == event.attacker) return // Ignore self inflicted damage

	// Glasses crit stuff
	if (rorplayer_attacker != null && rorplayer_attacker.GetItemCount(ITEMS.glasses) > 0 && player_attacker.GetTeam() == items[6].team){
		if (event.weapon == "glasses") return // don't infinite loop glasses proc
		local proc_chance = GetItemProc(6, rorplayer_attacker.GetItemCount(ITEMS.glasses));
		local clover_mult = GetItemEffect(16, rorplayer_attacker.GetItemCount(ITEMS.clover));
		local procced = ProcRNG(GetItemProc(6, rorplayer_attacker.GetItemCount(ITEMS.glasses)), clover_mult);
		local damage = event.dmg_health;
		local victim_hp = event.health;
		DebugPrint("[ITEM] Glasses crit chance: "+proc_chance*clover_mult+"%");
		if (procced){ // Player critted, do double damage stuff
			DebugPrint("[ITEM] Glasses procced, did "+damage+" damage");
			ItemKillDeathnotice(player_victim.GetName(), player_attacker, damage, "weapon_glasses");
		}
	}
	// Ignition Tank stuff
	if (rorplayer_attacker != null && rorplayer_attacker.GetItemCount(ITEMS.gastank) > 0 && rorplayer_victim.GetIgnited() == false && player_attacker.GetTeam() == items[7].team){
		local proc_chance = GetItemProc(7, rorplayer_attacker.GetItemCount(ITEMS.gastank));
		local clover_mult = GetItemEffect(16, rorplayer_attacker.GetItemCount(ITEMS.clover));
		local procced = ProcRNG(GetItemProc(7, rorplayer_attacker.GetItemCount(ITEMS.gastank)), clover_mult);
		if (procced){ // Ignition tank procced
			local burn_target_userid = rorplayer_victim.userid;
			local duration = GetItemDuration(7, rorplayer_attacker.GetItemCount(ITEMS.gastank));
			local effect = GetItemEffect(7, rorplayer_attacker.GetItemCount(ITEMS.gastank));
			local slow = rorplayer_victim.GetRunSlow() + effect;

			// Slow them by Gasoline effect
			rorplayer_victim.SetRunSlow(slow);
			DebugPrint("[ITEM] Gastank effect: "+effect+" slow: "+slow);
			// Set players Ignited to true
			rorplayer_victim.SetIgnited(true);

			// Reduce duration by raincoat stacks
			if (rorplayer_victim.GetItemCount(ITEMS.raincoat) > 0){
				local duration_reduction = GetItemEffect(15, rorplayer_victim.GetItemCount(ITEMS.raincoat));
				DebugPrint("[ITEM] Debuff duration reduction: "+duration_reduction);
				DebugPrint("[ITEM] Gas tank duration: "+duration);
				duration = duration * duration_reduction;
				DebugPrint("[ITEM] Gas tank duration with raincoat: "+duration);

				// Ignite them for 8 - reduction seconds
				EntFireByHandle(player_victim, "IgniteLifetime", duration.tostring(), 0, null, null);
				// Remove slow after 8 - reduction seconds
				EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+burn_target_userid+"].SetRunSlow("+(rorplayer_victim.GetRunSlow()-effect)+")", duration, null, null);
				// Removed player Ignited after 8 - reduction seconds
				EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+burn_target_userid+"].SetIgnited("+false+")", duration, null, null);

			}else{
				// Ignite them for 8 seconds
				EntFireByHandle(player_victim, "IgniteLifetime", duration.tostring(), 0, null, null);
				// Remove slow after 8 seconds
				EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+burn_target_userid+"].SetRunSlow("+(rorplayer_victim.GetRunSlow()-effect)+")", duration, null, null);
				// Removed player Ignited after 8 seconds
				EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+burn_target_userid+"].SetIgnited("+false+")", duration, null, null);
			}

			// Play random gasoline sound
			switch(RandomInt(1, 3)){
				case 1: PlaySound(player_victim, items[4].sound1, "2000");break
				case 2: PlaySound(player_victim, items[4].sound2, "2000");break
				case 3: PlaySound(player_victim, items[4].sound3, "2000");break
			}
		}
	}
	// Tentabauble root stuff
	if (rorplayer_attacker != null && rorplayer_attacker.GetItemCount(ITEMS.tentabauble) > 0 && player_attacker.GetTeam() == items[8].team){
		local proc_chance = GetItemProc(8, rorplayer_attacker.GetItemCount(ITEMS.tentabauble));
		local clover_mult = GetItemEffect(16, rorplayer_attacker.GetItemCount(ITEMS.clover));
		local procced = ProcRNG(GetItemProc(8, rorplayer_attacker.GetItemCount(ITEMS.tentabauble)), clover_mult);
		if (procced){ // Tentabuable procced
			local root_target_userid = rorplayer_victim.userid;
			local duration = GetItemDuration(8, rorplayer_attacker.GetItemCount(ITEMS.tentabauble));

			EntFireByHandle(player_victim, "AddOutput", "movetype 0", 0.0, null, null); // Root them

			// Reduce duration by raincoat stacks
			if (rorplayer_victim.GetItemCount(ITEMS.raincoat) > 0){
				local duration_reduction = GetItemEffect(15, rorplayer_victim.GetItemCount(ITEMS.raincoat));
				DebugPrint("[ITEM] Debuff duration reduction: "+duration_reduction);
				DebugPrint("[ITEM] Tentabauble duration: "+duration);
				duration = duration * duration_reduction;
				DebugPrint("[ITEM] Tentabauble duration with raincoat: "+duration);
				EntFireByHandle(player_victim, "AddOutput", "movetype 2", duration, null, null); // Free them
			}else{
				EntFireByHandle(player_victim, "AddOutput", "movetype 2", duration, null, null); // Free them
			}
			// Play random tentabauble sound
			switch(RandomInt(1, 4)){
				case 1: PlaySound(player_victim, items[8].sound1, "2000");break
				case 2: PlaySound(player_victim, items[8].sound2, "2000");break
				case 3: PlaySound(player_victim, items[8].sound3, "2000");break
				case 4: PlaySound(player_victim, items[8].sound4, "2000");break
			}
		}
	}
	// Chronobauble slow stuff
	if (rorplayer_attacker != null && rorplayer_attacker.GetItemCount(ITEMS.chronobauble) > 0 && rorplayer_victim.GetSlowed() == false && player_attacker.GetTeam() == items[9].team){
		local proc_chance = GetItemProc(9, rorplayer_attacker.GetItemCount(ITEMS.chronobauble));
		local clover_mult = GetItemEffect(16, rorplayer_attacker.GetItemCount(ITEMS.clover));
		local procced = ProcRNG(GetItemProc(9, rorplayer_attacker.GetItemCount(ITEMS.chronobauble)), clover_mult);
		if (procced){ // Chronobauble procced
			local slow_target_userid = rorplayer_victim.userid;
			local duration = GetItemDuration(9, rorplayer_attacker.GetItemCount(ITEMS.chronobauble));
			local effect = (GetItemEffect(9, rorplayer_attacker.GetItemCount(ITEMS.chronobauble)));
			local slow = rorplayer_victim.GetRunSlow()+effect;

			// Slow them by Chronobauble effect
			rorplayer_victim.SetRunSlow(slow);
			DebugPrint("[ITEM] Chronobauble effect: "+effect+" slow: "+slow);
			// Set players Slowed to true
			rorplayer_victim.SetSlowed(true);

			// Reduce duration by raincoat stacks
			if (rorplayer_victim.GetItemCount(ITEMS.raincoat) > 0){
				local duration_reduction = GetItemEffect(15, rorplayer_victim.GetItemCount(ITEMS.raincoat));
				DebugPrint("[ITEM] Debuff duration reduction: "+duration_reduction);
				DebugPrint("[ITEM] Chronobauble duration: "+duration);
				duration = duration * duration_reduction;
				DebugPrint("[ITEM] Chronobauble duration with raincoat: "+duration);

				// Remove slow after duration seconds
				EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+slow_target_userid+"].SetRunSlow("+(rorplayer_victim.GetRunSlow()-effect)+")", duration, null, null);
				// Remove players Slowed after duration seconds
				EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+slow_target_userid+"].SetSlowed("+false+")", duration, null, null);
			}else{
				// Remove slow after duration seconds
				EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+slow_target_userid+"].SetRunSlow("+(rorplayer_victim.GetRunSlow()-effect)+")", duration, null, null);
				// Remove players Slowed after duration seconds
				EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+slow_target_userid+"].SetSlowed("+false+")", duration, null, null);
			}
		}
	}
	// Leeching seed stuff
	if (rorplayer_attacker != null && rorplayer_attacker.GetItemCount(ITEMS.seed) > 0 && (rorplayer_attacker.GetHP() != rorplayer_attacker.GetMaxHP()) && player_attacker.GetTeam() == items[10].team){
		local damage = event.dmg_health;
		local heal = GetItemEffect(10, rorplayer_attacker.GetItemCount(ITEMS.seed));
		if ((rorplayer_attacker.GetSeed() - damage) <= 0){ // Player broke 500 damage breakpoint, heal them
			local new_seed = rorplayer_attacker.GetSeed() - damage + 500;
			rorplayer_attacker.SetSeed(new_seed);
			if (rorplayer_attacker.GetHP()+heal <= rorplayer_attacker.GetMaxHP()){ // If they're under max hp, heal them
				rorplayer_attacker.SetHP(rorplayer_attacker.GetHP()+heal);
			}
		}
		else{
			local new_seed = rorplayer_attacker.GetSeed()-damage;
			rorplayer_attacker.SetSeed(new_seed); // Subtract damage from Seed damage
		}
	}
	// Crowbar damage stuff
	if (rorplayer_attacker != null && rorplayer_attacker.GetItemCount(ITEMS.crowbar) > 0 && player_attacker.GetTeam() == items[11].team){
		local victim_hpmax = player_victim.GetMaxHealth().tofloat();
		local victim_hp = player_victim.GetHealth().tofloat();
		local damage = event.dmg_health;

		if (((victim_hp+damage) / victim_hpmax * 100) < 90) return // enemy is not under 90%

		local multiplier = GetItemEffect(11, rorplayer_attacker.GetItemCount(ITEMS.crowbar));
		damage = event.dmg_health * multiplier;
		victim_hp = event.health;
		DebugPrint("[ITEMS] Crowbar did "+damage+" damage ("+event.dmg_health+" * "+multiplier+")");

		ItemKillDeathnotice(player_victim.GetName(), player_attacker, damage, "weapon_crowbar");

		switch(RandomInt(1, 2)){ // Play random crowbar sound
			case 1: EntFireByHandle(CLIENTCMD, "command", "play "+items[11].sound1, 0, player_attacker);break
			case 2: EntFireByHandle(CLIENTCMD, "command", "play "+items[11].sound2, 0, player_attacker);break
		}
	}
	// Microbots stuff
	if (rorplayer_attacker != null && rorplayer_victim.GetItemCount(ITEMS.microbots) > 0 && player_attacker.GetTeam() == 3 && rorplayer_victim.GetMicrobots() == true){
		local proc_chance = GetItemProc(18, rorplayer_victim.GetItemCount(ITEMS.microbots));
		local clover_mult = GetItemEffect(16, rorplayer_victim.GetItemCount(ITEMS.clover));
		local procced = ProcRNG(GetItemProc(18, rorplayer_victim.GetItemCount(ITEMS.microbots)), clover_mult);
		local cooldown = GetItemCooldown(18, 1);
		local duration = GetItemDuration(18, 1);
		if (procced){
			DebugPrint("[ITEMS] Microbots procced");
			// Set Microbots on cooldown
			rorplayer_victim.SetMicrobots(false);
			// Disable movement effects
			EntFireByHandle(player_victim, "AddOutput", "movetype 1", 0, null, null);
			// Reenable movement effects
			EntFireByHandle(player_victim, "AddOutput", "movetype 2", duration, null, null);
			// Set microbots off cooldown
			EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+rorplayer_victim.userid+"].SetMicrobots("+true+")", cooldown, null, null);
		}
	}
	// Stungrenade stuff
	if (rorplayer_attacker != null && rorplayer_attacker.GetItemCount(ITEMS.stungrenade) > 0 && player_attacker.GetTeam() == items[19].team){
		local proc_chance = GetItemProc(19, rorplayer_attacker.GetItemCount(ITEMS.stungrenade));
		local clover_mult = GetItemEffect(16, rorplayer_attacker.GetItemCount(ITEMS.clover));
		local procced = ProcRNG(GetItemProc(19, rorplayer_attacker.GetItemCount(ITEMS.stungrenade)), clover_mult);
		if (procced){ // Stungrenade procced
			local radius = (GetItemEffect(19, rorplayer_attacker.GetItemCount(ITEMS.stungrenade)));
			local origin = player_victim.GetCenter();

			local ply = null;
			while (ply = Entities.FindInSphere(ply, origin, radius)){
				if (ply != null && ply.GetHealth() > 0 && ply.GetTeam() == 2){
					ply.SetVelocity(Vector(0,0,0));
				}
			}
			//VS.DrawSphere(origin, radius, 20, 20, RandomInt(0, 255), RandomInt(0, 255), RandomInt(0, 255), false, 15);
		}
	}
	// Razorwire stuff
	if (rorplayer_attacker != null && rorplayer_victim.GetItemCount(ITEMS.razorwire) > 0 && player_attacker.GetTeam() == 3){
		local proc_chance = GetItemProc(21, rorplayer_victim.GetItemCount(ITEMS.razorwire));
		local clover_mult = GetItemEffect(16, rorplayer_victim.GetItemCount(ITEMS.clover));
		local procced = ProcRNG(GetItemProc(21, rorplayer_victim.GetItemCount(ITEMS.razorwire)), clover_mult);
		local damage = GetItemEffect(21, rorplayer_victim.GetItemCount(ITEMS.razorwire));

		local attacker_hpmax = player_attacker.GetMaxHealth().tofloat();
		local attacker_hp = player_attacker.GetHealth().tofloat();

		if (procced){
			ItemKillDeathnotice(player_attacker.GetName(), player_victim, damage, "weapon_razorwire");
		}
	}


}, "event_player_hurt" );

//-----------------------------------------------------------------------------
// Player death event
//-----------------------------------------------------------------------------
VS.ListenToGameEvent( "player_death", function( event ){
	local player_victim = VS.GetPlayerByUserid(event.userid);
	local rorplayer_victim = RORPlayers[event.userid];
	local player_attacker = null;
	local rorplayer_attacker = null;
	if (event.attacker != 0){ // Ignore non player damage stuff
		player_attacker = VS.GetPlayerByUserid(event.attacker);
		rorplayer_attacker = RORPlayers[event.attacker];
	}
	local player_assister = null;
	local rorplayer_assister = null;
	if (event.assister != 0){ // Ignore non player damage stuff
		player_assister = VS.GetPlayerByUserid(event.assister);
		rorplayer_assister = RORPlayers[event.assister];
	}

	if (player_victim.GetTeam() == 3){
		if (rorplayer_victim.GetBonemerge() == null || rorplayer_victim.GetBonemerge().IsValid() == false) return
		rorplayer_victim.GetBonemerge().Destroy();
	}


	local CritKill = false; // Workaround for crit damage suicide
	if (player_attacker == player_victim){
		CritKill = true;
	}

	// If attacker killed someone with Gasoline, do Gasoline stuff
	if (event.weapon != "world" && event.weapon != "worldspawn" && event.attacker != 0 && rorplayer_attacker.GetItemCount(ITEMS.gasoline) > 0 && player_attacker.GetTeam() == items[4].team){
		foreach (player in RORPlayers){
			if (player.GetPlayerTeam() == 2){
				if (player == rorplayer_victim) continue // Don't ignite person that died
				// Ignite every zombie in 256 units away from dead zombie
				if (player.handle.GetHealth() > 0 && (player.handle.GetCenter() - player_victim.GetCenter()).LengthSqr() < 256*256 && player.GetIgnited() == false){
					local burn_target_userid = player.userid;
					local duration = GetItemDuration(4, rorplayer_attacker.GetItemCount(ITEMS.gasoline));
					local effect = GetItemEffect(4, rorplayer_attacker.GetItemCount(ITEMS.gasoline));
					local slow = player.GetRunSlow()+effect;

					// Slow them by Gasoline effect
					player.SetRunSlow(slow);
					DebugPrint("[ITEM] Gasoline effect: "+effect+" slow: "+slow);
					// Set players Ignited to true
					player.SetIgnited(true);

					// Reduce duration by raincoat stacks
					printl(rorplayer_victim)
					if (rorplayer_victim.GetItemCount(ITEMS.raincoat) > 0){
						local duration_reduction = GetItemEffect(15, rorplayer_victim.GetItemCount(ITEMS.raincoat));
						DebugPrint("[ITEM] Debuff duration reduction: "+duration_reduction);
						DebugPrint("[ITEM] Gasoline duration: "+duration);
						duration = duration * duration_reduction;
						DebugPrint("[ITEM] Gasoline duration with raincoat: "+duration);

						// Ignite them for 8 seconds
						EntFireByHandle(player.handle, "IgniteLifetime", duration.tostring(), 0, null, null);
						// Remove slow after 8 seconds
						EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+burn_target_userid+"].SetRunSlow("+(player.GetRunSlow()-effect)+")", duration, null, null);
						// Removed player Ignited after 8 seconds
						EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+burn_target_userid+"].SetIgnited("+false+")", duration, null, null);
					}else{
						// Ignite them for 8 seconds
						EntFireByHandle(player.handle, "IgniteLifetime", duration.tostring(), 0, null, null);
						// Remove slow after 8 seconds
						EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+burn_target_userid+"].SetRunSlow("+(player.GetRunSlow()-effect)+")", duration, null, null);
						// Removed player Ignited after 8 seconds
						EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+burn_target_userid+"].SetIgnited("+false+")", duration, null, null);
					}

					// Play random gasoline sound
					switch(RandomInt(1, 3)){
						case 1: PlaySound(player_victim, items[4].sound1, "4000");break
						case 2: PlaySound(player_victim, items[4].sound2, "4000");break
						case 3: PlaySound(player_victim, items[4].sound3, "4000");break
					}
				}
			}
		}
	}

	 // If assister assisted with a kill and had Gasoline, do Gasoline stuff
	if (CritKill && event.assister != 0 && rorplayer_assister.GetItemCount(ITEMS.gasoline) > 0 && player_assister.GetTeam() == items[4].team){
		foreach (player in RORPlayers){
			if (player.GetPlayerTeam() == 2){
				if (player == rorplayer_victim) continue // Don't ignite person that died
				// Ignite every zombie in 256 units away from dead zombie
				if (player.handle.GetHealth() > 0 && (player.handle.GetCenter() - player_victim.GetCenter()).LengthSqr() < 256*256 && player.GetIgnited() == false){
					local burn_target_userid = player.userid;
					local duration = GetItemDuration(4, rorplayer_assister.GetItemCount(ITEMS.gasoline));
					local effect = GetItemEffect(4, rorplayer_assister.GetItemCount(ITEMS.gasoline));
					local slow = player.GetRunSlow()+effect;

					// Slow them by Gasoline effect
					player.SetRunSlow(slow);
					DebugPrint("[ITEM] Gasoline effect: "+effect+" slow: "+slow);
					// Set players Ignited to true
					player.SetIgnited(true);

					// Reduce duration by raincoat stacks
					if (rorplayer_victim.GetItemCount(ITEMS.raincoat) > 0){
						local duration_reduction = GetItemEffect(15, rorplayer_victim.GetItemCount(ITEMS.raincoat));
						DebugPrint("[ITEM] Debuff duration reduction: "+duration_reduction);
						DebugPrint("[ITEM] Gasoline duration: "+duration);
						duration = duration * duration_reduction;
						DebugPrint("[ITEM] Gasoline duration with raincoat: "+duration);

						// Ignite them for 8 seconds
						EntFireByHandle(player.handle, "IgniteLifetime", duration.tostring(), 0, null, null);
						// Remove slow after 8 - duration seconds
						EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+burn_target_userid+"].SetRunSlow("+(player.GetRunSlow()-effect)+")", duration, null, null);
						// Removed player Ignited after 8 - duration seconds
						EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+burn_target_userid+"].SetIgnited("+false+")", duration, null, null);
					}
					else{
						// Ignite them for 8 seconds
						EntFireByHandle(player.handle, "IgniteLifetime", duration.tostring(), 0, null, null);
						// Remove slow after 8 seconds
						EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+burn_target_userid+"].SetRunSlow("+(player.GetRunSlow()-effect)+")", duration, null, null);
						// Removed player Ignited after 8 seconds
						EntFireByHandle(SCRIPT, "RunScriptCode", "RORPlayers["+burn_target_userid+"].SetIgnited("+false+")", duration, null, null);
					}

					// Play random gasoline sound
					switch(RandomInt(1, 3)){
						case 1: PlaySound(player_victim, items[4].sound1, "4000");break
						case 2: PlaySound(player_victim, items[4].sound2, "4000");break
						case 3: PlaySound(player_victim, items[4].sound3, "4000");break
					}
				}
			}
		}
	}
}, "event_player_death" );