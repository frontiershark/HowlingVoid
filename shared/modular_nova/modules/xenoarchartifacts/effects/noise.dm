/datum/artifact_effect/noise
	log_name = "Noise"
	var/static/list/possible_noises = list(
		'../assets/sound/machines/buzz/buzz-sigh.ogg',
		'../assets/sound/machines/buzz/buzz-two.ogg',
		'../assets/sound/machines/chime.ogg',
		'../assets/sound/items/bikehorn.ogg',
		'../assets/sound/machines/ping.ogg',
		'../assets/sound/misc/sadtrombone.ogg',
		'../assets/sound/machines/warning-buzzer.ogg',
		'../assets/sound/machines/slowclap.ogg',
		'../assets/sound/mobs/humanoids/moth/scream_moth.ogg',
		'../assets/sound/items/toy_squeak/toysqueak1.ogg',
		'../assets/sound/items/poster/poster_ripped.ogg',
		'../assets/sound/items/coinflip.ogg',
		'../assets/sound/items/megaphone.ogg',
		'../assets/sound/effects/magic/warpwhistle.ogg',
		'../assets/sound/mobs/non-humanoids/hiss/hiss1.ogg',
		'../assets/sound/mobs/humanoids/lizard/lizard_scream_1.ogg',
		'../assets/sound/items/weapons/flashbang.ogg',
		'../assets/sound/items/weapons/flash.ogg',
		'../assets/sound/items/weapons/whip.ogg',
		'../assets/sound/items/sitcom_laugh/sitcomLaugh1.ogg',
		'../assets/sound/items/gavel.ogg',
		'../assets/sound/items/haunted/ghostitemattack.ogg',
		'../assets/sound/items/ceramic_break.ogg',
		'../assets/sound/effects/hallucinations/veryfar_noise.ogg',
		'../assets/sound/effects/hallucinations/radio_static.ogg',
		'../assets/sound/effects/hallucinations/look_up1.ogg',
		'../assets/sound/effects/hallucinations/wail.ogg',
		'../assets/sound/effects/hallucinations/growl2.ogg',
		'../assets/sound/effects/hallucinations/far_noise.ogg',
		'../assets/sound/mobs/non-humanoids/alien/alien_eat.ogg', // vore :3
		'../assets/sound/runtime/complionator/asshole.ogg',
		'../assets/sound/misc/scary_horn.ogg',
		'../assets/sound/effects/magic/curse.ogg',
		'../assets/sound/machines/airlock/airlock_alien_prying.ogg',
		'../assets/sound/mobs/non-humanoids/clown/hohoho.ogg', // hehe
		'../assets/sound/mobs/non-humanoids/clown/hehe.ogg', // hohoho
		'../assets/sound/effects/wounds/crack1.ogg',
		'modular_nova/modules/emotes/sound/voice/scream_f1.ogg',
		'modular_nova/modules/random_ship_event/random_ships/heliostatic_inspectors/sounds/alarm_radio.ogg',
		'modular_nova/modules/random_ship_event/random_ships/heliostatic_inspectors/sounds/morse.ogg', // I can spend all day here, adding sounds. But i wont.
	)

/datum/artifact_effect/noise/New()
	. = ..()
	trigger = TRIGGER_OXY
	release_method = ARTIFACT_EFFECT_PULSE
	type_name = ARTIFACT_EFFECT_PSIONIC

/datum/artifact_effect/noise/do_effect_pulse(seconds_per_tick)
	. = ..()
	if(!.)
		return
	var/list/sound_type = pick(possible_noises)
	playsound(holder, pick(sound_type), 50, ignore_walls = TRUE)

/datum/artifact_effect/noise/do_effect_destroy()
	playsound(holder, '../assets/sound/effects/hallucinations/wail.ogg', 75, ignore_walls = TRUE, extrarange = 25, pressure_affected = FALSE) // Louder than usual scream with extra range
