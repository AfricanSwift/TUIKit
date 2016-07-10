//
//          File:   Custom+String.swift
//    Created by:   African Swift

import Foundation

// MARK: -
// MARK: String Extensions -
internal extension String {
  /// Convert to Ansi
  ///
  /// - returns: Ansi
  internal func toAnsi() -> Ansi
  {
    return Ansi(String(self))
  }
  
  /// Checks whether a String is Numeric
  ///
  /// - returns: Bool
  internal func isNumeric() -> Bool {
    return Int(self) != nil
  }
  
  /// Extract and return filename
  ///
  /// - returns: String
  internal var lastPathComponent: String {
    get {
      return (self as NSString).lastPathComponent
    }
  }
  
  /// Strips whitespace and newline characters
  ///
  /// - returns: String
  internal func trim() -> String {
    return self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  /// String subscripting
  ///
  /// - parameters:
  ///   - with: Range<Int> to use for extraction
  /// - returns: String extracted from range
  internal func substring(with range: Range<Int>) -> String?
  {
    guard let start = self.index(
      self.startIndex, offsetBy: range.lowerBound, limitedBy: self.endIndex),
      let end = self.index(
        self.startIndex, offsetBy: range.upperBound, limitedBy: self.endIndex)
      else {
        return nil
    }
    return self.substring(with: start..<end)
  }
  
  /// String subscripting
  ///
  /// - parameters:
  ///   - atIndex: Int to use for extraction
  /// - returns: Character?
  internal func substring(atIndex index: Int) -> Character?
  {
    guard let start = self.index(
      self.startIndex, offsetBy: index, limitedBy: self.endIndex),
      let end = self.index(
        self.startIndex, offsetBy: index + 1, limitedBy: self.endIndex)
      else { return nil }
    return Character(self.substring(with: start..<end))
  }
  
  /// Returns the longest possible subsequences of the sequence, in order,
  /// that don’t contain elements satisfying the given predicate.
  /// Elements that are used to split the sequence are not returned as part of any subsequence.
  ///
  /// - parameters:
  ///   - isSeparator: A closure that takes an element as an argument and
  ///     returns a Boolean value indicating whether the sequence should be
  ///     split at that element.
  /// - returns: An array of subsequences, split from this sequence's elements.
  internal func split(isSeparator: @noescape (UnicodeScalar) throws -> Bool)
    rethrows -> [String.UnicodeScalarView]
  {
    return try self.unicodeScalars.split(isSeparator: isSeparator)
  }
  
  /// Creates a string representing the given String repeated the specified
  /// number of times. For example, use this initializer to create a string with
  /// ten `"ab"` Strings in a row.
  /// ````
  /// let zeroes = String(repeating: "ab", count: 10)
  /// print(zeroes)  // prints "abababababababababab"
  /// ````
  /// - Parameters:
  ///   - repeating: String 
  ///   - count: Int
  internal init(repeating repeatedValue: String, count: Int)
  {
    self = (0..<count).map { _ in repeatedValue }.joined(separator: "")
  }
}
