(in-package "BASIC-BINARY-PACKET.TESTS")

(defun encode-decode-test (value-type encoding-type value test)
  (assert (typep value value-type) (value value-type)
	  "The value ~A is not of type ~A" value value-type)
  (let ((bytes (flexi-streams:with-output-to-sequence (out)
		 (write-value encoding-type out value))))
    (flexi-streams:with-input-from-sequence (in bytes)
      (let ((encoded-value (read-value encoding-type in)))
	(funcall test value encoded-value)))))

(define-test encode-decode-test
  (assert-true (encode-decode-test '(unsigned-byte 8) 'binary-uint8 128 #'=))
  (assert-error 'error (encode-decode-test '(unsigned-byte 8) 'binary-uint8 "hello" #'=)))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun do-define-encode-decode-test (name body)
    (labels ((test-values (key)
	       (let ((v (find key body :key #'first)))
		 (assert v)
		 (rest v)))
	     (test-value (key)
	       (let ((v (test-values key)))
		 (assert (= 1 (length v)))
		 (first v)))
	     (test-for-value (value)
	       `(encode-decode-test ',(test-value :type)
				    ',(test-value :encoder)
				    ,value
				    ,(test-value :test))))
      `(define-test ,name
	 ,@(loop :for value :in (test-values :values) :collect
	      `(assert-true ,(test-for-value value)))
	 ,@(loop :for value :in (test-values :errors) :collect
	      `(assert-error 'error ,(test-for-value value))))))

  (defmacro define-encode-decode-test (name &body body)
    (do-define-encode-decode-test name body))

  (defmacro define-binary-number-test (name &body body)
    `(define-encode-decode-test ,name
       ,@body
       (:test #'=))))

(define-binary-number-test binary-uint8-test
  (:type (unsigned-byte 8))
  (:encoder binary-uint8)
  (:values 0 127 255)
  (:errors -1 256 "hello"))

(define-binary-number-test binary-uint16-test
  (:type (unsigned-byte 16))
  (:encoder binary-uint16)
  (:values 0 255 65535)
  (:errors -1 65536 "hello"))

(define-binary-number-test binary-uint32-test
  (:type (unsigned-byte 32))
  (:encoder binary-uint32)
  (:values 0 255 65535 (1- (expt 2 24)) (1- (expt 2 32)))
  (:errors -1 (expt 2 32) "hello"))

(define-binary-number-test binary-uint64-test
  (:type (unsigned-byte 64))
  (:encoder binary-uint64)
  (:values 0 255 65535 (1- (expt 2 24)) (1- (expt 2 32)) (1- (expt 2 64)))
  (:errors -1 (expt 2 64) "hello"))

(define-binary-number-test binary-int8-test
  (:type (signed-byte 8))
  (:encoder binary-int8)
  (:values -128 -1 0 1 127)
  (:errors -129 128 "hello"))

(define-binary-number-test binary-int16-test
  (:type (signed-byte 16))
  (:encoder binary-int16)
  (:values (- (expt 2 15))
	   -1 0 1
	   (1- (expt 2 15)))
  (:errors (1- (- (expt 2 15))) (expt 2 15) "hello"))

(define-binary-number-test binary-int32-test
  (:type (signed-byte 32))
  (:encoder binary-int32)
  (:values (- (expt 2 31))
	   -1 0 1
	   (1- (expt 2 31)))
  (:errors (1- (- (expt 2 31)))
	   (expt 2 31)
	   "hello"))

(define-binary-number-test binary-int64-test
  (:type (signed-byte 64))
  (:encoder binary-int64)
  (:values (- (expt 2 63))
	   -1 0 1
	   (1- (expt 2 63)))
  (:errors (1- (- (expt 2 63)))
	   (expt 2 63)
	   "hello"))

(define-binary-number-test binary-single-float-test
  (:type single-float)
  (:encoder binary-single-float)
  (:values -1.0 0.0 1.0 1.5 3.5 -10.0 most-negative-single-float)
  (:errors most-negative-double-float
	   "hello"))

(define-binary-number-test binary-double-float-test
  (:type double-float)
  (:encoder binary-double-float)
  (:values -1d0 0d0 1d0 1.5d0 3.5d0 -10.0d0 most-negative-double-float)
  (:errors "hello"))

(define-binary-number-test binary-integer-test
  (:type integer)
  (:encoder binary-integer)
  (:values -1 1 0 (expt 2 65) (- (expt 8 1000)))
  (:errors 1.0 "hello"))

(define-binary-number-test binary-ratio-test
  (:type (or ratio
	     integer))
  (:encoder binary-ratio)
  (:values (/ 0 1) (/ 5 2) (/ -5 3) (/ 3 -5))
  (:errors "hello"))

(define-encode-decode-test binary-boolean-test
  (:type (member nil T))
  (:encoder binary-boolean)
  (:values nil T)
  (:errors "hello")
  (:test #'equal))

(define-encode-decode-test binary-utf8-string-test
  (:type string)
  (:encoder binary-utf8-string)
  (:values "G'day" "Mate")
  (:errors 5)
  (:test #'string=))

(define-test binary-utf8-string-test/incomplete
  (let ((bytes (make-array 5 :element-type '(unsigned-byte 8) :initial-contents '(0 0 0 2 1))))
    (flexi-streams:with-input-from-sequence (in bytes)
      (assert-error 'error (read-value 'binary-utf8-string in)))))

(define-encode-decode-test binary-keyword
  (:type keyword)
  (:encoder binary-keyword)
  (:values :one :two :three)
  (:errors 5 "hello")
  (:test #'eql))

(define-encode-decode-test binary-symbol-test
  (:type symbol)
  (:encoder binary-symbol)
  (:values 'one 'two 'three nil t)
  (:errors 5 "hello")
  (:test #'eql))
