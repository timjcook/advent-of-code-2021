# Advent of Code - 2021

The aim of this year is to tackle each days puzzle using ruby and the given example information to write a test or set of tests first. Like last year I'll be trying to put together Classes that make sense and have clearly defined responsibilities. Documenting my thoughts below!

## Day 1 - Depth Tracking
Unfortunately this puzzle was started on the 1st but due to the busyness of life has taken me until the 12th to get back to. My first pass was to write a basic method that iterated through the input and counted when the depth had increased based on the previous depth. The issues with these approaches are often that if in your loop you are referencing the main array of inputs, you have to add guards to make sure you don't access an index outside the range.
I took on the second task by refactoring what I had to use the window approach and get it working for a window size of 1. I iterated through the inputs and returned a list of depths for each window size, and then did the basic iteration and increase count from the first problem. It was then just a matter of increasing the window size to 3 to get the final result.

## Day 2 - Plotting a Course
Smooth sailing on this one. I really like using OpenStruct so that I can access named properties like methods. I also don't like destroying the answers for part 1 so I created a new class that inherited from the original plotting class and refactored so part 2 involved just overriding the instruction methods, super nice!

## Day 3 - Building with bits
Main challenge here was finding an abstraction that felt right. I over did the use of passing blocks initially and while a got a solution for part 1, when I had to reuse similar "common bit" logic for part 2 it was going to involve a bunch of copy pasting. I ended up passing a symbol of a instance method and calling send, not sure if that is a nice thing to do or not but it's what I wanted to do. In JS I would have just passed the function itself.