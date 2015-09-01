; 1.1.1 Expressions
    486
    (+ 137 349)
    (- 1000 334)
    (* 5 99)
    (/ 10 5)
    (+ 2.7 10)
    (+ 21 35 12 7)
    (* 25 4 12)

    (+ 21 35 12 7) ; Prefix Notation helps in having n number of arguments
    (* 25 4 12) ; No ambiguity because the operator is in front along with delimiting parentheses

    (+ (* 3 5) (- 10 6)) ; Nested combinations
    (+ (* 3 (+ (* 2 4) (+ 3 5))) (+ (- 10 7) 6)) ; Complex nested combination
    ; Pretty-printing the above complex nested combination
    (+ (* 3
          (+ (* 2 4)
             (+ 3 5)))
       (+ (- 10 7)
          6))

; 1.1.2 Naming and the Environment
     (define size 2)
     size ; refer 2 with name size
     (* 5 size) ; 10

     (define pi 3.14159)
     (define radius 10)
     (* pi (* radius radius)) ; 314.159
     (define circumference (* 2 pi radius))
     circumference ; 62.8318    Define is Lisp simplest means of abstraction

; 1.1.3 Evaluating combinations
    ; 1) Evaluate the subexpression of the combination
    ; 2) Apply the procedure that is the value of the operator(left-most) to the argument (subexpressions)
    ; Hence complex nested combination can be imagined in the form of tree and the percolating upward process start with
    ;  the terminal nodes. This type of evaluation is an example of Tree accumulation.

    (* (+ 2 (* 4 6))
       (+ 3 5 7))

    ; Evaluation is dependent on environment.
    ; Evaluation does not handle definitions like (define size 2) which are called as Special Forms.

; 1.1.4 Compound Procedures
    ; Procedure definitions, more powerful abstraction by which compound operation can be given a name
    ; General form is
    ;                (define (<name> <formal parameters>) <body>)
    ;                (define (square x)                   (* x x))

    (define (square x) (* x x))
    (square 21) ; 441
    (square (+ 2 5)) ; 49
    (square (square 3)) ; 81
    (+ (square x) (square y)) ; x^2 + y^2

    ; Defining sum of squares procedure
    (define (sum-of-squares x y)
      (+ (square x) (square y)))

    (sum-of-squares 3 4) ; 25

    ; Calling one procedure inside another
    (define (sample-procedure a)
      (sum-of-squares (+ a 1) (* a 2)))

    (sample-procedure 5) ; 136

    ;Compound procedures are used exactly like the primitive procedure. No difference between (* 1 2) and (sum-of-squares 2 3)

; 1.1.5 The Substitution Model for Procedure Application
    ; Evaluate arguments and then apply(applicative order evaluation)
    ; Typical interpreters do not evaluate procedure applications by manipulating the text of a procedure to substitue values of formal parameters
    ; This is the simplest of models and more models that the interpreter uses is covered in chapter 4 & 5

      (sample-procedure 5)
      (sum-of-squares (+ a 1) (* a 2))
      (sum-of-squares (+ 5 1) (* 5 2))
      (sum-of-squares 6 10)
      (+ (* 6 6) (* 10 10))
      (+ 36 100) ; 136 ; In chapter 3 procedures with mutable data will break substitution model and we'll see more complicated models.

    ; Fully expand and then reduce(normal order evaluation)

      (sample-procedure 5)
      (sum-of-squares (+ 5 1) (* 5 2))
      (+ (square (+ 5 1)) (square (* 5 2)) )
      (+ (* (+ 5 1) (+ 5 1)) (* (* 5 2) (* 5 2)))
      ; followed by reductions
      (+ (* 6 6) (* 10 10))
      (+ 36 100) ; 136 Here we notice (+ 5 1) (* 5 2) have repeated evaluations

    ; Lisp uses applicative order evaluation because of additional efficiency obtained by avoiding multiple evaluations of expressions.

; 1.1.6 Conditional Expressions and Predicates
    ; Using cond conditional statement
      ; (cond (<predicate1> <expression1>)
      ;       (<predicate2> <expression2>)
      ;       (<predicate-n> <expression-n>)) ; cond followed by expressions (<p> <e>) called clauses.
      ; Predicates can be procedures or expressions that evaluates to true or false
      ; <predicate1> is evaluated first, if it is false then <predicate2> is evaluted. If <predicate2> is false then <predicate3> is evaluted.
      ; if all predicates evalutes to false then the expression corresponding to else predicate is evaluted.

    ; Using cond conditional statement:
        (define (abs x)
          (cond ((< x 0) (- x))
                (else x))) ; represents mod |x| function

    ; Using if conditional statement
      ; (if <predicate> <consequent> <alternative>)
      ; mod |x| using if
        (define (abs x)
          (if (< x 0)
              (- x)
              x))

    ; Primitive predicates <, =, >
    ; Logical predicates and, or, not

      (and (> x 5) (< x 10)) ; 5 < x < 10

      ; One number is greater than or equal to another
        (define (>= x y)
          (or (> x y) (= x y)))

      ; Above snippet using not
        (define (>= x y)
          (not (< x y)))
