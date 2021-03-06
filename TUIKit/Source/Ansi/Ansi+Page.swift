//
//          File:   Ansi+Page.swift
//    Created by:   African Swift

import Foundation

// MARK: -
// MARK: Next Page and Previous Page -
public extension Ansi
{
  /// Next and Previous Page
  public enum Page
  {
    /// Scroll To Previous Page (PP)
    ///
    /// - parameters:
    ///   - quantity: Scroll quantity (default = 1) pages previous
    /// - returns: Ansi
    public static func previous(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)V")
    }
    
    /// Scroll To Next Page (NP)
    ///
    /// - parameters:
    ///   - quantity: Scroll quantity (default = 1) pages next
    /// - returns: Ansi
    public static func next(quantity: Int = 1) -> Ansi
    {
      return Ansi("\(Ansi.C1.CSI)\(quantity)U")
    }
  }
}
