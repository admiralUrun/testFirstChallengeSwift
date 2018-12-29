# testFirstChallengeSwift/ Evaluate Grammar

# primary 

primary -> number | (expression)

# priorityExp 

priorityExp -> priorityExp * prinary | primary 

# expression 

expression ->  expression + priorityExp | priorityExp  

# number 
number ->  digit | digit number
digit -> 0 | 1 | 2 | 3 | 5 | 6 | 7 | 8 | 9
