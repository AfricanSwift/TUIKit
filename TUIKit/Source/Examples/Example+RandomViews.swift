//
//          File:   Example+RandomViews.swift
//    Created by:   African Swift

import Foundation

public extension Example
{
  public struct RandomViews
  {
    public static func demo()
    {
      let current = TUIWindow.ttysize()?.character ?? TUISize(width: 50, height: 50)
      let color1 = Ansi.Color.Foreground.white()
        + Ansi.Color.Background.colorRGB256(red: 75, green: 25, blue: 50)
      let color2 = Ansi.Color.Background.color256(index: 17)
      var view = TUIView(x: 10, y: 6, width: 41, height: 41, border: .single,
                         borderColor: color1, backgroundColor: color2)
      let rect = TUIRectangle(x: 1, y: 1, width: 40, height: 40)
      for i in stride(from: 1.0, through: 39.0, by: 10)
      {
        view.drawRoundedRectangle(rect: rect, radius: i)
      }
      
      for _ in 0...1000
      {
        let x = Int(arc4random_uniform(UInt32(current.width - view.size.character.width - 1)))
        let y = Int(arc4random_uniform(UInt32(current.height - view.size.character.height - 1)))
        view.move(x: x, y: y)
        view.draw(atOrigin: true)
      }
    }
  }
}
