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
