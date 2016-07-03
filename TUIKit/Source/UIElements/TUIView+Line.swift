//
//          File:   TUIView+Line.swift
//    Created by:   African Swift

import Darwin

public extension TUIView
{
  ///  Drawille line iterator
  private struct LineIterator: IteratorProtocol
  {
    private let from: TUIPoint
    private let to: TUIPoint
    private let xDiff: Double
    private let yDiff: Double
    private let range: Double
    private let xAddend: Double
    private let yAddend: Double
    private var index = Double(0)
    
    /// Default initializer for line iterator
    ///
    /// - parameters:
    ///   - from: TUIPoint
    ///   - to: TUIPoint
    init(from: TUIPoint, to: TUIPoint)
    {
      precondition(!(from == to), "LineIterator: from/to are equivalent")
      
      self.from = TUIPoint(
        x: LineIterator.normalize(from.x),
        y: LineIterator.normalize(from.y))
      self.to = to
      self.xDiff = max(from.x, to.x) - min(from.x, to.x)
      self.yDiff = max(from.y, to.y) - min(from.y, to.y)
      self.range = max(self.xDiff, self.yDiff)
      self.xAddend = self.from.x < self.to.x ? 1 : -1
      self.yAddend = self.from.y < self.to.y ? 1 : -1
    }
    
    /// Returns next pixel offset along draw path
    ///
    /// - returns: TUIPoint?
    mutating func next() -> TUIPoint?
    {
      if self.index > self.range + 1
      {
        return nil
      }
      let x = self.from.x + (self.index * self.xDiff) / self.range * self.xAddend
      let y = self.from.y + (self.index * self.yDiff) / self.range * self.yAddend
      let point = TUIPoint(x: x, y: y)
      self.index += 1
      return point
    }
    
    /// Normalize values by round up/down to nearest value and then
    /// converting to Int e.g. Useful for trigonometric results
    ///
    /// - parameters:
    ///   - coordinate: Double
    /// - returns: Double
    private static func normalize(_ coordinate: Double) -> Double
    {
      return round(coordinate)
    }
  }
}

// MARK: -
// MARK: Draw Line -
public extension TUIView
{
  /// Draw line
  ///
  /// - parameters:
  ///   - x1: Int (originating x)
  ///   - y1: Int (originating y)
  ///   - x1: Int (destination x)
  ///   - y1: Int (destination y)
  ///   - color: Ansi.Color
  public mutating func drawLine(
    x1: Int,
    y1: Int,
    x2: Int,
    y2: Int,
    color: Ansi.Color)
  {
    self.drawLine(
      from: TUIPoint(x: x1, y: y1),
      to: TUIPoint(x: x2, y: y2),
      color: color)
  }
  
  /// Draw line
  ///
  /// - parameters:
  ///   - x1: Double (originating x)
  ///   - y1: Double (originating y)
  ///   - x1: Double (destination x)
  ///   - y1: Double (destination y)
  ///   - color: Ansi.Color
  public mutating func drawLine(
    x1: Double,
    y1: Double,
    x2: Double,
    y2: Double,
    color: Ansi.Color)
  {
    self.drawLine(
      from: TUIPoint(x: x1, y: y1),
      to: TUIPoint(x: x2, y: y2),
      color: color)
  }
  
  /// Draw line
  ///
  /// - parameters:
  ///   - from: TUIPoint (originating pixel offset)
  ///   - to: TUIPoint (destination pixel offset)
  ///   - color: Ansi.Color (Optional, default is white)
  public mutating func drawLine(
    from: TUIPoint,
    to: TUIPoint,
    color: Ansi.Color = Ansi.Color(red: 1, green: 1, blue: 1, alpha: 1))
  {
    precondition(!(from == to), "drawLine: from/to are equivalent")
    
    var line = TUIView.LineIterator(from: from, to: to)
    while let point = line.next()
    {
      self.drawPixel(x: point.x, y: point.y, color: color)
    }
  }
}

// MARK: -
// MARK: Draw Rectangle -
public extension TUIView
{
  /// Draw rectangle
  ///
  /// - parameters:
  ///   - rect: TUIRectangle
  ///   - color: Ansi.Color (Optional, default is white)
  public mutating func drawRectangle(
    rect: TUIRectangle,
    color: Ansi.Color = Ansi.Color(red: 1, green: 1, blue: 1, alpha: 1))
  {
    
    precondition(!(rect.size.width == 0) ||
      !(rect.size.height == 0), "drawRectangle: width/height == zero")
    
    let leftTop = rect.origin
    
    let leftBottom = TUIPoint(
      x: rect.origin.x,
      y: rect.origin.y + rect.size.height - 1.1)
    
    let rightTop = TUIPoint(
      x: rect.origin.x + rect.size.width - 1.1,
      y: rect.origin.y)
    
    let rightBottom = TUIPoint(
      x: rect.origin.x + rect.size.width - 1.1,
      y: rect.origin.y + rect.size.height - 1.1)
    
    let edges = [
      (leftTop, leftBottom),
      (leftTop, rightTop),
      (leftBottom, rightBottom),
      (rightTop, rightBottom)]
    
    // Draw connecting edges
    edges.forEach { self.drawLine(from: $0.0, to: $0.1, color: color) }
  }
}

