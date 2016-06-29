
//          File:   Custom+Extensions.swift
//    Created by:   African Swift

import Darwin
import Foundation

// MARK: - Threading -
infix operator ~> {}

/// Executes the lefthand closure on a background thread and,
/// upon completion, the righthand closure on the main thread.
/// Passes the background closure's output, if any, to the main closure.
/// - parameter backgroundClosure: code to execute on background thread
/// - parameter mainClosure: code to execute on main thread after background completes
/// - returns: Void
internal func ~> <R> (
  backgroundClosure: () -> R,
  mainClosure: (result: R) -> ())
{
  queue.async {
    let result = backgroundClosure()
    DispatchQueue.main.async(execute: {
      mainClosure(result: result)
    })
  }
}

/// Serial dispatch queue used by the ~> operator
/// - returns: dispatch_queue_t
private let queue = DispatchQueue(
  label: "serial-worker",
  attributes: DispatchQueueAttributes.serial)

// MARK: - Array Extensions -
internal extension Array {
  /// Return Array of type T with tuple of Array Index and Element
  /// - parameter function: map function to execute
  /// - returns: (Int, Element)
  internal func mapWithIndex<T>(_ function: (Int, Element) -> T) -> [T] {
    return zip((self.indices), self).map(function)
  }
}

/// Initialize 2D array
/// - parameter dimension1: 1st array dimension
/// - parameter dimension2: 2nd array dimension
/// - parameter repeatedValue: Initial array value
/// - returns: Two dimensional array of type T
internal func init2D<T>(
  dimension1: Int,
             dimension2: Int,
             repeatedValue value: T) -> [[T]] {
  return Array(repeating: Array(repeating: value,
                count: dimension2),
               count: dimension1)
}

/// Initialize 3D array
/// - parameter dimension1: 1st array dimension
/// - parameter dimension2: 2nd array dimension
/// - parameter dimension3: 3rd array dimension
/// - parameter repeatedValue: Initial array value
/// - returns: Three dimensional array of type T
internal func init3D<T>(
  dimension1: Int,
             dimension2: Int,
             dimension3: Int,
             repeatedValue value: T) -> [[[T]]] {
  return Array(repeating: Array(repeating: Array(repeating: value,
                  count: dimension3),
                count: dimension2),
               count: dimension1)
}

/// Initialize 4D array
/// - parameter dimension1: 1st array dimension
/// - parameter dimension2: 2nd array dimension
/// - parameter dimension3: 3rd array dimension
/// - parameter dimension4: 4th array dimension
/// - parameter repeatedValue: Initial array value
/// - returns: Fourth dimensional array of type T
internal func init4D<T>(
  dimension1: Int,
             dimension2: Int,
             dimension3: Int,
             dimension4: Int,
             repeatedValue value: T) -> [[[[T]]]] {
  return Array(repeating: Array(repeating: Array(repeating: Array(repeating: value,
                    count: dimension4),
                  count: dimension3),
                count: dimension2),
               count: dimension1)
}

// MARK: - Character Extensions -
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


// MARK: - String Extensions -
internal extension String {
  /// Convert to Ansi
  /// - returns: Ansi
  internal func toAnsi() -> Ansi
  {
    return Ansi(String(self))
  }
  
  /// Checks whether a String is Numeric
  /// - returns: Bool
  internal func isNumeric() -> Bool {
    return Int(self) != nil
  }
  
