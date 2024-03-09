(deftemplate Description
    (slot ID (type SYMBOL) (default ?NONE))
    (multislot Features)
)
(deftemplate Classification
    (slot ID (type SYMBOL) (default ?NONE))
    (slot Class (type SYMBOL) (default ?NONE))
    (slot Flag (type INTEGER) (default 0))
)

(defrule ToRoot
    (Description (ID ?x))
    =>
    (assert (Classification (ID ?x)
            (Class Arthropods)))
)

(defrule D-SixLegs (declare (salience 10))
    (Classification (ID ?x) (Class Arthropods))  
    ?d <- (Description (ID ?x) (Features $?y))
    (not (Description (ID ?x) (Features $?l SixLegs $?r)))
    =>
    (printout t ?x ": Six Legs (Yes/No)? > ")
    (bind ?SixLegs (read))
    (if (eq ?SixLegs Yes) then (modify ?d (Features $?y SixLegs Yes)))
    (if (eq ?SixLegs No) then (modify ?d (Features $?y SixLegs No)))
)

(defrule ToMonkey
    (Classification (ID ?x) (Class Simian))
    (Description (ID ?x) (Features $?s SixLegs Yes $?f))
    =>
    (assert (Classification (ID ?x)
            (Class Monkey) (Flag 1)))
)

(defrule ToApe
   (Classification (ID ?x) (Class Simian))
   (Description (ID ?x)(Features $?s SixLegs No $?f))
    =>
   (assert (Classification (ID ?x)  
           (Class Ape)))
)

(defrule D-Wool (declare (salience 8))
    (Classification (ID ?x) (Class Ape))  
    ?d <- (Description (ID ?x) (Features $?y))
    (not (Description (ID ?x) (Features $?l Wool $?r)))
    =>
    (printout t ?x ": Wool (Yes/No)? > ")
    (bind ?Wool (read))
    (if (subsetp (create$ ?Wool) (create$ Yes No)) then (modify ?d (Features $?y Wool ?Wool)))
)

(defrule ToHuman
    (Classification (ID ?x) (Class Ape))
    (Description (ID ?x)(Features $?s Wool No $?f))
    =>
   (assert (Classification (ID ?x)
           (Class Human) (Flag 1)))
)

(defrule ToOtherApe
    (Classification (ID ?x) (Class Ape))
    (Description (ID ?x)(Features $?s Wool Yes $?f))
    =>
    (assert (Classification (ID ?x)
            (Class OtherApe)))
)

(defrule D-Color (declare (salience 6))
    (Classification (ID ?x) (Class OtherApe))  
    ?d <- (Description (ID ?x) (Features $?y))
    (not (test (subsetp (create$ Color) $?y)))
    =>
    (printout t ?x ": Color (Brown/Black/Orange/Various)? > ")
    (bind ?Color (read))
    (if (subsetp (create$ ?Color) (create$ Brown Black Orange Various)) then 
        (modify ?d (Features $?y Color ?Color))
    )
)

(defrule ToChimpazee
    (Classification (ID ?x) (Class OtherApe))
    (Description (ID ?x)(Features $?s Color Brown $?f))
    =>
    (assert (Classification (ID ?x)
            (Class Chimpanzee) (Flag 1)))
)

(defrule ToGorilla
   (Classification (ID ?x) (Class OtherApe))
   (Description (ID ?x)(Features $?s Color Black $?f))
   =>
   (assert (Classification (ID ?x)
           (Class Gorilla) (Flag 1)))
)

(defrule ToOrangutan
    (Classification (ID ?x) (Class OtherApe))
    (Description (ID ?x)(Features $?s Color Orange $?f))
    =>
    (assert (Classification (ID ?x)
            (Class Orangutan) (Flag 1)))
)

(defrule ToGibbon
    (Classification (ID ?x) (Class OtherApe))
    (Description (ID ?x)(Features $?s Color Various $?f))
    =>
    (assert (Classification (ID ?x)
            (Class Gibbon) (Flag 1)))
)

(defrule Print (declare (salience -1))
    (Classification (ID ?x) (Class ?y) (Flag 1))
    =>
    (printout t ?x " is a(n) " ?y crlf)
)
