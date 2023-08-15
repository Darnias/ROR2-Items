enum ITEMS{ // Translate item strings
	steak			= "steak",
	hopoo			= "hopoo",
	wax				= "wax",
	hoof			= "hoof",
	gasoline		= "gasoline",
	potion			= "potion",
	glasses			= "glasses",
	gastank			= "gastank",
	tentabauble		= "tentabauble",
	chronobauble	= "chronobauble",
	seed			= "seed",
	crowbar			= "crowbar",
	fungus			= "fungus",
	aegis			= "aegis",
	magazine		= "magazine",
	raincoat		= "raincoat",
	clover			= "clover",
	medkit			= "medkit",
	microbots		= "microbots",
	stungrenade		= "stungrenade",
	stealthkit		= "stealthkit",
	razorwire		= "razorwire",
	crystal			= "crystal",

	singularity 	= "singularity",
}

::ItemStringToIndex <- function(item){  // Translate name strings to table index
	switch(item){
		case "steak" 		: return 0
		case "hopoo" 		: return 1
		case "wax" 			: return 2
		case "hoof" 		: return 3
		case "gasoline" 	: return 4
		case "potion" 		: return 5
		case "glasses" 		: return 6
		case "gastank" 		: return 7
		case "tentabauble" 	: return 8
		case "chronobauble"	: return 9
		case "seed" 		: return 10
		case "crowbar" 		: return 11
		case "fungus" 		: return 12
		case "aegis" 		: return 13
		case "magazine" 	: return 14
		case "raincoat" 	: return 15
		case "clover" 		: return 16
		case "medkit" 		: return 17
		case "microbots" 	: return 18
		case "stungrenade"	: return 19
		case "stealthkit"	: return 20
		case "razorwire"	: return 21
		case "crystal"		: return 22

		default				: return null
	}
}

::ItemRarityToRGB <- function(rarity){
	switch(rarity){
		case "common" 		: return "220 220 220"
		case "uncommon" 	: return "0 255 0"
		case "void" 		: return "225 50 134"
		case "legendary" 	: return "225 0 0"

		default 			: return null
	}
}

