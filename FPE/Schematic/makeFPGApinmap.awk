/^#/{next}	# ignore comments
/^$/{ next}	# ignore blank lines

/^\[END\]/{	# end of tsv map, start of Vivado csv
	FS=","
	next
}

NF==2 {		# Map file line
	map[$2] = $1
}

NF==24 {	# Anything not already matched should be a full Vivado csv line, but check

	pin = $2
	if( pin == "Pin Number") next	# ignore the header line 

	signal = 0					# assume no connection
	if( $10 ) signal = $10		# use name
	else if( $24) signal = $24	# use board voltage
	else if( $4 ~ /_0$/ ) signal = $4		# use "Site Type" for the _0 signals
	else if( $4 ~ /^VCC/ ) signal = $4		# and for unassigned power
	else if( $4 ~ /MGT.*/ ) signal = $4
	
	if( !signal ) next			# no connection
	
	net = map[ signal ]
	
	if( !net ) {
		print signal " is not in the map" >"/dev/stderr"
		exit(1)
	}
	
	if( net == "NC" ) next		# no connection
	
	print "U4\t" pin "\t" net "\t"	signal
}
