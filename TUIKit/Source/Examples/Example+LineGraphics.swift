//
//          File:   Example+LineGraphics.swift
//    Created by:   African Swift

import Foundation

public struct Example_LineGraphics
{
  public static func demo()
  {
    Ansi.Set.cursorOff().stdout()
    
    let color1 = Ansi.Color(red: 0.6, green: 0.2, blue: 0.4, alpha: 1)
    let color2 = Ansi.Color(red: 0.2, green: 0.6, blue: 0.4, alpha: 1)
    let color3 = Ansi.Color(red: 0.4, green: 0.2, blue: 0.6, alpha: 1)
    let color4 = Ansi.Color(red: 0.2, green: 0.4, blue: 0.6, alpha: 1)
    
    let len = (w: 200, h: 200)
    var view = TUIView(x: 0, y: 0, width: len.w, height: len.h, border: .none)
    
    for s in stride(from: 1.0, to: 5.0, by: 0.05)
    {
      
      let rect1 = TUIRectangle(origin: TUIPoint(x: 0, y: 0),
                               size: TUISize(width: len.w, height: len.h))
      
      let rect2 = TUIRectangle(origin: TUIPoint(x: 16, y: 16),
                               size: TUISize(width: len.w - 30, height: len.h - 30))
      
      view.drawRectangle(rect: rect1, color: color1)
      view.drawRectangle(rect: rect2, color: color2)
      view.drawCircle(
        center: TUIPoint(x: Double(len.w) * 0.5, y: Double(len.w) * 0.5),
        radius: Double(len.w) * 0.3,
        color: color3)
      
      for r in stride(from: 5, to: Double(len.w) * 0.5, by: 15)
      {
        view.drawCircle(
          center: TUIPoint(x: Double(len.w) * 0.5, y: Double(len.w) * 0.5),
          radius: Double(r),
          color: color4)
      }
      
      let rect = TUIRectangle(x: 4, y: 4, width: Double(len.w) * 0.4, height: Double(len.w) * 0.4)
      view.drawRoundedRectangle(rect: rect, radius: 10)
      view.drawStar(
        center: TUIPoint(x: Double(len.w) * 0.5, y: Double(len.w) * 0.5),
        radius1: Double(len.w) * 0.4,
        radius2: Double(len.w) * 0.1,
        segments: s)
      
      let renderparm = TUIRenderParameter(
        colorspace: .foreground256,
        composite: .first,
        style: .drawille)
      Ansi.Cursor.position(
        row: view.origin.y.toInt(),
        column: view.origin.x.toInt()).stdout()
      
//      let paint = view.draw(parameters: renderparm).map { $0.toString() }.joined(separator: "\n")
      
//      let ds: NSString = paint
//      try? ds.write(toFile: "test.ans", atomically: true, encoding: String.Encoding.utf8.rawValue )
      
//      print(paint)
      
      
      
//      Thread.sleep(forTimeInterval: 0.02)
      
      view.clear()
//      Ansi.Cursor.position(
//        row: view.origin.y.toInt(),
//        column: view.origin.x.toInt()).stdout()
//      print(view.draw(parameters: renderparm).map { $0.toString() }.joined(separator: "\n"))
    }
    Ansi.Color.resetAll().stdout()
    Ansi.Set.cursorOn().stdout()
  }
}
