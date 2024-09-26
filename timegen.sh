if [ $# -eq 0 ]; then
    echo "Usage: $0 --haskell|--python -r ROWS -c COLUMNS -n NTESTS [-o FILE]"
    exit 1
fi
CSV_FILE="time.csv"
while [[ $# -gt 0 ]]; do
    case $1 in
	--haskell)
	    lang=haskell
	    shift 1
	    ;;
	--python)
	    lang=python
	    shift 1
	    ;;
	-r|--rows)
	    if [[ $# -gt 1 && $2 =~ ^[0-9]++$ ]]; then
		rows=$2
		shift 2
	    else
		echo "Error: --rows requires a numeric value" >&2
		exit 1
	    fi
	    ;;
	-c|--cols)
	    if [[ $# -gt 1 && $2 =~ ^[0-9]+$ ]]; then
		cols=$2
		shift 2
	    else
		echo "Error: --cols requires a numeric value" >&2
		exit 1
	    fi
	    ;;
	-n|--number-of-tests)
	    if [[ $# -gt 1 && $2 =~ ^[0-9]+$ ]]; then
		ntests=$2
		shift 2
	    else
		echo "Error: --number-of-tests requires a numeric value" >&2
		exit 1
	    fi
	    ;;
	-o|--out)
	    if [[ $# -gt 1 ]]; then
		CSV_FILE=$2
		shift 2
	    else
		echo "Error: need a filename" >&2
		exit 1
	    fi
	    ;;

	*)
	    echo "Failed to parse: $1" >&2
	    exit 1
	    ;;
    esac
done
TEST_FILE="r$rows.c$cols.test.csv"

if [ ! -f "$TEST_FILE" ]; then
    sh gentestdata.sh $rows $cols $TEST_FILE
fi

# Create CSV header if file doesn't exist
if [ ! -f "$CSV_FILE" ]; then
    echo "RealTime,UserTime,SystemTime,Rows,Columns,Language" > $CSV_FILE
fi

case $lang in
    haskell)
	for ((i=1; i<=ntests; i++)); do
	    env time -f "%e,%U,%S" cabal exec \
		bioboombox knn $TEST_FILE \
		     2>&1 >/dev/null \
		| tr -d '\n' \
		     >> $CSV_FILE
	    echo ,$rows,$cols,$lang >> $CSV_FILE
	done
	;;
    python)
	for ((i=1; i<=ntests; i++)); do
	    env time -f "%e,%U,%S" python \
		nearestneighbors.py $TEST_FILE \
		     2>&1 >/dev/null \
	     	| tr -d '\n' '' \
		     >> $CSV_FILE
	    echo ,$rows,$cols,$lang >> $CSV_FILE
	done
	;;
esac	   

echo "Time statistics appended to $CSV_FILE"
