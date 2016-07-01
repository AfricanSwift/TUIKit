//
//          File:   Ansi+Line.swift
//    Created by:   African Swift

import Darwin

// MARK: - Next Line and Previous Line -
public extension Ansi
{
  /// Next and Previous Line
  public struct Line
  {
    /// Cursor Next Line (CNL)
    ///
    /// - parameters:
    ///   - quantity: Move to first position of quantity lines down (default = 1)
    /// - returns: Ansi
    public static func next(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)E")
    }
    
    /// Cursor Preceding Line (CPL)
    ///
    /// - parameters:
    ///   - quantity: Move to first position of quantity lines up (default = 1)
    /// - returns: Ansi
    public static func previous(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)F")
    }
    
    /// Insert Line(s) (IL)
    ///
    /// - parameters:
    ///   - quantity:  Insert quantity (default = 1) of lines
    /// - returns: Ansi
    public static func insert(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)L")
    }
    
    /// Delete Line(s) (DL)
    ///
    /// - parameters:
    ///   - quantity:  Delete quantity (default = 1) lines,
    /// - returns: Ansi
    public static func delete(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)M")
    }
  }
}

// MARK: - Erase in Line (EL & DECSEL) -
public extension Ansi.Line
{
  /// Erase in Line (EL & DECSEL)
  /// Erase in Line (cursor does not move)
  public struct Erase
  {
    
    /// Erase to Right.
    ///
    /// - returns: Ansi
    public static func right() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)0K")
    }
    
    /// Erase to Left.
    ///
    /// - returns: Ansi
    public static func left() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)1K")
    }
    
    /// Erase All.
    ///
    /// - returns: Ansi
    public static func all() -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)2K")
    }
  }
}

// MARK: - Scroll Up and Scroll Down -
public extension Ansi.Line
{
  /// Scroll
  public struct Scroll
  {
    /// Scroll up lines (SU)
    ///
    /// - parameters:
    ///   - quantity: Scroll quantity (default = 1) lines up,
    /// - returns: Ansi
    public static func up(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)S")
    }
    
    /// Scroll down lines (SD)
    ///
    /// - parameters:
    ///   - quantity: Scroll quantity (default = 1) lines down,
    /// - returns: Ansi
    public static func down(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)T")
    }
    
    /// Set Scrolling Region (DECSTBM)
    ///
    /// - parameters:
    ///   - top: Int (default = full size of window)
    ///   - bottom: Int
    /// - returns: Ansi
    public static func setRegion(top: Int = 0, bottom: Int = 0) -> Ansi
    {
      return top == 0 || bottom == 0 ?
        Ansi("\(Ansi.C1.CSI)r") :
        Ansi("\(Ansi.C1.CSI)\(top);\(bottom)r")
    }
  }
}
