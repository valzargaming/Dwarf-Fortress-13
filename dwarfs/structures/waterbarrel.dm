/obj/structure/dwarf_waterbarrel
	name = "Бочка с грязной водой"
	desc = "Для охлаждения и закалки заготовок."
	icon = 'white/rashcat/icons/dwarfs/objects/tools.dmi'
	icon_state = "barrel_water_1"
	anchored = TRUE
	density = TRUE
	layer = TABLE_LAYER

/obj/structure/dwarf_waterbarrel/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/blacksmith/tongs))
		if(I.contents.len)
			if(istype(I.contents[I.contents.len], /obj/item/blacksmith/ingot))
				var/obj/item/blacksmith/ingot/N = I.contents[I.contents.len]
				if(N.progress_current == N.progress_need + 1)
					for(var/i in 1 to rand(1, N.recipe.max_resulting))
						var/grd = "*"
						switch(N.mod_grade)
							if(5 to INFINITY)
								N.mod_grade = 5
								if(prob(10))
									N.mod_grade = 6
								grd = "☼"
							if(4)
								grd = "≡"
							if(3)
								grd = "+"
							if(2)
								grd = "-"
							if(1)
								grd = "*"
						var/obj/item/O = new N.recipe.result(drop_location())
						O.name = "[grd][O.name][grd]"
						if(istype(O, /obj/item/blacksmith))
							var/obj/item/blacksmith/B = O
							B.level = N.mod_grade
							B.grade = grd
						O.calculate_smithing_stats(N.mod_grade)
					qdel(N)
					LAZYCLEARLIST(contents)
					playsound(src, 'white/valtos/sounds/vaper.ogg', 100)
					I.icon_state = "tongs"
				else
					return
	else
		. = ..()