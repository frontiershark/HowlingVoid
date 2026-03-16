/mob/living/basic/migo
	name = "mi-go"
	desc = "A pinkish, fungoid crustacean-like creature with clawed appendages and a head covered with waving antennae."
	icon_state = "mi-go"
	icon_living = "mi-go"
	icon_dead = "mi-go-dead"
	health = 80
	maxHealth = 80
	obj_damage = 50
	melee_damage_lower = 25
	melee_damage_upper = 50
	speed = 1
	attack_verb_continuous = "lacerates"
	attack_verb_simple = "lacerate"
	melee_attack_cooldown = 1 SECONDS
	gold_core_spawnable = HOSTILE_SPAWN
	attack_sound = '../assets/sound/items/weapons/bladeslice.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	faction = list(FACTION_NETHER)
	speak_emote = list("screams", "clicks", "chitters", "barks", "moans", "growls", "meows", "reverberates", "roars", "squeaks", "rattles", "exclaims", "yells", "remarks", "mumbles", "jabbers", "stutters", "seethes")
	death_message = "wails as its form turns into a pulpy mush."
	death_sound = '../assets/sound/mobs/non-humanoids/hiss/hiss6.ogg'
	unsuitable_atmos_damage = 0
	unsuitable_cold_damage = 0
	unsuitable_heat_damage = 0
	// Real blue, trying to go for the migo's look
	lighting_cutoff_red = 15
	lighting_cutoff_green = 15
	lighting_cutoff_blue = 50

	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile_obstacles
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, STAMINA = 0, OXY = 1)
	var/static/list/migo_sounds
	/// Odds migo will dodge
	var/dodge_prob = 10
	/// Are we dodging an attack during this move?
	var/dodging = FALSE

