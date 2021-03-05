field_size = 4

field = [[0 for _ in range(field_size)] for _ in range(field_size)]     # initialize field with zeros

def print_field() -> None:
    global field
    print('#########################################')
    print('#\t' + '\t' * (field_size - 1) + '\t#')                        # empty line
    for line in field:
        print('#\t' + '\t'.join(str(num) for num in line) + '\t#')      # separate num with spaces
        print('#\t' + '\t' * (field_size - 1) + '\t#')                        # empty line
    print('#\t' + '\t' * (field_size - 1) + '\t#')                        # empty line
    print('#########################################')

print_field()

