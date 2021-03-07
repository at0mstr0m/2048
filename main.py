import random
import math
from colorama import Fore
from itertools import chain

def print_field(field:list) -> None:
    field_size = int(math.sqrt(len(field)))
    print('# # # # # # # # # # #')
    print('#\t' + '\t' * (field_size - 1) + '\t#')                        # empty line
    for i in range(field_size):
        print('#\t' + '\t'.join(str(num) for num in field[field_size * i : field_size + field_size * i]) + '\t#')      # separate num with spaces
        print('#\t' + '\t' * (field_size - 1) + '\t#')  # empty line
    print('# # # # # # # # # # #')

def add_num_to_field(field: list) -> list:
    try:                # check if there is any space to replace a 0
        field.index(0)
    except ValueError:
        return field
    while True:
        random_index = random.randrange(0, len(field))
        if field[random_index] == 0:
            field[random_index] = random.choice([2,4])
            break
    return field

def swipe_up(field: list) -> list:
    pass

def swipe_left(field: list) -> list:
    pass

def swipe_down(current_field: list) -> list:
    field_size = int(math.sqrt(len(current_field)))
    #lines = [current_field[field_size * i: field_size * i + field_size] for i in range(field_size)]
    #columns = [current_field[i::field_size] for i in range(field_size)]

    to_skip = []
    for i in range(len(current_field) - field_size - 1, -1, -1):    # am unteren rand zuerst zusammenfügen
        if i in to_skip or current_field[i] == 0:
            continue
        if current_field[i] == current_field[i + field_size]:
            current_field[i + field_size] *= 2
            current_field[i] = 0
            to_skip.append(i + field_size)
        if current_field[i + field_size] == 0:
            current_field[i + field_size] = current_field[i]
            current_field[i] = 0
            to_skip.append(i + field_size)
    return current_field

def swipe_right(field: list) -> list:
    pass

def swipe(field: list, direction: str) -> list:
    if direction == 'w':
        return swipe_up(field)
    if direction == 'a':
        return swipe_left(field)
    if direction == 's':
        return swipe_down(field)
    if direction == 'd':
        return swipe_right(field)


field_size = 4
field = [0 for _ in range(1, field_size ** 2 + 1)]     # initialize field with zeros
# field = [i for i in range(1, field_size ** 2 + 1)]     # initialize field with zeros

add_num_to_field(field)
add_num_to_field(field)
add_num_to_field(field)
add_num_to_field(field)
add_num_to_field(field)

print(Fore.BLUE + 'Use\tW\tA\tS\tD to swipe\n\tup\tleft\tdown\tright.\nPress Enter to confirm.')

game_over = False

print_field(field)

while game_over == False:     # game loop
    player_input = ''
    while True:
        player_input = input('Your input here: ')
        if player_input.lower() in ['w', 'a', 's', 'd']:
            field = swipe(field, player_input)
            break
        print('Wrong Input! Only up left down & right via W A S & D are possible.')
    print_field(field)
