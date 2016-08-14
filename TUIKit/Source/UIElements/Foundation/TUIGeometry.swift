//
//          File:   TUIGeometry.swift
//    Created by:   African Swift

import Darwin

// MARK: TUIVec2 -

/// Vector in the two-dimensional Euclidean space – R×R
///
/// - x: horizontal offset
/// - y: vertical offset
public struct TUIVec2
{
  public var x: Double
  public var y: Double
  
  /// Default TUIVec2 Initializer
  ///
  /// - parameters:
  ///   - x: Int
  ///   - y: Int
  public init(x: Int = 0, y: Int = 0)
  {
    self.x = Double(x)
    self.y = Double(y)
  }
  
  /// Default TUIVec2 Initializer
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
// MARK: TUIVec2 CustomStringConvertible -
extension TUIVec2: CustomStringConvertible
{
  public var description: String {
    return "(x: \(self.x), y: \(self.y))"
  }
}

// MARK: -
// MARK: TUIVec2 Equatable -
extension TUIVec2: Equatable { }

/// Equatable Operator for TUIVec2
///
/// - parameters:
///   - lhs: TUIVec2
///   - rhs: TUIVec2
/// - returns: Bool, True if lhs and rhs are equivalent
public func == (lhs: TUIVec2, rhs: TUIVec2) -> Bool
{
  return lhs.x == rhs.x && lhs.y == rhs.y
}

/// Plus Operator for TUIVec2
///
/// - parameters:
///   - lhs: TUIVec2
///   - rhs: TUIVec2
/// - returns: Product of two TUIVec2
public func + (lhs: TUIVec2, rhs: TUIVec2) -> TUIVec2
{
  return TUIVec2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

/// Minus Operator for TUIVec2
///
/// - parameters:
///   - lhs: TUIVec2
///   - rhs: TUIVec2
/// - returns: Difference of two TUIVec2
public func - (lhs: TUIVec2, rhs: TUIVec2) -> TUIVec2
{
  return TUIVec2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

/// Multiply Vector by Factor (Scale)
///
/// - parameters:
///   - lhs: TUIVec2
///   - rhs: Double
/// - returns: Factor increase of TUIVec2
public func * (lhs: TUIVec2, rhs: Double) -> TUIVec2
{
  return TUIVec2(x: lhs.x * rhs, y: lhs.y * rhs)
}

/// Dot Product of two TUIVec2
///
/// - parameters:
///   - lhs: TUIVec2
///   - rhs: TUIVec2
/// - returns: dot product of the two TUIVec2 vectors
public func * (lhs: TUIVec2, rhs: TUIVec2) -> Double {
  return (lhs.x * rhs.x) + (lhs.y * rhs.y)
}

// MARK: -
// MARK: TUIVec3 -

/// Vector in the three-dimensional Euclidean space – R×R×R
///
/// - x: X axis offset
/// - y: Y axis offset
/// - z: Z axis offset
public struct TUIVec3
{
  public var x: Double
  public var y: Double
  public var z: Double
  
  /// Default TUIVec3 Initializer
  ///
  /// - parameters:
  ///   - x: Double
  ///   - y: Double
  ///   - z: Double
  public init(x: Double = 0, y: Double = 0, z: Double = 0)
  {
    self.x = x
    self.y = y
    self.z = z
  }
  
  private func norm() -> Double
  {
    return sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
  }
  
  public func normalize() -> TUIVec3
  {
    return self * (1 / self.norm())
  }
}

// MARK: -
// MARK: TUIVec3 CustomStringConvertible -
extension TUIVec3: CustomStringConvertible
{
  public var description: String {
    return "(x: \(self.x), y: \(self.y), z: \(self.z))"
  }
}

// MARK: -
// MARK: TUIVec3 Equatable -
extension TUIVec3: Equatable { }

/// Equatable Operator for TUIVec3
///
/// - parameters:
///   - lhs: TUIVec3
///   - rhs: TUIVec3
/// - returns: Bool, True if lhs and rhs are equivalent
public func == (lhs: TUIVec3, rhs: TUIVec3) -> Bool
{
  return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

/// Cross Product of two TUIVec3
infix operator ** { associativity left precedence 150 }

/// Cross Product of two TUIVec3
///
/// - parameters:
///   - lhs: TUIVec3
///   - rhs: TUIVec3
/// - returns: cross product of the two TUIVec3 vectors
public func ** (lhs: TUIVec3, rhs: TUIVec3) -> TUIVec3
{
  return TUIVec3(x: lhs.y * rhs.z - lhs.z * rhs.y,
              y: lhs.z * rhs.x - lhs.x * rhs.z,
              z: lhs.x * rhs.y - lhs.y * rhs.x)
}

/// Plus Operator for TUIVec3
///
/// - parameters:
///   - lhs: TUIVec3
///   - rhs: TUIVec3
/// - returns: Product of two TUIVec3 vectors
public func + (lhs: TUIVec3, rhs: TUIVec3) -> TUIVec3
{
  return TUIVec3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
}

/// Minus Operator for TUIVec3
///
/// - parameters:
///   - lhs: TUIVec3
///   - rhs: TUIVec3
/// - returns: Difference of two TUIVec3 vectors
public func - (lhs: TUIVec3, rhs: TUIVec3) -> TUIVec3
{
  return TUIVec3(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
}

/// Multiply Vector by Factor (Scale)
///
/// - parameters:
///   - lhs: TUIVec3
///   - rhs: Double (factor)
/// - returns: Factor increase of TUIVec3 vector
public func * (lhs: TUIVec3, rhs: Double) -> TUIVec3
{
  return TUIVec3(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
}

/// Dot Product of two TUIVec3
///
/// - parameters:
///   - lhs: TUIVec3
///   - rhs: TUIVec3
/// - returns: dot product of the two vectors
public func * (lhs: TUIVec3, rhs: TUIVec3) -> Double
{
  return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
}

/// Radian Angle between two TUIVec3 vectors
infix operator *> { associativity left precedence 150 }

/// Radian Angle between two TUIVec3 vectors
///
/// - parameters:
///   - lhs: TUIVec3
///   - rhs: TUIVec3
/// - returns: Radian Angle of two vectors
public func *> (lhs: TUIVec3, rhs: TUIVec3) -> Double
{
  return acos((lhs * rhs) / (lhs.norm() * rhs.norm()))
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
/// - origin (TUIVec2): left / top origin
/// - size (TUISize): width / height
public struct TUIRectangle
{
  public private(set) var origin = TUIVec2()
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
    self.origin = TUIVec2(x: x, y: y)
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
    self.origin = TUIVec2(x: x, y: y)
    self.size = TUISize(width: width, height: height)
  }
  
  /// Default Initializer
  ///
  /// - parameters:
  ///   - origin: TUIVec2
  ///   - size: TUISize
  public init(origin: TUIVec2, size: TUISize)
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
