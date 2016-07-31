//
//          File:   TUIGeometry.swift
//    Created by:   African Swift

import Darwin

// MARK: TUIPoint -

/// Terminal UI Point
///
/// - x: horizontal offset
/// - y: vertical offset
public struct TUIPoint
{
  public var x: Double
  public var y: Double
  
  /// Default TUIPoint Initializer
  ///
  /// - parameters:
  ///   - x: Int
  ///   - y: Int
  public init(x: Int = 0, y: Int = 0)
  {
    self.x = Double(x)
    self.y = Double(y)
  }
  
  /// Default TUIPoint Initializer
  ///
  /// - parameters:
  ///   - x: Double
  ///   - y: Double
  public init(x: Double, y: Double)
  {
    self.x = x
    self.y = y
  }
}

// MARK: -
// MARK: TUIPoint Equatable -
extension TUIPoint: Equatable {}

/// Equatable Operator for TUIPoint
///
/// - parameters:
///   - lhs: TUIPoint
///   - rhs: TUIPoint
/// - returns: Bool, True if lhs and rhs are equivalent
public func == (lhs: TUIPoint, rhs: TUIPoint) -> Bool
{
  return lhs.x == rhs.x && lhs.y == rhs.y
}

// MARK: -
// MARK: TUISize -

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
  /// - parameters:
  ///   - width: Int
  ///   - height: Int
  public init(width: Int = 0, height: Int = 0)
  {
    self.width = Double(width)
    self.height = Double(height)
  }
  
  /// Default Initializer
  ///
  /// - parameters:
  ///   - width: Double
  ///   - height: Double
  public init(width: Double, height: Double)
  {
    self.width = width
    self.height = height
  }
}

// MARK: -
// MARK: TUISize Equatable -

/// TUISize equatable
extension TUISize: Equatable {}

/// Equatable Operator for TUISize
///
/// - parameters:
///   = lhs: TUISize
///   - rhs: TUISize
/// - returns: Bool, True if lhs and rhs are equivalent
public func == (lhs: TUISize, rhs: TUISize) -> Bool
{
  return lhs.height == rhs.height && lhs.width == rhs.width
}

// MARL: -
// MARK: TUIViewSize -

/// Terminal UI Viewsize with two size accessors: pixel vs. character
///
/// - pixel is based on the braille symbols
/// - 2 x 4 pixels per character (width x height)
public struct TUIWindowSize
{
  public var pixel: TUISize
  public var character: TUISize
  
  /// Default initializer
  ///
  /// - parameters:
  ///   - width: Int (pixel width)
  ///   - height: Int (pixel height)
  public init(width: Int, height: Int)
  {
    let w = Int(ceil(Double(width) / 2.0))
    let h = Int(ceil(Double(height) / 4.0))
    self.pixel = TUISize(width: w * 2, height: h * 4)
    self.character = TUISize(width: w, height: h)
  }
  
  /// Default initializer
  ///
  /// - parameters:
  ///   - width: Double (pixel width)
  ///   - height: Double (pixel height)
  public init(width: Double, height: Double)
  {
    self.init(width: Int(width), height: Int(height))
  }
  
  /// Default initializer
  ///
  /// - parameters:
  ///   - columns: Int (character width)
  ///   - rows: Int (character height)
  public init(columns: Int, rows: Int)
  {
    self.init(width: columns * 2, height: rows * 4)
  }
}

// MARK: -
// MARK: TUIRectangle -

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
  /// - parameters:
  ///   - x: Int
  ///   - y: Int
  ///   - width: Int
  ///   - height: Int
  public init(x: Int = 0, y: Int = 0, width: Int = 0, height: Int = 0)
  {
    self.origin = TUIPoint(x: x, y: y)
    self.size = TUISize(width: width, height: height)
  }
  
  /// Default Initializer
  ///
  /// - parameters:
  ///   - x: Double
  ///   - y: Double
  ///   - width: Double
  ///   - height: Double
  public init(x: Double = 0.0, y: Double = 0.0, width: Double = 0.0, height: Double = 0.0)
  {
    self.origin = TUIPoint(x: x, y: y)
    self.size = TUISize(width: width, height: height)
  }
  
  /// Default Initializer
  ///
  /// - parameters:
  ///   - origin: TUIPoint
  ///   - size: TUISize
  public init(origin: TUIPoint, size: TUISize)
  {
    self.origin = origin
    self.size = size
  }
}

// MARK: -
// MARK: TUIRectangle Equatable -
extension TUIRectangle: Equatable {}

/// Equatable Operator for TUIRectangle
///
/// - parameters:
///   - lhs: TUIRectangle
///   - rhs: TUIRectangle
/// - returns: Bool, True if lhs and rhs are equivalent
public func == (lhs: TUIRectangle, rhs: TUIRectangle) -> Bool
{
  return lhs.origin == rhs.origin && lhs.size == rhs.size
}
