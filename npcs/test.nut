// handles
MODEL <- null;

// variables
NPC_POS <- Vector(null);
ENEMY_POS <- Vector(null);
ENEMY <- null;
NODES <- [];
NODES_MAX_COUNT <- 48;
NODES_MAX_DISTANCE <- NODES_MAX_COUNT/2;
NODES_MAX_TIME <- 0.5;
NODES_LAST_TIME <- null;

JUMP_TRACE_OFFSET <- 26;

TICK <- 0.1;

function OnPostSpawn(){
	MODEL = self.FirstMoveChild();

	self.__KeyValueFromInt("movetype", 0); // Disable movement
	self.__KeyValueFromInt("friction", 1); // Don't slide too much
	self.__KeyValueFromInt("collisiongroup", 10); // Don't block bullets
	self.SetSize(Vector(-16,-16,0), Vector(16,16,72)); // Custom bounding box

	EntFireByHandle(self, "AddOutput", "movetype 3", FrameTime(), null, null); // Re-enable movement

	Spawn();
}

function Spawn(){

}

function testThink(){
	// Mob doesn't have enemy, find it
	if (ENEMY == null){
		LookForEnemy(); // Find possible enemy
	}

	// Mob has enemy, do stuff
	if (ENEMY != null){
		MoveToEnemy(); // Move to player
	}

	return TICK // Think every 1 second
}

function LookForEnemy(){
	local target = null;


	// TODO: Add random target from array so it doesn't pick same player always
	while (target=Entities.FindByClassname(target, "player")){
	if (target.IsValid() && target.GetTeam() == 3 && target.GetHealth() > 0){
		ENEMY = target;
		ENEMY_POS = ENEMY.GetCenter();
		return
		}
	}
}

function NodeToGround(input_node){
	local down_vector = Vector(input_node.x, input_node.y, input_node.z-1000);
	local ground_z = VS.TraceLine(input_node, down_vector).GetPos();
	local node = Vector(input_node.x, input_node.y, ground_z.z+32);
	return node
}

function CalculateNodes(){
	if (NODES_LAST_TIME == null){
		NODES.push(ENEMY.GetCenter())
		NODES_LAST_TIME <- Time();
		return	DrawNodes();
	}
	if (NODES.len() >= NODES_MAX_COUNT){
		NODES.remove(0);
	}
	if ((Time() - NODES_LAST_TIME) > NODES_MAX_TIME){
		NODES.push(ENEMY.GetCenter())
		NODES_LAST_TIME <- Time();
		return	DrawNodes();
	}
	if (NODES[NODES.len()-1].Length() - ENEMY.GetCenter().Length() > NODES_MAX_DISTANCE || ENEMY.GetCenter().Length() - NODES[NODES.len()-1].Length() > NODES_MAX_DISTANCE ){
		NODES.push(ENEMY.GetCenter())
		NODES_LAST_TIME <- Time();
		return DrawNodes();
	}
	DrawNodes();
}

function DrawNodes(){
	foreach(index, node in NODES){
		StrictDebugDrawBox(NODES[index], Vector(-4,-4,-4), Vector(4,4,4), 0, 255, 128, 150, TICK+FrameTime());
		if (index !=NODES.len()-1){
			StrictDebugDrawLine(NODES[index], NODES[index+1], 0, 255, 150, true, TICK+FrameTime());
		}
	}
}

