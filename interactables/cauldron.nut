SND_TIER_2 <- "darnias/ror2/interactables/item_spawn_tier_2.mp3";
SND_TIER_3 <- "darnias/ror2/interactables/item_spawn_tier_3.mp3";


function InputUse(){
	local activator_scope = activator.GetScriptScope();
	local activator_userid = activator_scope.userid;
	local rorplayer = RORPlayers[activator_userid];

	local item_count = 0;

	foreach(item, count in rorplayer.GetInventory()){
		if (count > 0){
			if (items[ItemStringToIndex(item)].rarity == "common"){
				for (local i = 0; i < count; i++){
					item_count ++;
				}
			}
		}
	}

	if (item_count > 2){
		DebugPrint("[INTERACT] PASSED player used cauldron with " + item_count + " item(s) in inventory");
		return true
	}
	else{
		DebugPrint("[INTERACT] FAILED player used cauldron with " + item_count + " item(s) in inventory");
		EntFireByHandle(CLIENTCMD, "command", "play darnias/ror2/ui/insufficient_funds.mp3", 0, activator);
		return false
	}
}


function Activate(){
	local activator_scope = activator.GetScriptScope();
	local activator_userid = activator_scope.userid;
	local rorplayer = RORPlayers[activator_userid];

	local inventory_items = [];
	local scrapped_items = [];

	foreach(item, count in rorplayer.GetInventory()){
		if (count > 0){
			if (items[ItemStringToIndex(item)].rarity == "common"){
				for (local i = 0; i < count; i++){
					inventory_items.push(item);
				}
			}
		}
	}

	local scrapped_items_count = 0;

	while (scrapped_items_count != 3){
		local random_item = RandomInt(0, inventory_items.len()-1);
		local scrapped_item = inventory_items[random_item];
		//local item_model = items[ItemStringToIndex(scrapped_item)].model;

		scrapped_items.push(scrapped_item);
		inventory_items.remove(random_item);

		scrapped_items_count ++;
		SetPlayerItemCount(activator_userid, scrapped_item, rorplayer.GetItemCount(scrapped_item)-1);
		DebugPrint("[INTERACT] Player scrapped "+ scrapped_item);
	}

	EntFireByHandle(CLIENTCMD, "command", "play "+SND_TIER_2, 0, activator);
	SpawnVisual(self.GetOrigin(), "models/darnias/ror2/items/razorwire.mdl", activator);

}