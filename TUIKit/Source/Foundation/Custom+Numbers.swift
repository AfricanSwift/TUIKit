//
//          File:   Custom+Numbers.swift
//    Created by:   African Swift

import Darwin

// MARK: - Double Extensions -
internal extension Double {
  /// Convert Double to Int
  ///
  /// - returns: Int
  internal func toInt() -> Int
  {
    return Int(self)
  }
  
  /// Convert Double to UInt
  ///
  /// - returns: UInt
  internal func toUInt() -> UInt
  {
    return UInt(self)
  }
  
  /// Convert Double to UInt32
  ///
  /// - returns: UInt32
  internal func toUInt32() -> UInt32
  {
    return UInt32(self)
  }
}

// MARK: - Int Extensions -
internal extension Int {
  /// Convert Int to Double
  ///
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
  
  /// Convert UInt32 to Double
  ///
  /// - returns: Double
  internal func toDouble() -> Double {
    return Double(self)
  }
}
