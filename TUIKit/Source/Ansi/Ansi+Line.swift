//
//          File:   Ansi+Line.swift
//    Created by:   African Swift

import Darwin

// MARK: -
// MARK: Next Line and Previous Line -
public extension Ansi
{
  /// Next and Previous Line
  public enum Line
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

// MARK: -
// MARK: Erase in Line (EL & DECSEL) -
public extension Ansi.Line
{
  /// Erase in Line (EL & DECSEL)
  /// Erase in Line (cursor does not move)
  public enum Erase
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

// MARK: -
// MARK: Scroll Up and Scroll Down -
public extension Ansi.Line
{
  /// Scroll
  public enum Scroll
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

public extension Ansi.Line
{
  /// Lines attributes are display features that affect a complete display line.
  /// The cursor selects the line affected by the attribute. The cursor stays in
  /// the same character position when the attribute changes, unless the attribute
  /// would move the cursor past the right margin. In that case, the cursor stops
  /// at the right margin. When you move lines on the screen by scrolling, the
  /// attribute moves with the line.
  public enum Attributes
  {
    /// Double Height Line (DECDHL)
    ///
    /// These sequences make the line with the cursor the top or bottom half
    /// of a double-height, double-width line. You must use these sequences
    /// in pairs on adjacent lines. The same character must be used on both
    /// lines to form a full character. If the line was previously single-width,
    /// single-height, all characters to the right of center are lost.
    public enum Height
    {
      /// Double Height Top Half (DECDHL)
      ///
      /// - returns: Ansi
      public static func topHalf() -> Ansi
      {
        return Ansi("\(Ansi.C0.ESC)#3")
      }
      
      /// Double Height Bottom Half (DECDHL)
      ///
      /// - returns: Ansi
      public static func bottomHalf() -> Ansi
      {
        return Ansi("\(Ansi.C0.ESC)#4")
      }
    }
      
    /// Line Width (DECSWL & DECDWL)
    ///
    /// The DECSWL sequence makes the line with the cursor single-width, 
    /// single-height. This is the line attribute for all new lines on the 
    /// screen. The DECDWL sequence makes the line with the cursor double-width, 
    /// single-height. If the line was previously single-width, single-height, 
    /// all characters to the right of center screen are lost.
    public enum Width
    {
      /// Single-Width Line (DECSWL)
      ///
      /// - returns: Ansi
      public static func single() -> Ansi
      {
        return Ansi("\(Ansi.C0.ESC)#5")
      }
      
      /// Double-Width Line (DECDWL)
      ///
      /// - returns: Ansi
      public static func double() -> Ansi
      {
        return Ansi("\(Ansi.C0.ESC)#6")
      }
    }
  }
}
