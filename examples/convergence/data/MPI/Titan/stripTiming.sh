#!/bin/bash

comp=$1
type=$2

if [[ $3 == 0 ]]; then
    comm='comp'
else
    comm='comm'
fi
fn=timing_${comm}_${comp}_${type}

echo "#Ele N Time Error" > $fn
if [[ $3 == 0 ]]; then
for file in ${1}_${2}_*
do
    printf "%s" "$file" >> $fn
    grep "total computation " $file | tr '\n' ' ' >> $fn
    grep "1000.*Linf" $file | awk '{print $9}' >> $fn
done
else
    if [[ $2 == 'GPU' ]]; then
        grep "total ACC communication  " ${1}_${2}_* >> $fn
    else
        grep "total communication  " ${1}_${2}_* >> $fn
    fi
fi
cat $fn
sed -i "s/${comp}_${type}_E//g" $fn 
if [[ $3 == 0 ]]; then
    sed -i 's/total computation/ /g' $fn
else
    if [[ $2 == 'GPU' ]]; then
        sed -i 's/total ACC communication/ /g' $fn
    else
        sed -i 's/total communication/ /g' $fn
    fi
fi

sed -i 's/_N/ /g' $fn
sed -i 's/://g' $fn
sed -i 's/sec//g' $fn
sed -i 's/  */ /g' $fn

sort -n -k1,1 -k2,2 $fn -o $fn
