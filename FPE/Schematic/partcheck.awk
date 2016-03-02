#
# Check for parts missing from the database of part numbers.
#
# Usage: awk -f partcheck.awk db bom
#
# Prints any BOM lines that have no part numbers in the databases.
# If value or spec contain  "DNP" the line is ignored.
# Exits with nonzero status if any printed.
#
# Format of the database (Fields separated by tabs):
# 	

# DEVICE	DESCR	VALUE	RATING	PACKAGE	MFG PN	MFGR NAME	MIT PN	NOTE

#
# Format of the BOM (Fields separated by tabs):
#
# refdes  device  value   spec    footprint       description
# (first line is column headers)


BEGIN{ 
	FS="\t" 
}

/^refdes/{		/* BOM column header */
	bom = 1
	next
}

/^DEVICE/{ next }	/* database column header */

# If we're not reading the BOM, we're reading a database

!bom {
	device = $1
	value = gensub(/([^.]*)\.$/, "\\1", 1, $3)	# Strip spurious trailing .
	spec = $4
	package = $5
	key = device FS value FS spec FS package
	part[ key ] = 1
	next
}

# Process a line from the BOM

{
	refdes = $1
	device = $2
	value = $3
	if( value ~ /DNP/ ) next
	spec = $4
	if( spec ~ /DNP/ ) next
	if( spec == "N/A" ) spec = "unknown"	# a foolish consistency...
	package = $5
	description = $6
	
	if( value == "omit" ) next
	
	key = device FS value FS spec FS package
	
	if( !part[key] ) {
		print "Missing: " $0
		missed = 1
	}
}

END { if( missed ) exit(1) }
