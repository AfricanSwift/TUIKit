//
//          File:   Ansi+Character.swift
//    Created by:   African Swift

import Darwin

// MARK: - Character: Insert, Delete, ... -
public extension Ansi
{
  /// Character
  public struct Character
  {
    /// Insert Character(s) (ICH)
    ///
    /// - parameters:
    ///   -  quantity: Insert quantity (default = 1) of blank characters at current position
    /// - returns: Ansi
    public static func insert(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)@")
    }
    
    /// Delete Character(s) (DCH)
    ///
    /// - parameters:
    ///   -  quantity: Delete quantity (default = 1) characters, current position to field end
    /// - returns: Ansi
    public static func delete(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)P")
    }
    
    /// Erase Character(s) (ECH)
    ///
    /// - parameters:
    ///   -  quantity: Erase quantity (default = 1) characters
    /// - returns: Ansi
    public static func erase(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)X")
    }
    
    /// Repeat the preceding graphic character (REP)
    ///
    /// - parameters:
    ///   -  quantity: Repeat previous displayable character a specified number of times (default = 1)
    /// - returns: Ansi
    public static func repeatLast(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)b")
    }
  }
}
