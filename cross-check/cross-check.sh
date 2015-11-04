#!/bin/bash
WHEREAMI="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd && echo)"
cd $WHEREAMI
# leave the table you wish to use un-commented:
#TABLE=$(cat numbertable999.txt)
#TABLE=$(cat numbertable99.txt)
#TABLE=$(cat numbertable29.txt)
TABLE=$(cat numbertable9.txt)
TABLE1=$TABLE
TABLE2=$TABLE
# solution to generate equations for:
EQUATEQ="5"

echo -n "" > results.txt

for f in $TABLE1
do
  echo "table 1 change: $f"
  for g in $TABLE2
  do
    devide="1"
    devide2="1"
    echo "table 2 change: $g"
    if [ "$g" = "0" ]; then
      devide="0"
    fi
    if [ "$f" = "0" ]; then
      devide="0"
    fi
    if [ "$g" = "0" ]; then
      devide2="0"
    fi
    if [ "$f" = "0" ]; then
      devide2="0"
    fi
    if [ "$g" = "$f" ]; then
      devide2="0"
    fi
    if [ "$(echo "$f-$g" | bc)" = "$EQUATEQ" ]; then 
      echo "$f-$g=$EQUATEQ" >> results.txt
      echo "match found"
      echo "$f-$g=$EQUATEQ"
    fi
    if [ "$(echo "$f+$g" | bc)" = "$EQUATEQ" ]; then 
      echo "$f+$g=$EQUATEQ" >> results.txt
      echo "match found"
      echo "$f+$g=$EQUATEQ"
    fi
    if [ "$(echo "$g-$f" | bc)" = "$EQUATEQ" ]; then 
      echo "$g-$f=$EQUATEQ" >> results.txt
      echo "match found"
      echo "$g-$f=$EQUATEQ"
    fi
    if [ "$(echo "$f*$g" | bc)" = "$EQUATEQ" ]; then 
      echo "$f*$g=$EQUATEQ" >> results.txt
      echo "match found"
      echo "$f*$g=$EQUATEQ"
    fi
    if [ "$devide" = "1" ]; then
      if [ "$(echo "scale=3;$f/$g" | bc)" = "$EQUATEQ.000" ]; then 
        echo "$f/$g=$EQUATEQ" >> results.txt
        echo "match found"
        echo "$f/$g=$EQUATEQ"
      fi
    fi
    if [ "$devide2" = "1" ]; then
      if [ "$(echo "scale=3;$g/$f" | bc)" = "$EQUATEQ.000" ]; then 
        echo "$g/$f=$EQUATEQ" >> results.txt
        echo "match found"
        echo "$g/$f=$EQUATEQ"
      fi
    fi
    if [[ "$(echo "$g*$f" | bc)" = "$EQUATEQ" && "$f" != "$g" ]]; then 
      echo "$g*$f=$EQUATEQ" >> results.txt
      echo "match found"
      echo "$g*$f=$EQUATEQ"
    fi
    if [[ "$(echo "$g+$f" | bc)" = "$EQUATEQ" && "$f" != "$g" ]]; then 
      echo "$g+$f=$EQUATEQ" >> results.txt
      echo "match found"
      echo "$g+$f=$EQUATEQ"
    fi
  done
done
echo "__________________________"
cat results.txt
