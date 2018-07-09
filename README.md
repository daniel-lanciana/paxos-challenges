# Wildcard Binary Counting

### Problem

You are given a string composed of only 1s, 0s, and Xs. Write a program that will print out every possible combination where you replace the X with both
0 and 1.

Xs are considered wildcards (i.e. variables), 0/1s are considered constants.

### Analysis

Considered approaches:

#### Replace Xs in the string

1. Iterate array and record locations of all Xs
2. Iterate string, moving 1s from the rightmost (i.e. least significant bit) position towards the left
3. Print at each step
4. Stop when all wildcards are 1s

String manipulation costly, lots of replacements tracking migration of 1s from right-to-left.

#### Iterate numbers

1. Replace all Xs with 0s, convert to integer to find the minimum
2. Replace all Xs with 1s, convert to integer to find the maximum
3. Iterate between minimum and maximum, excluding numbers affected by constants

Difficult to determine and overly complex.

### Branches

#### Recursion

1. Replace Xs with binary representation of current counter (starting at 0)
2. Print
3. Increment counter and call self
4. Stop when all Xs are 1s

- A less obvious choice as we know the length of the input, but slightly cleaner
- Still need to iterate and record the positions of wildcards to allow for positional substitutions
- Crashes for 15+ wildcards with `SystemStackError: stack level too deep`

### Design

Implemented approach:

#### Steps

1. Convert the input to a character array (for better replacement performance)
2. Gather input string positions of all wildcards
3. Iterate 2 to the power of the number of wildcards (as the number of outputs is exponential with base 2) for each output
4. Convert each iteration index (starting at 0) to a fixed-length (to the number of wildcards) binary array
5. Replace the wildcards from the input array with the binary array from step 4

#### Performance

- Leverages integers for binary counting (rather than manipulate 0/1s directly)
- Arrays for faster character replacement
- Stream print output rather than returning (simpler, less memory, output progress during large operations)
- O(1 + 2^N) complexity, where N are the number of wildcards (scan array for wildcards, each output)

### Features

- TDD
- Clean code (descriptive method names, short methods, readable code)
- Functional programming (e.g. map)
- Rubocop static code analysis
- Input wildcards are case-insensitive

For simplicity, no:
- Input validation
- Error messages

### Run

```sh
# Clone from GitHub
git clone git@github.com:daniel-lanciana/paxos-challenges.git
cd paxos-challenges

# Install dependencies
bundle install

# Run tests (optional)
bundle exec rake spec

# Run wildcard replacement
bundle exec rake replace_wildcards['1XX0']
```

### Benchmarks

Performed on a humble laptop:

- 10 wildcards, 0.01s
- 15 wildcards, 0.45s
- 20 wildcards, 45.8s

Ran a test with 100 wildcards for 5+ minutes, which didn't crash -- but would take a long time to complete!
