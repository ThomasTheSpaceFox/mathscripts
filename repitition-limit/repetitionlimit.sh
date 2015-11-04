#!/bin/bash
WHEREAMI="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd && echo)"
cd $WHEREAMI


# Change to your needs:
# MAIN OPTIONS:

# input and repititions calculations base number
ibase=10
# output base number  (conversions are automatic)
obase=10
# controls number of decimal places after decimal point
SCALE=10
# number of repititions to be calculated
REP=300

# main printout mode:
# KEY:
# 0=only final result 1=full table 2=prints at a defined variable
# 3=selective printout (see selective printout section)
#
REPTABLE=1
# beginning value for dynamic number
NUMA=0
# Static number
NUMB=1
# action to be preformed each repitition
ACT="+"
# ----------------------------------
# VARTABLE OPTIONAL POST-CALCULATIONS:

# Vartable's calculations are done in decimal,
# results will be converted to your designated 
# output base number automatically.

# Vartable is a simple variable equation solution script.
# for example: z*2=4 is sent to vartable. it solves for z
# and returns the value z=2 (or in reptable's case, 2)

# see vartable's comments for more info.

# emable post calculations in vartable? 1=yes 0=no
vartable=0
# varfirst: 1=variable to solve for is first
varfirst=0
# 1=result from reptable is solution 0=result from reptable is not solution
issolution=1
# other acting number
othernum="2.3"
# 

# action used it vartable post-calculations (+-/*)
varact="-"
# ----------------------------------
# MISIC. PRINTING OPTIONS:

# mode 2 print interval:
PLOCK=260
# mode 2 print last result of table (0=off 1=on):
PRINTLAST=0
# print NUMA at beginning of table (0=off 1=on):
PRINTNUMA=1
# ----------------------------------
# SELECTIVE PRINTOUT:

# uses a user designated text file in the 
# same directory as the script

# mode 3 list file (must be in same directory):
MLIST=repititionstoprint.txt


# ----------------------------------

# turn audiable bells on or off. 0=off 1=on
BELL=0
# ----------------------------------

# NOTE: Program will BEEP a low tone every time KBANG value is reached. (1000 by default)
# NOTE: Program will beep a higher tone when the calculations have completed.

# See replimit2.txt for a raw line-by-line table. ex calculation 2 is on line 2
# see replimit.txt contains info on the configuration above. consiquently, the table is not line-for-line.

# ==================================

# DO NOT CHANGE
VARI="x"
EQUAL="="
KBANG=1000
KCALCCNT=0
REPCOUNT=0
PRINTCOUNT=0
MLISTCOUNT=0
MLISTREAD=0
ICOUNT=1
XLCOUNT=1
ILOCK=$WHEREAMI/$MLIST
IBATCH=$(cat $ILOCK)
PRECACHE=$NUMA
echo "(digits after decimal point)         SCALE=$SCALE" > replimit.txt
echo "(number of repititions to preform)   REP=$REP" >> replimit.txt
echo "(mode for printout)                  REPTABLE=$REPTABLE" >> replimit.txt
echo "(starting value for dynaic number)   NUMA=$NUMA" >> replimit.txt
echo "(static number)                      NUMB=$NUMB" >> replimit.txt
echo "                                     ACT=$ACT" >> replimit.txt
echo "(Print interval for mode 2)          PLOCK=$PLOCK" >> replimit.txt
echo "(print last result in mode 2)        PRINTLAST=$PRINTLAST" >> replimit.txt
echo "(print NUMA at beginning of table)   PRINTNUMA=$PRINTNUMA" >> replimit.txt
echo "(input and calculations base number) ibase=$ibase" >> replimit.txt
echo "(output and printout base number)    obase=$obase" >> replimit.txt
echo "-----------------------------------------------------" >> replimit.txt
echo "" >> replimit.txt
echo -n "" > replimit2.txt
echo -n "" > vartable-output.txt
echo "secondary number:  $othernum" >> vartable-output.txt
echo "action sent to vartable:  $varact" >> vartable-output.txt
echo "is variable first:    $varfirst" >> vartable-output.txt
echo "is number from repitition calculation solution: $issolution" >> vartable-output.txt
echo "base number of these results: $obase" >> vartable-output.txt
echo "-----------------------------------------------------" >> vartable-output.txt
echo -n "" > vartable-output2.txt
echo -n "" > CALCNUM.txt
echo -n "" > EQUAT.txt
echo -n "" > RESULT.txt
if [ "$ibase" = "10" ]; then
  IBASED=""
  oclamp=""
