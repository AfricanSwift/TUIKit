//
//          File:   Ansi+Terminal.swift
//    Created by:   African Swift

import Darwin
import Foundation

// MARK: -
// MARK: Command, fileDescriptor, currentTTY -
public extension Ansi
{
  public struct Terminal
  {
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
    private static func currentTTY() -> Int32
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

// MARK: -
// MARK: readValue -
public extension Ansi.Terminal
{
  /// Read value from TTY
  ///
  /// - parameters:
  ///   - tty: Int32
  /// - returns: Int32
  private static func readValue(tty: Int32) -> Int32
  {
    // Maximum time (ms) to allow read to block
    let maximumBlockDuration = 0.6
    
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
  private static func saveSettings(tty: Int32) -> termios?
  {
    var result: Int32
    var settings = termios.init()
    repeat
    {
      result = tcgetattr(tty, &settings)
    } while result == -1 && errno == EINTR
    return result == -1 ? nil : settings
  }
  
  /// Enabled Non Canonical Input (Disable ICANON, ECHO & CREAD)
  ///
  /// - parameters:
  ///   - tty: Int32
  ///   - settings: inout termios
  /// - returns: Bool
  private static func enableNonCanon(tty: Int32, settings: inout termios) -> Bool
  {
    settings.c_lflag &= ~UInt(ICANON)
    settings.c_lflag &= ~UInt(ECHO)
    settings.c_cflag &= ~UInt(CREAD)
    
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
  private static func restoreSettings(tty: Int32, settings: inout termios)
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
    
    // Retrieve response
    return Ansi.Terminal.readResponse(tty: tty, expected: command.response)
  }
}
