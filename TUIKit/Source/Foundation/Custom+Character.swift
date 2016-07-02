//
//          File:   Custom+Character.swift
//    Created by:   African Swift

import Darwin

// MARK: -
// MARK: Character Extensions -
internal extension Character
{
  /// Convert Character to Scalar Value
  ///
  /// - returns: String.UnicodeScalarView
  internal func unicodeScalars() -> String.UnicodeScalarView
  {
    return String(self).unicodeScalars
  }
  
  /// Convert to Ansi
  ///
  /// - returns: Ansi
  internal func toAnsi() -> Ansi
  {
    return Ansi(String(self))
  }
  
  /// Character to String
  ///
  /// - returns: String
  internal func toString() -> String
  {
    return String(self)
  }
}