fi
if [ "$obase" = "10" ]; then
  OBASED=""
fi
if [ "$(echo "10<$ibase" | bc)" = "1" ]; then
  if [ "$ibase" = "16" ]; then
    IBASED="
    ibase=16"
    oclamp="
    obase=16"
  fi
fi
if [ "$(echo "10<$obase" | bc)" = "1" ]; then
  if [ "$obase" = "16" ]; then
    OBASED="
    obase=16"
    obasecon=1
  fi
fi
if [[ "$(echo "$ibase>1" | bc)" = "1" && "$(echo "$ibase<10" | bc)" = "1" ]]; then
  IBASED="
  ibase=$ibase"
  oclamp="
  obase=$ibase"
fi
if [[ "$(echo "$obase>1" | bc)" = "1" && "$(echo "$obase<10" | bc)" = "1" ]]; then
  OBASED="
  obase=$obase"
  obasecon=1
fi
if [ "$ibase" = "$obase" ];then
  obasecon=0
else
  obasecon=1
fi
# first number printer
if [ "$PRINTNUMA" = "1" ]; then
  NUME=$(echo "scale=$SCALE$IBASED$OBASED;$NUMA" | BC_LINE_LENGTH=0 bc)
  echo "$NUME" >> replimit.txt
  echo "-----" >> replimit.txt
  echo "$NUME" >> replimit2.txt
fi
# repitition calculations system
until [ "$REPCOUNT" = "$REP" ]
do
  CNT3=$(echo "$PRINTCOUNT+1" | BC_LINE_LENGTH=0 bc)
  PRINTCOUNT=$CNT3
  NUMC=$(echo -e "scale=$SCALE$IBASED$oclamp; $NUMA$ACT$NUMB" | BC_LINE_LENGTH=0 bc)
  NUMA=$NUMC
  if [ "$obasecon" = "1" ]; then
    NUMD=$(echo "scale=$SCALE$IBASED$OBASED;$NUMC" | BC_LINE_LENGTH=0 bc)
  else
    NUMD=$NUMC
  fi
  if [ "$vartable" = "1" ]; then
    NUME=$(echo "scale=$SCALE$IBASED;$NUMC" | BC_LINE_LENGTH=0 bc)
    if [ "$varfirst" = "1" ]; then
      if [ "$issolution" = "1" ]; then
        NUMF=$($WHEREAMI/vartable-replimit.sh "$VARI$varact$othernum$EQUAL$NUME")
        echo "$VARI$varact$othernum$EQUAL$NUME" >> vartable-output.txt
      else
        NUMF=$($WHEREAMI/vartable-replimit.sh "$VARI$varact$NUME$EQUAL$othernum")
        echo "$VARI$varact$NUME$EQUAL$othernum" >> vartable-output.txt
      fi
    else
      if [ "$issolution" = "1" ]; then
        NUMF=$($WHEREAMI/vartable-replimit.sh "$othernum$varact$VARI$EQUAL$NUME")
        echo "$othernum$varact$VARI$EQUAL$NUME" >> vartable-output.txt
      else
        NUMF=$($WHEREAMI/vartable-replimit.sh "$NUME$varact$VARI$EQUAL$othernum")
        echo "$NUME$varact$VARI$EQUAL$othernum" >> vartable-output.txt
      fi
    fi
    NUMG=$(echo "scale=$SCALE$OBASED;$NUMF" | BC_LINE_LENGTH=0 bc)
    echo "x=$NUMG" >> vartable-output.txt
    echo "(calculation $(echo "$REPCOUNT+1" | bc))" >> vartable-output.txt
    echo "" >> vartable-output.txt
    echo "$NUMG" >> vartable-output2.txt
  fi
  if [ "$REPTABLE" = "1" ]; then
    echo "$NUMD" >> replimit.txt
    echo "$NUMD" >> replimit2.txt
  fi
  if [[ "$REPTABLE" = "2" && "$PRINTCOUNT" = "$PLOCK" ]]; then
    echo "" >> replimit.txt
    echo "calculation $(echo "$REPCOUNT+1" | bc):" >> replimit.txt
    echo "$PRECACHE$ACT$NUMB" >> replimit.txt
    echo "result:" >> replimit.txt
    echo "$NUMD" >> replimit.txt
    echo "" >> replimit.txt
    echo "$NUMD" >> replimit2.txt
    PRINTCOUNT=0
  fi
  if [ "$REPTABLE" = "3" ]; then
    for f in $IBATCH
    do
      if [ "$f" = "$(echo "$REPCOUNT+1" | bc)" ]; then
        echo "" >> replimit.txt
        echo "calculation $(echo "$REPCOUNT+1" | bc):" >> replimit.txt
        echo "found match: calculation $(echo "$REPCOUNT+1" | bc)"
        echo "$PRECACHE$ACT$NUMB" >> replimit.txt
        echo "result:" >> replimit.txt
        echo "$NUMD" >> replimit.txt
        echo "" >> replimit.txt
        echo "$NUMD" >> replimit2.txt
      fi
    done
  fi
