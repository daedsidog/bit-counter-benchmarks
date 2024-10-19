(declaim (optimize (speed 3) (safety 0) (debug 0)))

(defun main ()
  (let ((longest-bits 0) 
        (current-bits 0))
    (declare (fixnum longest-bits current-bits))
    (loop for char = (read-byte *standard-input* nil) while char do
         (loop for i from 7 downto 0 do
              (if (zerop (ldb (byte 1 i) char))
                  (progn
                    (when (> current-bits longest-bits)
                      (setf longest-bits current-bits))
                    (setf current-bits 0))
                (incf current-bits))))
    (when (> current-bits longest-bits)
      (setf longest-bits current-bits))
    (format t "~A~%" longest-bits)))

#+ecl
(main)
