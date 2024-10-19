use std::io::{self, Read};

fn main() {
    let mut longest_bits = 0;
    let mut current_bits = 0;
    for byte in io::stdin().bytes() {
        let byte = match byte {
            Ok(b) => b,
            Err(_) => break,
        };
        for i in 0..8 {
            if (byte & (0b10000000 >> i)) == 0 {
                if current_bits > longest_bits {
                    longest_bits = current_bits;
                }
                current_bits = 0;
            } else {
                current_bits += 1;
            }
        }
    }
    if current_bits > longest_bits {
        longest_bits = current_bits;
    }
    println!("{}", longest_bits);
}