  /// Extract and return filename
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
  /// - parameter with: Range<Int> to use for extraction
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
  /// - parameter atIndex: Int to use for extraction
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
  
//  /// Trim spaces at the end of a String
//  /// - returns: String without spaces at the end.
//  internal func trimEnd() -> String
//  {
//    var lastWhitespaceIndex = -1
//    for (index, value) in self.characters.enumerated().reversed()
//    {
//      guard value == " " else { break }
//      lastWhitespaceIndex = index
//    }
//    
//    if lastWhitespaceIndex < 0
//    {
//      return self
//    }
//    return self[self.startIndex..<self.characters.index(self.startIndex, offsetBy: lastWhitespaceIndex)]
//  }
//  
//  /// String subscripting
//  /// - parameter range: Range to use for extraction
//  /// - returns: String extracted from range
//  internal subscript (range: Range<Int>) -> String?
//  {
//    let start = self.characters.index(self.startIndex, offsetBy: range.lowerBound)
//    let end = self.characters.index(self.startIndex, offsetBy: range.upperBound)
//    return substring(with: start ..< end)
//  }
//  
//  ///  Character subscripting
//  ///  - parameter index: Index to use for extraction
//  ///  - returns: String extracted at index
//  internal subscript (index: Int) -> String?
//  {
//    return String(self.characters.map{ $0 }[index])
//  }
//  
//  /// Replace specified strings
//  /// - parameter pattern:     Regular expression pattern
//  /// - parameter replacement: Replacement value
//  /// - parameter fromIndex:   Optional starting index for the search
//  /// - returns: Updated String with replacement values
//  internal func replace(
//    pattern: String,
//            replacement: String,
//            fromIndex: Int = 0) -> String?
//  {
//    guard let regex = try? RegularExpression(pattern: pattern, options: [.caseInsensitive])
//      else
//    {
//      print("\(pattern) -- exit")
//      return nil
//    }
//    
//    let range = NSRange(location: fromIndex, length: self.characters.count - fromIndex)
//    return regex.stringByReplacingMatches(
//      in: self,
//      options: [.withTransparentBounds],
//      range: range,
//      withTemplate: replacement)
//  }
//  
//  /// Search for match(es) against a regular expression
//  /// - parameter regex: Regular expression pattern
//  /// - returns: String array containing the matching values, or empty array (no match)
//  internal func matchesForRegex(_ regex: String) -> [String]
//  {
//    do
//    {
//      let regex = try RegularExpression(pattern: regex, options: [])
//      let stringValue = self as NSString
//      let range = NSRange(location: 0, length: stringValue.length)
//      
//      let results = regex.matches(
//        in: self,
//        options: [],
//        range: range)
//      return results.map { stringValue.substring(with: $0.range) }
//    }
//    catch let error as NSError
//    {
//      print("Regular Expression Error: \(error.localizedDescription)")
//      return []
//    }
//  }
}

// MARK: - Double Extensions -
internal extension Double {
  /// Convert Double to Int
  /// - returns: Int
  internal func toInt() -> Int
  {
    return Int(self)
  }
  
  internal func toUInt() -> UInt
  {
    return UInt(self)
  }
  
  internal func toUInt32() -> UInt32
  {
    return UInt32(self)
  }
}

// MARK: - Int Extensions -
internal extension Int {
  /// Convert Int to Double
  /// - returns: Double
  internal func toDouble() -> Double {
    return Double(self)
  }
}

// MARK: - UInt32 Extensions -
internal extension UInt32 {
  /// Convert UInt32 to Int
  ///
  /// - returns: Int
  internal func toInt() -> Int {
    return Int(self)
  }
  
  /// Convert UInt32 to Int
  ///
  /// - returns: Int
  internal func toDouble() -> Double {
    return Double(self)
  }
}

// MARK: - Code / Execution Timing -

/// Measure closure exection
/// - parameter title: String
/// - parameter closure: closure to measure execution duration
internal func measure(_ title: String = "", closure: () -> Void)
{
  let start = Date().timeIntervalSince1970
  closure()
  
  let result = String(format: "%.5f ms", title,
                      (Date().timeIntervalSince1970 - start) * 1000)
  print("\(title) duration: \(result)")
}

// MARK: - Loops -

/// Replacement for C Style For Loop for ;;
///
///     var i: Int = 0 // initialization
///     for i in Loop(i < 10, i += 1)
///     {
///       print(i)
///     }
/// - Authors: Joe Groff (Apple)
internal struct Loop: Sequence, IteratorProtocol
{
  let condition: () -> Bool
  let increment: () -> Void
  var started = false
  
  internal init(
    _ condition: @autoclosure(escaping)() -> Bool,
    _ increment: @autoclosure(escaping)() -> Void)
  {
    self.increment = increment
    self.condition = condition
  }
  
  internal func makeIterator() -> Loop
  {
    return self
  }
  
  internal mutating func next() -> Void?
  {
    if started
    {
      increment()
    }
    else
    {
      started = true
    }
    
    if condition()
    {
      return ()
    }
    return nil
  }
}

//// MARK: - guard / if let unwrapping debugging -
//
//infix operator =∅ {}
///// Nil Evaluate Operator
///// Useful to isolate a failure with multiple unwraps in guard by adding =∅ (#file, #line)
///// - parameter lhs: left hand side of operator
///// - parameter reference: tuple containing current file and line number
///// - returns: original unaltered lhs of type T
//internal func =∅<T> (lhs: T?, reference: (file: String, line: Int)) -> T? {
//  #if !debug
//    var unwrap = false
//    if let _ = lhs { unwrap = true }
//    let source = reference.file
//      .characters
//      .split("/")
//      .map{String($0)}
//      .last ?? ""
//    let outcome = "unwrap(\(unwrap ? "success" : "failure"))"
//    let status = "\(source)(\(reference.line)), \(outcome), value: \(lhs)"
//    print(status)
//  #endif
//  return lhs
//}