#  if [ "$REPTABLE" = "3" ]; then
#    echo "$(echo "$REPCOUNT+1" | bc)" >> CALCNUM.txt
#    echo "$PRECACHE$ACT$NUMB" >> EQUAT.txt
#    echo "$NUMD" >> RESULT.txt
#  fi
  if [ "$KCALCCNT" = "$KBANG" ]; then
    if [ "$BELL" = "1" ]; then
      beep -f 322
    fi
    KCALCCNT=0
  fi
  PRECACHE=$NUMD
  CNT1=$(echo "$REPCOUNT+1" | BC_LINE_LENGTH=0 bc)
  REPCOUNT=$CNT1
  CNT2=$(echo "$KCALCCNT+1" | BC_LINE_LENGTH=0 bc)
  KCALCCNT=$CNT2
  echo $REPCOUNT
done
if [ "$BELL" = "1" ]; then
  beep -f 586
fi
echo "repitition table calculated"
if [ "$REPTABLE" = "0" ]; then
    echo "final result after $REPCOUNT calculations" >> replimit.txt
    echo "$NUMD" >> replimit.txt
    echo "$NUMD" >> replimit2.txt
fi
if [[ "$REPTABLE" = "2" && "$PRINTLAST" = "1" ]]; then
    echo "final result after $REPCOUNT calculations" >> replimit.txt
    echo "$NUMD" >> replimit.txt
    echo "$NUMD" >> replimit2.txt
fi
FIXRPDTCT=$(echo "$REP+1" | BC_LINE_LENGTH=0 bc)
# selective output compiler
#if [ "$REPTABLE" = "3" ]; then
#  echo "please wait, compiling selected results..."  
#  for f in $IBATCH
#  do
##    XLCOUNT=1
#    ZIP=0
#    echo "checking..."
#    until [[ "$XLCOUNT" = "$FIXRPDTCT" || "ZIP" = "1" ]]
#    do
#      if [ "$(sed ''$XLCOUNT'q;d' $WHEREAMI/CALCNUM.txt)" = "$f" ]; then
#        ZIP=1
#        echo "" >> replimit.txt
#        echo "calculation $(sed ''$XLCOUNT'q;d' $WHEREAMI/CALCNUM.txt):" >> replimit.txt
#        echo "found match: calculation $(sed ''$XLCOUNT'q;d' $WHEREAMI/CALCNUM.txt)"
#        echo "$(sed ''$XLCOUNT'q;d' $WHEREAMI/EQUAT.txt)" >> replimit.txt
#        echo "result:" >> replimit.txt
#        echo "$(sed ''$XLCOUNT'q;d' $WHEREAMI/RESULT.txt)" >> replimit.txt
#        echo "" >> replimit.txt
#        echo "$(sed ''$XLCOUNT'q;d' $WHEREAMI/RESULT.txt)" >> replimit2.txt
#      fi
#      CNT5=$(echo "$XLCOUNT+1" | BC_LINE_LENGTH=0 bc)
#      XLCOUNT=$CNT5
#    done
#  done
#  echo "done"
#fi  