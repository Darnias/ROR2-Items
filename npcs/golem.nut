// handles
GRENADE <- null;
TANK_BASE <- null;
MODEL <- null;
TANK_HEAD <- null;
HURT <- null;
HITBOX <- null;
MODEL_HEAD <- null;
BEAM <- null;

// variables
DEAD <- false;
SPAWNING <- true;
ENEMY_LAST_POSITION <- null;
LOS_COUNT <- 0;
RANGED_ATTACK_CD <- true;
RANGED_ATTACK_DAMAGE <- false;

ANIMATION <- null;

ENEMY <- null;

STATE <- null;

AGGRO_RANGE <- 900;
AGGRO_RANGE_SQR <- AGGRO_RANGE * AGGRO_RANGE;

MELEE_DISTANCE <- 80;
MELEE_DISTANCE_SQR <- MELEE_DISTANCE * MELEE_DISTANCE;

MELEE_DAMAGE <- 150;
MELEE_DAMAGE_RADIUS <- 175;

RANGE_DAMAGE <- 40;

SND_SPAWN <- "darnias/ror2/npcs/golem/golem_spawn.mp3";
SND_ATTACK_MELEE <- ["darnias/ror2/npcs/golem/golem_clap_1.mp3","darnias/ror2/npcs/golem/golem_clap_2.mp3"];
SND_ATTACK_RANGED <- ["darnias/ror2/npcs/golem/golem_laser_charge.mp3","darnias/ror2/npcs/golem/golem_laser_fire.mp3"];
SND_DEATH <- "darnias/ror2/npcs/golem/golem_death.mp3";
SND_STEP <- ["darnias/ror2/npcs/golem/golem_step_1.mp3","darnias/ror2/npcs/golem/golem_step_2.mp3","darnias/ror2/npcs/golem/golem_step_3.mp3","darnias/ror2/npcs/golem/golem_step_4.mp3",];

function OnPostSpawn(){
	GRENADE = EntityGroup[0];
	TANK_BASE = EntityGroup[1];
	MODEL = EntityGroup[2];
	TANK_HEAD = EntityGroup[3];
	HURT = EntityGroup[4];
	HITBOX = EntityGroup[5];
	MODEL_HEAD = EntityGroup[6];
	BEAM = EntityGroup[7]

	GRENADE.__KeyValueFromInt("movetype", 0); // Disable movement
	GRENADE.__KeyValueFromInt("friction", 0.3); // Don't slide too much
	GRENADE.__KeyValueFromInt("collisiongroup", 10); // Don't block bullets
	GRENADE.SetSize(Vector(-22,-22,-2), Vector(22,22,44)); // Custom bounding box

	HITBOX.__KeyValueFromInt("material", 8); // Rock material

	HURT.__KeyValueFromInt("iMagnitude", MELEE_DAMAGE);
	HURT.__KeyValueFromInt("iRadiusOverride", MELEE_DAMAGE_RADIUS);

	EntFireByHandle(MODEL, "SetAnimation", "spawn", 0, null, null);

	EntFireByHandle(GRENADE, "AddOutput", "movetype 3", FrameTime(), null, null); // Re-enable movement

	EntFireByHandle(self, "RunScriptCode", "RANGED_ATTACK_CD<-false", RandomInt(4, 12), null, null);

	Spawn();
}



function golemThink(){
	// Don't think until mob finished spawning animation
	if (SPAWNING) return

	// Mob is dead, run code once
	if (DEAD) return 60 // Don't tick Think again

	// Mob doesn't have enemy, find it
	if (ENEMY == null){
		LookForEnemy(); // Find possible enemy
	}

	// Mob has enemy, do stuff
	if (ENEMY != null){
		if (!RANGED_ATTACK_CD){
			AttackRange();
		}
		if (IsEnemyTooFar()){ // If enemy is too far
			if (!IsLOS(ENEMY)){ // If we can't see player
				MoveToLastEnemyPositon(); // Move to where we last saw player
			}
			else{ // If we can see player
				MoveToEnemy(); // Move to player
			}
		}
		else{ // Enemy is not too far
			AttackMelee();
		}
	}

	return 1 // Think every 1 second
}

function Spawn(){
	PlaySound(MODEL, SND_SPAWN, "2000");
}

function Hurt(){

}

