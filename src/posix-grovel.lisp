(in-package "BASIC-BINARY-IPC")

#+linux (define "_GNU_SOURCE" 1)
#+freebsd (include "sys/types.h")
#+openbsd (include "sys/types.h")

(include "errno.h")

(constantenum (errno-enum :base-type :int)
  ((:eagain "EAGAIN"))
  ((:ewouldblock "EWOULDBLOCK"))
  ((:ebadf "EBADF"))
  ((:eintr "EINTR"))
  ((:eio   "EIO"))
  ((:eacces "EACCES"))
  ((:eafnosupport "EAFNOSUPPORT"))
  ((:eisconn "EISCONN"))
  ((:emfile "EMFILE"))
  ((:enfile "ENFILE"))
  ((:enobufs "ENOBUFS"))
  ((:enomem "ENOMEM"))
  ((:enospc "ENOSPC"))
  ((:eprotonosupport "EPROTONOSUPPORT"))
  ((:eprototype "EPROTOTYPE"))
  ((:eaddrinuse "EADDRINUSE"))
  ((:eaddrnotavail "EADDRNOTAVAIL"))
  ((:edestaddrreq "EDESTADDRREQ"))
  ((:efault "EFAULT"))
  ((:emsgsize "EMSGSIZE"))
  ((:einval "EINVAL"))
  ((:enotsock "ENOTSOCK"))
  ((:eopnotsupp "EOPNOTSUPP"))
  ((:ealready "EALREADY"))
  ((:econnrefused "ECONNREFUSED"))
  ((:ehostunreach "EHOSTUNREACH"))
  ((:einprogress "EINPROGRESS"))
  ((:ehostdown "EHOSTDOWN"))
  ((:enetdown "ENETDOWN"))
  ((:enetunreach "ENETUNREACH"))
  ((:etimedout "ETIMEDOUT"))
  ((:econnreset "ECONNRESET"))
  ((:eloop "ELOOP"))
  ((:enametoolong "ENAMETOOLONG"))
  ((:enoent "ENOENT"))
  ((:enotdir "ENOTDIR"))
  ((:epipe "EPIPE"))
  ((:enoprotoopt "ENOPROTOOPT"))
  ((:eperm "EPERM"))
  ((:enotconn "ENOTCONN")))

(include "fcntl.h")

(constantenum (fcntl-command :base-type :int)
  ((:f-getfl "F_GETFL"))
  ((:f-setfl "F_SETFL")))

(bitfield (operating-mode :base-type :int)
  ((o-nonblock "O_NONBLOCK")))

(include "sys/socket.h")

#-openbsd
(constantenum (posix-socket-namespace :base-type :int)
  ((:pf-inet "PF_INET"))
  ((:pf-local "PF_LOCAL")))
#+openbsd
(constantenum (posix-socket-namespace :base-type :int)
  ((:pf-inet "AF_INET"))
  ((:pf-local "AF_UNIX")))


(constantenum (posix-socket-type :base-type :int)
  ((:sock-stream "SOCK_STREAM"))
  ((:sock-dgram  "SOCK_DGRAM")))

(constantenum (socket-level :base-type :int)
  ((:sol-socket "SOL_SOCKET")))

(constantenum (socket-option :base-type :int)
  ((:so-reuseaddr "SO_REUSEADDR"))
  ((:so-keepalive "SO_KEEPALIVE")))

(ctype socklen-t "socklen_t")

(include "netinet/in.h")

(ctype sa-family-t "sa_family_t")
(constantenum (posix-socket-address-family :base-type sa-family-t)
  ((:af-inet "AF_INET"))
  ((:af-local "AF_LOCAL")))

(constantenum (posix-socket-protocols :base-type :int)
  ((:default "NULL"))
  ((:ipproto-tcp "IPPROTO_TCP")))

(cstruct in-addr "struct in_addr"
  (s-addr "s_addr" :type :uint32))

(cstruct sockaddr-in "struct sockaddr_in"
  (sin-family "sin_family" :type posix-socket-address-family)
  (sin-addr   "sin_addr"   :type (:struct in-addr))
  (sin-port   "sin_port"   :type :unsigned-short))

(constant (inaddr-loopback  "INADDR_LOOPBACK"))
(constant (inaddr-any       "INADDR_ANY"))
(constant (inaddr-broadcast "INADDR_BROADCAST"))
(constant (inaddr-none      "INADDR_NONE"))

; Local Sockets
(include "sys/un.h")

(cstruct sockaddr-un "struct sockaddr_un"
  (sun-family "sun_family" :type posix-socket-address-family)
  (sun-path   "sun_path" :type :char))

; poll
#+linux (define "__USE_XOPEN" 1)
(include "poll.h")

(ctype nfds-t "nfds_t")

(bitfield (poll-events :base-type :short)
  ((pollerr    "POLLERR"))
  ((pollhup    "POLLHUP"))
  ((pollin     "POLLIN"))
  ((pollnval   "POLLNVAL"))
  ((pollout    "POLLOUT"))
  ((pollpri    "POLLPRI"))
  ((pollrdband "POLLRDBAND"))
  ((pollrdnorm "POLLRDNORM"))
  ((pollwrband "POLLWRBAND"))
  ((pollwrnorm "POLLWRNORM")))

(cstruct pollfd "struct pollfd"
  (fd "fd" :type :int)
  (events "events" :type poll-events)
  (revents "revents" :type poll-events))

(ctype size-t "size_t")
(bitfield (message-flags :base-type :int)
  ((msg-oob "MSG_OOB"))
  ((msg-peek "MSG_PEEK"))
  ((msg-waitall "MSG_WAITALL"))
  ((msg-dontroute "MSG_DONTROUTE")))

; getaddrinfo
(include "netdb.h")
(bitfield (addrinfo-flags :base-type :int)
  ((ai-addrconfig "AI_ADDRCONFIG"))
  ((ai-all "AI_ALL"))
  ((ai-canonname "AI_CANONNAME"))
  ((ai-numerichost "AI_NUMERICHOST"))
  ((ai-numericserv "AI_NUMERICSERV"))
  ((ai-passive "AI_PASSIVE"))
  ((ai-v4mapped "AI_V4MAPPED")))

(cstruct addrinfo "struct addrinfo"
  (ai-flags "ai_flags" :type addrinfo-flags)
  (ai-family "ai_family" :type posix-socket-namespace)
  (ai-socktype "ai_socktype" :type posix-socket-type)
  (ai-protocol "ai_protocol" :type posix-socket-protocols)
  (ai-addrlen "ai_addrlen" :type socklen-t)
  (ai-addr "ai_addr" :type :pointer)
  (ai-canonname "ai_canonname" :type :string)
  (ai-next "ai_next" :type :pointer))

(constantenum (addrinfo-error-codes :base-type :int)
  ((:eai-noname "EAI_NONAME"))
  #+(or linux openbsd)
  ((:eai-nodata "EAI_NODATA")))

