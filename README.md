What started out as a Forth writing exercise quickly transformed into a naive bit counting benchmark. The results here should not be taken seriously and are not indicative of anything. I would even go a step further and claim that the benchmarks are lopsided and unfair, especially in cases where plain C was embedded in targets that supported it (such as ECL and MinForth).

The benchmark consists of counting the longest consecutive binary bits in the `string.txt` file, which consists entirely of garbage.

```
$ file string.txt && wc string.txt
string.txt: ASCII text, with very long lines (65536), with no line terminators
       1        1 10000002 string.txt
```

## Benchmarks

| Name                 | Time (mean ± σ)        | User     | System  | Command                                         |
|----------------------|----------------------- |----------|---------|-------------------------------------------------|
| Opt. C Clang         | **48.5 ms** ± 1.3 ms   | 46.9 ms  | 1.7 ms  | `bin/opt-clang-plb < string.txt`                |
| Rust                 | **120.7 ms** ± 0.9 ms  | 119.4 ms | 1.2 ms  | `bin/rust-plb < string.txt`                     |
| Opt. C GCC           | **188.7 ms** ± 3.3 ms  | 185.3 ms | 3.4 ms  | `bin/opt-gcc-plb < string.txt`                  |
| Lisp ECL /w inline C | **199.4 ms** ± 7.9 ms  | 181.6 ms | 31.6 ms | `bin/clang-ecl-inline-c-plb < string.txt`       |
| Java                 | **319.8 ms** ± 17.7 ms | 314.2 ms | 17.6 ms | `java -cp bin plb < string.txt`                 |
| C Clang              | **354.9 ms** ± 3.6 ms  | 352.2 ms | 2.7 ms  | `bin/clang-plb < string.txt`                    |
| C GCC                | **355.9 ms** ± 3.9 ms  | 353.7 ms | 2.1 ms  | `bin/gcc-plb < string.txt`                      |
| Lisp SBCL            | **360.7 ms** ± 3.4 ms  | 357.4 ms | 3.2 ms  | `bin/sbcl-plb < string.txt`                     |
| Python PyPy3         | **646.1 ms** ± 19.8 ms | 632.6 ms | 11.9 ms | `pypy3 src/python/plb.py < string.txt`          |
| MinForth /w inline C | **928.4 ms** ± 6.9 ms  | 921.2 ms | 7.2 ms  | `bin/mf-inline-c-plb < string.txt`              |
| Chez Scheme          | **1258 ms** ± 29 ms    | 1206 ms  | 119 ms  | `chez --script src/scheme/chez.ss < string.txt` |
| Gambit Scheme        | **1331 ms** ± 28 ms    | 1276 ms  | 115 ms  | `bin/gambit-plb < string.txt`                   |
| GForth (fast)        | **2.782 s** ± 0.051 s  | 1.392 s  | 1.390 s | `gforth-fast src/forth/plb.fs < string.txt`     |
| MinForth             | **2.591 s** ± 0.073 s  | 1.182 s  | 1.409 s | `bin/mf-plb < string.txt`                       |
| VFX Forth            | **3.670 s** ± 0.049 s  | 1.524 s  | 2.146 s | `bin/vfxf-plb < string.txt`                     |
| GForth               | **3.875 s** ± 0.086 s  | 2.422 s  | 1.453 s | `gforth src/forth/plb.fs < string.txt`          |
| Lisp ECL             | **3.942 s** ± 0.061 s  | 2.324 s  | 1.631 s | `bin/clang-ecl-plb < string.txt`                |
| Python CPython       | **4.280 s** ± 0.101 s  | 4.269 s  | 0.011 s | `python src/python/plb.py < string.txt`         |

* All benchmarks were measured via `hyperfine` with 30 runs and 5 warmup runs.
* MinForth C targets were compiled with Clang & the forthcoming compiler flags.
* The Lisp ECL /w inline C result should be taken with a massive grain of salt, as all I did there was embed the C solution as inline code, just to see how it would perform, after I was rather disappointed with the pure ECL solution.
* Unlike the ECL /w inline C solution, the MinForth /w inline C only used inline C for reading the next char, and that's it. I consider it faithful.
* GCC optimization flags: `-O3 -Ofast -flto -march=native -ffast-math -funroll-loops -ftree-vectorize -fpredictive-commoning`
* Clang optimization flags: `-O3 -Ofast -flto -march=native -ffast-math -funroll-loops -fvectorize -ftree-vectorize`
* Rust optimization flags: `-C opt-level=3 -C lto -C codegen-units=1 -C target-cpu=native`

The ECL Lisp results were chosen from their best-performing toolchain-specific benchmarks:

| Name                       | Time (mean ± σ)   | User     | System  | Command                                           |
|----------------------------|-------------------|----------|---------|---------------------------------------------------|
| Clang ECL /w inline C      | **199.4 ms** ± 7.9 ms | 181.6 ms | 31.6 ms | `bin/clang-ecl-inline-c-plb < string.txt`     |
| Opt. Clang ECL /w inline C | **201.0 ms** ± 8.8 ms | 180.9 ms | 32.7 ms | `bin/opt-clang-ecl-inline-c-plb < string.txt` |
| Opt. GCC ECL /w inline C   | **279.9 ms** ± 4.5 ms | 266.7 ms | 26.2 ms | `bin/opt-gcc-ecl-inline-c-plb < string.txt`   |
| Clang ECL                  | **3.942 s** ± 0.061 s | 2.324 s  | 1.631 s | `bin/clang-ecl-plb < string.txt`              |
| GCC ECL                    | **4.005 s** ± 0.071 s | 2.352 s  | 1.665 s | `bin/gcc-ecl-plb < string.txt`                |
| Opt. GCC ECL               | **4.099 s** ± 0.056 s | 2.416 s  | 1.695 s | `bin/opt-gcc-ecl-plb < string.txt`            |
| Opt. Clang ECL             | **4.124 s** ± 0.309 s | 2.433 s  | 1.704 s | `bin/opt-clang-ecl-plb < string.txt`          |

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

$ pypy3 --version
Python 3.10.14 (39dc8d3c85a7, Aug 30 2024, 08:27:45)
[PyPy 7.3.17 with GCC 14.2.1 20240805]

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
make gcc
make gcc-ecl
make sbcl
...
```

Obviously, you need the dependencies required by each target to build them.

* Targets that are purely interpreted, such as the Python and GForth ones, do not require any building, and could be evaluated right away, provided you have their dependencies.
* Build targets for VFX Forth and MinForth were not provided, but they invoke the same source as in `src/forth/plb.fs`, except for minor adjustments to turn them into standalone turnkey binaries.
