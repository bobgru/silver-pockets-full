#Silver Pockets Full of Baloney#

An Internet meme asserts that it's a once in 823-year event that a certain month has
5 each of Friday, Saturday, and Sunday. It didn't sound reasonable, so I wrote this program to count the number of such months in a certain 70-year lifespan. There were
69 of them. Not so special.

The title comes from the additional comment that the Chinese have a name for the special month. I give the Chinese more credit than that.

To run the program, install the [Haskell Platform][hp] and [git][git], then do the following:

```
git clone https://github.com/bobgru/silver-pockets-full.git
cabal sandbox init
cabal install --dependencies-only
cabal configure
cabal build
cabal run
```

The output is a list of (year, month) pairs which contain 5 each of Friday, Saturday, and Sunday.

[hp]: http://www.haskell.org/platform/
[git]: http://git-scm.com
