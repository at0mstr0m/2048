import random
from itertools import chain
from sty import fg, rs

color_codes = {0: fg(0),
               2: fg(148),
               4: fg(112),
               8: fg(76),
               16: fg(79),
               32: fg(81),
               64: fg(153),
               128: fg(189),
               256: fg(225),
               512: fg(218),
               1024: fg(210),
               2048: fg(203)}

square_size = 4                                                                 # size of the field
field = random.sample([0] * (square_size ** 2 - 2) + [2] * 2, square_size ** 2) # fill the field with zeros and exactly two 2s

def print_field(field: list) -> None:
    for i in range(1, square_size + 1):
        print('  '.join(color_codes[num] + str(num).center(4)
                        for num
                        in field[square_size * (i - 1):square_size * i]) + rs.fg + '\n')  # separate num with spaces

def check_game_over(field: list) -> bool:
    return field \
           == swipe_down(field) \
           == swipe_up(field) \
           == swipe_right(field) \
           == swipe_left(field)    # if nothing happens after swiping, the game is over

def add_num_to_field(field: list) -> list:
    if min(field) != 0:  # check if there is any space to replace a 0
        return field
    free_indices = [i for i, x in enumerate(field) if x == 0]
    random_index = random.choice(free_indices)
    field[random_index] = 2
    return field

def move_nums_to_side(lines: list) -> list:
    for i in range(square_size):                                # iterate through all lines
        if max(lines[i]) == 0:                                  # line with only zeros can be skipped
            continue
        lines[i] = list(filter(lambda x: x != 0, lines[i]))     # sort out all zeros
        if len(lines[i]) != 1:                                  # no need to check for merging numbers if line is only 1 element
            for j in reversed(range(len(lines[i]))):
                if lines[i][j] == 0:                            # skip new zeros
                    continue
                if lines[i][j] == lines[i][j - 1]:              # if two numbers next to another are the same
                    lines[i][j] *= 2                            # double the right one
                    lines[i][j - 1] = 0                         # zero the other one
            lines[i] = list(filter(lambda x: x != 0, lines[i])) # sort out all new zeros
        while len(lines[i]) != square_size:                     # fill up with zeros
            lines[i].insert(0, 0)
    return lines

def swipe(field: list, direction: str) -> list:
    if direction == 'w':
        return swipe_up(field)
    if direction == 'a':
        return swipe_left(field)
    if direction == 's':
        return swipe_down(field)
    if direction == 'd':
        return swipe_right(field)

def swipe_up(field: list) -> list:
    columns = [field[i::square_size] for i in range(square_size)]
    for column in columns:                              # reverse content to apply move_nums_to_side() the same way
        column.reverse()                                # it is applied in swipe_down() (quite lazy but handy solution)
    columns = move_nums_to_side(columns)                # apply swiping to columns
    for column in columns:                              # reverse content to return it the same way
        column.reverse()                                # it is return in swipe_right() (quite lazy but handy solution)
    return [columns[i][j] for j in range(square_size) for i in range(square_size)]


def swipe_down(field: list) -> list:
    columns = [field[i::square_size] for i in range(square_size)]
    columns = move_nums_to_side(columns)                                            # apply swiping to columns
    return [columns[i][j] for j in range(square_size) for i in range(square_size)]  # return result

def swipe_right(field: list) -> list:
    lines = [field[square_size * (i - 1):square_size * i] for i in range(1, square_size + 1)]
    lines = move_nums_to_side(lines)                # apply swiping to lines
    return list(chain.from_iterable(lines))         # return result

def swipe_left(field: list) -> list:
    lines = [field[square_size * (i - 1):square_size * i] for i in range(1, square_size + 1)]
    for line in lines:                              # reverse content to apply move_nums_to_side() the same way
        line.reverse()                              # it is applied in swipe_right() (quite lazy but handy solution)
    lines = move_nums_to_side(lines)                # apply swiping to lines
    for line in lines:                              # reverse content to return it the same way
        line.reverse()                              # it is return in swipe_right() (quite lazy but handy solution)
    return list(chain.from_iterable(lines))         # return result
    # return result

print('\nUse\tW\tA\tS\tD to swipe\n   up left down right.\n\nPress Enter to confirm.')
print_field(field)

while True:                                                 # game loop
    player_input = ''
    if check_game_over(field):                              # check for game over
        print('You lose :(')
        break
    while True:
        player_input = input('Your input here: ')
        if player_input.lower() in ['w', 'a', 's', 'd']:
            old_field = field.copy()                        # prepare comparing field after swipe
            new_field = swipe(field, player_input)          # apply swipe
            if new_field == old_field:                      # compare field before and after swipe
                break                                       # field can stay the same for next swipe
            field = new_field.copy()
            field = add_num_to_field(field)
            break
        print('Wrong Input! Only up left down & right via W A S & D are possible.')
    print_field(field)
    if max(field) == 2048:                                  # check if there is a 2048 on the field now
        print('YOU WIN!')
        break
