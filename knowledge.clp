
;;;======================================================
;;;   Automotive Expert System
;;;
;;;     This expert system diagnoses some simple
;;;     problems with a car.
;;;
;;;     CLIPS Version 6.3 Example
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================

;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule additional-question ""
   (not (question ?))
   (not (result ?))
   =>
   (assert (question 
            (yes-or-no-p "Asks an additional question (yes/no)? "))))

(defrule makes-mistakes ""
   (not (mistakes ?))
   (not (result ?))
   =>
   (assert (mistakes (yes-or-no-p "Does the makes mistakes (yes/no)? "))))

(defrule attending-classes ""
   (not (visit ?))
   (not (result ?))
   =>
   (assert (visit 
            (yes-or-no-p "Does the attending classes (yes/no)? "))))

(defrule works-are-performed ""
   (not (tasks ?))
   (not (result ?))
   =>
   (assert (tasks (yes-or-no-p "Does the work  (yes/no)? "))))

(defrule answers-the-questions ""
   (not (answer ?))
   (not (result ?))
   =>
   (assert (answer 
            (yes-or-no-p "Does the answers questions (yes/no)? "))))

(defrule level-knows ""
   (visit yes)
   (tasks yes)
   (answer yes)
   (not (result ?))
   =>
   (assert (knowledge level knows)))

(defrule completeness-of-the-answer ""
   (mistakes yes)
   (not (result ?))
   =>
   (assert (shortcomings (ask-question "Which teacher (kind/strict)? " kind strict))))

(defrule knowledge-level  ""   
   (tasks no)
   (answer no)
   (not (result ?))
   =>
   (assert (level not knows)))

(defrule knowledge-level-genius  ""   
   (tasks yes)
   (answer yes)
   (visit no)
   (not (result ?))
   =>
   (assert (level-genius genius)))

;;;****************
;;;* REPAIR RULES *
;;;****************

(defrule knowledge-level-on ""
   (mistakes no)
   (knowledge level knows)
   (not (result ?))
   =>
   (assert (result "Score five.")))

(defrule knowledge-level-genius ""
   (mistakes no)
   (level-genius genius)
   (not (result ?))
   =>
   (assert (result "Score five.")))

(defrule knowledge-level-ty ""
   (visit no)
   (level not knows)
   (not (result ?))
   =>
   (assert (result "Did not pass.")))

(defrule knowledge-level-try ""
   (shortcomings kind)
   (answer yes)
   (not (result ?))
   =>
   (assert (result "Score three.")))

(defrule knowledge-level-four ""
   (shortcomings kind)
   (answer no)
   (not (result ?))
   =>
   (assert (result "Score four.")))

(defrule knowledge-level-three ""
   (shortcomings strict)
   (answer yes)
   (question yes)
   (not (result ?))
   =>
   (assert (result "Score four.")))

(defrule knowledge-level-fo ""
   (shortcomings strict)
   (question yes)
   (answer no)
   (not (result ?))
   =>
   (assert (result "Score three.")))

(defrule no-result ""
  (declare (salience -10))
  (not (result ?))
  =>
  (assert (result "It can not be so.")))

;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;;;********************************

(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "The Assessment Of Knowledge Expert System")
  (printout t crlf crlf))

(defrule print-result ""
  (declare (salience 10))
  (result ?item)
  =>
  (printout t crlf crlf)
  (printout t "Suggested Result:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item))

