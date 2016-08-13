//
//          File:   Ansi+Terminal.swift
//    Created by:   African Swift

import Darwin
import Foundation

// MARK: -
// MARK: Command, fileDescriptor, currentTTY -
public extension Ansi
{
  public enum Terminal
  {
//    public enum Program
//    {
//      // mac Terminal "Apple_Terminal"
//      // mac iTerm "iTerm.app"
//      case macTerminal, iTerm, linuxXterm
//    }
    
    
    
    public static func hasUnicodeSupport() -> Bool
    {
      let value = [getenv("LANG"), getenv("LC_CTYPE"), getenv("LC_ALL")]
        .flatMap { return $0 == nil ? nil : $0 }
        .map { String(cString: $0) }.first ?? ""
      return value.lowercased().contains("utf")
    }
    
    public static func bell()
    {
      Ansi("\(Ansi.C0.BEL)").stdout()
    }
    
    /// Soft Terminal Reset (DECSTR)
    public static func softReset()
    {
      Ansi("\(Ansi.C1.CSI)!p").stdout()
    }
    
    /// Hard Terminal Reset (RIS)
    public static func hardReset()
    {
      Ansi("\(Ansi.C0.ESC)c").stdout()
    }
    
    /// Adjustments (DECALN)
    ///
    /// The terminal has a screen alignment pattern that service personnel use to
    /// adjust the screen. You can display the screen alignment pattern with the
    /// DECALN sequence. This sequence fills the screen with uppercase E's.
    public static func testPattern()
    {
      Ansi("\(Ansi.C0.ESC)#8").stdout()
    }
    
    /// Terminal Ansi command and expected response
    ///
    /// ````
    /// let cursorReport = Ansi.Terminal.Command(
    ///    request: Ansi.Cursor.Report.position(),
    ///    response: "\u{1B}[#;#R")
    /// ````
    public struct Command
    {
      var request: Ansi
      var response: String
    }
    
    /// Retrieve file descriptor
    ///
    /// - parameters:
    ///   - device: UnsafeMutablePointer<CChar>
    /// - returns: CInt
    private static func fileDescriptor(_ device: UnsafeMutablePointer<CChar>) -> CInt
    {
      var descriptor: Int32
      repeat
      {
        descriptor = open(device, O_RDWR | O_NOCTTY)
      } while descriptor == -1 && errno == EINTR
      return descriptor
    }
    
    /// File descriptor for current TTY
    ///
    /// - returns: Int32
    internal static func currentTTY() -> Int32
    {
      if let device = ttyname(STDIN_FILENO)
      {
        return Ansi.Terminal.fileDescriptor(device)
      }
      else if let device = ttyname(STDOUT_FILENO)
      {
        return Ansi.Terminal.fileDescriptor(device)
      }
      else if let device = ttyname(STDERR_FILENO)
      {
        return Ansi.Terminal.fileDescriptor(device)
      }
      return -1
    }
  }
}

// REPLACE with new termios code

// MARK: -
// MARK: readValue -
public extension Ansi.Terminal
{
  /// Read value from TTY
  ///
  /// - parameters:
  ///   - tty: Int32
  /// - returns: Int32
  internal static func readValue(tty: Int32) -> Int32
  {
    // Maximum time (ms) to allow read to block
    let maximumBlockDuration = 0.2
    
    var buffer = [UInt8](repeating: 0, count: 4)
    var n: ssize_t
    
    let RD_EOF = Int32(-1)
    let RD_EIO = Int32(-2)
    
    let start = Date().timeIntervalSince1970
    
    // Disable read blocking
    var flags = Darwin.fcntl(tty, F_GETFL, 0)
    _ = Darwin.fcntl(tty, F_SETFL, flags | O_NONBLOCK)
    
    // Restore flags on exit
    defer { _ = Darwin.fcntl(tty, F_SETFL, flags) }
    
    while true
    {
      n = Darwin.read(tty, &buffer, 1)
      if n > ssize_t(0)
      {
        return Int32(buffer[0])
      }
      else if n == ssize_t(0)
      {
        print("RD_EOF")
        return RD_EOF
      }
      else if n != ssize_t(-1)
      {
        print("RD_EIOa")
        return RD_EIO
      }
      else if errno != EINTR && errno != EAGAIN && errno != EWOULDBLOCK
      {
        print("RD_EIOb")
        return RD_EIO
      }
      
      // Precaution -- prevent blocking for longer than maximumBlockDuration
      if (Date().timeIntervalSince1970 - start) * 1000 > maximumBlockDuration
      {
        return Int32.max
      }
    }
  }
}

// MARK: -
// MARK: saveSettings, enableNonCanon, restoreSettings -
public extension Ansi.Terminal
{
  /// Save current terminal settings
  ///
  /// - parameters:
  ///   - tty: Int32
  /// - returns: termios?
  internal static func saveSettings(tty: Int32) -> termios?
  {
    var result: Int32
    var settings = termios.init()
    repeat
    {
      result = tcgetattr(tty, &settings)
    } while result == -1 && errno == EINTR
    return result == -1 ? nil : settings
  }
  
