(in-package "BASIC-BINARY-IPC.OVERLAPPED-IO")

(include "Winsock2.h")
(include "Windows.h")

;; Shared CTypes
(ctype dword "DWORD") ;; Should be an unsigned 32 bit integer.
(ctype handle "HANDLE")
(ctype bool "BOOL")

;; Constants
(constant (+true+ "TRUE"))
(constant (+false+ "FALSE"))
(constant (+invalid-handle-value+ "INVALID_HANDLE_VALUE"))
(constant (+null+ "NULL"))
(constant (+infinite+ "INFINITE"))
(constant (+maximum-wait-objects+ "MAXIMUM_WAIT_OBJECTS"))
(constant (+invalid-socket+ "INVALID_SOCKET"))

;; Overlapped
(cstruct overlapped "struct _OVERLAPPED"
  (h-event "hEvent" :type handle))

;; WaitForSingleObject
(constantenum (wait :base-type :unsigned-int)
  ((:wait-abandoned "WAIT_ABANDONED"))
  ((:wait-object-0 "WAIT_OBJECT_0"))
  ((:wait-timeout "WAIT_TIMEOUT"))
  ((:wait-failed "WAIT_FAILED")))

;;;; Named Pipes
(constant (+pipe-unlimited-instances+ "PIPE_UNLIMITED_INSTANCES"))

(bitfield (named-pipe-open-mode :base-type :unsigned-int)
  ((:pipe-access-duplex "PIPE_ACCESS_DUPLEX"))
  ((:file-flag-overlapped "FILE_FLAG_OVERLAPPED")))

(bitfield (named-pipe-mode :base-type :unsigned-int)
  ((:pipe-type-byte "PIPE_TYPE_BYTE"))
  ((:pipe-readmode-byte "PIPE_READMODE_BYTE")))

(bitfield (file-desired-access :base-type :unsigned-int)
  ((:generic-read "GENERIC_READ"))
  ((:generic-write "GENERIC_WRITE")))

(bitfield (file-share-mode :base-type :unsigned-int)
  ((:file-share-delete "FILE_SHARE_DELETE"))
  ((:file-share-read "FILE_SHARE_READ"))
  ((:file-share-write "FILE_SHARE_WRITE")))

(constantenum (file-creation-disposition :base-type :unsigned-int)
  ((:create-always "CREATE_ALWAYS"))
  ((:create-new "CREATE_NEW"))
  ((:open-always "OPEN_ALWAYS"))
  ((:open-existing "OPEN_EXISTING"))
  ((:truncate-existing "TRUNCATE_EXISTING")))

(bitfield (file-attribute :base-type :unsigned-int)
  ((:file-flag-overlapped "FILE_FLAG_OVERLAPPED")))

;;;; Sockets
(ctype socket "SOCKET")
(ctype socket-group "GROUP")

(constant (+inaddr-none+ "INADDR_NONE"))

(constantenum (socket-address-family :base-type :int)
  ((:af-inet "AF_INET")))

(constantenum (socket-type :base-type :int)
  ((:sock-stream "SOCK_STREAM")))

(constantenum (socket-protocol :base-type :int)
  ((:ipproto-tcp "IPPROTO_TCP")))

(constantenum (socket-flags :base-type :unsigned-int)
  ((:wsa-flag-overlapped "WSA_FLAG_OVERLAPPED")))

(cstruct in-addr "struct in_addr"
  (s-addr "S_un.S_addr" :type :unsigned-long))

(cstruct sockaddr-in "struct sockaddr_in"
  (sin-family "sin_family" :type :unsigned-short)
  (sin-port "sin_port" :type :unsigned-short)
  (in-addr "sin_addr" :type (:struct in-addr)))

