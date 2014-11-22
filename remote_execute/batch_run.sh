#!/bin/sh

if [ $# -lt 4 ]; then
	echo "usage: $0 \$user \$passwd \$cmdFile \$tmplFile [\$outFile]"
	exit
fi

user=$1
passwd="$2"
cmdFile=$3
tmplFile=$4
outFile=$5

tmpCmdFile="$cmdFile".real
cp $cmdFile $tmpCmdFile

cat $tmplFile | grep -v IP | while read IP worldid
do
	cat $cmdFile > $tmpCmdFile
	sh remote_cmd.sh $IP $user "$passwd" $tmpCmdFile "$outFile${worldid}"
done

rm $tmpCmdFile

