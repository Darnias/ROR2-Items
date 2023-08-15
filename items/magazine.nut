::weapon_mag_size <- {
	// Pistols
	weapon_usp_silencer = 12,
	weapon_hkp2000 = 13,
	weapon_glock = 20,
	weapon_deagle = 7,
	weapon_cz75a = 12,
	weapon_fiveseven = 20,
	weapon_p250 = 13,
	weapon_elite = 30,
	weapoon_revolver = 8,
	weapon_tec9 = 18,
	// SMGs
	weapon_mp9 = 30,
	weapon_ump45 = 25,
	weapon_p90 = 50,
	weapon_bizon = 64,
	weapon_mac10 = 30,
	weapon_mp5sd = 30,
	weapon_mp7 = 30,
	// Heavy
	weapon_mag7 = 5,
	weapon_nova = 8,
	weapon_sawedoff = 7,
	weapon_xm1014 = 7,
	weapon_m249 = 100,
	weapon_negev = 150,
	// Rifles
	weapon_ak47 = 30,
	weapon_aug = 30,
	weapon_sg556 = 30,
	weapon_famas = 25,
	weapon_m4a1_silencer = 20,
	weapon_m4a1 = 30,
	weapon_galilar = 35,
	// Sniper
	weapon_awp = 5,
	weapon_ssg08 = 10,
	weapon_scar20 = 20,
	weapon_g3sg1 = 20,
}

::weapon_reload_time <- {
	// Pistols
	weapon_usp_silencer = 2.17,
	weapon_hkp2000 = 2.27,
	weapon_glock = 2.27,
	weapon_deagle = 2.20,
	weapon_cz75a = 2.83,
	weapon_fiveseven = 2.27,
	weapon_p250 = 2.27,
	weapon_elite = 3.77,
	weapoon_revolver = 2.27,
	weapon_tec9 = 2.57,
	// SMGs
	weapon_mp9 = 2.13,
	weapon_ump45 = 3.43,
	weapon_p90 = 3.37,
	weapon_bizon = 2.43,
	weapon_mac10 = 2.57,
	weapon_mp5sd = 2.94,
	weapon_mp7 = 3.13,
	// Heavy
	weapon_mag7 = 2.47,
	weapon_nova = 4.74,
	weapon_sawedoff = 4.22,
	weapon_xm1014 = 4.22,
	weapon_m249 = 5.70,
	weapon_negev = 5.70,
	// Rifles
	weapon_ak47 = 2.43,
	weapon_aug = 3.77,
	weapon_sg556 = 2.77,
	weapon_famas = 3.30,
	weapon_m4a1_silencer = 3.07,
	weapon_m4a1 = 3.07,
	weapon_galilar = 3.03,
	// Sniper
	weapon_awp = 3.67,
	weapon_ssg08 = 3.70,
	weapon_scar20 = 3.07,
	weapon_g3sg1 = 4.67,
}

::GetHeldWeaponName <- function(handle = null){ // Returns the currently held weapon as a string
	if (handle == null || typeof handle != "instance")return null; // Check for correct inputs
	local vm = null;
	while (vm = Entities.FindByClassname(vm, "predicted_viewmodel")){
		if (vm.GetMoveParent() == handle)return ModelToClassname(vm.GetModelName())
	}
	return null
}

::GetHeldWeaponHandle <- function(handle = null){ // Returns the currently held weapon as a handle
	if (handle == null || typeof handle != "instance")return null; // Check for correct inputs
	local weapon = null;
	while (weapon = Entities.FindByClassname(weapon, "weapon_*")){
		if (weapon.GetMoveParent() == handle){
			local WeaponName = GetHeldWeaponName(handle);
			switch (WeaponName){ // These weapons inherit classname
				case "weapon_axe":
				case "weapon_hammer":
				case "weapon_spanner": WeaponName = "weapon_melee";break
				case "weapon_usp_silencer": WeaponName = "weapon_hkp2000";break
				case "weapon_cz75a": WeaponName = "weapon_p250";break
				case "weapon_revolver": WeaponName = "weapon_deagle";break
				case "weapon_m4a1_silencer": WeaponName = "weapon_m4a1";break
				case "weapon_mp5sd": WeaponName = "weapon_mp7";break
			}
			if (weapon.GetClassname() == WeaponName)return weapon
		}
	}
	return null
}

