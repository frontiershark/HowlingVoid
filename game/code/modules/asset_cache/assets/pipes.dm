/datum/asset/spritesheet_batched/pipes
	name = "pipes"
	ignore_dir_errors = TRUE

/datum/asset/spritesheet_batched/pipes/create_spritesheets()
	for (var/each in list('../assets/icons/obj/pipes_n_cables/pipe_item.dmi', '../assets/icons/obj/pipes_n_cables/disposal.dmi', '../assets/icons/obj/pipes_n_cables/transit_tube.dmi', '../assets/icons/obj/pipes_n_cables/hydrochem/fluid_ducts.dmi'))
		insert_all_icons("", each, GLOB.alldirs)
