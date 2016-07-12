//
//          File:   Example+ProgressBars.swift
//    Created by:   African Swift

import Foundation

public extension Example
{
  public struct ProgressBars
  {
    public static func demo()
    {
      
      let c: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].reversed()
      let i = Character(".")
      let spinner: [Character] = ["▁", "▃", "▄", "▅", "▆", "▇", "█", "▇", "▆", "▅", "▄", "▃"]
      let animate: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].reversed()
      let bellsWhistles = TUIBar(format: [.percent, .text(" <"),
                                 .complete(c), .incomplete(i),
                                 .text("> "), .remaining,
                                 .text(" "), .message, .text(" "),
                                 .scanner("0","-"), .text(" "),
                                 .spinner(spinner), .text("  "),
                                 .animate(animate, "."), .text(" "),
                                 .cylon("0", "-")],
                        width: 12)
      
      var bar = TUIProgress(style: .custom(bar: bellsWhistles), message: "Hello world!")
      bar.color.complete = Ansi.Color.Foreground.color256(index: 194)
      bar.style.width = 6
      
      for i in 0...100
      {
        bar.advance(message: "Hello world! : \(i)")
        bar.draw()
        Thread.sleep(forTimeInterval: 0.05)
      }

      Ansi.resetAll().stdout()
      Thread.sleep(forTimeInterval: 1)
    }
  }
}
