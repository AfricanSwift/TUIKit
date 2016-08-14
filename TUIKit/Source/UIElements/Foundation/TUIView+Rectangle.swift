//
//          File:   TUIView+Rectangle.swift
//    Created by:   African Swift

import Darwin

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
    
    let leftBottom = TUIVec2(
      x: rect.origin.x,
      y: rect.origin.y + rect.size.height)
    
    let rightTop = TUIVec2(
      x: rect.origin.x + rect.size.width,
      y: rect.origin.y)
    
    let rightBottom = TUIVec2(
      x: rect.origin.x + rect.size.width,
      y: rect.origin.y + rect.size.height)
    
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
  
  private struct RoundedRectangle
  {
    let rect: TUIRectangle
    let color: Ansi.Color
    let radius: Double
    
    /// Default initializer
    ///
    /// - parameters:
    ///   - rect: TUIRectangle
    ///   - color: Ansi.Color
    ///   - radius: Double
    private init(rect: TUIRectangle, color: Ansi.Color, radius: Double)
    {
      self.rect = rect
      self.color = color
      self.radius = radius
    }
    
    typealias rr = RoundedRectangle
    static var parts = [rr.leftLine, rr.rightLine, rr.topLine, rr.bottomLine,
                        rr.leftTopArc, rr.rightTopArc, rr.leftBottomArc, rr.rightBottomArc]
    
    /// Left Line
    ///
    /// - parameters:
    ///   - roundedRect rr: RoundedRectangle
    ///   - view: inout TUIView
    private static func leftLine(roundedRect rr: RoundedRectangle, view: inout TUIView)
    {
      let from = TUIVec2(
        x: rr.rect.origin.x,
        y: rr.rect.origin.y + rr.radius)
      let to = TUIVec2(
        x: rr.rect.origin.x,
        y: rr.rect.origin.y + rr.rect.size.height - rr.radius)
      view.drawLine(from: from, to: to, color: rr.color)
    }
    
    /// Right Line
    ///
    /// - parameters:
    ///   - roundedRect rr: RoundedRectangle
    ///   - view: inout TUIView
    private static func rightLine(roundedRect rr: RoundedRectangle, view: inout TUIView)
    {
      let from = TUIVec2(
        x: rr.rect.origin.x + rr.rect.size.width,
        y: rr.rect.origin.y + rr.radius)
      let to = TUIVec2(
        x: rr.rect.origin.x + rr.rect.size.width,
        y: rr.rect.origin.y + rr.rect.size.height - rr.radius)
      view.drawLine(from: from, to: to, color: rr.color)
    }
    
    /// Top Line
    ///
    /// - parameters:
    ///   - roundedRect rr: RoundedRectangle
    ///   - view: inout TUIView
    private static func topLine(roundedRect rr: RoundedRectangle, view: inout TUIView)
    {
      let from = TUIVec2(
        x: rr.rect.origin.x + rr.radius,
        y: rr.rect.origin.y)
      let to = TUIVec2(
        x: rr.rect.origin.x + rr.rect.size.width - rr.radius,
        y: rr.rect.origin.y)
      view.drawLine(from: from, to: to, color: rr.color)
    }
    
    /// Bottom Line
    ///
    /// - parameters:
    ///   - roundedRect rr: RoundedRectangle
    ///   - view: inout TUIView
    private static func bottomLine(roundedRect rr: RoundedRectangle, view: inout TUIView)
    {
      let from = TUIVec2(
        x: rr.rect.origin.x + rr.radius,
        y: rr.rect.origin.y + rr.rect.size.height)
      let to = TUIVec2(
        x: rr.rect.origin.x + rr.rect.size.width - rr.radius,
        y: rr.rect.origin.y + rr.rect.size.height)
      view.drawLine(from: from, to: to, color: rr.color)
    }
    
    /// Left Top Arc
    ///
    /// - parameters:
    ///   - roundedRect rr: RoundedRectangle
    ///   - view: inout TUIView
    private static func leftTopArc(roundedRect rr: RoundedRectangle, view: inout TUIView)
    {
      let leftTop = TUIVec2(
        x: rr.rect.origin.x + rr.radius,
        y: rr.rect.origin.y + rr.radius)
      view.drawEllipse(
        center: leftTop,
        radiusX: rr.radius,
        radiusY: rr.radius,
        startAngle: 270,
        endAngle: 360,
        color: rr.color)
    }
    
    /// Right Top Arc
    ///
    /// - parameters:
    ///   - roundedRect rr: RoundedRectangle
    ///   - view: inout TUIView
    private static func rightTopArc(roundedRect rr: RoundedRectangle, view: inout TUIView)
    {
      let rightTop = TUIVec2(
        x: rr.rect.origin.x + rr.rect.size.width - rr.radius,
        y: rr.rect.origin.y + rr.radius)
      view.drawEllipse(
        center: rightTop,
        radiusX: rr.radius,
        radiusY: rr.radius,
        startAngle: 0,
        endAngle: 90,
        color: rr.color)
    }
    
    /// Left Bottom Arc
    ///
    /// - parameters:
    ///   - roundedRect rr: RoundedRectangle
    ///   - view: inout TUIView
    private static func leftBottomArc(roundedRect rr: RoundedRectangle, view: inout TUIView)
    {
      let leftBottom = TUIVec2(
        x: rr.rect.origin.x + rr.radius,
        y: rr.rect.origin.y + rr.rect.size.height - rr.radius)
      view.drawEllipse(
        center: leftBottom,
        radiusX: rr.radius,
        radiusY: rr.radius,
        startAngle: 180,
        endAngle: 270,
        color: rr.color)
    }
    
    /// Right Bottom Arc
    ///
    /// - parameters:
    ///   - roundedRect rr: RoundedRectangle
    ///   - view: inout TUIView
    private static func rightBottomArc(roundedRect rr: RoundedRectangle, view: inout TUIView)
    {
      let rightBottom = TUIVec2(
        x: rr.rect.origin.x + rr.rect.size.width - rr.radius,
        y: rr.rect.origin.y + rr.rect.size.height - rr.radius)
      view.drawEllipse(
        center: rightBottom,
        radiusX: rr.radius,
        radiusY: rr.radius,
        startAngle: 90,
        endAngle: 180,
        color: rr.color )
    }
  }
  
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
    
    let rr = RoundedRectangle(rect: rect, color: color, radius: radius)
    RoundedRectangle.parts.forEach { $0(roundedRect: rr, view: &self) }
  }
}
