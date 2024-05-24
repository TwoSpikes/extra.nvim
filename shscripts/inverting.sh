#!/bin/env sh

#pdftk "$1" output - uncompress | \
#awk '
#  /^1 1 1 / {
#    sub(/1 1 1 /,"0 0 0 ",$0);
#    print;
#    next;
#  }
#
#  /^0 0 0 / {
#    sub(/0 0 0 /,"1 1 1 ",$0);
#    print;
#    next;
#  }
#
#  { print }' | \
#pdftk - output "${1/%.pdf/_inverted.pdf}" compress

if test "${1}" = '--help'; then
	echo "./inverting.sh INPUT OUTPUT"
	echo "./inverting.sh: Simple tool for convert pdf colors using ghostscript"
	exit 0
fi

case "${1}" in
	'')
		echo -e "\033[91mERROR\033[0m: No input"
		exit 1
		;;
	*)
		INPUT="${1}"
		;;
esac

case "${2}" in
	'')
		OUTPUT=$(echo "$(echo "${1}" | sed -e "s/\.pdf//")_inverted.pdf")
		;;
	*)
		OUTPUT="${2}"
		;;
esac

gs -o "${OUTPUT}"\
 -sDEVICE=pdfwrite  \
 -c "{1 exch sub}{1 exch sub}{1 exch sub}{1 exch sub} setcolortransfer" \
 -f "${INPUT}"