  /// Set termios control chars
  ///
  /// - parameters:
  ///   - settings: inout termios
  ///   - index: Int32
  ///   - value: UInt8
  internal static func setc_cc(settings: inout termios, index: Int32, value: UInt8)
  {
    withUnsafeMutablePointer(&settings.c_cc) { tuplePointer -> Void in
      let c_ccPointer = UnsafeMutablePointer<cc_t>(tuplePointer)
      c_ccPointer[Int(index)] = value
    }
  }
  
  /// Enabled Non Canonical Input (Disable ICANON, ECHO & CREAD)
  ///
  /// - parameters:
  ///   - tty: Int32
  ///   - settings: inout termios
  /// - returns: Bool
  internal static func enableNonCanon(tty: Int32, settings: inout termios) -> Bool
  {
    settings.c_lflag &= ~UInt(ICANON)
    settings.c_lflag &= ~UInt(ECHO)
    settings.c_cflag &= ~UInt(CREAD)
    Ansi.Terminal.setc_cc(settings: &settings, index: VMIN, value: 1)
    Ansi.Terminal.setc_cc(settings: &settings, index: VTIME, value: 1)
    
    // Set modified settings
    var result: Int32
    repeat
    {
      result = tcsetattr(tty, TCSANOW, &settings)
    } while result == -1 && errno == EINTR
    return result == -1 ? false : true
  }
  
  /// Restore TTY settings
  ///
  /// - parameters:
  ///   - tty: Int32
  ///   - settings: inout termios
  internal static func restoreSettings(tty: Int32, settings: inout termios)
  {
    // Restore saved terminal settings`
    var result: Int32
    repeat
    {
      result = tcsetattr(tty, TCSANOW, &settings)
    } while result == -1 && errno == EINTR
  }
}

// MARK: -
// MARK: readResponse & responseTTY -
public extension Ansi.Terminal
{
  /// Read TTY response
  ///
  /// - parameters:
  ///   - tty: Int32
  ///   - expected: String
  /// - returns: String?
  private static func readResponse(tty: Int32, expected: String) -> String?
  {
    var result: Int32 = -1
    let values: [Character] = expected.characters.map{$0}
    guard let terminator = values.last else { return nil }
    var index = 0
    var reply = ""
    var ch = Character(" ")
    repeat
    {
      result = Ansi.Terminal.readValue(tty: tty)
      if result == Int32.max { return nil }
      ch = Character(UnicodeScalar(Int(result)))
      if index == 0 && ch != values[0]
      {
        return nil
      }
      reply += String(ch)
      index += 1
    } while ch != terminator
    return reply.characters.count == 0 ? nil : reply
  }
  
  /// Issue a command to TTY and await a response
  ///
  /// - parameters:
  ///   - command: Ansi.Terminal.Command
  /// - returns: String?
  internal static func responseTTY(command: Command) -> String?
  {
    // Save the current error number
    var savedError: Int32 = errno
    var result: Int32 = -1
    let tty = Ansi.Terminal.currentTTY()
    
    // Inappropriate TTY
    if tty == -1
    {
      errno = savedError
      return nil
    }
    
    // Save the current state
    guard var currentState = Ansi.Terminal.saveSettings(tty: tty)
      else { return nil }
    
    // Restore current state on completion
    defer {
      Ansi.Terminal.restoreSettings(tty: tty, settings: &currentState)
      errno = savedError
    }
    
    // Enable temporary state with non canonical input
    var temporaryState = currentState
    guard Ansi.Terminal.enableNonCanon(tty: tty, settings: &temporaryState) == true
      else { return nil }
    
    // Submit ansi request and flush standard out
    command.request.stdout()
    Ansi.flush()
  
    // Nominal delay, without which buffer overruns occur for consecutive requests.
    Thread.sleep(forTimeInterval: 0.02)
    
    // Retrieve response
    return Ansi.Terminal.readResponse(tty: tty, expected: command.response)
  }
}


public extension Ansi.Terminal
{
  internal static func readAll(fd: CInt) -> String
  {
    var buffer = [UInt8](repeating: 0, count: 1024)
    var usedBytes = 0
    while true
    {
      print("here")
      let readResult: ssize_t = buffer.withUnsafeMutableBufferPointer {
        value in
        guard let address = value.baseAddress else {
          print("12345")
          return ssize_t.max
        }
        let ptr = UnsafeMutablePointer<Void>(address + usedBytes)
      return read(fd, ptr, size_t(buffer.count - usedBytes))
      }
      
      if readResult > 0
      {
        usedBytes += readResult
//        print("readResult > 0", usedBytes, readResult)
        continue
      }
      
      if readResult == 0
      {
//        print("readResult == 0", usedBytes, readResult)
        break
      }
      print("precondition")
      preconditionFailure("read() failed")
    }
    
//    return (0..<usedBytes)
//      .map { String(UnicodeScalar(Int(buffer[$0]))) }
//      .joined(separator: "")
    
//    return String(cString: buffer[0..<usedBytes], encoding: .utf8)
    
    return String._fromCodeUnitSequenceWithRepair(
      UTF8.self, input: buffer[0..<usedBytes]).0
  }
}
