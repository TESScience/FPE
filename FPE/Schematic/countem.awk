# $Id: countem.awk,v 1.1 2009-01-30 04:17:52 jpd Exp $
#
# List each unique part with a count of the number of occurances in the BOM
#
# Usage: awk -f countem.awk bom
#
# Format of the BOM (Fields separated by tabs):
#
# refdes  device  value   spec    footprint       description
# (first line is column headers)


BEGIN{ FS="\t" }

/^refdes/{next}

{
	device = $2
	value = $3
	spec = $4
	package = $5
	
	count[ device FS value FS spec FS package ] += 1
}

END{
	for( key in count ) print count[key] FS key
}

# $Log: countem.awk,v $
# Revision 1.1  2009-01-30 04:17:52  jpd
# Start work on interface board.
# Infrastructure to export to Screaming Circuits.
# Database of part numbers.
# More conservative part choices.
#
