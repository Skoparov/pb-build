#!/bin/bash

buildList=""

if [ $# -gt 0 ]
then
	buildList="ONLY=$@"

	>&2 echo "$(tput setaf 3)-Building only:"

	for arg; do
	    >&2 echo "$(tput setaf 3)--$arg"
		done
	else
		buildList="build test"
		>&2 echo "$(tput setaf 3)-Building everything"
fi

echo $(tput sgr0)
	
>&2 echo $buildList
	
errors="/home/skoparov/errors"

# VALGRIND=valgrind VALGRIND_ARGS='--leak-check=full --error-exitcode=1'

pushd /home/skoparov/HOM/boese > /dev/null
schroot -c mcp_8 -- /home/skoparov/HOM/boese/pb go $buildList 2>$errors 
popd > /dev/null


sed '/^Note: / d' $errors > ~/temp_errors
cat ~/temp_errors > $errors
rm ~/temp_errors
	
if [ -s $errors ]
then
	message="BUILD FAILED"
	color="tput setaf 1"
	icon="software-update-urgent"

	>&2 echo "$(tput setaf 3)-Errors are in "$errors
	#nohup xdg-open $errors > /dev/null 2>&1
else
	message="BUILD SUCCEDED"
	color="tput setaf 2"
	icon="emblem-default"

	if [ -f $errors ]
	then
		#rm $errors
		> $errors
	fi
fi

>&2 echo "$($color)-$message$(tput sgr0)"

notify-send -i $icon $message -t 1	