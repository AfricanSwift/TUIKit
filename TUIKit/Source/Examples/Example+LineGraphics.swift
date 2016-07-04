//
//          File:   Example+LineGraphics.swift
//    Created by:   African Swift

import Darwin

public struct Example_LineGraphics
{
  public static func demo()
  {
    let color1 = Ansi.Color(red: 0.6, green: 0.2, blue: 0.4, alpha: 1)
    let color2 = Ansi.Color(red: 0.2, green: 0.6, blue: 0.4, alpha: 1)
    let color3 = Ansi.Color(red: 0.4, green: 0.2, blue: 0.6, alpha: 1)
    let color4 = Ansi.Color(red: 0.2, green: 0.4, blue: 0.6, alpha: 1)
    
    
    var view = TUIView(x: 0, y: 0, width: 100, height: 100, border: .none)
    let rect1 = TUIRectangle(origin: TUIPoint(x: 0, y: 0), size: TUISize(width: 100, height: 100))
    let rect2 = TUIRectangle(origin: TUIPoint(x: 16, y: 16), size: TUISize(width: 70, height: 70))
    view.drawRectangle(rect: rect1, color: color1)
    view.drawRectangle(rect: rect2, color: color2)
    view.drawCircle(center: TUIPoint(x: 50, y: 50), radius: 34, color: color3)
    
    for r in stride(from: 5, to: 50, by: 10)
    {
      view.drawCircle(center: TUIPoint(x: 50, y: 50), radius: Double(r), color: color4)
    }
    
    let rect = TUIRectangle(x: 4, y: 4, width: 40, height: 40)
    view.drawRoundedRectangle(rect: rect, radius: 10)
    
    view.drawStar(center: TUIPoint(x: 50, y: 50), radius1: 40, radius2: 25, segments: 16)
    
    let renderparm = TUIRenderParameter(
      colorspace: .foreground256,
      composite: .first,
      style: .drawille)
    Ansi.Cursor.position(
      row: view.origin.y.toInt(),
      column: view.origin.x.toInt()).stdout()
    print(view.draw(parameters: renderparm).map { $0.toString() }.joined(separator: "\n"))
    
    Ansi.Color.resetAll().stdout()
  }
}
