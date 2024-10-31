filename = "hex_screen.txt"

file = open(filename, 'w')

for i in range(19200):
    file.write("000\n")
file.close()
print("done")