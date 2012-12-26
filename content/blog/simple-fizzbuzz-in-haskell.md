---
kind: article
layout: post
excerpt: ''
title: Simple FizzBuzz in Haskell
created_at: Oct 3 2010
tags: 
- haskell
- fizzbuzz
---
Yesterday I started reading about [Haskell](http://www.haskell.org/) through [Learn You a Haskell](http://learnyouahaskell.com/). I started playing around with __Haskell__ when I changed my window manager to __Xmonad__. 

Currently reading on [Syntax in Functions: Guards, guards!](http://learnyouahaskell.com/syntax-in-functions#guards-guards). I was able to come up with this [FizzBuzz](http://www.codinghorror.com/blog/2007/02/why-cant-programmers-program.html) function that I've read in [Coding Horror](http://www.codinghorror.com/).

~~~ haskell
fizzBuzz :: (Integral a) => a -> String
fizzBuzz a
    | a `mod` 5 == 0 && a `mod` 3 == 0 = "FizzBuzz"
    | a `mod` 3 == 0 = "Fizz"
    | a `mod` 5 == 0 = "Buzz"
    | otherwise = show a
~~~

Somehow cheated because I based it on [this](http://www.haskell.org/haskellwiki/Haskell_Quiz/FizzBuzz/Solution_Ninju) though I don't quite get that one yet. :D So for now I just have this one which produces a list. And to provide the input I have - `[fizzBuzz x | x <- [1..100]]`. Woot!