// MARK: -
// MARK: Draw Rounded Rectangle -
public extension TUIView
{
  /// Draw rounded rectangle
  ///
  /// - parameters:
  ///   - rect: TUIRectangle
  ///   - color: Ansi.Color (Option, default is white)
  ///   - radius: Double (Optional, default is 4.0)
  public mutating func drawRoundedRectangle(
    rect: TUIRectangle,
    color: Ansi.Color = Ansi.Color(red: 1, green: 1, blue: 1, alpha: 1),
    radius: Double = 4.0)
  {
    precondition(!(rect.size.width == 0) ||
      !(rect.size.height == 0), "drawRectangle: width/height == zero")
    
    // Left
    var from = TUIPoint(
      x: rect.origin.x,
      y: rect.origin.y + radius)
    var to = TUIPoint(
      x: rect.origin.x,
      y: rect.origin.y + rect.size.height - 1.1 - radius)
    self.drawLine(from: from, to: to, color: color)
    
    
    // Right
    from = TUIPoint(
      x: rect.origin.x + rect.size.width - 1.1,
      y: rect.origin.y + radius)
    to = TUIPoint(
      x: rect.origin.x + rect.size.width - 1.1,
      y: rect.origin.y + rect.size.height - 1.1 - radius)
    self.drawLine(from: from, to: to, color: color)
    
    
    // Top
    from = TUIPoint(
      x: rect.origin.x + radius,
      y: rect.origin.y)
    to = TUIPoint(
      x: rect.origin.x + rect.size.width - 1.1 - radius,
      y: rect.origin.y)
    self.drawLine(from: from, to: to, color: color)
    
    // Bottom
    from = TUIPoint(
      x: rect.origin.x + radius,
      y: rect.origin.y + rect.size.height - 1.1)
    to = TUIPoint(
      x: rect.origin.x + rect.size.width - 1.1 - radius,
      y: rect.origin.y + rect.size.height - 1.1)
    self.drawLine(from: from, to: to, color: color)
    
    // Left Top Arc
    let leftTop = TUIPoint(
      x: rect.origin.x + radius,
      y: rect.origin.y + radius)
    self.drawEllipse(
      center: leftTop,
      radiusX: radius,
      radiusY: radius,
      startAngle: 270,
      endAngle: 360,
      color: color)
    
    // Right Top Arc
    let rightTop = TUIPoint(
      x: rect.origin.x + rect.size.width - 1 - radius,
      y: rect.origin.y + radius)
    self.drawEllipse(
      center: rightTop,
      radiusX: radius,
      radiusY: radius,
      startAngle: 0,
      endAngle: 90,
      color: color)
    
    // Left Bottom Arc
    let leftBottom = TUIPoint(
      x: rect.origin.x + radius,
      y: rect.origin.y + rect.size.height - 1 - radius)
    self.drawEllipse(
      center: leftBottom,
      radiusX: radius,
      radiusY: radius,
      startAngle: 180,
      endAngle: 270,
      color: color)
    
    // Right Bottom Arc
    let rightBottom = TUIPoint(
      x: rect.origin.x + rect.size.width - 1 - radius,
      y: rect.origin.y + rect.size.height - 1 - radius)
    self.drawEllipse(
      center: rightBottom,
      radiusX: radius,
      radiusY: radius,
      startAngle: 90,
      endAngle: 180,
      color: color )
  }
}

// MARK: -
// MARK: Draw Square -
public extension TUIView
{
  /// Draw Square
  ///
  /// - parameters:
  ///   - point: TUIPoint
  ///   - width: Double
  ///   - color: Ansi.Color (Optional, default is white)
  public mutating func drawSquare(
    point: TUIPoint,
    width: Double,
    color: Ansi.Color = Ansi.Color(red: 1, green: 1, blue: 1, alpha: 1)) {
    
    precondition(!(width == 0), "drawSquare: width == zero")
    
    self.drawRectangle(
      rect: TUIRectangle(origin: point, size: TUISize(width: width, height: width)),
      color: color)
  }
}
