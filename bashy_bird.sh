#!/usr/bin/bash

# Constants
readonly SCREEN_WIDTH=50
readonly SCREEN_HEIGHT=20
readonly PIPE_WIDTH=3
readonly PIPE_GAP=5
readonly sleep_time=0.1

# Initial positions
bird_x=5
bird_y=10
pipe_x=$SCREEN_WIDTH
pipe_gap_y=$((RANDOM % (SCREEN_HEIGHT - PIPE_GAP)))

function draw
{
    for ((i=0; i<SCREEN_HEIGHT; i++)); do
        for ((j=0; j<SCREEN_WIDTH; j++)); do
            if ((i == bird_y && j == bird_x)); then
                # Draw the bird
                echo -ne "\033[33m◾\033[0m"
            elif ((j >= pipe_x && j < pipe_x + PIPE_WIDTH)); then
                # Draw the pipes
                if ((i < pipe_gap_y || i >= pipe_gap_y + PIPE_GAP)); then
                    echo -ne "\033[32m█\033[0m" # Green pipes
                else
                    echo -n " " # Gap in the pipe
                fi
            else
                echo -n " "
            fi
        done
        echo ""
    done
}

# Main game loop
while true; do
    clear
    draw
    stty -echo -icanon time 0 min 0
    key=$(dd bs=1 count=1 2>/dev/null)
    stty sane

    # Bird movement
    if [[ $key == " " ]]; then
        bird_y=$((bird_y - 1))
    else
        bird_y=$((bird_y + 1))
    fi

    # Prevent bird from going out of bounds
    if ((bird_y < 0)); then
        bird_y=0
    fi
    if ((bird_y >= SCREEN_HEIGHT)); then
        clear
        echo "Game Over!"
        break
    fi

    # Move pipes
    pipe_x=$((pipe_x - 1))

    # Generate new pipe when the current one goes off-screen
    if ((pipe_x + PIPE_WIDTH < 0)); then
        pipe_x=$SCREEN_WIDTH
        pipe_gap_y=$((RANDOM % (SCREEN_HEIGHT - PIPE_GAP)))
    fi

    # Collision detection
    if ((bird_x >= pipe_x && bird_x < pipe_x + PIPE_WIDTH)); then
        if ((bird_y < pipe_gap_y || bird_y >= pipe_gap_y + PIPE_GAP)); then
            clear
            echo "Game Over!"
            break
        fi
    fi

    # Debugging output
    echo "Bird: ($bird_x, $bird_y), Pipe: ($pipe_x, Gap: $pipe_gap_y-$((pipe_gap_y + PIPE_GAP)))"

    sleep $sleep_time
done
