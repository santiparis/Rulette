#!/bin/bash

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n${redColour}[!] Exiting program...${endColour}\n"
  tput cnorm; exit 1
}

function helpPanel(){
  echo -e "\t${yellowColour}[+]${endColour}${grayColour} Arguments:${endColour}\n"
  echo -e "\t${purpleColour}-m${endColour}\t${grayColour}Input the amount of $ you want to play (-m [$])" 
  echo -e "\t${purpleColour}-t${endColour}\t${grayColour}Input the technique to use (-t [TECHNIQUE] : martingala or inversedLabouchere)" 
  echo -e "\t${purpleColour}-h${endColour}\t${grayColour}Help panel\n"
  echo -e "${redColour}[!]${endColour}${grayColour} If you want to start playing you have to input both -m [$] and -t [TECHNIQUE]4${endColour}\n"
}

function martingala(){
  money="$1"
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Current money:${endColour}${purpleColour} \$${money}${endColour}\n"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} Place the first bet:${endColour} " && read initialBet
  echo -ne "${yellowColour}[+]${endColour}${grayColour} Choose where to place bets repeatedly (odd or even):${endColour} " && read odd_even
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Placing${endColour}${purpleColour} \$${initialBet}${endColour}${grayColour} on${endColour}${purpleColour} ${odd_even}${endColour}\n"

  if [ $odd_even != "odd" ] && [ $odd_even != "even" ]; then
    echo -e "\n${redColour}[!] Invalid bet option. Exiting program...${endColour}\n"
    tput cnorm; exit 1
  fi

  bet="$(echo "$initialBet")"
  play_counter=0
  last_plays=""
  max_money="0"

  tput civis

  while true; do

    if [ $(($money+0)) -lt $(($initialBet+0)) ]; then
      echo -e "${yellowColour}[+]${endColour}${grayColour} Total plays:${endColour}${yellowColour} ${play_counter}${endColour}\n"
      echo -e "${yellowColour}[+]${endColour}${grayColour} The max amount of money owned was:${endColour}${yellowColour} ${max_money}${endColour}\n"
      echo -e "${redColour}[+] Last plays: ${last_plays}${endColour}\n"

      echo -e "${redColour}[!] Lost all money. Exiting program...${endColour}"

      tput cnorm; exit 0
    fi

    random_number="$(($RANDOM%37))"

#    echo -e "${yellowColour}[+]${endColour}${grayColour} Betted:${endColour}${purpleColour} ${bet}${endColour}"
#    echo -e "${yellowColour}[+]${endColour}${grayColour} Pulled${endColour}${purpleColour} ${random_number}${endColour}"

    if [ $random_number == 0 ];then
      money="$(($money-$bet))"
      if [ $(($bet*2)) -le $(($money+0)) ]; then
        bet="$(($bet*2))"
      else
        bet="$(echo "$money")"
      fi
      last_plays+="$random_number "
#      echo -e "${yellowColour}[+]${endColour}${redColour} Lost the bet${endColour}"
#      echo -e "${yellowColour}[+]${endColour}${grayColour} Next Bet:${endColour}${purpleColour} ${bet}${endColour}"
    elif [ $odd_even == "odd" ]; then
      if [ $(($random_number%2)) -eq 1 ]; then
        money="$(($money+$bet))"
        bet=$initialBet
        last_plays=""

        if [ $(($money+0)) -gt $(($max_money+0)) ]; then
          max_money=$money
        fi
#        echo -e "${yellowColour}[+]${endColour}${greenColour} Won the bet${endColour}"
#        echo -e "${yellowColour}[+]${endColour}${grayColour} Next bet:${endColour}${purpleColour} ${bet}${endColour}"
      else
        money="$(($money-$bet))"
        if [ $(($bet*2)) -le $(($money+0)) ]; then
          bet="$(($bet*2))"
        else
          bet="$(echo "$money")"
        fi
        last_plays+="$random_number "
#        echo -e "${yellowColour}[+]${endColour}${redColour} Lost the bet${endColour}"
#        echo -e "${yellowColour}[+]${endColour}${grayColour} Next bet:${endColour}${purpleColour} ${bet}${endColour}"
      fi
    else
      if [ $(($random_number%2)) -eq 1 ]; then
        money="$(($money-$bet))"
        if [ $(($bet*2)) -le $(($money+0)) ]; then
          bet="$(($bet*2))"
        else
          bet="$(echo "$money")"
        fi
        last_plays+="$random_number "
#        echo -e "${yellowColour}[+]${endColour}${redColour} Lost the bet${endColour}"
#        echo -e "${yellowColour}[+]${endColour}${grayColour} Next bet:${endColour}${purpleColour} ${bet}${endColour}"
      else
        money="$(($money+$bet))"
        bet=$initialBet
        last_plays=""
        if [ $(($money+0)) -gt $(($max_money+0)) ]; then
          max_money=$money
        fi
#        echo -e "${yellowColour}[+]${endColour}${greenColour} Won the bet${endColour}"
#        echo -e "${yellowColour}[+]${endColour}${grayColour} Next bet:${endColour}${purpleColour} ${bet}${endColour}"
      fi
    fi
#    echo -e "${yellowColour}[+]${endColour}${grayColour} Money:${endColour}${purpleColour} ${money}${endColour}\n"
    let play_counter+=1
  done

  tput cnorm
}

