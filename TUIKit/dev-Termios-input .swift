//
//          File:   dev-Termios-input.swift
//    Created by:   African Swift

import Darwin
import Foundation

var terminal_descriptor: Int32 = -1
var terminal_original = termios()
var terminal_settings = termios()

/// Restore terminal to original settings
func terminal_done()
{
  if terminal_descriptor != -1
  {
    tcsetattr(terminal_descriptor, TCSANOW, &terminal_original)
  }
}

// "Default" signal handler: restore terminal, then exit.
func terminal_signal(_ signum: Int32)
{
  if terminal_descriptor != -1
  {
    tcsetattr(terminal_descriptor, TCSANOW, &terminal_original)
  }
  
  /* exit() is not async-signal safe, but _exit() is.
   * Use the common idiom of 128 + signal number for signal exits.
   * Alternative approach is to reset the signal to default handler,
   * and immediately raise() it. */
  _exit(128 + signum)
}

func devTermios()
{
  // Initialize terminal for non-canonical, non-echo mode,
  // that should be compatible with standard C I/O.
  // Returns 0 if success, nonzero errno otherwise.
  func terminal_init() -> Int32
  {
    var act = sigaction()
    
    // Already initialized
    if terminal_descriptor != -1
    {
      errno = 0
      return errno
    }
    
    print("stderr", isatty(STDERR_FILENO))
    print("stdin", isatty(STDIN_FILENO))
    print("stdout", isatty(STDOUT_FILENO))
    
    // Which standard stream is connected to our TTY?
    if isatty(STDERR_FILENO) != 0
    {
      terminal_descriptor = STDERR_FILENO
      print("stderr connected")
    }
    else if isatty(STDIN_FILENO) != 0
    {
      terminal_descriptor = STDIN_FILENO
      print("stdin connected")
    }
    else if isatty(STDOUT_FILENO) != 0
    {
      terminal_descriptor = STDOUT_FILENO
      print("stdout connected")
    }
    else
    {
      errno = ENOTTY
      return errno
    }
    
    // Obtain terminal settings.
    if tcgetattr(terminal_descriptor, &terminal_original) != 0 ||
      tcgetattr(terminal_descriptor, &terminal_settings) != 0
    {
      errno = ENOTSUP
      return errno
    }
    
    // Disable buffering for terminal streams.
    if isatty(STDIN_FILENO) != 0
    {
      setvbuf(stdin, nil, _IONBF, 0)
    }
    
    if isatty(STDERR_FILENO) != 0
    {
      setvbuf(stderr, nil, _IONBF, 0)
    }
    
    // At exit() or return from main(), restore the original settings
    if atexit(terminal_done) != 0
    {
      errno = ENOTSUP
      return errno
    }
    
    // Set new "default" handlers for typical signals, so that if this process is
    // killed by a signal, the terminal settings will still be restored first.
    sigemptyset(&act.sa_mask)
    act.__sigaction_u.__sa_handler = terminal_signal as (@convention(c) (Int32) -> Void)
    act.sa_flags = 0
    
    // Break conditions
    var condition = sigaction(SIGHUP,  &act, nil) != 0 ||
      sigaction(SIGINT,  &act, nil) != 0 ||
      sigaction(SIGQUIT, &act, nil) != 0 ||
      sigaction(SIGTERM, &act, nil) != 0 ||
      sigaction(SIGPIPE, &act, nil) != 0 ||
      sigaction(SIGALRM, &act, nil) != 0
    #if SIGXCPU
      condition |= sigaction(SIGXCPU, &act, nil) != 0
    #endif
    #if SIGXFSZ
      condition |= sigaction(SIGXFSZ, &act, nil) != 0
    #endif
    #if SIGIO
      condition |= sigaction(SIGIO, &act, nil) != 0
    #endif

    if condition
    {
      errno = ENOTSUP
      return errno
    }

    // Let BREAK cause a SIGINT in input
    terminal_settings.c_iflag &= ~UInt(IGNBRK)
    terminal_settings.c_iflag |=  UInt(BRKINT)
    
    // Ignore framing and parity errors in input
    terminal_settings.c_iflag |=  UInt(IGNPAR)
    terminal_settings.c_iflag &= ~UInt(PARMRK)
    
    // Do not strip eighth bit on input
    terminal_settings.c_iflag &= ~UInt(ISTRIP)
    
    // Do not do newline translation on input
    terminal_settings.c_iflag &= ~(UInt(INLCR) | UInt(IGNCR) | UInt(ICRNL))
    
    #if IUCLC
      // Do not do uppercase-to-lowercase mapping on input
      terminal_settings.c_iflag &= ~UInt(IUCLC)
    #endif
    
    // Use 8-bit characters. This too may affect standard streams,
    // but any sane C library can deal with 8-bit characters
    terminal_settings.c_cflag &= ~UInt(CSIZE)
    terminal_settings.c_cflag |= UInt(CS8)
    
    // Enable receiver
    terminal_settings.c_cflag |= UInt(CREAD)
    
    // Let INTR/QUIT/SUSP/DSUSP generate the corresponding signals (CTRL-C, ....)
    terminal_settings.c_lflag &= ~UInt(ISIG)
    
    // Enable noncanonical mode.
    // This is the most important bit, as it disables line buffering etc
    terminal_settings.c_lflag &= ~UInt(ICANON)
    
    // Disable echoing input characters
    terminal_settings.c_lflag &= ~(UInt(ECHO) | UInt(ECHOE) | UInt(ECHOK) | UInt(ECHONL))
    
    // Disable implementation-defined input processing
    terminal_settings.c_lflag &= ~UInt(IEXTEN)
    
    // To maintain best compatibility with normal behaviour of terminals,
    // we set TIME=0 and MAX=1 in noncanonical mode. This means that
    // read() will block until at least one byte is available.
    //  terminal_settings.c_cc[VTIME] = 0
    //  terminal_settings.c_cc[VMIN] = 1
    Ansi.Terminal.setc_cc(settings: &terminal_settings, index: VTIME, value: 0)
    Ansi.Terminal.setc_cc(settings: &terminal_settings, index: VMIN, value: 1)
    
    // Set the new terminal settings.
    // Note that we don't actually check which ones were successfully
    // set and which not, because there isn't much we can do about it.
    tcsetattr(terminal_descriptor, TCSANOW, &terminal_settings)
    
    // Done
    errno = 0
    return errno
  }
  
  Ansi.Set.sendMouseXYOnButtonPressX11On().stdout()
  Ansi.Set.sgrMouseModeOn().stdout()
  Ansi.flush()
  
  
  if terminal_init() != 0
  {
    if Darwin.errno == ENOTTY
    {
      fputs("This program requires a terminal.\n", stderr)
    }
    else
    {
      fputs("Cannot initialize terminal: \(strerror(errno))\n", stderr)
    }
  }

  
  var readFDS = fd_set()
  var timeValue = timeval()
  
  var result = ""
  
  while true
  {
    // Watch stdin (fd 0) to see when it has input.
    Swift_FD_ZERO(&readFDS)
    Swift_FD_SET(0, &readFDS)
    
    // Wait up to 5 milliseconds.
    timeValue.tv_sec = 0
    timeValue.tv_usec = 5000
    
    let retval = select(1, &readFDS, nil, nil, &timeValue)
    if retval == -1
    {
      perror("select()")
      exit(EXIT_FAILURE)
    }
    else if retval != 0
    {
      let c = getc(stdin)
      if c >= 33 && c <= 126
      {
//        let format = String(format: "0x%02x = 0%03o = %3d = '%c'\n", c, c, c, c)
//        print(format)
      }
      else
      {
//        let format = String(format: "0x%02x = 0%03o = %3d\n", c, c, c)
//        print(format)
      }
      result += String(UnicodeScalar(Int(c)))
      
//      print(result)
      
//      if c == 3 || c == Q || c == q
      
      // Exit on CTRL-C
      if c == 3
      {
        Ansi.Set.sendMouseXYOnButtonPressX11Off().stdout()
        Ansi.Set.sgrMouseModeOff().stdout()
        break
      }
    }
    else
    {
      if result.characters.count > 0
      {
        if result.hasPrefix("\u{1b}")
        {
          debugPrint("\(result)")
        }
        else
        {
          print(result, terminator: "")
        }
        
        result = ""
      }
      // Triggered when select timed out
      // Add event code here: screen painting, etc...
      Thread.sleep(forTimeInterval: 0.1)
    }
  }
  
  //Thread.sleep(forTimeInterval: 10)
  Ansi.Set.sendMouseXYOnButtonPressX11Off().stdout()
  Ansi.Set.sgrMouseModeOff().stdout()
  
  
//  print(Ansi.Terminal.hasUnicodeSupport())
  Ansi.Terminal.bell()
}
