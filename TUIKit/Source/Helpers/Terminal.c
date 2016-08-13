//
//          File:   Terminal.c
//    Created by:   African Swift

#include "Terminal.h"

/// Get window size
const unsigned long S_TIOCGWINSZ = TIOCGWINSZ;

/// Set window size
const unsigned long S_TIOCSWINSZ = TIOCSWINSZ;

///  Wrapper for ioctl
int Swift_ioctl(int fildes, unsigned long request, int *val) {
  return ioctl(fildes, request, val);
}

///  Wrapper for FD_SET
void Swift_FD_SET(int fd, fd_set *fdset) {
  FD_SET(fd, fdset);
}

///  Wrapper for FD_ZERO
void Swift_FD_ZERO(fd_set *fdset) {
  FD_ZERO(fdset);
}
