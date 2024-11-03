filename = "hex_screen.txt"

file = open(filename, 'w')

for i in range(19200):
    if (i < 160):
        file.write("F00\n")
    elif (i>19100):
        file.write("FF0\n")
    elif (i%3 == 1):
        file.write("0F0\n")
    else:
        file.write("00F\n")
file.close()
print("done")