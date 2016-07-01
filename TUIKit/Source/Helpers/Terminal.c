//
//          File:   Terminal.c
//    Created by:   African Swift

#include "Terminal.h"

/// Get window size
const unsigned long S_TIOCGWINSZ = TIOCGWINSZ;

/// Set window size
const unsigned long S_TIOCSWINSZ = TIOCSWINSZ;

///  Wrapper for ioctl
int S_ioctl(int fildes, unsigned long request, int *val) {
  return ioctl(fildes, request, val);
}
