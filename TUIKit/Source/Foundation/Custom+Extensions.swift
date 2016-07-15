//
//          File:   Custom+Extensions.swift
//    Created by:   African Swift

import Foundation

// MARK: -
// MARK: Threading -

infix operator ~> {}

/// Executes the lefthand closure on a background thread and,
/// upon completion, the righthand closure on the main thread.
/// Passes the background closure's output, if any, to the main closure.
///
/// - parameters:
///   - backgroundClosure: code to execute on background thread
///   - mainClosure: code to execute on main thread after background completes
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
///
/// - returns: dispatch_queue_t
private let queue = DispatchQueue(
  label: "serial-worker",
  attributes: DispatchQueueAttributes.serial)

// MARK: -
// MARK: Array Extensions -
internal extension Array {
  /// Return Array of type T with tuple of Array Index and Element
  ///
  /// - parameters:
  ///   - function: map function to execute
  /// - returns: (Int, Element)
  internal func mapWithIndex<T>(_ function: (Int, Element) -> T) -> [T] {
    return zip((self.indices), self).map(function)
  }
}

/// Initialize 2D array
///
/// - parameters:
///   - d1: 1st array dimension
///   - d2: 2nd array dimension
///   - repeatedValue: Initial array value
/// - returns: Two dimensional array of type T
internal func init2D<T>(d1: Int, d2: Int, repeatedValue value: T) -> [[T]]
{
  return Array(
    repeating: Array(
      repeating: value, count: d2), count: d1)
}

/// Initialize 3D array
///
/// - parameters:
///   - d1: 1st array dimension
///   - d2: 2nd array dimension
///   - d3: 3rd array dimension
///   - repeatedValue: Initial array value
/// - returns: Three dimensional array of type T
internal func init3D<T>(d1: Int, d2: Int, d3: Int, repeatedValue value: T) -> [[[T]]]
{
  return Array(
    repeating: Array(
      repeating: Array(
        repeating: value, count: d3), count: d2), count: d1)
}

/// Initialize 4D array
///
/// - parameters:
///   - d1: 1st array dimension
///   - d2: 2nd array dimension
///   - d3: 3rd array dimension
///   - d4: 4th array dimension
///   - repeatedValue: Initial array value
/// - returns: Fourth dimensional array of type T
internal func init4D<T>(d1: Int, d2: Int, d3: Int, d4: Int, repeatedValue value: T) -> [[[[T]]]]
{
  return Array(
    repeating: Array(
      repeating: Array(
        repeating: Array(
          repeating: value, count: d4), count: d3), count: d2), count: d1)
}

// MARK: -
// MARK: Code / Execution Timing -

/// Measure closure exection
///
/// - parameters:
///   - title: String
///   - closure: closure to measure execution duration
internal func measure(_ title: String = "", closure: () -> Void)
{
  let start = Date().timeIntervalSince1970
  closure()
  
  let result = String(format: "%.5f ms", title,
                      (Date().timeIntervalSince1970 - start) * 1000)
  print("\(title) duration: \(result)")
}

// MARK: -
// MARK: C-Style Loop -

/// Replacement for C Style For Loop for ;;
///
/// ````
/// var i: Int = 0 // initialization
/// for _ in CStyleLoop(i < 10, i += 1)
/// {
///   print(i)
/// }
/// ````
/// - Author: Joe Groff (Apple)
internal struct CStyleLoop: Sequence, IteratorProtocol
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
  
  internal func makeIterator() -> CStyleLoop
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
