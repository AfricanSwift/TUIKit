///  Wrapper for ioctl

#import "Term.h"
#include "Terminal.h"
#include <sys/ioctl.h>
//#include <stdlib.h>
//#include <string.h>
//#include <sys/select.h>

int Swift_ioctl(int fildes, unsigned long request, int *val);

/// Get window size
extern const unsigned long S_TIOCGWINSZ;

/// Set window size
extern const unsigned long S_TIOCSWINSZ;

//struct termios saved;

void Swift_FD_SET(int fd, fd_set *fdset);
void Swift_FD_ZERO(fd_set *fdset);
