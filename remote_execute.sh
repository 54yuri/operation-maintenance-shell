#!/bin/sh

if [ $# -lt 4 ]; then
    echo "usage: $0 \$IP \$user \$passwd \$cmdFile [\$outFile]"
    exit -1
fi

ip=$1
user=$2
passwd=$3
cmdFile=$4
outFile=$5


#step1 upload cmd file 
dst="~${user}"

expect <<EOF
#!/usr/bin/expect --

set timeout -1
spawn rsync -ac -e "ssh -p36000 -l$user" $cmdFile $ip:$dst
for {} {1} {} {
    expect {
        "yes/no)?" {send "yes\n"}
        "assword:" {send "$passwd\n"}
        eof break
    }
}
EOF

#step2 remote exec cmdfile
cmd="cd ${dst}; sh ${cmdFile}"

if [ x${outFile} != "x" ]; then
    cmd="cd ${dst}; sh ${cmdFile} > ${outFile}"
fi

expect <<EOF
#!/usr/bin/expect --

set timeout -1
spawn ssh -o ConnectTimeout=3 -q $user@$ip "$cmd"
for {} {1} {} {
    expect {
        "yes/no)?" {send "yes\n"}
        "assword:" {send "$passwd\n"}
        eof break
    }
}

EOF


#step3 get back result

if [ x${outFile} != "x" ]; then

expect <<EOF
#!/usr/bin/expect --

set timeout -1
spawn rsync -ac -e "ssh -p36000 -l$user" $ip:$dst/$outFile $outFile
for {} {1} {} {
    expect {
        "yes/no)?" {send "yes\n"}
        "assword:" {send "$passwd\n"}
        eof break
    }
}
EOF

fi

#step 4 optional [remote ] remove file
cmd="cd ${dst}; rm ${cmdFile}"

if [ x${outFile} != "x" ]; then
    cmd="cd ${dst}; rm ${cmdFile}; test -f ${outFile} && rm ${outFile}"
fi

echo $cmd

expect <<EOF
#!/usr/bin/expect --

set timeout -1
spawn ssh -o ConnectTimeout=3 -q $user@$ip "$cmd"
for {} {1} {} {
    expect {
        "yes/no)?" {send "yes\n"}
        "assword:" {send "$passwd\n"}
        eof break
    }
}
EOF

