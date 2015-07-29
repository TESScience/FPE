# General conversion of TSV files to LaTeX table data.
# Intended for files with the same number of field on each line.


BEGIN{
FS="\t"
}

# Special case "comment" for making a horizontal line.
/^#-/{ print "\\hline" }

# ignore comment lines
/^#/{next}

{
	a = ""
	for( i = 1; i < NF; i += 1) a = a $i " & "
	print a $NF " \\\\"
}
