import random
import math
from itertools import chain
from colorama import init, Fore

init(autoreset=True)

game_over = False
color_codes = {0: Fore.RESET,
               2: Fore.RED,
               4: Fore.GREEN,
               8: Fore.YELLOW,
               16: Fore.BLUE,
               32: Fore.MAGENTA,
               64: Fore.CYAN,
               128: Fore.LIGHTBLUE_EX,
               256: Fore.LIGHTRED_EX,
               512: Fore.LIGHTGREEN_EX,
               1024: Fore.LIGHTCYAN_EX,
               2048: Fore.LIGHTYELLOW_EX}

def print_field(current_field:list) -> None:
    field_size = int(math.sqrt(len(current_field)))
    print('# # # # # # # # # # #')
    print('#\t' + '\t' * (field_size - 1) + '\t#')                        # empty line
    for i in range(field_size):
        print('#\t' + '\t'.join(color_codes[num] + str(num) for num in current_field[field_size * i : field_size + field_size * i]) + Fore.RESET + '\t#')      # separate num with spaces
        print('#\t' + '\t' * (field_size - 1) + '\t#')  # empty line
    print('# # # # # # # # # # #')

def check_game_over(current_field: list) -> bool:
    field_size = int(math.sqrt(len(current_field)))
    return current_field\
           == swipe_down(current_field, field_size)\
           == swipe_up(current_field, field_size)\
           == swipe_right(current_field, field_size)\
           == swipe_left(current_field, field_size)     # if nothing happens after swiping, the game is over

def add_num_to_field(current_field: list) -> list:
    if min(current_field) != 0:         # check if there is any space to replace a 0
        if not check_game_over(current_field):  # if no movement is possible the game is lost
            global game_over
            game_over = True
        return current_field
    free_indices = [i for i, x in enumerate(current_field) if x == 0]
    random_index = random.choice(free_indices)
    current_field[random_index] = 2
    return current_field

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

def swipe_down(current_field: list, field_size: int) -> list:
    columns = [current_field[i::field_size] for i in range(field_size)]                                 # separate field into the separate columns
    columns = move_nums_to_side(columns, field_size)                                                    # apply swiping to columns
    return [columns[i][j] for j in range(field_size) for i in range(field_size)]                        # return result

def swipe_right(current_field: list, field_size: int) -> list:
    lines = [current_field[field_size * i: field_size * i + field_size] for i in range(field_size)]     # separate field into the separate lines
    lines = move_nums_to_side(lines, field_size)                                                        # apply swiping to lines
    return list(chain.from_iterable(lines))                                                             # return result


def swipe_left(current_field: list, field_size: int) -> list:
    lines = [current_field[field_size * i: field_size * i + field_size] for i in range(field_size)]     # separate field into the separate lines
    for line in lines:                                                                                  # reverse content to apply move_nums_to_side() the same way
        line.reverse()                                                                                  # it is applied in swipe_right() (quite lazy but handy solution)
    lines = move_nums_to_side(lines, field_size)                                                        # apply swiping to lines
    for line in lines:                                                                                  # reverse content to return it the same way
        line.reverse()                                                                                  # it is return in swipe_right() (quite lazy but handy solution)
    return list(chain.from_iterable(lines))                                                             # return result

def swipe_up(current_field: list, field_size: int) -> list:
    columns = [current_field[i::field_size] for i in range(field_size)]                                 # separate field into the separate columns
    for column in columns:                                                                              # reverse content to apply move_nums_to_side() the same way
        column.reverse()                                                                                # it is applied in swipe_down() (quite lazy but handy solution)
    columns = move_nums_to_side(columns, field_size)                                                    # apply swiping to columns
    for column in columns:                                                                              # reverse content to return it the same way
        column.reverse()                                                                                # it is return in swipe_right() (quite lazy but handy solution)
    return [columns[i][j] for j in range(field_size) for i in range(field_size)]                        # return result


def swipe(current_field: list, direction: str) -> list:
    field_size = int(math.sqrt(len(current_field)))
    if direction == 'w':
        return swipe_up(current_field, field_size)
    if direction == 'a':
        return swipe_left(current_field, field_size)
    if direction == 's':
        return swipe_down(current_field, field_size)
    if direction == 'd':
        return swipe_right(current_field, field_size)

square_size = 4
field = [0 for _ in range(1, square_size ** 2 + 1)]     # initialize field with zeros
# field = [i for i in range(1, field_size ** 2 + 1)]     # initialize field with numbers

print(field)

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
            field = add_num_to_field(field)
            break
        print('Wrong Input! Only up left down & right via W A S & D are possible.')
    print_field(field)
    if max(field) == 2048:
        print('WIN!')
        break
