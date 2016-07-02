//
//          File:   Ansi+Cursor.swift
//    Created by:   African Swift

import Darwin

// MARK: -
// MARK: Primary Cursor Movements -
public extension Ansi
{
  public struct Cursor
  {
    /// Cursor Up (CUU)
    ///
    /// - parameters:
    ///   - quantity: Move up quantity of lines (default = 1)
    /// - returns: Ansi
    public static func up(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)A")
    }
    
    /// Cursor Down (CUD)
    ///
    /// - parameters:
    ///   - quantity: Move down quantity lines (default = 1).
    /// - returns: Ansi
    public static func down(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)B")
    }
    
    /// Cursor Forward (CUF)
    ///
    /// - parameters:
    ///   - quantity: Move forward quantity (default = 1) of characters,
    /// - returns: Ansi
    public static func forward(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)C")
    }
    
    /// Cursor Backward (CUB)
    ///
    /// - parameters:
    ///   - quantity: Move backward quantity (default = 1) of characters,
    /// - returns: Ansi
    public static func backward(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)D")
    }
    
    /// Cursor Character Absolute (CHA)
    ///
    /// - parameters:
    ///   - column: Move to column (default = 1)
    /// - returns: Ansi
    public static func column(column: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(column)G")
    }
    
    /// Cursor Position [row;column] (CUP)
    ///
    /// - parameters:
    ///   - row: Move to row (default = 1)
    ///   - column: Move to column (default = 1)
    /// - returns: Ansi
    public static func position(row: Int = 1, column: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(row);\(column)H")
    }
    
    /// Horizontal and Vertical Position (HVP)
    ///
    /// - parameters:
    ///   - row: Move to row (default = 1)
    ///   - column: Move to column (default = 1)
    /// - returns: Ansi
    public static func horizontalVerticalPosition(
      row: Int = 1,
          column: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(row);\(column)f")
    }
    
    /// Restore cursor (ANSI.SYS)
    ///
    /// - returns: Ansi
    public static let Restore = Ansi("\(Ansi.C1.CSI)u")
    
    /// Save cursor (ANSI.SYS), available only when DECLRMM is disabled
    ///
    /// - returns: Ansi
    public static let Save = Ansi("\(Ansi.C1.CSI)s")
  }
}

// MARK: -
// MARK: Ansi.Cursor,Choices -
public extension Ansi.Cursor
{
  public enum Choices
  {
    case up(Int), down(Int), forward(Int), backward(Int)
    case position(Int, Int), column(Int), row(Int)
    
    /// String to Ansi Cursor
    ///
    /// - parameters:
    ///   - cursor: Ansi.Cursor.Type
    /// - returns: Ansi
    private func toAnsi(cursor: Ansi.Cursor.Type) -> Ansi
    {
      /// Switch over common Ansi cursor movements
      ///
      /// - returns: Ansi
      func matchCommonCursors() -> Ansi
      {
        switch self
        {
        case .up(let quantity):
          return cursor.up(quantity: quantity)
        case .down(let quantity):
          return cursor.down(quantity: quantity)
        case .forward(let quantity):
          return cursor.forward(quantity: quantity)
        case .backward(let quantity):
          return cursor.backward(quantity: quantity)
        case .position(let row, let column):
          return cursor.position(row: row, column: column)
        case .column(let column):
          return cursor.Column.absolute(column: column)
        case .row(let row):
          return cursor.Row.absolute(row: row)
        }
      }
      
      return matchCommonCursors()
    }
  }
}

// MARK: -
// MARK: String Ansi.Cursor.Choices -
public extension String
{
  /// Ansi Cursor
  ///
  /// - returns: String (with prepended Ansi Cursor)
  public var cursor: ((Ansi.Cursor.Choices) -> String)
  {
    return { choice in
      Ansi.Cursor.Choices.toAnsi(choice)(
        cursor: Ansi.Cursor.self).toString() + self
    }
  }
}

// MARK: -
// MARK: Column: Absolute, Relative -
public extension Ansi.Cursor
{
  /// Column: Absolute, Relative
  public struct Column
  {
    /// Horizontal Position Absolute (HPA)
    ///
    /// - parameters:
    ///   - column: Move to absolute column (default = 1)
    /// - returns: Ansi
    public static func absolute(column: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(column)`")
    }
    
    /// Horizontal Position Relative (HPR)
    ///
    /// - parameters:
    ///   - quantity: Move to relative column (default = current column + 1)
    /// - returns: Ansi
    public static func relative(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)a")
    }
  }
}

// MARK: -
// MARK: Row: Absolute, Relative -
public extension Ansi.Cursor
{
  public struct Row
  {
    /// Line Position Absolute (VPA)
    ///
    /// - parameters:
    ///   - row: Move to absolute row (default = 1)
    /// - returns: Ansi
    public static func absolute(row: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(row)d")
    }
    
    /// Line Position Relative (VPR)
    ///
    /// - parameters:
    ///   - quantity: Move to relative row (default = current row + 1)
    /// - returns: Ansi
    public static func relative(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)e")
    }
  }
}

// MARK: -
// MARK: Set cursor style (DECSCUSR, VT520) -
public extension Ansi.Cursor
{
  /// Set cursor style (DECSCUSR, VT520).
  public struct Style
  {
    /// Blinking block
    ///
    /// - returns: Ansi
    public static func blinkingBlock() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)1\(Ansi.C0.SP)q")
    }
    
    /// Steady block
    ///
    /// - returns: Ansi
    public static func steadyBlock() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)2\(Ansi.C0.SP)q")
    }
    
    /// Blinking underline
    ///
    /// - returns: Ansi
    public static func blinkingUnderline() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)3\(Ansi.C0.SP)q")
    }
    
    /// Steady underline
    ///
    /// - returns: Ansi
    public static func steadyUnderline() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)4\(Ansi.C0.SP)q")
    }
    
    /// Blinking bar (xterm)
    ///
    /// - returns: Ansi
    public static func blinkingBar() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)5\(Ansi.C0.SP)q")
    }
    
    /// Steady bar (xterm)
    ///
    /// - returns: Ansi
    public static func steadyBar() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)6\(Ansi.C0.SP)q")
    }
  }
}

// MARK: -
// MARK: Set cursor style (DECSCUSR, VT520) -
public extension Ansi.Cursor
{
  public struct Report
  {
    
    private static let statusCommand = Ansi.Terminal.Command(
      request: Ansi("\(Ansi.C1.CSI)5n"),
      response: "\u{1B}[#n")
    
    /// Report Device Status Report (DSR)
    /// Ps = 5  -> Status Report.
    /// Result ("OK") is CSI 0 n
    ///
    /// - returns: Int?
    public static func status() -> Int?
    {
      guard let response = Ansi.Terminal.responseTTY(command: statusCommand)
        else { return nil }
      let values = response
        .replacingOccurrences(of: Ansi.C1.CSI, with: "")
        .replacingOccurrences(of: "n", with: "")
      return Int(values) ?? -1
    }
    
    
    
    /// Report Device Status Report (DSR)
    /// Ps = 5  -> Status Report.
    /// Result ("OK") is CSI 0 n
    ///
    /// - returns: Ansi
//    public static func status() -> Ansi
//    {
//      return Ansi("\(Ansi.C1.CSI)5n")
//    }
    
    /// Report Cursor Position (CPR) [row;column].
    /// Result is CSI r ; c R
    ///
    /// - returns: Ansi
    public static func position() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)6n")
    }  }
}
