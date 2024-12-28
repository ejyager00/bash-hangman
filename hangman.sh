#!/bin/bash

# Function to get hidden input for the secret word
get_secret_word() {
    echo -n "Enter the secret word: "
    stty -echo
    read secret_word
    stty echo
    echo
}

# Function to display the current game state
display_state() {
    echo " "
    echo "Word: $current_display"
    echo "Guesses: $guessed_letters"
    echo "Misses: $misses"
    echo "Remaining attempts: $((max_attempts - misses))"
}

# Initialize game variables
max_attempts=6
misses=0
current_display=""
guessed_letters=""

declare -A letter_found

# Get the secret word
get_secret_word

# Initialize the display with underscores
for ((i = 0; i < ${#secret_word}; i++)); do
    current_display+="_ "
    letter_found[${secret_word:$i:1}]=0
done

# Main game loop
while [[ "$current_display" =~ "_" && $misses -lt $max_attempts ]]; do
    display_state

    echo -n "Enter your guess: "
    read -n 1 guess
    echo

    if [[ "$guessed_letters" == *"$guess"* ]]; then
        echo "You already guessed '$guess'. Try a different letter."
        continue
    fi

    guessed_letters+="$guess "

    if [[ "$secret_word" == *"$guess"* ]]; then
        echo "Good guess!"
        temp_display=""
        for ((i = 0; i < ${#secret_word}; i++)); do
            if [[ "${secret_word:$i:1}" == "$guess" ]]; then
                temp_display+="$guess "
            else
                temp_display+="${current_display:$((i*2)):1} "
            fi
        done
        current_display="$temp_display"
    else
        echo "Sorry, '$guess' is not in the word."
        ((misses++))
    fi

    display_state
done

# Display final result
if [[ "$current_display" =~ "_" ]]; then
    echo "You lost! The word was '$secret_word'."
else
    echo "Congratulations! You guessed the word '$secret_word'."
fi
