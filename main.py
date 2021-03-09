import random
import math
from itertools import chain
# from colorama import Fore

def print_field(field:list) -> None:
    field_size = int(math.sqrt(len(field)))
    print('# # # # # # # # # # #')
    print('#\t' + '\t' * (field_size - 1) + '\t#')                        # empty line
    for i in range(field_size):
        print('#\t' + '\t'.join(str(num) for num in field[field_size * i : field_size + field_size * i]) + '\t#')      # separate num with spaces
        print('#\t' + '\t' * (field_size - 1) + '\t#')  # empty line
    print('# # # # # # # # # # #')

def add_num_to_field(field: list) -> list:
    if min(field) != 0:     # check if there is any space to replace a 0
        return field
    # try:                # check if there is any space to replace a 0
    #     field.index(0)
    # except ValueError:
    #     return field
    while True:
        random_index = random.randrange(0, len(field))
        if field[random_index] == 0:
            field[random_index] = 2
            break
    return field

def move_nums_to_side(lines, field_size) -> list:
    for i in range(len(lines)):                             # iterate through all lines
        if max(lines[i]) == 0:                              # line with only zeros can be skipped
            continue
        lines[i] = list(filter(lambda x: x != 0, lines[i])) # sort out all zeros
        if len(lines[i]) != 1:                              # no need to check for merging numbers if line is only 1 element
            for j in reversed(range(len(lines[i]))):
                if lines[i][j] == 0:                        # skip new zeros
                    continue
                if lines[i][j] == lines[i][j - 1]:          # if two numbers next to another are the same
                    lines[i][j] *= 2                        # double the right one
                    lines[i][j - 1] = 0                     # zero the other one
            lines[i] = list(filter(lambda x: x != 0, lines[i]))  # sort out all new zeros
        while len(lines[i]) != field_size:  # fill up with zeros
            lines[i].insert(0, 0)
    return lines

def swipe_up(current_field: list) -> list:
    pass

def swipe_left(current_field: list) -> list:
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

def swipe_right(current_field: list) -> list:
    field_size = int(math.sqrt(len(current_field)))
    lines = [current_field[field_size * i: field_size * i + field_size] for i in range(field_size)]
    lines = move_nums_to_side(lines, field_size)
    return list(chain.from_iterable(lines))

def swipe(current_field: list, direction: str) -> list:
    if direction == 'w':
        return swipe_up(current_field)
    if direction == 'a':
        return swipe_left(current_field)
    if direction == 's':
        return swipe_down(current_field)
    if direction == 'd':
        return swipe_right(current_field)


field_size = 4
field = [0 for _ in range(1, field_size ** 2 + 1)]     # initialize field with zeros
# field = [i for i in range(1, field_size ** 2 + 1)]     # initialize field with zeros

print(field)

field = add_num_to_field(field)
field = add_num_to_field(field)
field = add_num_to_field(field)
field = add_num_to_field(field)
field = add_num_to_field(field)
field = add_num_to_field(field)
field = add_num_to_field(field)
field = add_num_to_field(field)
field = add_num_to_field(field)
field = add_num_to_field(field)

print('Use\tW\tA\tS\tD to swipe\n\tup\tleft\tdown\tright.\nPress Enter to confirm.')

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
