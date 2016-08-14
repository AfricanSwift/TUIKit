//
//          File:   Example+LineGraphics.swift
//    Created by:   African Swift

import Foundation

public extension Example
{
  public struct LineGraphics
  {
    public static func demo()
    {
      let len = (w: 150, h: 150)
      let viewParam = TUIView.Parameter(border: .none)
      var view = TUIView(x: 0, y: 0, width: len.w, height: len.h, parameters: viewParam)
      drawRectangles(view: &view)
      Thread.sleep(forTimeInterval: 1)
      drawCircles(view: &view)
      Thread.sleep(forTimeInterval: 1)
      drawStar(view: &view)
    }
  }
}

public extension Example.LineGraphics
{
  private static func drawStar(view: inout TUIView)
  {
    let len = (w: Int(view.size.pixel.width), h: Int(view.size.pixel.height))
    for s in stride(from: 1.0, to: 5.0, by: 0.05)
    {
      view.drawStar(
        center: TUIVec2(x: Double(len.w) * 0.5, y: Double(len.w) * 0.5),
        radius1: Double(len.w) * 0.4,
        radius2: Double(len.w) * 0.1,
        segments: s)
      let renderparm = TUIRenderParameter(
        colorspace: .foreground256,
        composite: .first,
        style: .drawille)
      Ansi.Cursor.position(
        row: Int(view.origin.y),
        column: Int(view.origin.x)).stdout()
      view.draw(atOrigin: true, parameters: renderparm)
      view.clear()
    }
  }
}

public extension Example.LineGraphics
{
  private static func drawRectangles(view: inout TUIView)
  {
    let color1 = Ansi.Color(red: 0.6, green: 0.2, blue: 0.4, alpha: 1)
    let color2 = Ansi.Color(red: 0.2, green: 0.6, blue: 0.4, alpha: 1)
    let len = (w: Int(view.size.pixel.width), h: Int(view.size.pixel.height))
    let rect1 = TUIRectangle(
      origin: TUIVec2(x: 0, y: 0),
      size: TUISize(width: len.w - 1, height: len.h - 1))
    let rect2 = TUIRectangle(
      origin: TUIVec2(x: 16, y: 16),
      size: TUISize(width: len.w - 30, height: len.h - 30))
    let rect3 = TUIRectangle(
      origin: TUIVec2(x: 4, y: 4),
      size: TUISize(width: Double(len.w) * 0.4, height: Double(len.w) * 0.4))
    view.drawRectangle(rect: rect1, color: color1)
    view.drawRectangle(rect: rect2, color: color2)
    view.drawRoundedRectangle(rect: rect3, radius: 10)
    let renderparm = TUIRenderParameter(
      colorspace: .foreground256,
      composite: .first,
      style: .drawille)
    Ansi.Cursor.position(
      row: Int(view.origin.y),
      column: Int(view.origin.x)).stdout()
    view.draw(atOrigin: true, parameters: renderparm)
  }
}

public extension Example.LineGraphics
{
  private static func drawCircles(view: inout TUIView)
  {
    let color3 = Ansi.Color(red: 0.4, green: 0.2, blue: 0.6, alpha: 1)
    let color4 = Ansi.Color(red: 0.2, green: 0.4, blue: 0.6, alpha: 1)
    let len = (w: Int(view.size.pixel.width), h: Int(view.size.pixel.height))
    view.drawCircle(
      center: TUIVec2(x: Double(len.w) * 0.5, y: Double(len.w) * 0.5),
      radius: Double(len.w) * 0.3,
      color: color3)
    
    for r in stride(from: 5, to: Double(len.w) * 0.5, by: 15)
    {
      view.drawCircle(
        center: TUIVec2(x: Double(len.w) * 0.5, y: Double(len.w) * 0.5),
        radius: Double(r),
        color: color4)
    }
    let renderparm = TUIRenderParameter(
      colorspace: .foreground256,
      composite: .first,
      style: .drawille)
    Ansi.Cursor.position(
      row: Int(view.origin.y),
      column: Int(view.origin.x)).stdout()
    view.draw(atOrigin: true, parameters: renderparm)
  }
}
