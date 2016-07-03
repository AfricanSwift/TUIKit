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
    view.drawSquare(point: TUIPoint(x: 0, y: 0), width: 100, color: color1)
    view.drawSquare(point: TUIPoint(x: 16, y: 16), width: 70, color: color2)
    view.drawCircle(center: TUIPoint(x: 50, y: 50), radius: 34, color: color3)
    
    for r in stride(from: 5, to: 50, by: 5)
    {
      view.drawCircle(center: TUIPoint(x: 50, y: 50), radius: Double(r), color: color4)
    }
    
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
