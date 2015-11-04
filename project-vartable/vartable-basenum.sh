#!/bin/bash
WHEREAMI="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd && echo)"
cd $WHEREAMI
CLOCK=1
echo "vartable V1.0.1"
set -f
echo "set base number: (2-10)"
read base
#instring=$1
echo "enter equation:"
read instring
classbatch=$(echo $instring | grep -o .)
# base 2-10 supported  (faults to base 10)
#base=$2
#base="3"

if [[ "$(echo "$base>1" | bc)" = "1" && "$(echo "$base<10" | bc)" = "1" ]]; then
  IBASED="
  ibase=$base"
  OBASED="
  obase=$base"
else
  IBASED=""
  OBASED=""
fi
baseD="$IBASED$OBASED"
symbatch="+
-
/
*"
alphibatch="a
b
c
d
e
f
g
h
i
j
k
l
m
n
o
p
q
r
s
t
u
v
w
x
y
z"
numbatch="0
1
2
3
4
5
6
7
8
9
."
for alph in $alphibatch
do
  for class in $classbatch
  do
    if [ "$alph" = "$class" ];then
      solvefor=$class
    fi
  done
done
PREPOSTEQ="PRE"
CHARCOUNT="0"
LOCAN="0"
echo -n "" > num1.vartable.txt
echo -n "" > num2.vartable.txt
for f in $classbatch
do
  if [ "$f" = "$solvefor" ]; then
    varID1=$f
    if [ "$LOCAN" = "0" ]; then
      isvarfirst=1
    else
      isvarfirst=0
    fi
  fi
  for h in $numbatch
  do
    if [[ "$h" = "$f" && "$PREPOSTEQ" = "POST" ]]; then
      echo -n "$h" >> num2.vartable.txt
    fi
    if [[ "$h" = "$f" && "$PREPOSTEQ" = "PRE" ]]; then
      echo -n "$h" >> num1.vartable.txt
    fi
  done
  for g in $symbatch
  do
    if [ "$g" = "$f" ]; then
      act=$f
    fi
  done
  if [ "$f" = "=" ]; then
    PREPOSTEQ="POST"
  fi
  if [ "$LOCAN" = "0" ]; then
    LOCAN=1
  fi
done    
NUM1=$(cat num1.vartable.txt)
NUM2=$(cat num2.vartable.txt)
if [[ "$act" = "+" && "$isvarfirst" = "1" ]]; then
  VARis=$(echo "scale=6$baseD;$NUM2-$NUM1" | bc)
fi
if [[ "$act" = "+" && "$isvarfirst" = "0" ]]; then
  VARis=$(echo "scale=6$baseD;$NUM2-$NUM1" | bc)
fi
if [[ "$act" = "-" && "$isvarfirst" = "1" ]]; then
  VARis=$(echo "scale=6$baseD;$NUM2+$NUM1" | bc)
fi
if [[ "$act" = "-" && "$isvarfirst" = "0" ]]; then
  VARis=$(echo "scale=6$baseD;$NUM1-$NUM2" | bc)
fi
if [[ "$act" = "*" && "$isvarfirst" = "1" ]]; then
  VARis=$(echo "scale=6$baseD;$NUM2/$NUM1" | bc)
fi
if [[ "$act" = "*" && "$isvarfirst" = "0" ]]; then
  VARis=$(echo "scale=6$baseD;$NUM2/$NUM1" | bc)
fi
if [[ "$act" = "/" && "$isvarfirst" = "1" ]]; then
  VARis=$(echo "scale=6$baseD;$NUM2*$NUM1" | bc)
fi
if [[ "$act" = "/" && "$isvarfirst" = "0" ]]; then
  VARis=$(echo "scale=6$baseD;$NUM1/$NUM2" | bc)
fi
echo "$varID1=$VARis"
echo "base $base"
