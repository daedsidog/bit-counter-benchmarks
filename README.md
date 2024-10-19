What started out as a Forth writing exercise quickly transformed into a naive bit counting benchmark. The results here should not be taken seriously and are not indicative of anything. I would even go a step further and claim that the benchmarks are lopsided and unfair, especially in cases where plain C was embedded in targets that supported it (such as ECL and MinForth).

The benchmark consists of counting the longest consecutive binary bits in the `string.txt` file, which consists entirely of garbage.

```
$ file string.txt && wc string.txt
string.txt: ASCII text, with very long lines (65536), with no line terminators
       1        1 10000002 string.txt
```

## Benchmarks

| Name                    | Time (mean ± σ)        | User     | System   | Command                                        |
|-------------------------|------------------------|----------|----------|------------------------------------------------|
| C Clang                 | **42.9 ms** ± 0.8 ms   | 40.7 ms  | 1.6 ms   | `bin/clang-plb < string.txt`                   |
| Rust                    | **133.1 ms** ± 1.6 ms  | 128.0 ms | 5.1 ms   | `bin/rust-plb < string.txt`                    |
| C GCC                   | **187.5 ms** ± 2.1 ms  | 184.1 ms | 3.4 ms   | `bin/gcc-plb < string.txt`                     |
| Lisp ECL /w inline C    | **200.7 ms** ± 5.1 ms  | 180.3 ms | 33.8 ms  | `bin/inline-c-ecl-plb < string.txt`            |
| Java                    | **324.4 ms** ± 15.9 ms | 318.1 ms | 19.2 ms  | `java -cp bin plb < string.txt`                |
| Lisp SBCL               | **372.8 ms** ± 6.7 ms  | 369.2 ms | 3.4 ms   | `bin/sbcl-plb < string.txt`                    |
| MinForth /w inline C    | **938.8 ms** ± 14.5 ms | 935.9 ms | 2.7 ms   | `bin/inline-c-mf-plb < string.txt`             |
| GForth (fast)           | **2.782 s** ± 0.051 s  | 1.392 s  | 1.390 s  | `gforth-fast source/forth/plb.fs < string.txt` |
| MinForth                | **2.812 s** ± 0.053 s  | 1.461 s  | 1.351 s  | `bin/mf-plb < string.txt`                      |
| VFX Forth               | **3.670 s** ± 0.049 s  | 1.524 s  | 2.146 s  | `bin/vfxf-plb < string.txt`                    |
| GForth                  | **3.875 s** ± 0.086 s  | 2.422 s  | 1.453 s  | `gforth src/forth/plb.fs < string.txt`         |
| Lisp ECL                | **4.067 s** ± 0.290 s  | 2.448 s  | 1.632 s  | `bin/ecl-plb < string.txt`                     |
| Python                  | **4.280 s** ± 0.101 s  | 4.269 s  | 0.011 s  | `python src/python/plb.py < string.txt`        |

* All C targets have been compiled with the `-O3` flag. Targets that utilize inline C code specifically employed the `clang` compiler.
* The Lisp ECL /w inline C result should be taken with a massive grain of salt, as all I did there was embed the C solution as inline code, just to see how it would perform, after I was rather disappointed with the pure ECL solution.
* Unlike the ECL /w inline C solution, the MinForth /w inline C only used inline C for reading the next char, and that's it. I consider it faithful.

## System

```
$ ldd --version
ldd (GNU libc) 2.39
Copyright (C) 2024 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Roland McGrath and Ulrich Drepper.

$ clang --version
clang version 18.1.8
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/sbin

$ gcc --version
gcc (GCC) 14.2.1 20240910
Copyright (C) 2024 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ sbcl --version
SBCL 2.4.9

$ ecl --version
ECL 23.9.9

$ gforth --version
gforth 0.7.9_20241013 amd64

$ rustc --version
rustc 1.81.0 (eeb90cda1 2024-09-04) (Arch Linux rust 1:1.81.0-1)

$ python --version
Python 3.12.7

$ java --version
openjdk 23 2024-09-17
OpenJDK Runtime Environment (build 23)
OpenJDK 64-Bit Server VM (build 23, mixed mode, sharing)
```

```
CPU: Intel Xeon W-11855M @ 12x 3.187GHz
GPU: NVIDIA RTX A4000 Laptop GPU
RAM: 801MiB / 15597MiB
```

## Building

Clone this repository, `cd` into it, then run `make` for each particular target you are interested in want, e.g.:

```
make c
make sbcl
...
```

Obviously, you need the dependencies required by each target to build them.

* Targets that are purely interpreted, such as the Python and GForth ones, do not require any building, and could be evaluated right away, provided you have their dependencies.
* Build targets for VFX Forth and MinForth were not provided, but they invoke the same source as in `src/forth/plb.fs`, except for minor adjustments to turn them into standalone turnkey binaries.
