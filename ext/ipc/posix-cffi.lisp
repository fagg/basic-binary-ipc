(in-package "BASIC-BINARY-PACKET.IPC")

(cffi:defctype posix-socket-protocol :int)

(define-system-call (%ff-socket "socket") :int
  (domain   posix-socket-namespace)
  (type     posix-socket-type)
  (protocol posix-socket-protocol))

(define-system-call (%ff-close "close") :int
  (file-descriptor :int))

(define-system-call (%ff-bind "bind") :int
  (socket :int)
  (socket-address :pointer)
  (socket-address-length socklen-t))

(define-system-call (%ff-listen "listen") :int
  (socket :int)
  (backlog :int))

(cffi:defcfun (%ff-inet-aton "inet_aton") :int
  (name :string)
  (addr (:pointer (:struct in-addr))))

(cffi:defcfun (%ff-htons "htons") :uint16
  (host-short :uint16))

(cffi:defcfun (%ff-ntohl "ntohl") :uint32
  (network-long :uint32))

(cffi:defcfun (%ff-inet-ntoa "inet_ntoa") :string
  (addr :uint32))

;; inaddr
;(defmethod cffi:translate-into-foreign-memory ((value integer) (type inaddr)))
