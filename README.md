# Gift Card Spending & Binary Wildcards

## Problem #1 (Gift Card Spending)

You have been given a gift card that is about to expire and you want to buy gifts for 2 friends.
You want to spend the whole gift card, or if that’s not an option as close to the balance as
possible. You have a list of sorted prices for a popular store that you know they both like to
shop at. Your challenge is to find two distinct items in the list whose sum is minimally under (or
equal to) the gift card balance.

### Analysis

#### Load file to memory

- If we can store the entire input file in memory, we can check every pair combination O(N^2) and store the differences
- A better approach would be to start from both ends of the array working inwards for O(N) time

#### File too big for memory

- If there are many rows, we need to seek (i.e. goto) positions within a data stream of the file
- Scalable but more low-level complexity

### Design

Implemented my own binary search algorithm (rather than using a gem), which may be suboptimal but a good challenge.

#### Steps

1. Get first line gift amount (i.e. lowest)
2. Binary search balance less lowest amount (i.e. target) by going to middle of file
3. Step back until we get the current line
4. Parse amount of current line
5. If amount matches target, move to second match
6. If amount less, record as closest match and step 2 of top-half of remaining file. If more, lower-half of file.
7. Once top match found, lower starting amount and recursively search for more optimal solution
8. Stop searching when starting target less than half the current optimal match
9. Print output

### Performance

O(½N M log N) complexity -- where N is the number of lines and M are the number of gifts (i.e. 2). Additional ½N for 
recursively checking past the first high/low match.

### Features

- TDD with 1, 2 and 3-gift tests
- Variable min/max number of gifts
- Separate files for search and parser (allowing implementation swap)
- Binary search large files as data streams rather than loading entire file to memory
  - Ruby file seek has no easy rewind to start of line (that I'm aware of), move position left until newline of start of file
  - Halving position 
- Finds the closest two-gift solution, even if central (e.g. balance 100, items [5, 40, 50, 80], result 90)
- Start searching at (balance - first amount) for minimum of 2 matches
- Functional programming, clean code, static code analysis (Rubocop)
- Benchmarking in console

For simplicity, no:
- Input validation
- Complex 3 gift matching (i.e. [A, C, D] > [A, B, F])

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
bundle exec rake spend_gift_card['path/to/input.txt', 2500]
```

---

## Problem #2 (Binary Wildcards)

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

#### recursion

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
- O(N + 2^N) complexity, where N are the number of wildcards (scan array for wildcards, each output)

### Features

- TDD
- Clean code (descriptive method names, short methods, readable code)
- Functional programming (e.g. map)
- Rubocop static code analysis
- Input wildcards are case-insensitive
- Benchmarking in console

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
