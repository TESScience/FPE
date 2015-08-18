# $Id: expand37.awk,v 1.2 2009-01-30 04:17:52 jpd Exp $

# Make a pin list for all CCD connectors from the
# CCD-37pin.tsv file or similar

/^#/{next}	# ignore comments
/^$/{next}	# and blank lines

{
	for( ccd = 1; ccd < 5; ccd += 1 ) {
		net = $3
		sub( "-1$", "-" ccd, net )	# customize netname
		print "J" ccd "\t" $2 "\t" net
	}
}

# $Log: expand37.awk,v $
# Revision 1.2  2009-01-30 04:17:52  jpd
# Start work on interface board.
# Infrastructure to export to Screaming Circuits.
# Database of part numbers.
# More conservative part choices.
#

	
	
