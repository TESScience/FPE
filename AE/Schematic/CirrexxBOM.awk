#
# Make a Cirrexx BOM from a gEDA bom and part # databases.
#
# Usage: awk -f CirrexxBOM.awk db1 [db2 ...] bom
#
# Format of the databases (Fields separated by tabs):
# 	
# device	value	spec	footprint	manufacturer	part#	note
#
# Format of the input BOM (Fields separated by colons):
#
# refdes:device:value:spec:footprint:description:qty
# (first line is column headers)
# ("gnetlist -g bom2" can make this)
#
# Format of the output BOM (Fields separated by tabs):
#
# Item#	quantity	refdes	description	Mfr	part#	notes
# (first line is column headers)
# (description is the concatenation of the input device, value, spec, and footprint)
# (at present, notes is unused)
# (if the value is "omit", the part will not appear in the output)
# (if manufacturer or part number is missing from the database, it will be **MISSING** in the output)


BEGIN{
	TAB = "\t"
	FS=TAB 
	print "ITEM" TAB "QTY/BD" TAB "REF DES" TAB "DESCRIPTION" TAB "Mfr." TAB "Mfr's PN" TAB "NOTES"
}

/^#/{next}	# ignore comment lines

/^$/{next}	# ignore blank lines

/^refdes:device:value:spec:footprint:description:qty/{
	bom = 1		# seen BOM header, now reading BOM
	FS = ":"	# bom2 format separates fields wit ":"
	next
}

# If we're not reading the BOM, we're reading a database

!bom {
	key = $1 FS $2 FS $3 FS $4
	mfr[ key ] = $5
	part[ key ] = $6
	note[key] = $7
	next
}

{
	refdes = $1
	device = $2
	value = $3
	spec = $4
	footprint = $5
	description = $6
	qty = $7
	
	if( value == "omit" ) next
	
	key = device TAB value TAB spec TAB footprint
	
	thisnote = note[key]
	thismfr = mfr[key]
	if( !thismfr && !thisnote ) thismfr = "**MISSING**"
	thispart = part[key]
	if( !thispart && !thisnote ) thispart = "**MISSING**"
			
	print ++item TAB qty TAB refdes TAB device, value, spec, footprint TAB thismfr TAB thispart TAB thisnote
}
