COST <- 25;

function InputUse(){
	local activator_scope = activator.GetScriptScope();
	local activator_userid = activator_scope.userid;
	local rorplayer = RORPlayers[activator_userid];

	if (rorplayer.GetGold() < COST){
		EntFireByHandle(CLIENTCMD, "command", "play darnias/ror2/ui/insufficient_funds.mp3", 0, activator);

		return false
	}

	RemovePlayerGold(activator_userid, COST);

	return true
}


function Open(){
	local activator_scope = activator.GetScriptScope();
	local activator_userid = activator_scope.userid;
	local rorplayer = RORPlayers[activator_userid];

	PlaySound(self, "darnias/ror2/interactables/chest_open.mp3", "800");

	local DropArray = [];

	local rng = RandomInt(0, 100);

	if (rng < 79){ // Common
		EntFireByHandle(CLIENTCMD, "command", "play darnias/ror2/interactables/item_tier_1.mp3", 0.75, activator)
		DebugPrint("[INTERACT] Chest basic rng: "+rng+" (COMMON)");
		foreach (item in items){
			if (item.rarity == "common" && item.team == activator.GetTeam() || item.rarity == "common" && item.team == 0){
				DropArray.push(item);
				DebugPrint("[INTERACT] Added "+item.name+" to drop array");
			}
		}
		foreach (item, count in rorplayer.GetInventory()){
			if (GetItemMax(item) == 0) continue
			if (count == GetItemMax(item)){
				foreach(index, item_drop in DropArray){
					if (item == item_drop.name){
						DropArray.remove(index);
						DebugPrint("[INTERACT] Deleted "+item_drop.name+" from DropArray because player has max item count");
					}
				}
			}
		}
	}
	else if (rng > 78 && rng < 100){ // Uncommon
		EntFireByHandle(CLIENTCMD, "command", "play darnias/ror2/interactables/item_tier_2.mp3", 0.75, activator)
		DebugPrint("[INTERACT] Chest basic rng: "+rng+" (UNCOMMON)");
		foreach (item in items){
			if (item.rarity == "uncommon" && item.team == activator.GetTeam() || item.rarity == "uncommon" && item.team == 0){
				DropArray.push(item);
				DebugPrint("[INTERACT] Added "+item.name+" to drop array");
			}
		}
		foreach (item, count in rorplayer.GetInventory()){
			if (GetItemMax(item) == 0) continue
			if (count == GetItemMax(item)){
				foreach(index, item_drop in DropArray){
					if (item == item_drop.name){
						DropArray.remove(index);
						DebugPrint("Deleted "+item_drop.name+" from DropArray because player has max item count");
					}
				}
			}
		}
	}
	else if (rng == 100){ // Legendary
		EntFireByHandle(CLIENTCMD, "command", "play darnias/ror2/interactables/item_tier_3.mp3", 0.75, activator)
		DebugPrint("[INTERACT] Chest basic rng: "+rng+" (LEGENDARY)");
		foreach (item in items){
			if (item.rarity == "legendary" && item.team == activator.GetTeam() || item.rarity == "legendary" && item.team == 0){
				DropArray.push(item);
				DebugPrint("[INTERACT] Added "+item.name+" to drop array");
			}
		}
		foreach (item, count in rorplayer.GetInventory()){
			if (GetItemMax(item) == 0) continue
			if (count == GetItemMax(item)){
				foreach(index, item_drop in DropArray){
					if (item == item_drop.name){
						DropArray.remove(index);
						DebugPrint("Deleted "+item_drop.name+" from DropArray because player has max item count");
					}
				}
			}
		}
	}

	local DropItem = DropArray[RandomInt(0, DropArray.len()-1)]

	SpawnVisual(self.GetOrigin()+Vector(0,0,30), DropItem.model, activator);

	GivePlayerItem(activator_userid, DropItem.name, 1);
}