//
//          File:   TUIView+Line.swift
//    Created by:   African Swift

import Darwin

public extension TUIView
{
  /// Drawille line iterator
  /// Based on Bresenham’s Line Drawing Algorithm
  private struct LineIterator: IteratorProtocol
  {
    private var from: (x: Int, y: Int)
    private var to: (x: Int, y: Int)
    private var distance: (x: Int, y: Int)
    private var steep: Bool
    private var error: Int
    private let distanceError: Int
    private var pixel: (x: Int, y: Int)
    
    /// Default initializer for line iterator
    ///
    /// - parameters:
    ///   - from: TUIPoint
    ///   - to: TUIPoint
    init(from: TUIPoint, to: TUIPoint)
    {
      self.steep = false
      self.from = (x: Int(from.x), y: Int(from.y))
      self.to = (x: Int(to.x), y: Int(to.y))

      if abs(self.from.x - self.to.x) < abs(self.from.y - self.to.y)
      {
        swap(&self.from.x, &self.from.y)
        swap(&self.to.x, &self.to.y)
        self.steep = true
      }
      
      if self.from.x > self.to.x
      {
        swap(&self.from.x, &self.to.x)
        swap(&self.from.y, &self.to.y)
      }
      
      self.distance = (x: self.to.x - self.from.x, y: self.to.y - self.from.y)
      self.distanceError = abs(self.distance.y) * 2
      self.error = 0
      self.pixel = (x: self.from.x, y: self.from.y)
    }
    
    /// Returns next pixel offset along draw path
    ///
    /// - returns: TUIPoint?
    mutating func next() -> TUIPoint?
    {
      if self.pixel.x > self.to.x
      {
        return nil
      }
      
      let result = steep ? TUIPoint(x: self.pixel.y, y: self.pixel.x) :
        TUIPoint(x: self.pixel.x, y: self.pixel.y)
      
      self.error += self.distanceError
      if self.error > self.distance.x
      {
        self.pixel.y += self.to.y > self.from.y ? 1 : -1
        self.error -= self.distance.x * 2
      }
      self.pixel.x += 1
      return result
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
    color: Ansi.Color = Ansi.Color(red: 1, green: 1, blue: 1, alpha: 1), action: TUICharacter.SetAction = .on)
  {
    precondition(!(from == to), "drawLine: from/to are equivalent")
    
    var line = TUIView.LineIterator(from: from, to: to)
    while let point = line.next()
    {
      self.drawPixel(x: point.x, y: point.y, color: color, action: action)
    }
  }
}
