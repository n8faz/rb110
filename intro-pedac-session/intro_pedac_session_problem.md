
Given a grid of values represented by an array of arrays, e.g.:
[1, 2, 3],
[4, 5, 6],
[7, 8, 9]

Return the largest sum of a column of values in the grid.
In this example, the largest sum is 18.

a = [[1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]]

largest_column(a) == 18

b = [[1, 2, 3, 4],
    [5, 6, 7, 8]]
    
largest_column(b) == 12


P - Understanding the Problem:

- Goal: understand what you're being asked to do
  - Read the problem description
  - Identify expected input and output
  - Establish rules/requirements/define the boundaries of the problem
  - Ask clarifying questions
  - Take your time on this step!

  Inputs: A nested array.
  Output: A single integer (or float?)

  Questions: Do all arrays have the same number of elements. Will the contents of all the subarrays always be integers?

  Explicit rules: 
    - summing up the numbers by column, and by column we mean the same index of each subarray. (this becomes significant if we have idfferent numbers of elements in each subarray)
  Implicit rules:
    - 

E - Examples and Test Cases:
- Goal: further expand and clarify understanding about what you're being asked to do 
  - Use examples/test cases to confirm or refute assumptions made about the problem in the previous step

D - Data Structures:
- Goal: begin to think logically about the problem
  - What data structures could we use to solve this problem?
    - What does our data look like when we get it? (input)
    - What does our data look like when we return it? (output?)
    - What does our data need to look like in the intermediate steps?

  Inputs: A array of arrays of equal size and all subarray elements are integers
  Intermediate: array of integer sums
  Output: A single integer (or float?)

A - Algorithm:
- Goal: write out steps to solve the given problem in plain English
  - A logical sequence of steps for accomplishing a task/objective
  - Start high level, but make sure you've thought through and have provided sufficient detail for working through the most difficult parts of the problem
  - Stay programming-language-agnostic
  - Can create substeps for different parts or separate concerns into a helper method
  - You can (and should) revisit your algorithm during the implementation stage if you need to refine your logic
  - Before moving onto implementing the algorithm, check it against a few test cases

[[1, 2, 3, 4],
 [5, 6, 7, 8]]

  - Get the sums of all the columns and hold them in an Array
    - identify which element in each array is a part of the same column - that is, they have the same index
    - gather all the values in each column together into their own arrays:
    - iterate over the column positions from 0 to the length of the subarray minus 1
      - get all of the elements at that position in each row, and add them to a new subarray, and put that into some array `results`
      results = [[1, 5], [2, 6], [3, 7], [4, 8]]
    - transform the intermediate array and for each element, find the sum of its elements
      results = [6, 8, 10, 12]
  - return the largest value in the array 12

C - Implementing a Solution in Code:
- Goal: translate the algorithm into your programming language of choice
  - Code with intent. Avoid hack and slash 
- TEST FREQUENTLY
  - Use the REPL or run your code as a file
  - When testing your code, always have an idea in place of what you're expecting
  - If you find that your algorithm doesn't work, return there FIRST if needed and THEN fix your code
  =end

- Get the sums of all the columns and hold them in an Array

- identify which element in each array is a part of the same column - that is, they have the same index

- gather all the values in each column together into their own arrays:

- iterate over the column positions from 0 to the length of the subarray minus 1

- get all of the elements at that position in each row, and add them to a new subarray, and put that into some array `results`

 get an array of subarrays with all the column values.

results = [[1, 5], [2, 6], [3, 7], [4, 8]]

- transform the intermediate array and for each element, find the sum of its elements

results = [6, 8, 10, 12]

- return the largest value in the array 12

def largest_column(grid)
  results = []
  0.upto(grid[0].length - 1) do |column_index|
    column_values = []
    grid.each do |row|
      column_values << row[column_index]
    end
    results << column_values
  end

  results.map! { |sub| sub.sum }

  results.max
end

a = [[1, 2, 3],
   [4, 5, 6],
   [7, 8, 9]]

p largest_column(a) == 18

b = [[1, 2, 3, 4],
    [5, 6, 7, 8]]
    
p largest_column(b) == 12

Common Mistakes:

- Not enough time spent parsing the problem (usually means not examining test cases for implicit rules)

- Fuzzy algorithm (not end-to-end path to the solution; maybe missing 1 critical piece)

- Lack of flexibility (not going back to the algorithm when necessary or algo isn't flexible)

- Lack of syntax fluency (unfamiliar with Ruby techniques and methods)