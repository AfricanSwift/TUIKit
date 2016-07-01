//
//          File:   TUIScreen.swift
//    Created by:   African Swift

import Darwin

public struct TUIScreen {
  /// TTY Window Origin
  public private(set) var origin: TUIPoint
  
  /// Initialized size
  public private(set) var size: TUIWindowSize
  public var invalidate: Bool
  
  /// TTY Window Size: IOCTL (TIOCGWINSZ)
  public static var size: TUIWindowSize {
    return TUIScreen.currentSize() ?? TUIWindowSize(columns: 0, rows: 0)
  }
  
//  private var views: [TUIView]
  private var buffer: [[TUICharacter]]
  
  /// Flat array of active buffer cell indexes
  internal var activeIndex: [(x: Int, y: Int, type: TUICharacter.Category)] {
    let rows = self.size.character.height.toInt()
    let columns = self.size.character.width.toInt()
    let screenArray = (0..<rows)
      .map { r in (0..<columns)
        .map { c in (x: c, y: r, type: self.buffer[r][c].type) } }
    return screenArray
      .flatMap { $0 }
      .filter { $0.type != .none }
  }
  
  /// Default initializer
  ///
  /// - parameters:
  ///   - x: Int
  ///   - y: Int
  ///   - width: Int
  ///   - height: Int
  ///   - border: TUIBorders
  public init(x: Int, y: Int, width: Int, height: Int, border: TUIBorders)
  {
    self.origin = TUIPoint(x: x, y: y)
    self.size = TUIWindowSize(width: width, height: height)
    self.invalidate = true
    self.buffer = init2D(
      d1: self.size.character.height.toInt(),
      d2: self.size.character.width.toInt(),
      repeatedValue: TUICharacter(
        character: " ",
        color: Ansi.Color(red: 0, green: 0, blue: 0, alpha: 0)))
  }
  
  private struct TTYSize  {
    private let rows: UInt16
    private let columns: UInt16
    private let width: UInt16
    private let height: UInt16
    
    func toTUIWindowSize() -> TUIWindowSize
    {
      return TUIWindowSize(columns: Int(self.columns), rows: Int(self.rows))
    }
  }
  
  /// Get Current Terminal Size
  ///
  /// - returns: TUIWindowSize?
  private static func currentSize() -> TUIWindowSize?
  {
    guard let ttySize = UnsafeMutablePointer<Int32>(malloc(sizeof(TTYSize)))
      else { return nil }
    defer { free(ttySize) }
    S_ioctl(0, S_TIOCGWINSZ, ttySize)
    return UnsafeMutablePointer<TTYSize>(ttySize)[0].toTUIWindowSize()
  }
}
