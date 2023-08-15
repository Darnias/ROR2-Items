//::hudhint_template <- Entities.FindByName(null, "item_hudhint_template");
::hudhint_maker <- Entities.FindByName(null, "item_hudhint_maker");

::hudhint_keyvalues <- {}

function PreSpawnInstance(classname, targetname){
	local keyvalues = hudhint_keyvalues
	return keyvalues
}

function PostSpawn(ents){ // Called when point_template spawns something
	foreach(name, handle in ents){
		EntFireByHandle(handle, "showmessage", "", 0, HUDHINTplayer, null);
		if (ShowTwice)EntFireByHandle(handle, "showmessage", "", 1, HUDHINTplayer, null);
		EntFireByHandle(handle, "Kill", "", 1.1, null, null);
	}
}

::HUDHINTplayer <- null;
::ShowTwice <- false;
::ShowItemHudHint <- function(item, _activator, show_twice = false){

	hudhint_keyvalues = {
		message = GetItemDescription(item),
	}

	HUDHINTplayer = _activator
	ShowTwice = show_twice
	hudhint_maker.SpawnEntity()
	//EntFireByHandle(hudhint_template, "Forcespawn", "", 0, null, null);
}


::GetRarityColor <- function (rarity){
	switch(rarity){
		case "common": return "#FFFFFF"
		case "uncommon": return "#00FF21"
		case "legendary": return "#E02A23"
		case "void": return "#E13286"
	}
}

::GetItemDescription <- function(item){
	local index = ItemStringToIndex(item);
	if (index == null) return "<img src='https://i.imgur.com/AIJQUEx.jpeg'/>"
	local name = items[index].name_full;
	local team = items[index].team;
	local desc = items[index].description;
	local rarity = items[index].rarity;
	local proc = items[index].proc_base;
	local proc_add = items[index].proc_add;
	local effect = items[index].effect_base;
	local effect_add = items[index].effect_add
	local duration = items[index].duration_base
	local duration_add = items[index].duration_add
	local cooldown = items[index].cooldown
	local cooldown_sub = items[index].cooldown_sub
	local max = items[index].max

	local message = "";

	switch(item){
		case "steak":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Effect: +"+effect+" hp<br>"
		}break
		case "hopoo":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Effect: +"+effect+" jump<br>"
		}break
		case "wax":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Effect: +"+effect*100+"% velocity (+"+effect_add*100+"% per stack)<br>"
		}break
		case "hoof":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Effect: +"+effect*100+"% speed (+"+effect_add*100+"% per stack)<br>"
		}break
		case "gasoline":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Effect: +"+effect*100+"% slow (+"+effect_add*100+"% per stack)<br>"
			message += "Duration: "+duration+"s<br>"
		}break
		case "potion":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "<font color='#D3D3D3'>(consumes 1 stack per heal)</font><br>";
		}break
		case "glasses":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Proc: "+proc+"% (+"+proc_add+"% per stack)<br>"
			message += "Max: "+max+" stacks<br>"
		}break
		case "gastank":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Proc: "+proc+"% (+"+proc_add+"% per stack)<br>"
			message += "Effect: +"+effect*100+"% slow (+"+effect_add*100+"% per stack)<br>"
			message += "Duration: "+duration+"s<br>"
		}break
		case "tentabauble":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Proc: "+proc+"% (+"+proc_add+"% per stack)<br>"
			message += "Duration: "+duration+"s (+"+duration_add+"s per stack)<br>"
		}break
		case "chronobauble":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Proc: "+proc+"% (+"+proc_add+"% per stack)<br>"
			message += "Effect: +"+effect*100+"% slow (+"+effect_add*100+"% per stack)<br>"
			message += "Duration: "+duration+"s (+"+duration_add+"s per stack)<br>"
		}break
		case "seed":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Proc: Every 500 damage dealt<br>"
			message += "Effect: Restores 1 hp (+"+effect_add+"hp per stack)<br>"
		}break
		case "crowbar":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Effect: +100% damage (+100% damage per stack)<br>"
		}break
		case "fungus":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Proc: Every 50 steps (-5 steps per stack)<br>"
			message += "Effect: 5% heal<br>"
			message += "Max: "+max+" stacks<br>"
		}break
		case "aegis":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Proc: Every 90s (-15s per stack)<br>"
			message += "Effect: Restore 100 armor<br>"
			message += "Max: "+max+" stacks<br>"
		}break
		case "magazine":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Effect: +"+effect_add*100+"% ammo (+"+effect_add*100+"% ammo per stack)<br>"
		}break
		case "raincoat":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Effect: "+effect_add*100+"% duration ("+effect_add*100+"% duration per stack)<br>"
			message += "Max: "+max+" stacks<br>"
		}break
		case "clover":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Effect: +"+effect_add*100+"% proc chance (+"+effect_add*100+"% proc chance per stack)<br>"
		}break
		case "medkit":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Effect: "+effect*100+"% heal (+"+effect_add*100+"% heal per stack)<br>"
			message += "Cooldown: "+cooldown+"s (-"+cooldown_sub+"s per stack)<br>"
		}break
		case "microbots":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Proc: "+proc+"% (+"+proc_add+"% per stack)<br>"
			message += "Cooldown: "+cooldown+"s<br>"
		}break
		case "stungrenade":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Proc: "+proc+"% (+"+proc_add+"% per stack)<br>"
		}break
		case "stealthkit":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Effect: "+effect*100+"% speed (+"+effect_add*100+"% speed per stack)<br>"
			message += "Cooldown: "+cooldown+"s (-"+cooldown_sub+"s per stack)<br>"
		}break
		case "razorwire":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Proc: "+proc+"% (+"+proc_add+"% per stack)<br>"
			message += "Effect: Deal "+effect+" damage to attacker (+"+effect_add+" damage per stack)<br>"
		}break
		case "crystal":{
			switch(team){
				case 0: message += "<img src='file://{images}/tct.png'/>";break
				case 2: message += "<img src='file://{images}/t.png'/>";break
				case 3: message += "<img src='file://{images}/ct.png'/>";break
			}
			message += "<font color='"+GetRarityColor(rarity)+"'>["+name+"]</font><br>";
			message += "<font color='#D3D3D3'>"+desc+"</font><br>";
			message += "Effect: Deals "+effect+"% damage to nearby enemy (+"+effect_add+"% damage per stack)<br>"
		}break
	}

	return message
}