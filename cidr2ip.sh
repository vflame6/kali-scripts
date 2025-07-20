#!/usr/bin/env bash

# Print usage
function usage {
  echo -n "$(basename $0) CIDR...
$(basename $0) [OPTION] CIDR...

This script prints the ip range or full list of ip addresses for one or more CIDR.

 Options:
  -a, --all             Print the list of ip addresses rather than the range for each CIDR
  -h, --help            Display this help and exit
"
}

# Exit with error code and statement
function die() { out "$@"; exit 1; } >&2

############################
##  Methods
############################
prefix_to_bit_netmask() {
    prefix=$1;
    shift=$(( 32 - prefix ));

    bitmask=""
    for (( i=0; i < 32; i++ )); do
        num=0
        if [ $i -lt $prefix ]; then
            num=1
        fi

        space=
        if [ $(( i % 8 )) -eq 0 ]; then
            space=" ";
        fi

        bitmask="${bitmask}${space}${num}"
    done
    echo $bitmask
}

bit_netmask_to_wildcard_netmask() {
    bitmask=$1;
    wildcard_mask=
    for octet in $bitmask; do
        wildcard_mask="${wildcard_mask} $(( 255 - 2#$octet ))"
    done
    echo $wildcard_mask;
}

check_net_boundary() {
    net=$1;
    wildcard_mask=$2;
    is_correct=1;
    for (( i = 1; i <= 4; i++ )); do
        net_octet=$(echo $net | cut -d '.' -f $i)
        mask_octet=$(echo $wildcard_mask | cut -d ' ' -f $i)
        if [ $mask_octet -gt 0 ]; then
            if [ $(( $net_octet&$mask_octet )) -ne 0 ]; then
                is_correct=0;
            fi
        fi
    done
    echo $is_correct;
}

# native bash script to expand cidr
function coldcidr {

		net=$(echo $1 | cut -d '/' -f 1);
		prefix=$(echo $1 | cut -d '/' -f 2);
		do_processing=1;

		bit_netmask=$(prefix_to_bit_netmask $prefix);

		wildcard_mask=$(bit_netmask_to_wildcard_netmask "$bit_netmask");
		is_net_boundary=$(check_net_boundary $net "$wildcard_mask");

		if [ $is_net_boundary -ne 1 ] ; then
        echo "CIDR base address $net didn't start at a subnet boundary" 1>&2
        echo    ## move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            do_processing=1;
        else
            do_processing=0;
        fi
    fi

		if [ $do_processing -eq 1 ]; then
				str=
				for (( i = 1; i <= 4; i++ )); do
						range=$(echo $net | cut -d '.' -f $i)
						mask_octet=$(echo $wildcard_mask | cut -d ' ' -f $i)
						if [ $mask_octet -gt 0 ]; then
								range="{$range..$(( $range | $mask_octet ))}";
						fi
						str="${str} $range"
				done
				ips=$(echo $str | sed "s, ,\\.,g"); ## replace spaces with periods, a join...

				if (( DISPLAYRANGE )); then
					echo $(eval echo $ips | tr ' ' '\n' | (head -n1 && echo '-' && tail -n1))
				else
					eval echo $ips | tr ' ' '\n'
				fi
		else
				exit 1
		fi

}

# Wrapper to print prips output as a range
function hotcidr {

		if (( DISPLAYRANGE )); then
			echo $(prips $1 | (head -n1 && echo '-' && tail -n1))
		else
			prips $1
		fi

}


############################
## Main
############################

function main {

	# Use the prips util if present on the local system
	EXPANDCMD=hotcidr
	if [[ -z $(which prips) ]]; then
		# if prips is not available, we fall back on a slower native bash function
		# implemented above.
		EXPANDCMD=coldcidr
	fi

	cidrs=$@

	# iterate over all cidr given in the input and print
	for cidr in ${cidrs[@]}; do

		$EXPANDCMD "$cidr"

	done
}


# we default to printing a range, but if a list of ip addresses
# is desired, we will print that
DISPLAYRANGE=1

# parse arguments
while [[ $1 = -?* ]]; do
  case $1 in
    -h|--help) usage >&2; exit 0;;
    -a|--all) DISPLAYRANGE=0;;
  	*) die "invalid option: $1" ;;
  esac
  shift
done

if [[ -z "$@" ]]; then
  usage
fi

# process the cidrs passed in as arguments
main "$@"
