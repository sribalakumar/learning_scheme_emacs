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

;1.1.7 Example: Square Roots by Newton's Method
    ; square root of (x)  = y such that y >= 0 and y^2 = x
      (define (square x) (* x x))
    ; In computer science we use imperative(how to) descriptions of functions.
    ; Newton's method of successive repetation says that whenever we have a guess y for square root of x,
    ;   we arrive at a better guess by averaging y with x/y.
    ; |Guess|        |Quotient|            |Average|
    ;    1             (2/1)=2               ((2+1)/2) = 1.5
    ;    1.5           (2/1.5)=1.333         ((1.333+1.5)/2) = 1.4167
    ;    1.4167        (2/1.4167)=1.4118     ((1.4167+1.4118)/2) = 1.4142
    ;    1.4142        ....                  ....
    ; continuing the process we obtatin better approximations to the square root.
      (define (sqrt-iter guess x)
         (if (good-enough? guess x)
             guess
             (sqrt-iter (improve guess x)
                        x)))
    ; averaging the quotient of the radicand and the old guess
      (define (improve guess x)
        (average guess (/ x guess))
    ; where we define average as
      (define (average x y)
        (/ (+ x y) 2))
    ; For simplicity as of now we define good enough such that its square differs from the radicand by less than a predetermined tolerance 0.001
      (define (good-enough? guess x)
        (< (abs (- (square guess) x)) 0.001))
    ;We need to start with a guess and lets start with 1
      (define (sqrt x)
        (sqrt-iter 1.0 x))

    ; Calling examples to sqrt
      (sqrt 9) ; 3.00009155413138
      (sqrt (+ 100 37)) ; 11.704699917758145
      (sqrt (+ (sqrt 2) (sqrt 3))) ; 1.7739279023207892
      (square (sqrt 1000)) ; 1000.000369924366

    ; sqrt-iter demonstrates how iteration can be accompanied using no special construct other then ordinary ability to call a procedure.
    ; Example .1.6 is a must for pratice

;1.1.8 Procedures as Black-Box Abstractions
    ; Every indvidual have their own implementation of squaring
      ; A lame man can compute square like
        (define (square x) (* x x))
      ; A math guy can define it like
        (define (square x)
          (exp (double (log x))))
        (define (double x) (+ x x))
      ; Each of those definitions is fine and when we have to import a library then the first implementation should not affect the final result.
        ; Such abstraction of a procedure is called procedural abstraction. The users of a procedure may not have written it themselves, but may have
        ; obtained it from another programmer as a black box. A user should not need to know how the procedure is implemented in order to use it.

    ; Local Names
      ; The implementers choice of names for the procedure's formal parameters should not matter to the user of the procedure.
        (define (square x) (* x x))
        (define (good-enough? guess x)
          (< (abs (- (square guess) x)) 0.001))
      ; here the parameter x in square is isloated to its own procedure and is not the same parameter x of procedure good-enough 
      ; In the good-enough? procedure - guess, x are bounded to its procedure and are called bound variable with the procedure good-enough has their
        ; scope. If a variable is not bound, we say that it is free. The set of expressions for which binding defines a name is called the scope of 
        ; that name.

    ; Internal definitions and block structure
      ; Formal parameters of a procedure are local to the body of the procedure.
      ; Existing sqrt procedure can be decomposed into various procedures like sqrt-iter, good-enough?, improve, average.
      ; Problem is in a large system there can  numerous libraries which can lead to name conflicts with the procedures.
      ; Hence to localize the procedures with in the main procedure:
        (define (sqrt x)
          (define (good-enough? guess x)
            (< (abs (- (square guesss) x)) 0.001))
          (define (improve guess x)
            (average guess (/ x guesss)))
          (define (sqrt-iter guess x)
            (if (good-enough? guess x)
                guess
                (sqrt-iter (improve guess x) x)))
          (sqrt-iter 1.0 x)
        ; This type of nesting of definitions is called block structure.
      ; Caveat in the above definition is passing paramter x even though it is available in the block, so it is not necessary to explicityly mention x
        ; This discipline is called lexical scoping.
        (define (sqrt x)
          (define (good-enough? guess)
            (< (abs (- (square guess) x)) 0.001))
          (define (improve guess)
             (average guess (/ x guess)))
          (define (sqrt-iter guess)
             (if (good-enough? guess)
                 guess
                 (sqrt-iter (improve guess))))
          (sqrt-iter 1.0))
