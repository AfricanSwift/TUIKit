
//          File:   Ansi+Display.swift
//    Created by:   African Swift

import Darwin

// MARK: - Erase Display -
public extension Ansi
{
  /// Display
  public struct Display
  {
    /// __Erase in Display (ED & DECSED).__
    /// Erase in display (cursor does not move)
    public struct Erase
    {
      private static let erase =
      {
        (function: Int) -> Ansi in
        return Ansi("\(Ansi.C1.CSI)\(function)J")
      }
      
      /// Erase Below
      ///
      /// - returns: Ansi
      public static func below() -> Ansi
      {
        return Ansi("\(Ansi.C1.CSI)0J")
      }
      
      /// Erase Above
      ///
      /// - returns: Ansi
      public static func above() -> Ansi
      {
        return Ansi("\(Ansi.C1.CSI)1J")
      }
      
      /// Erase All
      ///
      /// - returns: Ansi
      public static func all() -> Ansi
      {
        return Ansi("\(Ansi.C1.CSI)2J")
      }
      
      /// Erase Saved Lines (i.e. scroll back buffer)
      ///
      /// - returns: Ansi
      public static func saveLines() -> Ansi
      {
        return Ansi("\(Ansi.C1.CSI)3J")
      }
    }
  }
}
