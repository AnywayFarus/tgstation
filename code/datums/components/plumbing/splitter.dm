/datum/component/plumbing/splitter
	demand_connects = NORTH
	supply_connects = SOUTH | EAST

/datum/component/plumbing/splitter/Initialize(start=TRUE, _ducting_layer, _turn_connects=TRUE, datum/reagents/custom_receiver)
	. = ..()
	if(. && !istype(parent, /obj/machinery/plumbing/splitter))
		return FALSE

/datum/component/plumbing/splitter/can_give(amount, reagent, datum/ductnet/net)
	. = ..()
	if(!.)
		return
	var/direction
	for(var/A in ducts)
		if(ducts[A] == net)
			direction = get_original_direction(text2num(A))
			break
	var/obj/machinery/plumbing/splitter/S = parent
	switch(direction)
		if(SOUTH)
			if(S.turn_straight && S.transfer_straight <= amount)
				S.turn_straight = FALSE
				return TRUE
		if(EAST)
			if(!S.turn_straight && S.transfer_side <= amount)
				S.turn_straight = TRUE
				return TRUE
	return FALSE


/datum/component/plumbing/splitter/transfer_to(datum/component/plumbing/target, amount, reagent, datum/ductnet/net, round_robin = TRUE)
	var/direction
	for(var/A in ducts)
		if(ducts[A] == net)
			direction = get_original_direction(text2num(A))
			break
	var/obj/machinery/plumbing/splitter/S = parent
	switch(direction)
		if(SOUTH)
			if(amount >= S.transfer_straight)
				amount = S.transfer_straight
		if(EAST)
			if(amount >= S.transfer_side)
				amount = S.transfer_side
	S.use_energy(S.active_power_usage)
	return ..()

