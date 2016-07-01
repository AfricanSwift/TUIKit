//
//          File:   Ansi+Tab.swift
//    Created by:   African Swift

import Darwin

// MARK: - Forward Tab and Back Tab -
public extension Ansi
{
  /// Tab
  public struct Tab
  {
    /// Cursor Forward Tabulation (CHT)
    ///
    /// - parameters:
    ///   - quantity: Tab quantity forward (default = 1)
    /// - returns: Ansi
    public static func forward(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)I")
    }
    
    /// Cursor Backward Tabulation (CBT)
    ///
    /// - parameters:
    ///   - quantity:  Tab quantity backwards (default = 1)
    /// - returns: Ansi
    public static func backward(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)Z")
    }
    
    public struct Clear
    {
      /// Tab Clear Current Column (TBC)
      ///
      /// Clears tab in current column
      /// - returns: Ansi
      public static func currentColumn() -> Ansi
      {
        return Ansi("\(Ansi.C1.CSI)0g")
      }
      
      /// Tab Clear All (TBC)
      ///
      /// Clears all tabs
      /// - returns: Ansi
      public static func all() -> Ansi
      {
        return Ansi("\(Ansi.C1.CSI)3g")
      }
    }
  }
}
