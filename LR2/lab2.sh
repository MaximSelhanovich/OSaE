#!/bin/sh

player_1_character="X"
player_2_character="O"

move=1
game_on=true

moves=( 1 2 3 4 5 6 7 8 9 )

welcome_message() {
 	clear
	echo "========================"
	echo "=== LETS PLAY A GAME ==="
	echo "========================"
	sleep 2
}
print_board() {
	clear
	echo " ${moves[0]} | ${moves[1]} | ${moves[2]} "
	echo "-----------"
	echo " ${moves[3]} | ${moves[4]} | ${moves[5]} "
	echo "-----------"
	echo " ${moves[6]} | ${moves[7]} | ${moves[8]} "
	echo "============="
}

player_pick() {
	if [[ $(($move % 2)) == 0 ]]
	then
		play_character=$player_2_character
		echo -n "(Move $move)PLAYER 2 PICK A SQUARE: "
	else
		echo -n "(Move $move)PLAYER 1 PICK A SQUARE: "
		play_character=$player_1_character
	fi
	
	read square

	if [[ ! $square =~ ^-?[0-9]+$ ]] || [[ ! ${moves[($square-1)]}  =~ ^[0-9]+$ ]]; then 
		echo "Not a valid square"
		player_pick
	else
		moves[($square-1)]=$play_character
		((move += 1))
	fi
}

check_match() {
	if [[ ${moves[$1]} == ${moves[$2]} ]] && \
		[[ ${moves[$2]} == ${moves[$3]} ]]; then
		game_on=false
	fi
	if [ $game_on == false ]; then
		if [ ${moves[$1]} == $player_1_character ]; then
			echo "Player one wins!"
		else
			echo "Player two wins!"
		fi
	fi
}

check_winner() {
	if [ $game_on == false ]; then return; fi
	check_match 0 1 2
	if [ $game_on == false ]; then return; fi
	check_match 3 4 5
	if [ $game_on == false ]; then return; fi
	check_match 6 7 8
	if [ $game_on == false ]; then return; fi
	check_match 0 4 8
	if [ $game_on == false ]; then return; fi
	check_match 2 4 6
	if [ $game_on == false ]; then return; fi
	check_match 0 3 6
	if [ $game_on == false ]; then return; fi
	check_match 1 4 7
	if [ $game_on == false ]; then return; fi
	check_match 2 5 8
	if [ $game_on == false ]; then return; fi

	if [ $move -gt 9 ]; then 
		game_on=false
		echo "Its a draw!"
	fi
}

choose_characters() {
	while true
	do
		echo "PLAYER 1 CHOOSE CHARACTER TO PLAY: "
		read player_1_character
		if [[ ${#player_1_character} == 1 ]] && [[ ! $player_1_character =~ ^[0-9]+$ ]]; then break; fi
		echo "INVALID CHARACTER: $player_1_character"
	done
	
	while true
	do
		echo "PLAYER 2 CHOOSE CHARACTER TO PLAY: "
		read player_2_character
		if [[ ${#player_2_character} == 1 ]] && \
			[[ ! $player_1_character =~ ^[0-9]+$ ]] && \
			[[ $player_2_character != $player_1_character ]]; then break; fi
		echo "INVALID CHARACTER OR ALREADY TAKEN: $player_2_character"
	done
}

welcome_message
choose_characters
print_board
while $game_on
do
	player_pick
	print_board
	check_winner
done
