//
//          File:   main.swift
//    Created by:   African Swift

import Darwin
import Foundation

//// WWDC 2016 Logo Example
//Example_WWDCLogo.demo()
//
//// Fig Font Example

//for i in 1...20 {
//  try Example_Figfont.demo()
//}

//let saved, temporary: termios
//
//let z1 = ICANON
//let z2 = ECHO
//let z3 = CREAD

/// File descriptor for current TTY
///
/// - returns: Int32
func currentTTY() -> Int32
{
  func fileDescriptor(_ device: UnsafeMutablePointer<CChar>) -> CInt
  {
    var descriptor: Int32
    repeat
    {
      descriptor = open(device, O_RDWR | O_NOCTTY)
    } while descriptor == -1 && errno == EINTR
    return descriptor
  }
  if let device = ttyname(STDIN_FILENO)
  {
    return fileDescriptor(device)
  }
  else if let device = ttyname(STDOUT_FILENO)
  {
    return fileDescriptor(device)
  }
  else if let device = ttyname(STDERR_FILENO)
  {
    return fileDescriptor(device)
  }
  return -1
}

func readTTY(_ tty: Int32) -> Int32
{
  var buffer = [UInt8](repeating: 0, count: 4)
  var n: ssize_t
  
  let RD_EOF = Int32(-1)
  let RD_EIO = Int32(-2)
  
  while true
  {
    n = read(tty, &buffer, 1)
    if n > ssize_t(0)
    {
      return Int32(buffer[0])
    }
    else if n == ssize_t(0)
    {
      return RD_EOF
    }
    else if n != ssize_t(-1)
    {
      return RD_EIO
    }
    else if errno != EINTR && errno != EAGAIN && errno != EWOULDBLOCK
    {
      return RD_EIO
    }
  }
}

func cursorPosition(tty: Int32) -> TUIPoint?
{
  var saved = termios.init()
  var temporary = termios.init()
  var rows, cols: Int
  var result, retval: Int32
  var saved_errno: Int32
  
  result = -1
  
  // Inappropriate TTY
  if tty == -1 { return nil }
  
  saved_errno = errno
  
  // Save current terminal settings
  repeat
  {
    result = tcgetattr(tty, &saved)
  } while result == -1 && errno == EINTR
  
  if result == -1
  {
    errno = saved_errno
    return nil
  }
  
  // Get current terminal settings for basis, too.
  repeat
  {
    result = tcgetattr(tty, &temporary)
  } while result == -1 && errno == EINTR
  
  if result == -1
  {
    errno = saved_errno
    return nil
  }
  
  // Disable ICANON, ECHO, and CREAD.
  temporary.c_lflag &= ~UInt(ICANON)
  temporary.c_lflag &= ~UInt(ECHO)
  temporary.c_cflag &= ~UInt(CREAD)
  
  // Restore saved terminal settings.
  defer
  {
    repeat
    {
      result = tcsetattr(tty, TCSANOW, &saved)
    } while result == -1 && errno == EINTR
  }
  
  // Set modified settings
  repeat
  {
    result = tcsetattr(tty, TCSANOW, &temporary)
  } while result == -1 && errno == EINTR
  
  if result == -1
  {
    return nil
  }
  
  // Request cursor coordinates from the terminal
  Ansi.Cursor.Report.position().stdout()
  Ansi.flush()
  
  // Assume coordinate reponse parsing fails.
  retval = EIO
  
  let values: [Character] = ["\u{1b}", "[", "#", ";", "#", "R"]
  var index = 0
  var num = [Int]()
  
  repeat
  {
    result = readTTY(tty)
    let ch = Character(UnicodeScalar(Int(result)))
    if ch != values[index] && values[index] != "#"
    {
      break
    }
    
    if values[index] == "R" { break }
    if values[index] == "#"
    {
      // Process number
      var number = String(ch)
      repeat
      {
        result = readTTY(tty)
        let ch = Character(UnicodeScalar(Int(result)))
        
        if ch == ";" || ch == "R"
        {
          num.append(Int(number) ?? -99)
          index += 1
          break
        }
        number += String(ch)
      } while true
    }
    index += 1
    
  } while index < values.count
  
  if num.count == 2 { return TUIPoint(x: num[1], y: num[0]) }
  
  return nil
}


//print(currentTTY())

Ansi.Cursor.position(row: 5, column: 20).stdout()
let a = cursorPosition(tty: currentTTY())

debugPrint(a)


//Ansi.Window.resize(width: 60, height: 36).stdout()

//Ansi.Window.move(x: 10, y: 10).stdout()

//print("characterScreenSize")
//Ansi.Window.Report.characterScreenSize().stdout()
//print()

//print("characterTextAreaSize")
//Ansi.Window.Report.characterTextAreaSize().stdout()

//print(TUIScreen.size)

//print("characterTextAreaSize")
//Ansi.Window.Report.characterTextAreaSize().stdout()

//
//print("pixelSize")
//Ansi.Window.Report.pixelSize().stdout()
//
//print("position")
//Ansi.Window.Report.position().stdout()


//Ansi.Window.resize(width: 200, height: 200).stdout()


//Ansi.Window.Report.position().stdout()