;;;; ERRORS
;; Winsock Errors
;; These constants are found in 
;; - ( x86_64 ) mingw64/x86_64-w64-mingw32/include/winsock2.h
;; - ( x86 )    MinGW/include/winsock2.h
(constantenum (winsock-error-codes :base-type :unsigned-int)
  ((:error-success "ERROR_SUCCESS"))
  ((:no-error "NO_ERROR"))
  ((:wsa-invalid-handle "WSA_INVALID_HANDLE"))
  ((:wsa-not-enough-memory "WSA_NOT_ENOUGH_MEMORY"))
  ((:wsa-invalid-parameter "WSA_INVALID_PARAMETER"))
  ((:wsa-operation-aborted "WSA_OPERATION_ABORTED"))
  ((:wsa-io-incomplete "WSA_IO_INCOMPLETE"))
  ((:wsa-io-pending "WSA_IO_PENDING"))
  ((:wsaeintr "WSAEINTR"))
  ((:wsaebadf "WSAEBADF"))
  ((:wsaeacces "WSAEACCES"))
  ((:wsaefault "WSAEFAULT"))
  ((:wsaeinval "WSAEINVAL"))
  ((:wsaemfile "WSAEMFILE"))
  ((:wsaewouldblock "WSAEWOULDBLOCK"))
  ((:wsaeinprogress "WSAEINPROGRESS"))
  ((:wsaealready "WSAEALREADY"))
  ((:wsaenotsock "WSAENOTSOCK"))
  ((:wsaedestaddrreq "WSAEDESTADDRREQ"))
  ((:wsaemsgsize "WSAEMSGSIZE"))
  ((:wsaeprototype "WSAEPROTOTYPE"))
  ((:wsaenoprotoopt "WSAENOPROTOOPT"))
  ((:wsaeprotonosupport "WSAEPROTONOSUPPORT"))
  ((:wsaesocktnosupport "WSAESOCKTNOSUPPORT"))
  ((:wsaeopnotsupp "WSAEOPNOTSUPP"))
  ((:wsaepfnosupport "WSAEPFNOSUPPORT"))
  ((:wsaeafnosupport "WSAEAFNOSUPPORT"))
  ((:wsaeaddrinuse "WSAEADDRINUSE"))
  ((:wsaeaddrnotavail "WSAEADDRNOTAVAIL"))
  ((:wsaenetdown "WSAENETDOWN"))
  ((:wsaenetunreach "WSAENETUNREACH"))
  ((:wsaenetreset "WSAENETRESET"))
  ((:wsaeconnaborted "WSAECONNABORTED"))
  ((:wsaeconnreset "WSAECONNRESET"))
  ((:wsaenobufs "WSAENOBUFS"))
  ((:wsaeisconn "WSAEISCONN"))
  ((:wsaenotconn "WSAENOTCONN"))
  ((:wsaeshutdown "WSAESHUTDOWN"))
  ((:wsaetoomanyrefs "WSAETOOMANYREFS"))
  ((:wsaetimedout "WSAETIMEDOUT"))
  ((:wsaeconnrefused "WSAECONNREFUSED"))
  ((:wsaeloop "WSAELOOP"))
  ((:wsaenametoolong "WSAENAMETOOLONG"))
  ((:wsaehostdown "WSAEHOSTDOWN"))
  ((:wsaehostunreach "WSAEHOSTUNREACH"))
  ((:wsaenotempty "WSAENOTEMPTY"))
  ((:wsaeproclim "WSAEPROCLIM"))
  ((:wsaeusers "WSAEUSERS"))
  ((:wsaedquot "WSAEDQUOT"))
  ((:wsaestale "WSAESTALE"))
  ((:wsaeremote "WSAEREMOTE"))
  ((:wsasysnotready "WSASYSNOTREADY"))
  ((:wsavernotsupported "WSAVERNOTSUPPORTED"))
  ((:wsanotinitialised "WSANOTINITIALISED"))
  ((:wsaediscon "WSAEDISCON"))
  ((:wsaenomore "WSAENOMORE"))
  ((:wsaecancelled "WSAECANCELLED"))
  ((:wsaeinvalidproctable "WSAEINVALIDPROCTABLE"))
  ((:wsaeinvalidprovider "WSAEINVALIDPROVIDER"))
  ((:wsaeproviderfailedinit "WSAEPROVIDERFAILEDINIT"))
  ((:wsasyscallfailure "WSASYSCALLFAILURE"))
  ((:wsaservice-not-found "WSASERVICE_NOT_FOUND"))
  ((:wsatype-not-found "WSATYPE_NOT_FOUND"))
  ((:wsa-e-no-more "WSA_E_NO_MORE"))
  ((:wsa-e-cancelled "WSA_E_CANCELLED"))
  ((:wsaerefused "WSAEREFUSED"))
  ((:wsahost-not-found "WSAHOST_NOT_FOUND"))
  ((:wsatry-again "WSATRY_AGAIN"))
  ((:wsano-recovery "WSANO_RECOVERY"))
  ((:wsano-data "WSANO_DATA")))

;;;; Errors
;; Have a look in the following files to find these constants:
;; - ( x86_64 ) mingw64/x86_64-w64-mingw32/include/winerror.h
;; - ( x86 )    MinGW/include/winerror.h
(constantenum (error-codes :base-type :unsigned-int)
  ((:error-success "ERROR_SUCCESS"))
  ((:no-error "NO_ERROR"))
  ((:error-invalid-handle "ERROR_INVALID_HANDLE"))
  ((:error-invalid-user-buffer "ERROR_INVALID_USER_BUFFER"))
  ((:error-not-enough-memory "ERROR_NOT_ENOUGH_MEMORY"))
  ((:error-operation-aborted "ERROR_OPERATION_ABORTED"))
  ((:error-not-enough-quota "ERROR_NOT_ENOUGH_QUOTA"))
  ((:error-insufficient-buffer "ERROR_INSUFFICIENT_BUFFER"))
  ((:error-io-incomplete "ERROR_IO_INCOMPLETE"))
  ((:error-io-pending "ERROR_IO_PENDING"))
  ((:error-handle-eof "ERROR_HANDLE_EOF"))
  ((:error-broken-pipe "ERROR_BROKEN_PIPE"))
  ((:error-more-data "ERROR_MORE_DATA"))
  ((:error-file-not-found "ERROR_FILE_NOT_FOUND"))
  ((:error-pipe-connected "ERROR_PIPE_CONNECTED"))
  ((:error-pipe-listening "ERROR_PIPE_LISTENING"))
  ((:error-pipe-busy "ERROR_PIPE_BUSY"))
  ((:error-pipe-not-connected "ERROR_PIPE_NOT_CONNECTED"))
  ((:wait-timeout "WAIT_TIMEOUT")))

;;;; Bloody FormatMessage crap. What a joke.
(ctype lpcvoid "LPCVOID")
(ctype lptstr "LPTSTR")
(ctype tchar "TCHAR")
(bitfield (format-message-flags :base-type :uint32)
  ((:format-message-allocate-buffer "FORMAT_MESSAGE_ALLOCATE_BUFFER"))
  ((:format-message-argument-array "FORMAT_MESSAGE_ARGUMENT_ARRAY"))
  ((:format-message-from-hmodule "FORMAT_MESSAGE_FROM_HMODULE"))
  ((:format-message-from-string "FORMAT_MESSAGE_FROM_STRING"))
  ((:format-message-from-system "FORMAT_MESSAGE_FROM_SYSTEM"))
  ((:format-message-ignore-inserts "FORMAT_MESSAGE_IGNORE_INSERTS")))
