///  Wrapper for ioctl

#import "Term.h"
#include "Terminal.h"
#include <sys/ioctl.h>

int S_ioctl(int fildes, unsigned long request, int *val);

/// Get window size
extern const unsigned long S_TIOCGWINSZ;

/// Set window size
extern const unsigned long S_TIOCSWINSZ;

struct termios saved;
