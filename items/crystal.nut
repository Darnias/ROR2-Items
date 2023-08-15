crystal_players <- [];
owner <- null;
ror_owner <- null;

function OnPostSpawn(){
	owner <- self.GetOwner();
	local owner_scope = self.GetOwner().GetScriptScope();
	local owner_userid = owner_scope.userid;
	ror_owner <- RORPlayers[owner_userid];
}

function CrystalPlayerAdd(){
	crystal_players.append(activator);
	DebugPrint("[ITEMS] Added "+activator+" to CrystalPlayers");
}

function CrystalPlayerRemove(){
	foreach(index, player in crystal_players){
		if (player == activator){
			crystal_players.remove(index);
			DebugPrint("[ITEMS] Removed "+player+" from CrystalPlayers");
		}
	}
}

function CrystalThink(){
	local effect = GetItemEffect(22, ror_owner.GetItemCount(ITEMS.crystal));
	foreach(index, player in crystal_players){
		local hp = player.GetHealth();
		local hpmax = player.GetMaxHealth();
		local damage = (hpmax / 100) * effect;

		ItemKillDeathnotice(player.GetName(), owner, damage, "weapon_crystal");
	}

	return 1.0 // Hurt players every 1 second
}