::items <- [ // Information about items
	/* Template item
	{
		name = "Dummy",		// Item name
		name_full = "Foo",	// Full item name
		description = "",	// Description text
		rarity = "",		// Rarity
		model = "",			// Model string
		bodygroup = 0,		// Bodygroup int
		team = 0			// What team this item is for (3 CT, 2 T, 0 ANY)
		cooldown = 0,		// Item cooldown
		cooldown_sub = 0,	// Item cooldown reduction
		cast = 0,			// Gold cost of item
		cost_mult = 1,		// Cost multiplier
		proc_base = 100,	// Base proc %
		proc_add = 100,		// Additive proc %
		effect_base = 100,	// Base effect %
		effect_add = 100,	// Additive effect %
		duration_base = 0,	// Effect duration
		duration_add = 0,	// Additive duration
		max = 100,			// Max stack count
		banned = false		// Item allowed or not
		sound1 = "",		// Optional sound for procs etc.
	}*/
	// [0] steak
	{
		name = "steak",
		name_full = "Bison Steak",
		description = "Increase max health",
		rarity = "common",
		model = "models/darnias/ror2/items/steak.mdl",
		bodygroup_ct = 1<<0,
		team = 3,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 100,
		proc_add = 0,
		effect_base = 25,
		effect_add = 25,
		duration_base = 0,
		duration_add = 0,
		max = 0,
		banned = false,
	}
	// [1] Hopoo Feather
	{
		name = "hopoo",
		name_full = "Hopoo Feather",
		description = "Gain an additional jump",
		rarity = "uncommon",
		model = "models/darnias/ror2/items/feather.mdl",
		bodygroup_ct = 1<<1,
		team = 0,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 100,
		proc_add = 0,
		effect_base = 1,
		effect_add = 0,
		duration_base = 0,
		duration_add = 0,
		max = 0,
		banned = false,
		sound1 = "darnias/ror2/items/hopoo/item_proc_feather_01.mp3",
		sound2 = "darnias/ror2/items/hopoo/item_proc_feather_02.mp3",
		sound3 = "darnias/ror2/items/hopoo/item_proc_feather_03.mp3",
	}
	// [2] Wax Quail
	{
		name = "wax",
		name_full = "Wax Quail",
		description = "Jumping gives a velocity boost",
		rarity = "uncommon",
		model = "models/darnias/ror2/items/wax.mdl",
		bodygroup_ct = 1<<2,
		team = 0,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 100,
		proc_add = 0,
		effect_base = 0.3,	// Boost velocity by 30%
		effect_add = 0.15,	// Additional boost by 15%
		duration_base = 0,
		duration_add = 0,
		max = 0,
		banned = false,
		sound1 = "darnias/ror2/items/wax/char_land_sweet_02.mp3",
	}
	// [3] Paul's Goat Hoof
	{
		name = "hoof",
		name_full = "Paul's Goat Hoof",
		description = "Increases movement speed",
		rarity = "common",
		model = "models/darnias/ror2/items/hoof.mdl",
		bodygroup_ct = 1<<3,
		team = 0,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 100,
		proc_add = 0,
		effect_base = 0.03,	// Boost movement speed by 3%
		effect_add = 0.02,	// Additional speed by 2%
		duration_base = 0,
		duration_add = 0,
		max = 0,
		banned = false,
	}
	// [4] Gasoline
	{
		name = "gasoline",
		name_full = "Gasoline",
		description = "Killing an enemy ignites other nearby enemies",
		rarity = "common",
		model = "models/darnias/ror2/items/gasoline.mdl",
		bodygroup_ct = 1<<4,
		team = 3,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 100,
		proc_add = 0,
		effect_base = 0.20,	// Slows movement speed by 20%
		effect_add = 0.10,	// Additional slow by 10%
		duration_base = 8,	// Slow for 8 seconds
		duration_add = 0,
		max = 0,
		banned = false,
		sound1 = "darnias/ror2/items/gasoline/item_proc_igniteOnKill_01.mp3",
		sound2 = "darnias/ror2/items/gasoline/item_proc_igniteOnKill_02.mp3",
		sound3 = "darnias/ror2/items/gasoline/item_proc_igniteOnKill_03.mp3",
	}
	// [5] Power Elixir
	{
		name = "potion",
		name_full = "Power Elixir",
		description = "Heal for 75% after dropping below 25%",
		rarity = "common",
		model = "models/darnias/ror2/items/potion.mdl",
		bodygroup_ct = 1<<5,
		team = 0,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 100,
		proc_add = 0,
		effect_base = 0.75,	// Heal for 75% of max health
		effect_add = 0,		// Elixir doesn't stack
		duration_base = 0,
		duration_add = 0,
		max = 0,
		banned = false,
		sound1 = "darnias/ror2/items/potion/proc_healingPotion1.mp3",
		sound2 = "darnias/ror2/items/potion/proc_healingPotion2.mp3",
		sound3 = "darnias/ror2/items/potion/proc_healingPotion3.mp3",
		sound4 = "darnias/ror2/items/potion/proc_healingPotion4.mp3",
	}
	// [6] Lens-Maker's Glasses
	{
		name = "glasses",
		name_full = "Lens-Maker's Glasses",
		description = "Gain a chance to deal double damage",
		rarity = "common",
		model = "models/darnias/ror2/items/glasses.mdl",
		bodygroup_ct = 1<<6,
		team = 3,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 10,
		proc_add = 10,
		effect_base = 2, // Increases damage by 100%
		effect_add = 0,
		duration_base = 0,
		duration_add = 0,
		max = 10,
		banned = false,
	}
	// [7] Ignition Tank
	{
		name = "gastank",
		name_full = "Ignition Tank",
		description = "Chance to ignite enemy on hit",
		rarity = "uncommon",
		model = "models/darnias/ror2/items/gastank.mdl",
		bodygroup_ct = 1<<7,
		team = 3,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 2,		// 2% to proc
		proc_add = 2,		// +2% to proc
		effect_base = 0.20,	// Slows movement speed by 20%
		effect_add = 0.10,	// Additional slow by 10%
		duration_base = 8,	// Slow for 8 seconds
		duration_add = 0,
		max = 0,
		banned = false,
		sound1 = "darnias/ror2/items/gasoline/item_proc_igniteOnKill_01.mp3",
		sound2 = "darnias/ror2/items/gasoline/item_proc_igniteOnKill_02.mp3",
		sound3 = "darnias/ror2/items/gasoline/item_proc_igniteOnKill_03.mp3",
	}
	// [8] Tentabauble
	{
		name = "tentabauble",
		name_full = "Tentabauble",
		description = "Chance to root enemy on hit",
		rarity = "void",
		model = "models/darnias/ror2/items/tentabauble.mdl",
		bodygroup_ct = 1<<8,
		team = 3,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 2,			// 2% to proc
		proc_add = 2,			// +2% to proc
		effect_base = 0,
		effect_add = 0,
		duration_base = 2,		// Root for 2 seconds
		duration_add = 0.25,	// Root for +0.25 seconds
		max = 0,
		banned = false,
		sound1 = "darnias/ror2/items/tentabauble/void_slowOnHit1.mp3",
		sound2 = "darnias/ror2/items/tentabauble/void_slowOnHit2.mp3",
		sound3 = "darnias/ror2/items/tentabauble/void_slowOnHit3.mp3",
		sound4 = "darnias/ror2/items/tentabauble/void_slowOnHit4.mp3",
	}
	// [9] Chronobauble
	{
		name = "chronobauble",
		name_full = "Chronobauble",
		description = "Chance to slow enemy on hit",
		rarity = "uncommon",
		model = "models/darnias/ror2/items/chronobauble.mdl",
		bodygroup_ct = 1<<9,
		team = 3,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 3,		// 3% to proc
		proc_add = 3,		// +3% to proc
		effect_base = 0.10,	// Slow by 10%
		effect_add = 0.05,	// Slow by 5%
		duration_base =	3,	// Slow for 3 seconds
		duration_add =	1,	// Root for +1 seconds
		max = 0,
		banned = false,
	}
	// [10] Leeching Seed
	{
		name = "seed",
		name_full = "Leeching Seed",
		description = "Dealing damage heals you",
		rarity = "uncommon",
		model = "models/darnias/ror2/items/seed.mdl",
		bodygroup_ct = 1<<10,
		team = 3,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 100,
		proc_add = 0,
		effect_base = 1,
		effect_add = 1,
		duration_base =	0,
		duration_add =	0,
		max = 0,
		banned = false,
	}
	// [11] Crowbar
	{
		name = "crowbar",
		name_full = "Crowbar",
		description = "Deal increased damage to enemies above 90%",
		rarity = "common",
		model = "models/darnias/ror2/items/crowbar.mdl",
		bodygroup_ct = 1<<11,
		team = 3,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 100,
		proc_add = 0,
		effect_base = 1,	// Double damage
		effect_add = 1, 	// Double damage
		duration_base =	0,
		duration_add =	0,
		max = 0,
		banned = false,
		sound1 = "darnias/ror2/items/crowbar/item_proc_crowbar_02.mp3",
		sound2 = "darnias/ror2/items/crowbar/item_proc_crowbar_03.mp3",
	}
	// [12] Weeping Fungus
	{
		name = "fungus",
		name_full = "Weeping Fungus",
		description = "Moving heals you",
		rarity = "void",
		model = "models/darnias/ror2/items/weeping_fungus.mdl",
		bodygroup_t = 0,
		team = 2,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 100,
		proc_add = 0,
		effect_base = 50,	// 50 Steps base
		effect_add = -5, 	// -5 Steps per stack
		duration_base =	0,
		duration_add =	0,
		max = 10, 			// Every 5 steps will heal at 10 stacks
		banned = false,
		sound1 = "darnias/ror2/items/weeping_fungus/void_mushroom1.mp3",
	}
	// [13] Aegis
	{
		name = "aegis",
		name_full = "Aegis",
		description = "Periodically replenishes Armor",
		rarity = "legendary",
		model = "models/darnias/ror2/items/aegis.mdl",
		bodygroup_ct = 1<<12,
		team = 3,
		cooldown = 90,
		cooldown_sub = 15,
		cost = 0,
		cost_mult = 1,
		proc_base = 100,
		proc_add = 0,
		effect_base = 0,
		effect_add = 0,
		duration_base =	0,
		duration_add =	0,
		max = 6,			// 15 sec restock cd at 6 stacks
		banned = false,
	}
	// [14] Backup Magazine
	{
		name = "magazine",
		name_full = "Backup Magazine",
		description = "Manual reloading gives bonus ammo",
		rarity = "common",
		model = "models/darnias/ror2/items/magazine.mdl",
		bodygroup_ct = 1<<13,
		team = 3,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 100,
		proc_add = 0,
		effect_base = 1.1,	// 10% more ammo on reload
		effect_add = 0.1,	// +10% more ammo on reload
		duration_base =	0,
		duration_add =	0,
		max = 0,
		banned = false,
	}
	// [15] Ben's Raincoat
	{
		name = "raincoat",
		name_full = "Ben's Raincoat",
		description = "Reduces debuff duration",
		rarity = "legendary",
		model = "models/darnias/ror2/items/raincoat.mdl",
		bodygroup_t = 0,
		team = 2,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 100,
		proc_add = 0,
		effect_base = 0.80,	// -20% duration
		effect_add = -0.20,	// -20% duration
		duration_base =	0,
		duration_add =	0,
		max = 4,			// 4 items max = -80% duration
		banned = false,
	}
	// [16] 57 Leaf Clover
	{
		name = "clover",
		name_full = "57 Leaf Clover",
		description = "Increases your proc chance luck",
		rarity = "legendary",
		model = "models/darnias/ror2/items/clover.mdl",
		bodygroup_ct = 1<<14,
		team = 0,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 0,
		proc_add = 0,
		effect_base = 1.1,	// +10% proc chance
		effect_add = 0.1,	// +10% proc chance
		duration_base =	0,
		duration_add =	0,
		max = 0,
		banned = false,
	}
		// [17] Medkit
	{
		name = "medkit",
		name_full = "Medkit",
		description = "Taking damage heals you",
		rarity = "common",
		model = "models/darnias/ror2/items/medkit.mdl",
		bodygroup_ct = 1<<15,
		team = 0,
		cooldown = 60,
		cooldown_sub = 3,
		cost = 0,
		cost_mult = 1,
		proc_base = 100,
		proc_add = 0,
		effect_base = 0.2,	// 20% hp
		effect_add = 0.05,	// +5% hp
		duration_base =	0,
		duration_add =	0,
		max = 16,			// 15 sec cd
		banned = false,
		sound1 = "darnias/ror2/items/medkit/Item_proc_medkit.mp3",
	}
	// [18] Defensive Microbots
	{
		name = "microbots",
		name_full = "Defensive Microbots",
		description = "Chance to nullify movement effects on hit",
		rarity = "legendary",
		model = "models/darnias/ror2/items/microbots.mdl",
		bodygroup_t = 0,
		team = 2,
		cooldown = 30,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 1,
		proc_add = 1,
		effect_base = 0,
		effect_add = 0,
		duration_base =	3,
		duration_add =	0,
		max = 0,
		banned = false,
	}
	// [19] Stun Grenade
	{
		name = "stungrenade",
		name_full = "Stun Grenade",
		description = "Chance explode and stun enemies on hit",
		rarity = "common",
		model = "models/darnias/ror2/items/stungrenade.mdl",
		bodygroup_ct = 1<<16,
		team = 3,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 1,
		proc_base = 2,		// 2% proc chance
		proc_add = 2,		// +2% proc chance
		effect_base = 175,	// 150 units radius
		effect_add = 25,	// +25 units radius
		duration_base =	0,
		duration_add =	0,
		max = 0,
		banned = false,
	}
	// [20] Old War Stealthkit
	{
		name = "stealthkit",
		name_full = "Old War Stealthkit",
		description = "Turn invisible when low on hp",
		rarity = "uncommon",
		model = "models/darnias/ror2/items/stealthkit.mdl",
		bodygroup_t = 0,
		team = 2,
		cooldown = 45,
		cooldown_sub = 3,
		cost = 0,
		cost_mult = 1,
		proc_base = 0,
		proc_add = 0,
		effect_base = 0.1,
		effect_add = 0.05,
		duration_base =	5,
		duration_add =	0,
		max = 10,
		banned = false,
		sound1 = "darnias/ror2/items/stealthkit/phasing.mp3",
	}
	// [21] Razorwire
	{
		name = "razorwire",
		name_full = "Razorwire",
		description = "Retaliate by shooting your victim with a razor",
		rarity = "uncommon",
		model = "models/darnias/ror2/items/razorwire.mdl",
		bodygroup_t = 0,
		team = 2,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 0,
		proc_base = 2,
		proc_add = 2,
		effect_base = 3,
		effect_add = 3,
		duration_base =	0,
		duration_add =	0,
		max = 0,
		banned = false,
	}
	// [22] Focus Crystal
	{
		name = "crystal",
		name_full = "Focus Crystal",
		description = "Deal periodic damage to nearby enemies",
		rarity = "common",
		model = "models/darnias/ror2/items/crystal.mdl",
		bodygroup_t = 0,
		team = 2,
		cooldown = 0,
		cooldown_sub = 0,
		cost = 0,
		cost_mult = 0,
		proc_base = 100,
		proc_add = 0,
		effect_base = 6,
		effect_add = 2,
		duration_base =	0,
		duration_add =	0,
		max = 0,
		banned = false,
	}

]