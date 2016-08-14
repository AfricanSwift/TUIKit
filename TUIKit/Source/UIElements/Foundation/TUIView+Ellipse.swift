//
//          File:   TUIView+Ellipse.swift
//    Created by:   African Swift

import Darwin

// MARK: -
// MARK: Ellipse Generator -
public extension TUIView
{
  ///  Drawille Ellipse iterator
  private struct EllipseIterator: IteratorProtocol
  {
    let center: TUIVec2
    let radiusX: Double
    let radiusY: Double
    let segments: Double
    let endAngle: Double
    var index: Double
    
    /// Default initializer for line iterator
    ///
    /// - parameters:
    ///   - center: TUIVec2
    ///   - radiusX: Double
    ///   - radiusY: Double
    ///   - startAngle: Double (default = 0)
    ///   - endAngle: Double (default = 360)
    ///   - segments: Double (default = 360)
    init(
      center: TUIVec2,
      radiusX: Double,
      radiusY: Double,
      startAngle: Double = 0,
      endAngle: Double = 360,
      segments: Double = 360)
    {
      self.center = center
      self.radiusX = radiusX
      self.radiusY = radiusY
      self.segments = segments
      self.index = startAngle
      self.endAngle = endAngle
    }
    
    /// Returns next pixel offset along draw path
    ///
    /// - returns: TUIVec2?
    mutating func next() -> TUIVec2?
    {
      guard self.index <= self.endAngle else
      {
        return nil
      }
      let slice = 2.0 * M_PI / self.segments
      let angle = slice * (self.index - 90)
      let x = EllipseIterator.normalize(self.center.x + self.radiusX * cos(angle))
      let y = EllipseIterator.normalize(self.center.y + self.radiusY * sin(angle))
      let point = TUIVec2(x: x, y: y)
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
// MARK: Ellipse -
public extension TUIView
{
  /// Draw Ellipse
  ///
  /// - parameters:
  ///   - center: TUIVec2
  ///   - radiusX: Double
  ///   - radiusY: Double
  ///   - startAngle: Double (Optional, default is 0)
  ///   - endAngle: Double (Optional, default is 360)
  ///   - color: Ansi.Color (Optional, default is white)
  public mutating func drawEllipse(
    center: TUIVec2,
    radiusX: Double,
    radiusY: Double,
    startAngle: Double = 0,
    endAngle: Double = 360,
    color: Ansi.Color = Ansi.Color(red: 1, green: 1, blue: 1, alpha: 1))
  {
    precondition(!(radiusX == 0) &&
      !(radiusY == 0), "drawEllipse: radiusX/radiusY == zero")
    
    var circle = TUIView.EllipseIterator(
      center: center,
      radiusX: radiusX,
      radiusY: radiusY,
      startAngle: startAngle,
      endAngle: endAngle)
    while let point = circle.next()
    {
      self.drawPixel(x: point.x, y: point.y, color: color)
    }
  }
}

// MARK: -
// MARK: Pie Slice -
public extension TUIView
{
  /// Draw Circle
  ///
  /// - parameters:
  ///   - center: TUIVec2
  ///   - radius: Double
  ///   - startAngle: Double (Optional, default is 0)
  ///   - endAngle: Double (Optional, default is 360)
  ///   - color: Ansi.Color (Optional, default is white)
  ///   - segments: Double (Optional, default is 360)
  ///   - fill: Bool (Optional, default is false)
  public mutating func drawPieSlice(
    center: TUIVec2,
    radius: Double,
    startAngle: Double = 0,
    endAngle: Double = 360,
    color: Ansi.Color = Ansi.Color(red: 1, green: 1, blue: 1, alpha: 1),
    segments: Double = 360,
    fill: Bool = false)
  {
    
    precondition(!(radius == 0), "drawCircle: radius == zero")
    var circle = TUIView.EllipseIterator(
      center: center,
      radiusX: radius,
      radiusY: radius,
      startAngle: startAngle,
      endAngle: endAngle,
      segments: segments)
//    var pointT = center
    var first = false
    while let point = circle.next()
    {
      if first == false
      {
        first = true
        self.drawLine(from: point, to: center, color: color)
      }
      
      if fill == true
      {
        self.drawLine(from: point, to: center, color: color)
      }
      else
      {
        self.drawPixel(x: point.x, y: point.y, color: color)
      }
      
//      pointT = point
    }
    
//    if first == true
//    {
//      self.drawLine(from: pointT, to: center, color: color)
//    }
  }
}

// MARK: -
// MARK: Circle -
public extension TUIView
{
  /// Draw Circle
  ///
  /// - parameters:
  ///   - center: TUIVec2
  ///   - radius: Double
  ///   - startAngle: Double (Optional, default is 0)
  ///   - endAndle: Double (Optional, default is 360)
  ///   - color: Ansi.Color (Optional, default is white)
  public mutating func drawCircle(
    center: TUIVec2,
    radius: Double,
    startAngle: Double = 0,
    endAngle: Double = 360,
    color: Ansi.Color = Ansi.Color(red: 1, green: 1, blue: 1, alpha: 1))
  {
    precondition(!(radius == 0), "drawCircle: radius == zero")
    var circle = TUIView.EllipseIterator(
      center: center,
      radiusX: radius,
      radiusY: radius,
      startAngle: startAngle,
      endAngle: endAngle)
    while let point = circle.next()
    {
      self.drawPixel(x: point.x, y: point.y, color: color)
    }
  }
}

// MARK: - 
// MARK: Polygon -
public extension TUIView
{
  /// Draw Polygon
  ///
  /// - parameters:
  ///   - center: TUIVec2
  ///   - radius: Double
  ///   - startAngle: Double (Optional, default is 0)
  ///   - endAndle: Double (Optional, default is 360)
  ///   - color: Ansi.Color (Optional, default is white)
  ///   - segments: Double
  public mutating func drawPolygon(
    center: TUIVec2,
    radius: Double,
    startAngle: Double = 0,
    endAngle: Double = 360,
    color: Ansi.Color = Ansi.Color(red: 1, green: 1, blue: 1, alpha: 1),
    segments: Double)
  {
    precondition(!(radius == 0), "drawPolygon: radius == zero")
    var polygon = TUIView.EllipseIterator(
      center: center,
      radiusX: radius,
      radiusY: radius,
      startAngle: startAngle,
      endAngle: endAngle,
      segments: segments)
    
    var begin = TUIVec2()
    while let point = polygon.next()
    {
      let end = point
      if begin.x.isNaN || begin.x == 0
      {
        begin = end
        continue
      }
      self.drawLine(from: begin, to: end, color: color)
      begin = end
    }
  }
}

// MARK: -
// MARK: Star -
public extension TUIView
{
  /// Draw Star
  ///
  /// - parameters:
  ///   - center: TUIVec2
  ///   - radius1: Double
  ///   - radius2: Double
  ///   - startAngle: Double (default = 0)
  ///   - endAngle: Double (default = 360)
  ///   - color: Ansi.Color (default is white)
  ///   - segments: Double
  public mutating func drawStar(
    center: TUIVec2,
    radius1: Double,
    radius2: Double,
    startAngle: Double = 0,
    endAngle: Double = 360,
    color: Ansi.Color = Ansi.Color(red: 1, green: 1, blue: 1, alpha: 1),
    segments: Double)
  {
    precondition(!(radius1 == 0), "drawStar: radius1 == zero")
    var outer = TUIView.EllipseIterator(
      center: center,
      radiusX: radius1,
      radiusY: radius1,
      startAngle: startAngle,
      endAngle: endAngle,
      segments: segments)
    
    var inner = TUIView.EllipseIterator(
      center: center,
      radiusX: radius2,
      radiusY: radius2,
      startAngle: startAngle,
      endAngle: endAngle,
      segments: segments)
    
    var innerMark = false
    var begin = TUIVec2()
    
    while let outerPoint = outer.next(), let innerPoint = inner.next()
    {
      var end = TUIVec2()
      
      if innerMark
      {
        end = innerPoint
        innerMark = !innerMark
      } else
      {
        end = outerPoint
        innerMark = !innerMark
      }
      
      if begin.x.isNaN || begin.x == 0
      {
        begin = end
        continue
      }
      self.drawLine(from: begin, to: end, color: color)
      begin = end
    }
  }
}

// MARK: -
// MARK: - Polyhedron -
public extension TUIView
{
  /// Draw Polyhedron
  ///
  /// - parameters:
  ///   - center: TUIVec2
  ///   - radius1: Double
  ///   - radius2: Double
  ///   - startAngle: Double (default = 0)
  ///   - endAngle: Double (default = 360)
  ///   - color: Ansi.Color (default is white)
  ///   - segments: Double
  public mutating func drawPolyhedron(
    center1: TUIVec2,
    center2: TUIVec2,
    radius1: Double,
    radius2: Double,
    startAngle: Double = 0,
    endAngle: Double = 360,
    color: Ansi.Color = Ansi.Color(red: 1, green: 1, blue: 1, alpha: 1),
    segments: Double)
  {
    precondition(!(radius1 == 0), "drawPolyhedron: radius1 == zero")
    var outer = TUIView.EllipseIterator(
      center: center1,
      radiusX: radius1,
      radiusY: radius1,
      startAngle: startAngle,
      endAngle: endAngle,
      segments: segments)
    
    var inner = TUIView.EllipseIterator(
      center: center2,
      radiusX: radius2,
      radiusY: radius2,
      startAngle: startAngle,
      endAngle: endAngle,
      segments: segments)
    
    var begin1 = TUIVec2()
    var begin2 = TUIVec2()
    
    while let point1 = outer.next(), let point2 = inner.next()
    {
      let end1 = point1
      let end2 = point2
      
      if begin1.x.isNaN || begin1.x == 0
      {
        begin1 = end1
        begin2 = end2
        continue
      }
      
      self.drawLine(from: begin1, to: end1, color: color)
      self.drawLine(from: begin2, to: end2, color: color)
      self.drawLine(from: begin1, to: begin2, color: color)
      
      begin1 = end1
      begin2 = end2
    }
  }
}
