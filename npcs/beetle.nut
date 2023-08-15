// handles
TANK <- null;
HITBOX <- null;
MODEL <- null;
HURT <- null;

// variables
DEAD <- false;
SPAWNING <- true;
ENEMY_LAST_POSITION <- null;
LOS_COUNT <- 0;

ENEMY <- null;

AGGRO_RANGE <- 450;
AGGRO_RANGE_SQR <- AGGRO_RANGE * AGGRO_RANGE;

MELEE_DISTANCE <- 90;
MELEE_DISTANCE_SQR <- MELEE_DISTANCE * MELEE_DISTANCE;

ATTACK_DAMAGE <- 50;
DAMAGE_TYPE <- 4; // SLASH

SND_SPAWN <- "darnias/ror2/npcs/beetle/beetle_worker_spawn.mp3";
SND_ATTACK <- "darnias/ror2/npcs/beetle/beetle_worker_attack.mp3";
SND_DEATH <- "darnias/ror2/npcs/beetle/beetle_worker_death.mp3";
SND_HURT <- ["darnias/ror2/npcs/beetle/beetle_worker_impact_1.mp3","darnias/ror2/npcs/beetle/beetle_worker_impact_2.mp3","darnias/ror2/npcs/beetle/beetle_worker_impact_3.mp3","darnias/ror2/npcs/beetle/beetle_worker_impact_4.mp3"];
SND_STEP <- ["darnias/ror2/npcs/beetle/beetle_worker_step_1.mp3","darnias/ror2/npcs/beetle/beetle_worker_step_2.mp3","darnias/ror2/npcs/beetle/beetle_worker_step_3.mp3","darnias/ror2/npcs/beetle/beetle_worker_step_4.mp3"];

function OnPostSpawn(){
	TANK = self.FirstMoveChild();
	MODEL = TANK.FirstMoveChild();
	HURT = MODEL.FirstMoveChild();
	HITBOX = HURT.FirstMoveChild();

	self.__KeyValueFromInt("movetype", 0); // Disable movement
	self.__KeyValueFromInt("friction", 2); // Don't slide too much
	self.__KeyValueFromInt("collisiongroup", 10); // Don't block bullets
	self.SetSize(Vector(-22,-22,-2), Vector(22,22,44)); // Custom bounding box

	HITBOX.__KeyValueFromInt("material", 3); // Flesh material

	HURT.__KeyValueFromInt("damage", ATTACK_DAMAGE);
	HURT.__KeyValueFromInt("damagetype", DAMAGE_TYPE);

	EntFireByHandle(MODEL, "SetAnimation", "spawn", 0, null, null);

	EntFireByHandle(self, "AddOutput", "movetype 3", FrameTime(), null, null); // Re-enable movement
	Spawn();
}


function beetleThink(){
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
		if (IsEnemyTooFar()){ // If enemy is too far
			if (!IsLOS(ENEMY)){ // If we can't see player
				MoveToLastEnemyPositon(); // Move to where we last saw player
			}
			else{ // If we can see player
				MoveToEnemy(); // Move to player
			}
		}
		else{ // Enemy is not too far
			Attack();
		}
	}

	return 1.0 // Think every 1 second
}

function Spawn(){
	PlaySound(MODEL, SND_SPAWN, "2000");
}

function Hurt(){
	local sound = SND_HURT[RandomInt(0, 3)];
	PlaySound(MODEL, sound, "2000");
}

function Death(){
	DebugPrint("[NPC] Death");
	DEAD <- true;
	PlaySound(MODEL, SND_DEATH, "2000");
	self.SetVelocity(Vector(0,0,-16));
	HURT.Destroy();
	EntFireByHandle(MODEL, "ClearParent", "", 0, null, null);
	EntFireByHandle(self, "Kill", "", 0.5, null, null);
}

function Attack(){
	DebugPrint("[NPC] Attack");
	PlaySound(MODEL, SND_ATTACK, "2000");
	EntFireByHandle(HURT, "Enable", "", 0.2, null, null);
	EntFireByHandle(MODEL, "SetAnimation", "attack", 0, null, null);
	EntFireByHandle(HURT, "Disable", "", 0.75, null, null);
}

function LookForEnemy(){
	DebugPrint("[NPC] Look for Enemy");
	if (DEAD) return

	local target = null;
	while (target=Entities.FindByClassname(target, "player")){
	if (target.IsValid() && (target.GetCenter()-self.GetCenter()).LengthSqr() < AGGRO_RANGE_SQR && target.GetTeam() == 3 && target.GetHealth() > 0 && IsLOS(target)){
		ENEMY = target;
		local enemy_name = RORPlayers[ENEMY.GetScriptScope().userid].targetname;
		EntFireByHandle(TANK, "settargetentityname", enemy_name, 0, null, null);
		return
		}
	}
}

function IsLOS(target_handle){
//	DebugPrint("[NPC] Is LOS");
	if (DEAD) return
	if (target_handle == null) return

	local start_trace = self.GetCenter();
	local end_trace = target_handle.GetCenter();

	if (TraceLine(start_trace, end_trace, self) < 1)return false

	return true
}

function IsEnemyTooFar(){
//	DebugPrint("[NPC] Is Enemy too far");
	if (DEAD)return
	if (ENEMY == null) return

	local distance = (self.GetCenter() - ENEMY.GetCenter()).LengthSqr()

	if ((distance > MELEE_DISTANCE_SQR)){
		return true
	}

	return false
}

function MoveToLastEnemyPositon(){
	DebugPrint("[NPC] Move to last Enemy position");
	if (DEAD) return
	if (ENEMY == null) return
	local velocity = (ENEMY_LAST_POSITION - self.GetCenter());

	velocity.Norm();
	velocity.x = velocity.x * 200;
	velocity.y = velocity.y * 200;
	velocity.z = 220;
	velocity = Vector(velocity.x, velocity.y, velocity.z);

	if (!IsLOS(ENEMY)) LOS_COUNT ++;

	if (LOS_COUNT > 8){
		ENEMY = null;
		LOS_COUNT = 0;
		EntFireByHandle(TANK, "cleartargetentity", "", 0, null, null);
	}

	self.SetVelocity(velocity);
	local sound = SND_STEP[RandomInt(0, 3)];
	PlaySound(MODEL, sound, "2000");
//	EntFireByHandle(self, "RunScriptCode", "self.SetVelocity(Vector("+velocity.x+", "+velocity.y+", "+velocity.z+"))", 0.25, null, null);
	EntFireByHandle(MODEL, "SetAnimation", "hop", 0, null, null);
}


function MoveToEnemy(){
//	DebugPrint("[NPC] Move to Enemy");
	if (DEAD) return
	if (ENEMY == null) return

	ENEMY_LAST_POSITION <- ENEMY.GetCenter();

	local velocity = (ENEMY.GetCenter() - self.GetCenter());

	velocity.Norm();
	velocity.x = velocity.x * 200;
	velocity.y = velocity.y * 200;
	velocity.z = 220;
	velocity = Vector(velocity.x, velocity.y, velocity.z);
	self.SetVelocity(velocity);
	local sound = SND_STEP[RandomInt(0, 3)];
	PlaySound(MODEL, sound, "2000");
//	EntFireByHandle(self, "RunScriptCode", "self.SetVelocity(Vector("+velocity.x+", "+velocity.y+", "+velocity.z+"))", 0.25, null, null);
	EntFireByHandle(MODEL, "SetAnimation", "hop", 0, null, null);
}