::ModelToClassname <- function(weapon = null){
	if (weapon == null || typeof weapon != "string")		return null; // Check for correct inputs
	if (weapon == "models/weapons/v_knife_gg.mdl")			return "weapon_knifegg"; // weapon_knifegg is unique
	if (weapon.find("models/weapons/v_knife") == 0)			return "weapon_knife";  // all knives are weapon_knife
	switch (weapon){
		case "models/weapons/v_axe.mdl":					return "weapon_axe"; // Fake
		case "models/weapons/v_breachcharge.mdl":			return "weapon_breachcharge";
		case "models/weapons/v_bumpmine.mdl":				return "weapon_bumpmine";
		case "models/weapons/v_eq_decoy.mdl":				return "weapon_decoy";
		case "models/weapons/v_eq_flashbang.mdl":			return "weapon_flashbang";
		case "models/weapons/v_eq_fraggrenade.mdl":			return "weapon_hegrenade";
		case "models/weapons/v_eq_incendiarygrenade.mdl":	return "weapon_incgrenade";
		case "models/weapons/v_eq_molotov.mdl":				return "weapon_molotov";
		case "models/weapons/v_eq_smokegrenade.mdl":		return "weapon_smokegrenade";
		case "models/weapons/v_eq_snowball.mdl":			return "weapon_snowball";
		case "models/weapons/v_eq_taser.mdl":				return "weapon_taser";
		case "models/weapons/v_fists.mdl":					return "weapon_fists";
		case "models/weapons/v_hammer.mdl":					return "weapon_hammer"; // Fake
		case "models/weapons/v_healthshot.mdl":				return "weapon_healthshot";
		case "models/weapons/v_ied.mdl":					return "weapon_c4";
		case "models/weapons/v_mach_m249para.mdl":			return "weapon_m249";
		case "models/weapons/v_mach_negev.mdl":				return "weapon_negev";
		case "models/weapons/v_pist_223.mdl":				return "weapon_usp_silencer"; // Fake
		case "models/weapons/v_pist_cz_75.mdl":				return "weapon_cz75a"; // Fake
		case "models/weapons/v_pist_deagle.mdl":			return "weapon_deagle";
		case "models/weapons/v_pist_elite.mdl":				return "weapon_elite";
		case "models/weapons/v_pist_fiveseven.mdl":			return "weapon_fiveseven";
		case "models/weapons/v_pist_glock18.mdl":			return "weapon_glock";
		case "models/weapons/v_pist_hkp2000.mdl":			return "weapon_hkp2000";
		case "models/weapons/v_pist_p250.mdl":				return "weapon_p250";
		case "models/weapons/v_pist_revolver.mdl":			return "weapon_revolver"; // Fake
		case "models/weapons/v_pist_tec9.mdl":				return "weapon_tec9";
		case "models/weapons/v_repulsor.mdl":				return "weapon_zone_repulsor";
		case "models/weapons/v_rif_ak47.mdl":				return "weapon_ak47";
		case "models/weapons/v_rif_aug.mdl":				return "weapon_aug";
		case "models/weapons/v_rif_famas.mdl":				return "weapon_famas";
		case "models/weapons/v_rif_galilar.mdl":			return "weapon_galilar";
		case "models/weapons/v_rif_m4a1.mdl":				return "weapon_m4a1";
		case "models/weapons/v_rif_m4a1_s.mdl":				return "weapon_m4a1_silencer"; // Fake
		case "models/weapons/v_rif_sg556.mdl":				return "weapon_sg556";
		case "models/weapons/v_shield.mdl":					return "weapon_shield";
		case "models/weapons/v_shot_mag7.mdl":				return "weapon_mag7";
		case "models/weapons/v_shot_nova.mdl":				return "weapon_nova";
		case "models/weapons/v_shot_sawedoff.mdl":			return "weapon_sawedoff";
		case "models/weapons/v_shot_xm1014.mdl":			return "weapon_xm1014";
		case "models/weapons/v_smg_bizon.mdl":				return "weapon_bizon";
		case "models/weapons/v_smg_mac10.mdl":				return "weapon_mac10";
		case "models/weapons/v_smg_mp5sd.mdl":				return "weapon_mp5sd"; // Fake
		case "models/weapons/v_smg_mp7.mdl":				return "weapon_mp7";
		case "models/weapons/v_smg_mp9.mdl":				return "weapon_mp9";
		case "models/weapons/v_smg_p90.mdl":				return "weapon_p90";
		case "models/weapons/v_smg_ump45.mdl":				return "weapon_ump45";
		case "models/weapons/v_snip_awp.mdl":				return "weapon_awp";
		case "models/weapons/v_snip_g3sg1.mdl":				return "weapon_g3sg1";
		case "models/weapons/v_snip_scar20.mdl":			return "weapon_scar20";
		case "models/weapons/v_snip_ssg08.mdl":				return "weapon_ssg08";
		case "models/weapons/v_sonar_bomb.mdl":				return "weapon_tagrenade";
		case "models/weapons/v_spanner.mdl":				return "weapon_spanner"; // Fake
		case "models/weapons/v_tablet.mdl":					return "weapon_tablet";
		default: return "Weapon Unknown"
	}
}