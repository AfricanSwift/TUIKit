#------------------------------------------
# Profiling of Swift Compilation 
#
# Param1: Project filename
# Param2: Scheme name
#------------------------------------------
project=''
scheme=''
blackfggraybg="\033[37;48;5;233m"
reset="\033[0m"
spc=$(echo -n -e "_")

function echor {
	for ((i=1; i<=$2; i++))
	do
		echo -n "$1"
	done
}

function echoc {
	echo -e "$2" "${1//$spc/ }" "$reset"
}

function hdecor {
	mchar=$(echor $2 50)
	lchar=$1
	rchar=$3
	combined="${lchar}${mchar}${rchar}"
	echoc $combined $4
}

function htext {
	if [ -z $5 ]
	then
		filler=$spc
	else
		filler=$5
	fi
	text="${2}"
	len=${#text}
	filllen=$(expr 50 - $len)
	midchar=$(echor $filler $filllen)
	leftchar=$1
	rightchar=$3
	combined="${leftchar}${text}${midchar}${rightchar}"
	echoc $combined $4
}

function helpmenu {
	hdecor ┌ ─ ┐ $blackfggraybg
	htext │ "Profiling_Swift_Compiler_Parameters" │ $blackfggraybg
	hdecor ├ ─ ┤ $blackfggraybg
	htext │ "1)_Project_filename_(extension_optional)" │ $blackfggraybg
	htext │ "2)_Project_scheme" │ $blackfggraybg
	htext │ "_" │ $blackfggraybg
	htext │ "example:" │ $blackfggraybg
	htext │ "__./pc_project1_scheme1" │ $blackfggraybg
	hdecor └ ─ ┘ $blackfggraybg
	echo
}

if [ -z $1 ] 
then 
	helpmenu
	exit
fi

if [ $1 != *".xcodeproj"* ] 
then 
	project=$(echo "${1}.xcodeproj")
else 
	project=$1
fi

if [ -e "${project}" ] 
then
	echo -n ""
else 
	echo $1 'not found.'
	exit
fi

if [ -z $2 ] 
then 
	scheme=$(echo "${1%.*}")
else 
	scheme=$2
fi

output=$(echo "${project%.*}"-perform.txt)
echo -n "Compiling..."
xcodebuild -project $project -scheme $scheme clean build OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies" | grep [1-9].[0-9]ms | sort -nr > "$output"
echo "done"
hdecor ┌ ─ ┐ $blackfggraybg
htext │ "Project:_${project}" │ $blackfggraybg
htext │ "Scheme:_${scheme}" │ $blackfggraybg
sumt=$(awk '{ sum += $0; } END { print sum; }' "$output")
htext │ "Duration:_${sumt}ms" │ $blackfggraybg
hdecor └ ─ ┘ $blackfggraybg
awk -v sumt="$sumt" 'FNR==NR{gsub(/\/.*\//,"",$0);printf "%3.2f%s%s\n",100*$1/sumt,"% : ",$0}' "$output" | sed -n "1,10p"