function Death(){
	DebugPrint("[NPC] Death");
	DEAD <- true;
	PlaySound(MODEL, SND_DEATH, "2000");
	GRENADE.SetVelocity(Vector(0,0,0));
	HURT.Destroy();
	EntFireByHandle(MODEL, "ClearParent", "", 0, null, null);
	EntFireByHandle(MODEL_HEAD, "SetParent", "!activator", 0, MODEL, null);
	EntFireByHandle(MODEL_HEAD, "setparentattachmentmaintainoffset", "attach_head", FrameTime(), null, null);
	EntFireByHandle(TANK_HEAD, "Kill", "", 0.5, null, null);
	EntFireByHandle(GRENADE, "Kill", "", 0.5, null, null);
	EntFireByHandle(self, "Kill", "", 0.5, null, null);
}

function AttackMelee(){
	if (STATE == "attack") return // Don't attack if already attacking;
	STATE <- "attack";
	GRENADE.__KeyValueFromInt("friction", 5); // Don't slide too much
	DebugPrint("[NPC] Attack");
	local sound = SND_ATTACK_MELEE[RandomInt(0, 1)];
	PlaySound(MODEL, sound, "2000");
	if (ANIMATION != "attack_melee"){
		EntFireByHandle(MODEL, "SetAnimation", "attack_melee", 0, null, null);
		ANIMATION <- "attack_melee";
	}
	EntFireByHandle(self, "RunScriptCode", "STATE<-null", 1.5, null, null);
	EntFireByHandle(HURT, "Explode", "", 1.2, null, null);
}

function AttackRange(){
	if (!IsLOS(ENEMY)) return
	if (STATE == "attack") return // Don't attack if already attacking;
	STATE <- "attack";
	GRENADE.__KeyValueFromInt("friction", 5); // Don't slide too much
	DebugPrint("[NPC] Attack Range")

	if (ANIMATION != "idle"){
		EntFireByHandle(MODEL, "SetAnimation", "idle", 0, null, null);
		ANIMATION <- "idle";
	}

	EntFireByHandle(BEAM, "TurnOn", "", 0, null, null);
}

function AttackRangeTouch(){
	if (RANGED_ATTACK_CD) return
	RANGED_ATTACK_CD <- true
	PlaySound(MODEL, SND_ATTACK_RANGED[0], "3000");

	EntFireByHandle(BEAM, "Width", "3", 0.3, null, null);
	EntFireByHandle(BEAM, "Alpha", "140", 0.3, null, null);
	EntFireByHandle(BEAM, "Width", "4", 0.6, null, null);
	EntFireByHandle(BEAM, "Alpha", "160", 0.6, null, null);
	EntFireByHandle(BEAM, "Width", "5", 0.9, null, null);
	EntFireByHandle(BEAM, "Alpha", "180", 0.9, null, null);
	EntFireByHandle(BEAM, "Width", "6", 1.2, null, null);
	EntFireByHandle(BEAM, "Alpha", "200", 1.2, null, null);
	EntFireByHandle(BEAM, "Width", "7", 1.5, null, null);
	EntFireByHandle(BEAM, "Alpha", "220", 1.5, null, null);

	EntFireByHandle(BEAM, "TurnOff", "", 1.6, null, null);

	EntFireByHandle(BEAM, "Width", "10", 1.7, null, null);
	EntFireByHandle(BEAM, "Alpha", "255", 1.7, null, null);

	EntFireByHandle(self, "RunScriptCode", "RANGED_ATTACK_DAMAGE<-true", 1.7, null, null);
	EntFireByHandle(self, "RunScriptCode", "RANGED_ATTACK_CD<-false", RandomInt(12, 20), null, null);

	EntFireByHandle(BEAM, "TurnOn", "", 1.8, null, null);

	EntFireByHandle(self, "RunScriptCode", "AttackRangeFire()", 1.9, null, null);
}

function AttackRangeFire(){
	if (!RANGED_ATTACK_DAMAGE) return
	RANGED_ATTACK_DAMAGE<-false;
	PlaySound(MODEL, SND_ATTACK_RANGED[1], "5000");

	if (activator != null && IsLOS(ENEMY)){
		local velocity = (activator.GetCenter() - GRENADE.GetCenter());

		velocity.Norm();
		velocity.x = velocity.x * 500;
		velocity.y = velocity.y * 500;
		velocity.z = 255;
		velocity = Vector(velocity.x, velocity.y, velocity.z);

		activator.SetVelocity(velocity);
		local health = activator.GetHealth()-RANGE_DAMAGE;
		EntFireByHandle(activator, "SetHealth", health.tostring(), 0, null, null);
	}

	EntFireByHandle(BEAM, "TurnOn", "", 0.0, null, null);
	EntFireByHandle(BEAM, "Width", "2", FrameTime(), null, null);
	EntFireByHandle(BEAM, "Alpha", "120", FrameTime(), null, null);
	EntFireByHandle(BEAM, "TurnOff", "", FrameTime(), null, null);
	EntFireByHandle(self, "RunScriptCode", "STATE<-null", 0.1, null, null);
}