function inverseLabouchere(){

  money=$1
  declare -a array=()
  play_counter=0
  max_money=0

  echo -ne "${yellowColour}[+]${endColour}${grayColour} Input the array length:${endColour} " && read betAmount
  echo -ne "${yellowColour}[+]${endColour}${grayColour} Choose where to place bets repeatedly (odd or even):${endColour} " && read odd_even
  if [ $odd_even != "odd" ] && [ $odd_even != "even" ]; then
    echo -e "\n${redColour}[!] Invalid bet option. Exiting program...${endColour}\n"
    tput cnorm; exit 1
  fi

  for i in $(seq $betAmount); do
    array[$i-1]=$i
  done

  tput civis

  while true; do

    if [ ${#array[@]} -eq 0 ]; then
      for i in $(seq $betAmount); do
        array[$i-1]=$i
      done
    fi
    
    if [ ${#array[@]} -ne 1 ] && [ $money -ge $((${array[0]}+${array[-1]})) ]; then
      bet=$((${array[0]}+${array[-1]}))
    elif [ ${#array[@]} -eq 1 ] && [ $money -ge $((${array[0]})) ]; then
      bet=${array[0]}
    else
      bet=$money
    fi

    if [ $money -eq 0 ]; then
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Total plays:${endColour}${yellowColour} ${play_counter}${endColour}\n"
      echo -e "${yellowColour}[+]${endColour}${grayColour} The max amount of money owned was:${endColour}${yellowColour} ${max_money}${endColour}\n"

      echo -e "${redColour}[!] Lost all money. Exiting program...${endColour}"

      tput cnorm; exit 0
    fi

    random_number=$(($RANDOM%37))

#    echo -e "${yellowColour}[+]${endColour}${grayColour} Betted:${endColour}${purpleColour} ${bet}${endColour}"
#    echo -e "${yellowColour}[+]${endColour}${grayColour} Pulled${endColour}${purpleColour} ${random_number}${endColour}"

    if [ $random_number -eq 0 ]; then
      money=$(($money-$bet))
      if [ ${#array[@]} -ne 1 ]; then
        unset array[-1]
      fi
      unset array[0]
      array=(${array[@]})
#      echo -e "${yellowColour}[+]${endColour}${redColour} Lost the bet${endColour}"
    elif [ "$odd_even" == "odd" ];then
      if [ $(($random_number%2)) -eq 0 ]; then
        money=$(($money-$bet))
        if [ ${#array[@]} -ne 1 ]; then
          unset array[-1]
        fi
        unset array[0]
        array=(${array[@]})
#        echo -e "${yellowColour}[+]${endColour}${redColour} Lost the bet${endColour}"
      else
        money=$(($money+$bet))
        array[${#array[@]}]=$bet
#        echo -e "${yellowColour}[+]${endColour}${greenColour} Won the bet${endColour}"
      fi
    else
      if [ $(($random_number%2)) -eq 0 ]; then
        money=$(($money+$bet))
        array[${#array[@]}]=$bet
#        echo -e "${yellowColour}[+]${endColour}${greenColour} Won the bet${endColour}"
      else
        money=$(($money-$bet))
        if [ ${#array[@]} -ne 1 ]; then
          unset array[-1]
        fi
        unset array[0]
        array=(${array[@]})
#        echo -e "${yellowColour}[+]${endColour}${redColour} Lost the bet${endColour}"
      fi
    fi

    if [ $money -gt $max_money ]; then
      max_money=$money
    fi

#    echo -e "${yellowColour}[+]${endColour}${grayColour} Money:${endColour}${purpleColour} ${money}${endColour}\n"
    let play_counter+=1
  done

  tput cnorm
}

# Ctrl+C

trap ctrl_c INT

while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG; let parameter_counter+=1;;
    t) tech=$OPTARG; let parameter_counter+=2;;
    h) helpPanel;;
  esac
done

if [ "$money" ] && [ "$tech" ]; then
  if [ "$tech" == "martingala" ]; then
    martingala $money
  elif [ "$tech" == "inverseLabouchere" ]; then
    inverseLabouchere $money
  else
    echo -e "\n${redColour}[!] Error. Technique not found${endColour}"
    exit 1
  fi
else
  helpPanel
fi