function MoveToEnemy(){
	CalculateNodes()
	NPC_POS = (self.GetOrigin())+(Vector(0,0,MODEL.GetBoundingMaxs().z/1.75));
	// Draw npc pos
	StrictDebugDrawBox(NPC_POS, Vector(-4,-4,-4), Vector(4,4,4), 0, 255, 0, 150, TICK+FrameTime()); // Mid

	StrictDebugDrawBox(self.GetOrigin()-(self.GetLeftVector()*JUMP_TRACE_OFFSET), Vector(-2,-2,-2), Vector(2,2,2), 0, 0, 255, 150, TICK+FrameTime()); // Right

	StrictDebugDrawBox(self.GetOrigin()+(self.GetLeftVector()*JUMP_TRACE_OFFSET), Vector(-2,-2,-2), Vector(2,2,2), 255, 0, 0, 150, TICK+FrameTime()); // Left

	target_node <- null;
	hitscan_count <- 0;
/*	foreach(index, node in NODES){
		if (NODES[index] == null) break
		if (TraceLinePlayersIncluded(NPC_POS, NODES[index], ENEMY) >= 1){
			target_node = NODES[index];
			StrictDebugDrawLine(NPC_POS, NODES[index], 255, 0, 0, true, TICK+FrameTime())
			break
		}
	}*/
	if (NODES.len() == 1){
		target_node <- NODES[0]
	}
	local boost_left = false;
	local boost_right = false;
	local jump_height = 0.0;
	local dont_move = false;
	for(local index = NODES.len()-1; index != 0; index--){
		if (NODES[index] == null) break

		if (TraceLinePlayersIncluded(NPC_POS, NODES[index], ENEMY) >= 1){ // Mid
			target_node <- NODES[index];

			foreach(node in NODES){

			}
			if ((self.GetCenter() - target_node).Length() < 20){
				dont_move = true;
			}
			StrictDebugDrawLine(NPC_POS, target_node, 0, 255, 0, true, TICK+FrameTime());
			if (TraceLinePlayersIncluded(self.GetOrigin()-(self.GetLeftVector()*JUMP_TRACE_OFFSET), target_node, ENEMY) < 1){ // Right
				boost_right = true;
				StrictDebugDrawLine(self.GetOrigin()-(self.GetLeftVector()*JUMP_TRACE_OFFSET), target_node, 0, 0, 255, true, TICK+FrameTime());
			}
			if (TraceLinePlayersIncluded(self.GetOrigin()+(self.GetLeftVector()*JUMP_TRACE_OFFSET), target_node, ENEMY) < 1){ // Left
				boost_left = true;
				StrictDebugDrawLine(self.GetOrigin()+(self.GetLeftVector()*JUMP_TRACE_OFFSET), target_node, 255, 0, 0, true, TICK+FrameTime());
			}

			local npc_height = MODEL.GetOrigin()+Vector(0,0,MODEL.GetBoundingMaxs().z)+(self.GetForwardVector()*JUMP_TRACE_OFFSET);
			local npc_bottom = MODEL.GetOrigin()+(self.GetForwardVector()*JUMP_TRACE_OFFSET);
			local npc_disp_bottom = MODEL.GetOrigin()+(self.GetForwardVector()*64);
			local npc_disp_top = MODEL.GetOrigin()+Vector(0,0,32)+(self.GetForwardVector()*64);

			local step_boost = false;
			if (TraceLinePlayersIncluded(npc_bottom, npc_bottom, ENEMY) < 0.99){ // there's a step in front of npc
				StrictDebugDrawLine(npc_height, npc_bottom, 255, 0, 0, false, TICK+FrameTime()); // Draw top to down in front of npc

				local step_height_delta = 1-TraceLinePlayersIncluded(npc_height, npc_bottom, ENEMY); // Top to down in front of npc
				//printl("Step height delta: "+step_height_delta);

				local step_height_origin = Vector(npc_bottom.x, npc_bottom.y, (npc_height.z + npc_bottom.z)*step_height_delta);
				//printl("Step height origin: "+step_height_origin);

				StrictDebugDrawBox(step_height_origin, Vector(-2,-2,-2), Vector(2,2,2), 255, 128, 0, 200, TICK+FrameTime()); // Top of npc model <PINK>

				StrictDebugDrawBox(npc_height, Vector(-2,-2,-2), Vector(2,2,2), 255, 0, 128, 200, TICK+FrameTime()); // Top of npc model <ORANGE>

				StrictDebugDrawBox(npc_bottom, Vector(-2,-2,-2), Vector(2,2,2), 0, 255, 255, 200, TICK+FrameTime()); // bottom of npc <CYAN>

				jump_height = 150*(1+step_height_delta);
				step_boost = true
			}

			if (TraceLinePlayersIncluded(npc_disp_top, npc_disp_bottom, ENEMY) < 0.99 && step_boost == false){ // Displacement boost check
				StrictDebugDrawLine(npc_disp_top, npc_disp_bottom, 255, 0, 0, false, TICK+FrameTime());
				jump_height = 100;
			}

			step_boost = false;
		break
		}
	}

	//printl("node: "+target_node);
	//printl("NPC_POS: "+NPC_POS);
	if (target_node == null) return
	local velocity = (target_node - NPC_POS);
	velocity.Norm();
	velocity.x = velocity.x * 325;
	velocity.y = velocity.y * 325;
	velocity.z = self.GetVelocity().z;

	printl(self.GetVelocity().z)

	local angles_delta = target_node - self.GetOrigin();
	angles_delta.Norm();
	self.SetForwardVector(Vector(angles_delta.x, angles_delta.y, 0))

	if (dont_move){
		self.SetVelocity(Vector(0,0,self.GetVelocity().z));
		dont_move = false;
		return
	}

	if (boost_left){
		velocity = Vector(velocity.x, velocity.y velocity.z)-(self.GetLeftVector()*120);
	}
	else if(boost_right){
		velocity = Vector(velocity.x, velocity.y, velocity.z)+(self.GetLeftVector()*120);
	}
	else{
		velocity = Vector(velocity.x, velocity.y, velocity.z);
	}

	if (jump_height > 0 && self.GetVelocity().z < 20){
		velocity.z = jump_height
	}

	/*if (velocity.z != 0){
		velocity.x = clamp(velocity.x, -50, 50); // Don't be too fast if mid jump
	velocity.y = clamp(velocity.y, -50, 50); // ditto
	}*/

	self.SetVelocity(velocity);

	boost_left = false;
	boost_right = false;
}








// utility functions and shit

DRAW_DEBUG <- false;

function clamp(v,mi,ma)
{
	if(v < mi) return mi;
	if(v > ma) return ma;
	return v;
}

function StrictDebugDrawBox(origin, mins, max, r, g, b, alpha, duration){
	if(!DRAW_DEBUG) return
	DebugDrawBox(origin, mins, max, r, g, b, alpha, duration)
}

function StrictDebugDrawLine(start, end, r, g, b, noDepthTest, duration){
	if(!DRAW_DEBUG) return
	DebugDrawLine(start, end, r, g, b, noDepthTest, duration)
}