BEGIN{FS="\t"}
{	if($1) {
		print "Js\t" $1 "\t" $2
		print "Js\t" $5 "\t" $6
	}
	else {
		print "Js\t" $3 "\t" $4
		print "Js\t" $7 "\t" $8
	}
}