function InputUse(){
	local activator_scope = activator.GetScriptScope();
	local activator_userid = activator_scope.userid;
	local rorplayer = RORPlayers[activator_userid];

	if (rorplayer.GetBlood() > 2) return false

	return true
}


function Activate(){
	local activator_scope = activator.GetScriptScope();
	local activator_userid = activator_scope.userid;
	local rorplayer = RORPlayers[activator_userid];

	local use_count = rorplayer.GetBlood();

	local hp = activator.GetHealth();
	local hpmax = activator.GetMaxHealth();
	local damage = 0;
	local award = 0;

	switch(use_count){

		case 0:{
			damage = hpmax * 0.5;
			award = ceil(damage/2);

			EntFireByHandle(activator, "SetHealth", hp-damage, 0, activator, activator);

			EntFireByHandle(CLIENTCMD, "Command", "cam_idealdistup 1", 0, activator, activator);
			rorplayer.SetBlood(1);

			AddPlayerGold(activator_userid, award);
		}break
		case 1:{
			damage = hpmax * 0.75
			award = ceil(damage/2);

			EntFireByHandle(activator, "SetHealth", hp-damage, 0, activator, activator);

			EntFireByHandle(CLIENTCMD, "Command", "cam_idealdistup 2", 0, activator, activator);
			rorplayer.SetBlood(2);

			AddPlayerGold(activator_userid, award);
		}break
		case 2:{
			damage = hpmax * 0.9
			award = ceil(damage/2);

			EntFireByHandle(activator, "SetHealth", hp-damage, 0, activator, activator);

			EntFireByHandle(CLIENTCMD, "Command", "cam_idealdistup 3", 0, activator, activator);
			rorplayer.SetBlood(3);

			AddPlayerGold(activator_userid, award);
		}break
	}

	EntFireByHandle(CLIENTCMD, "command", "play darnias/ror2/interactables/shrine_activate.mp3", 0.0, activator)
}