(in-package "ASDF")

(eval-when (:compile-toplevel :load-toplevel :execute)
  (asdf:load-system "cffi-grovel"))

(defsystem "basic-binary-ipc"
  :author "Mark Cox"
  :description "A inter-process communication library for transmitting binary data over a stream."
  :license "Simplified BSD License variant"
  :depends-on ("cffi-grovel")
  :serial t
  :components ((:module "src"
			:serial t
			:components ((:file "packages")
				     (:file "protocols")
				     (:file "system-calls")))
	       #+(or darwin freebsd openbsd linux)
	       (:module "src/posix"
			:serial t
			:pathname "src"
			:components ((:file "posix-helpers")
				     (cffi-grovel:grovel-file "posix-grovel")
				     (:file "posix-cffi")
				     (:file "posix-socket-options")
				     (:file "posix-sockets")
				     (:file "posix-poll")))	       
	       #+(or darwin freebsd openbsd)
	       (:module "src/kqueue"
			:serial t
			:pathname "src"
			:components ((cffi-grovel:grovel-file "kqueue-grovel")
				     (:file "kqueue-cffi")
				     (:file "kqueue-poller")))
	       #+linux
	       (:module "src/epoll"
			:serial t
			:pathname "src"
			:components ((cffi-grovel:grovel-file "epoll-grovel")
				     (:file "epoll-cffi")
				     (:file "epoll-poller")))

	       #+windows
	       (:module "src/overlapped-io"
			:serial t
			:pathname "src"
			:components ((:file "overlapped-io-packages")
				     (cffi-grovel:grovel-file "overlapped-io-grovel")
				     (:file "overlapped-io-errors")
				     (:file "overlapped-io-cffi")
				     (:file "overlapped-io")
				     (:file "windows"))))
  :in-order-to ((test-op (test-op "basic-binary-ipc-tests"))))