/mob/living/basic/migo/Initialize(mapload)
	. = ..()
	migo_sounds = list('../assets/sound/items/bubblewrap.ogg', '../assets/sound/items/tools/change_jaws.ogg', '../assets/sound/items/tools/crowbar.ogg', '../assets/sound/items/drink.ogg', '../assets/sound/items/deconstruct.ogg', '../assets/sound/items/carhorn.ogg', '../assets/sound/items/tools/change_drill.ogg', '../assets/sound/items/dodgeball.ogg', '../assets/sound/items/eatfood.ogg', '../assets/sound/items/megaphone.ogg', '../assets/sound/items/tools/screwdriver.ogg', '../assets/sound/items/weeoo1.ogg', '../assets/sound/items/tools/wirecutter.ogg', '../assets/sound/items/tools/welder.ogg', '../assets/sound/items/zip/zip.ogg', '../assets/sound/items/tools/rped.ogg', '../assets/sound/items/tools/ratchet.ogg', '../assets/sound/items/polaroid/polaroid1.ogg', '../assets/sound/items/pshoom/pshoom.ogg', '../assets/sound/items/airhorn/airhorn.ogg', '../assets/sound/items/geiger/high1.ogg', '../assets/sound/items/geiger/high2.ogg', '../assets/sound/mobs/non-humanoids/beepsky/creep.ogg', '../assets/sound/mobs/non-humanoids/beepsky/iamthelaw.ogg', '../assets/sound/mobs/non-humanoids/ed209/ed209_20sec.ogg', '../assets/sound/mobs/non-humanoids/hiss/hiss3.ogg', '../assets/sound/mobs/non-humanoids/hiss/hiss6.ogg', '../assets/sound/mobs/non-humanoids/medbot/patchedup.ogg', '../assets/sound/mobs/non-humanoids/medbot/feelbetter.ogg', '../assets/sound/mobs/humanoids/human/laugh/manlaugh1.ogg', '../assets/sound/mobs/humanoids/human/laugh/womanlaugh.ogg', '../assets/sound/items/weapons/sear.ogg', '../assets/sound/music/antag/clockcultalr.ogg', '../assets/sound/music/antag/ling_alert.ogg', '../assets/sound/music/antag/traitor/tatoralert.ogg', '../assets/sound/music/antag/monkey.ogg', '../assets/sound/vehicles/mecha/nominal.ogg', '../assets/sound/vehicles/mecha/weapdestr.ogg', '../assets/sound/vehicles/mecha/critdestr.ogg', '../assets/sound/vehicles/mecha/imag_enh.ogg', '../assets/sound/effects/adminhelp.ogg', '../assets/sound/effects/alert.ogg', '../assets/sound/effects/blob/attackblob.ogg', '../assets/sound/effects/bamf.ogg', '../assets/sound/effects/blob/blobattack.ogg', '../assets/sound/effects/break_stone.ogg', '../assets/sound/effects/bubbles/bubbles.ogg', '../assets/sound/effects/bubbles/bubbles2.ogg', '../assets/sound/effects/clang.ogg', '../assets/sound/effects/clockcult_gateway_disrupted.ogg', '../assets/sound/effects/footstep/clownstep2.ogg', '../assets/sound/effects/curse/curse1.ogg', '../assets/sound/effects/dimensional_rend.ogg', '../assets/sound/effects/doorcreaky.ogg', '../assets/sound/effects/empulse.ogg', '../assets/sound/effects/explosion/explosion_distant.ogg', '../assets/sound/effects/explosion/explosionfar.ogg', '../assets/sound/effects/explosion/explosion1.ogg', '../assets/sound/effects/grillehit.ogg', '../assets/sound/effects/genetics.ogg', '../assets/sound/effects/heart_beat.ogg', '../assets/sound/runtime/hyperspace/hyperspace_begin.ogg', '../assets/sound/runtime/hyperspace/hyperspace_end.ogg', '../assets/sound/effects/his_grace/his_grace_awaken.ogg', '../assets/sound/effects/pai_boot.ogg', '../assets/sound/effects/phasein.ogg', '../assets/sound/effects/pickaxe/picaxe1.ogg', '../assets/sound/effects/sparks/sparks1.ogg', '../assets/sound/effects/smoke.ogg', '../assets/sound/effects/splat.ogg', '../assets/sound/effects/snap.ogg', '../assets/sound/effects/tendril_destroyed.ogg', '../assets/sound/effects/supermatter.ogg', '../assets/sound/effects/desecration/desecration-01.ogg', '../assets/sound/effects/desecration/desecration-02.ogg', '../assets/sound/effects/desecration/desecration-03.ogg', '../assets/sound/announcer/alarm/bloblarm.ogg', '../assets/sound/announcer/alarm/airraid.ogg', '../assets/sound/misc/bang.ogg','../assets/sound/misc/highlander.ogg', '../assets/sound/misc/interference.ogg', '../assets/sound/announcer/notice/notice1.ogg', '../assets/sound/announcer/notice/notice2.ogg', '../assets/sound/misc/sadtrombone.ogg', '../assets/sound/misc/slip.ogg', '../assets/sound/misc/splort.ogg', '../assets/sound/items/weapons/armbomb.ogg', '../assets/sound/items/weapons/beam_sniper.ogg', '../assets/sound/items/weapons/chainsawhit.ogg', '../assets/sound/items/weapons/emitter.ogg', '../assets/sound/items/weapons/emitter2.ogg', '../assets/sound/items/weapons/blade1.ogg', '../assets/sound/items/weapons/bladeslice.ogg', '../assets/sound/items/weapons/blastcannon.ogg', '../assets/sound/items/weapons/blaster.ogg', '../assets/sound/items/weapons/bulletflyby3.ogg', '../assets/sound/items/weapons/circsawhit.ogg', '../assets/sound/items/weapons/cqchit2.ogg', '../assets/sound/items/weapons/drill.ogg', '../assets/sound/items/weapons/genhit1.ogg', '../assets/sound/items/weapons/gun/pistol/shot_suppressed.ogg', '../assets/sound/items/weapons/gun/pistol/shot.ogg', '../assets/sound/items/weapons/handcuffs.ogg', '../assets/sound/items/weapons/homerun.ogg', '../assets/sound/items/weapons/kinetic_accel.ogg', '../assets/sound/machines/clockcult/steam_whoosh.ogg', '../assets/sound/machines/fryer/deep_fryer_emerge.ogg', '../assets/sound/machines/airlock/airlock.ogg', '../assets/sound/machines/airlock/airlock_alien_prying.ogg', '../assets/sound/machines/airlock/airlockclose.ogg', '../assets/sound/machines/airlock/airlockforced.ogg', '../assets/sound/machines/airlock/airlockopen.ogg', '../assets/sound/announcer/alarm/nuke_alarm.ogg', '../assets/sound/machines/blender.ogg', '../assets/sound/machines/airlock/boltsdown.ogg', '../assets/sound/machines/airlock/boltsup.ogg', '../assets/sound/machines/buzz/buzz-sigh.ogg', '../assets/sound/machines/buzz/buzz-two.ogg', '../assets/sound/machines/chime.ogg', '../assets/sound/machines/cryo_warning.ogg', '../assets/sound/machines/defib/defib_charge.ogg', '../assets/sound/machines/defib/defib_failed.ogg', '../assets/sound/machines/defib/defib_ready.ogg', '../assets/sound/machines/defib/defib_zap.ogg', '../assets/sound/machines/beep/deniedbeep.ogg', '../assets/sound/machines/ding.ogg', '../assets/sound/machines/disposalflush.ogg', '../assets/sound/machines/door/door_close.ogg', '../assets/sound/machines/door/door_open.ogg', '../assets/sound/machines/engine_alert/engine_alert1.ogg', '../assets/sound/machines/engine_alert/engine_alert2.ogg', '../assets/sound/machines/hiss.ogg', '../assets/sound/mobs/non-humanoids/honkbot/honkbot_evil_laugh.ogg', '../assets/sound/machines/juicer.ogg', '../assets/sound/machines/ping.ogg', '../assets/sound/ambience/misc/signal.ogg', '../assets/sound/machines/synth/synth_no.ogg', '../assets/sound/machines/synth/synth_yes.ogg', '../assets/sound/machines/terminal/terminal_alert.ogg', '../assets/sound/machines/beep/triple_beep.ogg', '../assets/sound/machines/beep/twobeep.ogg', '../assets/sound/machines/ventcrawl.ogg', '../assets/sound/machines/warning-buzzer.ogg', '../assets/sound/announcer/default/outbreak5.ogg', '../assets/sound/announcer/default/outbreak7.ogg', '../assets/sound/announcer/default/poweroff.ogg', '../assets/sound/announcer/default/radiation.ogg', '../assets/sound/announcer/default/shuttlecalled.ogg', '../assets/sound/announcer/default/shuttledock.ogg', '../assets/sound/announcer/default/shuttlerecalled.ogg', '../assets/sound/announcer/default/aimalf.ogg') //hahahaha fuck you code divers

	if(!istype(src, /mob/living/basic/migo/hatsune) && prob(0.1)) // chance on-load mi-gos will spawn with a miku wig on (shiny variant)
		new /mob/living/basic/migo/hatsune(get_turf(loc), mapload)
		return INITIALIZE_HINT_QDEL

	AddElement(/datum/element/swabable, CELL_LINE_TABLE_NETHER, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 0)
	AddComponent(/datum/component/health_scaling_effects, min_health_slowdown = -1.5, additional_status_callback = CALLBACK(src, PROC_REF(update_dodge_chance)))

