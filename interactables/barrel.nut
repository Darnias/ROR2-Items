GOLD <- 20;

function Open(){
	DebugPrint("[INTERACT] Barrel gold: "+GOLD);
	activator.ValidateScriptScope();
	local activator_scope = activator.GetScriptScope();
	local activator_userid = activator_scope.userid;

	PlaySound(self, "darnias/ror2/interactables/barrel_open.mp3", "2000");

	AddPlayerGold(activator_userid, GOLD);
}