import sys

def longest_sequence_of_1s(stream):
    longest_bits = 0
    current_bits = 0
    byte = stream.read(1)
    while byte:
        byte_value = ord(byte)
        for i in range(8):
            if (0b10000000 >> i) & byte_value == 0:
                if current_bits > longest_bits:
                    longest_bits = current_bits
                current_bits = 0
            else:
                current_bits += 1
        byte = stream.read(1)
    if current_bits > longest_bits:
        longest_bits = current_bits
    return longest_bits

def main():
    result = longest_sequence_of_1s(sys.stdin.buffer)
    print(result)

if __name__ == "__main__":
    main()