/// Makes the migo more likely to dodge around the more damaged it is
/mob/living/basic/migo/proc/update_dodge_chance(health_ratio)
	dodge_prob = LERP(50, 10, health_ratio)

/mob/living/basic/migo/proc/make_migo_sound()
	playsound(src, pick(migo_sounds), 50, TRUE)

/mob/living/basic/migo/send_speech(message_raw, message_range, obj/source, bubble_type, list/spans, datum/language/message_language, list/message_mods, forced, tts_message, list/tts_filter)
	. = ..()
	if(stat != CONSCIOUS)
		return
	make_migo_sound()

/mob/living/basic/migo/Life(seconds_per_tick = SSMOBS_DT)
	. = ..()
	if(!.) //dead or deleted
		return
	if(stat)
		return
	if(SPT_PROB(5, seconds_per_tick))
		make_migo_sound()

/mob/living/basic/migo/Move(atom/newloc, dir, step_x, step_y)
	if(!dodging && !ckey && prob(dodge_prob) && moving_diagonally == 0 && isturf(loc) && isturf(newloc))
		return dodge(newloc, dir)
	else
		return ..()

/mob/living/basic/migo/proc/dodge(moving_to, move_direction)
	//Assuming we move towards the target we want to swerve toward them to get closer
	var/cdir = turn(move_direction, 45)
	var/ccdir = turn(move_direction, -45)
	dodging = TRUE
	. = Move(get_step(loc,pick(cdir, ccdir)))
	if(!.)//Can't dodge there so we just carry on
		. = Move(moving_to, move_direction)
	dodging = FALSE

/// The special hatsune miku themed mi-go.
/mob/living/basic/migo/hatsune
	name = "hatsune mi-go"
	desc = parent_type::desc + " This one is wearing a bright blue wig."
	icon_state = "mi-go-h"
	icon_living = "mi-go-h"

	gender = FEMALE
	gold_core_spawnable = FRIENDLY_SPAWN
	faction = list(FACTION_NEUTRAL)

/mob/living/basic/migo/hatsune/make_migo_sound()
	playsound(src, '../assets/sound/mobs/non-humanoids/tourist/tourist_talk_japanese1.ogg', 50, TRUE)

/mob/living/basic/migo/hatsune/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/death_drops, /obj/item/instrument/piano_synth)
