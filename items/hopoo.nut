INIT <- false;
ALLOW <- true;

function HopooPlayerOff(){ // Called when player uses jump and disables game_ui (this triggers bonus jump)
	if (ALLOW == false) return
	local activator_userid = activator.GetScriptScope().userid;
	RORPlayers[activator_userid].SetJumps(RORPlayers[activator_userid].GetJumps()-1) // take away 1 jump

	local velocity = Vector(activator.GetVelocity().x, activator.GetVelocity().y, 375); // 375 feels like a good number
	activator.SetVelocity(velocity); // Set the velocity to make player "jump" again

	switch(RandomInt(1, 3)){ // Play random jump sound
		case 1: EntFireByHandle(CLIENTCMD, "command", "play "+items[1].sound1, 0, activator);break
		case 2: EntFireByHandle(CLIENTCMD, "command", "play "+items[1].sound2, 0, activator);break
		case 3: EntFireByHandle(CLIENTCMD, "command", "play "+items[1].sound3, 0, activator);break
	}

	// If player has more bonus jumps, spawn another Hopoo UI
	if (RORPlayers[activator_userid].GetJumps() > 0){
		EntFireByHandle(RORPlayers[activator_userid].GetHopooUI(), "Activate", "", 0.0, activator, activator);
	}
//	DebugPrint("Player jumped, remaining jumps: "+RORPlayers[activator_userid].GetJumps());
}