function LookForEnemy(){
	DebugPrint("[NPC] Look for Enemy");
	if (DEAD) return

	local target = null;
	while (target=Entities.FindByClassname(target, "player")){
	if (target.IsValid() && (target.GetCenter()-GRENADE.GetCenter()).LengthSqr() < AGGRO_RANGE_SQR && target.GetTeam() == 3 && target.GetHealth() > 0 && IsLOS(target)){
		ENEMY = target;
		local enemy_name = RORPlayers[ENEMY.GetScriptScope().userid].targetname;
		EntFireByHandle(TANK_BASE, "settargetentityname", enemy_name, 0, null, null);
		EntFireByHandle(TANK_HEAD, "settargetentityname", enemy_name, 0, null, null);
		return
		}
		GRENADE.SetVelocity(Vector(null))
		if (ANIMATION != "idle"){
			EntFireByHandle(MODEL, "SetAnimation", "idle", 0, null, null);
			ANIMATION <- "idle";
		}
	}
}

function IsLOS(target_handle){
//	DebugPrint("[NPC] Is LOS");
	if (DEAD) return
	if (target_handle == null) return

	local start_trace = GRENADE.GetCenter();
	local end_trace = target_handle.GetCenter();

	if (TraceLine(start_trace, end_trace, GRENADE) < 1)return false

	return true
}

function IsEnemyTooFar(){
//	DebugPrint("[NPC] Is Enemy too far");
	if (DEAD)return
	if (ENEMY == null) return

	local distance = (GRENADE.GetCenter() - ENEMY.GetCenter()).LengthSqr()

	if ((distance > MELEE_DISTANCE_SQR)){
		return true
	}

	return false
}

function MoveToLastEnemyPositon(){
	if (STATE == "attack") return // Don't move if attacking
	GRENADE.__KeyValueFromInt("friction", 0.6); // Don't slide too much
	DebugPrint("[NPC] Move to last Enemy position");
	if (DEAD) return
	if (ENEMY == null) return
	local velocity = (ENEMY_LAST_POSITION - GRENADE.GetCenter());

	velocity.Norm();
	velocity.x = velocity.x * 125;
	velocity.y = velocity.y * 125;
	velocity.z = 20;
	velocity = Vector(velocity.x, velocity.y, velocity.z);

	if (!IsLOS(ENEMY)) LOS_COUNT ++;

	if (LOS_COUNT > 8){
		ENEMY = null;
		LOS_COUNT = 0;
		EntFireByHandle(TANK_BASE, "cleartargetentity", "", 0, null, null);
		EntFireByHandle(TANK_HEAD, "cleartargetentity", "", 0, null, null);
	}

	GRENADE.SetVelocity(velocity);
	local sound = SND_STEP[RandomInt(0, 3)];
	PlaySound(MODEL, sound, "2000");
	if (ANIMATION != "move"){
		EntFireByHandle(MODEL, "SetAnimation", "move", 0, null, null);
		ANIMATION <- "move";
	}
}


function MoveToEnemy(){
	if (STATE == "attack") return // Don't move if attacking
	GRENADE.__KeyValueFromInt("friction", 0.6); // Don't slide too much
//	DebugPrint("[NPC] Move to Enemy");
	if (DEAD) return
	if (ENEMY == null) return

	ENEMY_LAST_POSITION <- ENEMY.GetCenter();

	local velocity = (ENEMY.GetCenter() - GRENADE.GetCenter());

	velocity.Norm();
	velocity.x = velocity.x * 125;
	velocity.y = velocity.y * 125;
	velocity.z = 20;
	velocity = Vector(velocity.x, velocity.y, velocity.z);

	GRENADE.SetVelocity(velocity);
	local sound = SND_STEP[RandomInt(0, 3)];
	PlaySound(MODEL, sound, "2000");
	if (ANIMATION != "move"){
		EntFireByHandle(MODEL, "SetAnimation", "move", 0, null, null);
		ANIMATION <- "move";
	}
}