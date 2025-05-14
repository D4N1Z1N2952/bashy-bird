#!/usr/bin/bash

# ▢ ◾

#constants
readonly SCREEN_WIDTH=50
readonly SCREEN_HEIGHT=20

#initial bird position
bird_x=5  # Horizontal position
bird_y=10 # Vertical position

function draw
{
    for ((i=0; i<SCREEN_HEIGHT; i++)); do
        for ((j=0; j<SCREEN_WIDTH; j++)); do
            if ((i == bird_y && j == bird_x)); then
                echo -ne "\033[33m◾\033[0m" #yellow bird
            else
                echo -n " "
            fi
        done
        echo ""
    done
}

function generate_pipe
{
    local down_pipe_height=$((RANDOM % (10 - 3)))
    local up_pipe_height=$((20 - down_pipe_height + 3))
    loacal distance_between_pipes=$((RANDOM % ()))
}


# Main game loop

while true; do
    clear
    draw
    stty -echo -icanon time 0 min 0
    key=$(dd bs=1 count=1 2>/dev/null)
    stty sane

    if [[ $key == " " ]]; then
        bird_y=$((bird_y - 1))
    else
        bird_y=$((bird_y + 1))
    fi

    if ((bird_y < 0)); then
        bird_y=0
    fi
    if ((bird_y >= SCREEN_HEIGHT)); then
        break
    fi
    echo "Bird position: ($bird_x, $bird_y)"
    sleep 0.1
done