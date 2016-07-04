//
//          File:   TUIView+ProgressBar.swift
//    Created by:   African Swift

import Darwin


internal struct TUIProgressLine
{
  internal let prefix: String
  internal let midfix: String
  internal let suffix: String
  internal let complete: [String]
  internal let incomplete: String
  internal let width: Int
  
  /// Default initializer
  ///
  /// - parameters:
  ///   - prefix: String
  ///   - midfix: String
  ///   - suffix: String
  ///   - complete: [String]
  ///   - incomplete: String
  ///   - width: Int
  internal init(prefix: String, midfix: String, suffix: String,
                complete: [String], incomplete: String, width: Int)
  {
    self.prefix = prefix
    self.midfix = midfix
    self.suffix = suffix
    self.complete = complete
    self.incomplete = incomplete
    self.width = width
  }
}
