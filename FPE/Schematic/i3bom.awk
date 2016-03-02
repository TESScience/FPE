#
# Make BOM for I3
#
# Usage: awk -f i3bom.awk db bom
#
#
# Format of the database (Fields separated by tabs):
# 	

# DEVICE	DESCR	VALUE	RATING	PACKAGE	MFG PN	MFGR NAME	MIT PN	NOTE

#
# Format of the BOM (bom2 format, fields separated by :):
#
# refdes:device:value:spec:footprint:description:qty
# (first line is column headers)
# refdes is a comma-separated list
# If value or spec contain  "DNP" the line is ignored.


# Format of the output:

# Item	IPN	CPN	Description	Qty	UM	Manufacturer	Manufacturer PN	REFDES
# Item and IPN are blank
# CPN is the MIT PN unless that's blank, in which case it's MFG PN
# UM is always EA
# Description is device value spec footprint
# REFDES is a comma separated list

BEGIN{ 
	FS="\t" 
}

/^refdes/{		/* BOM column header */
	bom = 1
	FS=":"
	print "Item" "\t" "IPN" "\t" "CPN" "\t" "Description" "\t" "Qty" "\t" "UM" "\t" "Manufacturer" "\t" "Manufacturer PN" "\t" "REFDES"
	next
}

/^DEVICE/{ next }	/* database column header */

# If we're not reading the BOM, we're reading a database

!bom {
	device = $1
	descr = $2
	value = gensub(/([^.]*)\.$/, "\\1", 1, $3)	# Strip spurious trailing .
	rating = $4
	package = $5
	mfg_pn = $6
	mfgr_name = $7
	mit_pn = $8
	if( !mit_pn ) mit_pn = mfg_pn
	key = device "\t" value "\t" rating "\t" package
	if( value == "unknown" ) value = ""
	if( rating == "unknown" ) rating = ""
	part1[ key ] = "\t" "\t" mit_pn "\t" device " " value " " rating " " package
	part2[ key ] = "EA" "\t" mfgr_name "\t" mfg_pn
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
	qty = $7
		
	key = device "\t" value "\t" spec "\t" package
	
	if( !part1[key] ) {
		print "Missing: " $0 >"/dev/stderr"
		print "Key: " key
		exit( 1 )
	}
	
	print part1[key] "\t" qty "\t" part2[key] "\t" refdes	
}

