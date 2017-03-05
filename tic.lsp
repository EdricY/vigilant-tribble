(defparameter *S* #\space)
(defparameter *board* '((#\space #\space #\space)
		(#\space #\space #\space)
		(#\space #\space #\space))
)

#|
(setf *board* '((O X X)
                (O O X)
                (X O O) )
)
|#

(defun tic-tac-toe ()
	(setf *board* '((#\space #\space #\space)
			(#\space #\space #\space)
			(#\space #\space #\space))
	)
	(format t "Let's play tic-tac-toe!~%Who will go first, (H)uman or (C)omputer?~%>")
	(let ((starter (read)))
		(if (eql starter 'H)
			(progn
				(format t "Human starts.~%Input row and column separated by a space or a newline~%Ex: 1 2~%>")
				(h-move (read) (read))
			)
		(if (eql starter 'C)
			(progn
				(format t "Computer starts:~%")
				(c-move)
			)
		(progn
			(format t "Input Error!~A~%Please input H or C~%" starter)
			(tic-tac-toe)
		))))
)

(defun h-move (row col)
	(format t "H-Move ~A ~A~%~%" row col)
	(if (eql (get-sym row col) #\space)
		(setf (nth col (nth row *board*)) 'H)
	(progn
		(format t "Invalid input, try again~%>")
		(h-move (read) (read))
	))
	
	(print-board)
	(if (check-win 'H) "You Win!"
	(c-move) )
)

(defun c-move()
	(format t "hmmm...~%~%")
	(if (sleep 1) "Oh... uh... this is embarassing. You were never supposed to see this :/"
	
	;set board...
	(format t "TO DO: make a move.~%")
	)

	; loop through available cells, scoring them
	(let ((available-cells '()))
		(do ((row 0 (+ row 1)))
			((> row 2) t)
			(do ((col 0 (+ col 1)))
				((> col 2) t)
				(if (is-space (get-sym row col))
					(setf available-cells (cons (cons row (cons col (get-cell-score row col))) available-cells))
				)
			)
		)
		; sort them by score
		(setf available-cells (sort available-cells #'> :key #'(lambda (x) (cdr (cdr x)))))
		(format t "~A~%" available-cells)
		; pick the one with the highest score and use that as the move
		(setf (nth (car (cdr (car available-cells))) (nth (car (car available-cells)) *board*)) 'C)
	)

	;if available-cells is empty, tie
	;sort by (car (cdr (cdr cell))), take top one, use that

	(print-board)
	(format t "~%>")
	(if (check-win 'C) (format t "You Win!")
	(h-move (read) (read)) )
)

(defun print-board()
	(format t "~A|~A|~A~%-+-+-~%~A|~A|~A~%-+-+-~%~A|~A|~A~%" 
		(caar *board*)
		(cadar *board*)
		(car (cddar *board*));	can't use caddar :(
		(caadr *board*)
		(car (cdadr *board*))
		(car (cddadr *board*))
		(caar(cddr *board*))
		(cadar(cddr *board*))
		(caddr(caddr *board*))
	)
)

(defun check-win(sym)
	(if (and 
		(eql sym (get-sym 0 0)) 
		(eql sym (get-sym 0 1))
		(eql sym (get-sym 0 2)) )
	t
	(if (and
                (eql sym (get-sym 1 0))  
                (eql sym (get-sym 1 1))
                (eql sym (get-sym 1 2)) )
	t
        (if (and
                (eql sym (get-sym 2 0))
                (eql sym (get-sym 2 1))
                (eql sym (get-sym 2 2)) )
	t
        (if (and
                (eql sym (get-sym 0 0))
                (eql sym (get-sym 1 0))
                (eql sym (get-sym 2 0)) )
	t
        (if (and
                (eql sym (get-sym 0 1))
                (eql sym (get-sym 1 1))
                (eql sym (get-sym 2 1)) )
	t
        (if (and
                (eql sym (get-sym 0 2))
                (eql sym (get-sym 1 2))
                (eql sym (get-sym 2 2)) )
	t
        (if (and
                (eql sym (get-sym 0 0))
                (eql sym (get-sym 1 1))
                (eql sym (get-sym 2 2)) )
	t
        (if (and
                (eql sym (get-sym 0 2))
                (eql sym (get-sym 1 1))
                (eql sym (get-sym 2 0)) )
	t ))))))))
)

(defun is-space(x)
	(eql x #\space)
)

(defun is-board-full()
	(and 
		(every #'null (mapcar #'is-space (car *board*)))
		(every #'null (mapcar #'is-space (cadr *board*)))
		(every #'null (mapcar #'is-space (caddr *board*)))
	)
)

(defun get-sym(r c)
	(if (> r 2) nil
	(if (< r 0) nil
	(if (> c 2) nil
	(if (< c 0) nil
	(nth c (nth r *board*) )))))
)

(defun get-cell-score(r c)
	; add weights of surrounding cells
	(+ (get-cell-weight (- r 1) c) ;vertical line
	   (get-cell-weight (+ r 1) c)
	   (* 1.5 (get-cell-weight (- r 2) c))
	   (* 1.5 (get-cell-weight (+ r 2) c))
	   (get-cell-weight r (- c 1)) ;horizontal line
	   (get-cell-weight r (+ c 1))
	   (* 1.5 (get-cell-weight r (- c 2)))
	   (* 1.5 (get-cell-weight r (+ c 2)))
	   (get-cell-weight (- r 1) (- c 1)) ;negative diagonal
	   (get-cell-weight (+ r 1) (+ c 1))
	   (* 1.5 (get-cell-weight (- r 2) (- c 2)))
	   (* 1.5 (get-cell-weight (+ r 2) (+ c 2)))
	   (get-cell-weight (- r 1) (+ c 1)) ;positive diagonal
	   (get-cell-weight (+ r 1) (- c 1))
	   (* 1.5 (get-cell-weight (- r 2) (+ c 2)))
	   (* 1.5 (get-cell-weight (+ r 2) (- c 2))))	
)

(defun get-cell-weight(r c)
	(let ((occupant (get-sym r c)))
		(cond
			((eq occupant nil) 0)
			((is-space occupant) 1)
			((eq occupant 'H) 5)
			((eq occupant 'C) 6)
			(T 0)
		)
	)
)

(defun get-placement-score(cell1 cell2 cell3 cell4)
	(let ((score 0))
		(if (not (null cell1))
			(progn
				(if (eq cell1 cell2)
					(setf score (+ 1 score)))
				(if (eq cell1 cell3)
					(setf score (+ 1 score)))
				(if (eq cell1 cell4)
					(setf score (+ 1 score))))
		)
		(if (not (null cell2))
			(progn
				(if (eq cell2 cell3)
					(setf score (+ 1 score)))
				(if (eq cell2 cell4)
					(setf score (+ 1 score))))
		)
		(if (not (null cell3))
			(if (eq cell3 cell4)
				(setf score (+ 1 score)))
		)
		score
	)
)