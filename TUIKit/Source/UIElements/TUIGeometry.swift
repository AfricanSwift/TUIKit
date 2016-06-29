
//          File:   TUIGeometry.swift
//    Created by:   African Swift

import Darwin

// MARK: - TUIPoint -

/// Terminal UI Point
///
/// - x: horizontal offset
/// - y: vertical offset
public struct TUIPoint
{
  public private(set) var x: Double
  public private(set) var y: Double
  
  /// Default TUIPoint Initializer
  ///
  /// - parameter x: Int
  /// - parameter y: Int
  public init(x: Int = 0, y: Int = 0)
  {
    self.x = Double(x)
    self.y = Double(y)
  }
  
  /// Default TUIPoint Initializer
  ///
  /// - parameter x: Double
  /// - parameter y: Double
  public init(x: Double, y: Double)
  {
    self.x = x
    self.y = y
  }
}

// MARK: - TUIPoint Equatable -
extension TUIPoint: Equatable {}

/// Equatable Operator for TUIPoint
///
/// - parameter lhs: TUIPoint
/// - parameter rhs: TUIPoint
/// - returns: Bool, True if lhs and rhs are equivalent
public func == (lhs: TUIPoint, rhs: TUIPoint) -> Bool
{
  return lhs.x == rhs.x && lhs.y == rhs.y
}

// MARK: - TUISize -

/// Terminal UI Size
///
/// - width: horizontal size
/// - size: vertical size
public struct TUISize
{
  public private(set) var width: Double
  public private(set) var height: Double
  
  /// Default Initializer
  ///
  /// - parameter width: Int
  /// - parameter height: Int
  public init(width: Int = 0, height: Int = 0)
  {
    self.width = Double(width)
    self.height = Double(height)
  }
  
  /// Default Initializer
  ///
  /// - parameter width: Double
  /// - parameter height: Double
  public init(width: Double, height: Double)
  {
    self.width = width
    self.height = height
  }
}

// MARK: - TUISize Equatable -

/// TUISize equatable
extension TUISize: Equatable {}

/// Equatable Operator for TUISize
///
/// - parameter lhs: TUISize
/// - parameter rhs: TUISize
/// - returns: Bool, True if lhs and rhs are equivalent
public func == (lhs: TUISize, rhs: TUISize) -> Bool
{
  return lhs.height == rhs.height && lhs.width == rhs.width
}

// MARK: TUIViewSize -

/// Terminal UI Viewsize with two size accessors: pixel vs. character
///
/// - pixel is based on the braille symbols
/// - 2 x 4 pixels per character (width x height)
public struct TUIViewSize
{
  public var pixel: TUISize
  public var character: TUISize
}

// MARK: - TUIRectangle -

/// Terminal UI Rectangle
//
/// - origin (TUIPoint): left / top origin
/// - size (TUISize): width / height
public struct TUIRectangle
{
  public private(set) var origin = TUIPoint()
  public private(set) var size = TUISize()
  
  /// Default Initializer
  ///
  /// - parameter x: Int
  /// - parameter y: Int
  /// - parameter width: Int
  /// - parameter height: Int
  public init(x: Int = 0, y: Int = 0, width: Int = 0, height: Int = 0)
  {
    self.origin = TUIPoint(x: x, y: y)
    self.size = TUISize(width: width, height: height)
  }
  
  /// Default Initializer
  ///
  /// - parameter x: Double
  /// - parameter y: Double
  /// - parameter width: Double
  /// - parameter height: Double
  public init(x: Double = 0.0, y: Double = 0.0, width: Double = 0.0, height: Double = 0.0)
  {
    self.origin = TUIPoint(x: x, y: y)
    self.size = TUISize(width: width, height: height)
  }
  
  /// Default Initializer
  ///
  /// - parameter origin: TUIPoint
  /// - parameter size: TUISize
  public init(origin: TUIPoint, size: TUISize)
  {
    self.origin = origin
    self.size = size
  }
}

//MARK: TUIRectangle Equatable -
extension TUIRectangle: Equatable {}

/// Equatable Operator for TUIRectangle
///
/// - parameter lhs: TUIRectangle
/// - parameter rhs: TUIRectangle
/// - returns: Bool, True if lhs and rhs are equivalent
public func == (lhs: TUIRectangle, rhs: TUIRectangle) -> Bool
{
  return lhs.origin == rhs.origin && lhs.size == rhs.size
}
