/*
Money
COST <- 17;
COST_MULT <- 1.4;

Item drops
CHANCE_NOTHING <- 45;
CHANCE_COMMON <- 36;
CHANCE_UNCOMMON <- 18; // should be 9% but we dont have equipment which is the other 9%
CHANCE_LEGENDARY <- 1; */

function InputUse(){
	local activator_scope = activator.GetScriptScope();
	local activator_userid = activator_scope.userid;
	local rorplayer = RORPlayers[activator_userid];
	local cost = rorplayer.GetChance();

	if (rorplayer.GetChanceItems() == 2) return false // Player got 2 items from shrine, don't let him try to get more shit

	if (rorplayer.GetGold() < cost){
		EntFireByHandle(CLIENTCMD, "command", "play darnias/ror2/ui/insufficient_funds.mp3", 0, activator);

		return false
	}

	return true
}


function Activate(){
	EntFireByHandle(CLIENTCMD, "command", "play darnias/ror2/interactables/shrine_activate.mp3", 0.0, activator)

	local activator_scope = activator.GetScriptScope();
	local activator_userid = activator_scope.userid;
	local rorplayer = RORPlayers[activator_userid];

	local DropArray = [];

	local rng = RandomInt(0, 100);

	local chance_cost = rorplayer.GetChance(); // Money it cost for player to use Shrine

	RemovePlayerGold(activator_userid, chance_cost); // Deduct cost money

	local cost = (chance_cost * 1.4).tointeger(); // Next use of Shrine will be 40% more expensive
	rorplayer.SetChance(cost);

	local cost_ones = 0;
	local cost_tens = 0;
	local cost_hundreds = 0;

	cost = cost.tostring();
	if (cost.len() == 2){
		cost_ones = cost[0].tochar();
		cost_tens = cost[1].tochar();

		EntFireByHandle(CLIENTCMD, "Command", "cam_idealdistright "+cost_ones, 0, activator, activator);
		EntFireByHandle(CLIENTCMD, "Command", "cam_idealdist "+cost_tens, 0, activator, activator);
		EntFireByHandle(CLIENTCMD, "Command", "cam_idealyaw 10", 0, activator, activator);
	}
	else if(cost.len() == 3){
		cost_ones = cost[0].tochar();
		cost_tens = cost[1].tochar();
		cost_hundreds = cost[2].tochar();

		EntFireByHandle(CLIENTCMD, "Command", "cam_idealdistright "+cost_ones, 0, activator, activator);
		EntFireByHandle(CLIENTCMD, "Command", "cam_idealdist "+cost_tens, 0, activator, activator);
		EntFireByHandle(CLIENTCMD, "Command", "cam_idealyaw "+cost_hundreds, 0, activator, activator);
	}

	if (rng < 46) return // nothing dropped

	if (rng < 81){ // Common
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
						DebugPrint("Deleted "+item_drop.name+" from DropArray because player has max item count");
					}
				}
			}
		}
	}
	else if (rng > 81 && rng < 100){ // Uncommon
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

	SpawnVisual(self.GetOrigin()+Vector(30,0,30), DropItem.model, activator);

	GivePlayerItem(activator_userid, DropItem.name, 1);

	rorplayer.SetChanceItems(rorplayer.GetChanceItems()+1); // Add 1 item to shrine item count, can't get more than 2

	if (rorplayer.GetChanceItems() == 2){
		EntFireByHandle(CLIENTCMD, "Command", "cam_idealdistright 10", 0, activator, activator);
		EntFireByHandle(CLIENTCMD, "Command", "cam_idealdist 10", 0, activator, activator);
		EntFireByHandle(CLIENTCMD, "Command", "cam_idealyaw 10", 0, activator, activator);
	}
}