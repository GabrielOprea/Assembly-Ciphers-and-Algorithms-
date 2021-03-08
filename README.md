# Assembly-Ciphers-and-Algorithms-
Implemented in x86 Assembly the Caesar, One-Time Pad and Vigenere Ciphers, alongside an equivalent function to strstr from C and a binary to hexadecimal converter.

bin_to_hex: Firstly I calculated the length of de hexadecimal sequence by dividing the
binary sequence length by 4(and rounding if necessary). If the binary sequence length
is not divisible by 4, then I consider by default some 0 bits in the beggining.
I extract the 4 bits that form a hexa character, and I build the character in the
ebx register using bitwise operations. After that, I print the character using
printf function in C. I appended a newline character at the end of the string.

my_strstr: I search in the haystack, from index 0 to haystack_len - needle_len. The program
is equivalent to two for loops in C. For each character in the haystack, I search in
the needle, starting with that position.

For the ciphers, I implemented their specific algorithms, taking into consideration
the possibility of performing a a rotation. When the ascii code of a character is bigger
than the ascii code of 'z' or 'Z', I set the ascii code of that character to one
in the range 'a' - 'z' or 'A' - 'Z'.
