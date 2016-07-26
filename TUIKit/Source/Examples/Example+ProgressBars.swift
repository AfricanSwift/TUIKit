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
      var bar1 = TUIStatus(message: "Hello world!")
      for i in 1...100
      {
        bar1.advance(message: "Hello world! : \(i)")
        Thread.sleep(forTimeInterval: 0.01)
      }
      
      var bar2 = TUIStatus(format: TUIStatus.Bars.gradient1, message: "Hello world!")
      bar2.color.message = Ansi.Color.Foreground.lightRed()
      for i in 1...100
      {
        bar2.advance(message: "Hello world! : \(i)")
        Thread.sleep(forTimeInterval: 0.01)
      }
      
      let numbers: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].reversed()
      let spinner: [Character] = TUIStatus.Spinners.runner.characters.map { $0 }
      let bellsWhistles: [TUIStatus.Bits] =
        [.percent, .text(" <"),
         .complete(sequence: ["😬"], width: 10, kern: " "),
         .incomplete(filler: "💀", width: 10, kern: " "),
         .text(" "), .complete(sequence: numbers, width: numbers.count, kern: nil),
         .incomplete(filler: ".", width: numbers.count, kern: nil),
         .text("> "), .remaining,
         .text(" "), .scan(line: "0", filler: "-", width: 4, kern: nil),
         .text(" "), .spinner(sequence: spinner, end: (success: "✔︎", failure: "╳"), kern: " "),
         .text("  "), .animate(sequence: numbers, filler: ".", kern: nil),
         .text(" "), .cylon(eye: "0", filler: "-", width: 4, kern: nil),
         .text(" "), .message]
      
      var bar3 = TUIStatus(format: bellsWhistles, message: "Hello world!")
      for i in 1...100
      {
        bar3.advance(message: "Hello world! : \(i)")
        Thread.sleep(forTimeInterval: 0.01)
        if i > 50
        {
          bar3.failed()
          break
        }
      }
      
      let spinner2: [Character] = TUIStatus.Spinners.dots11.characters.map { $0 }
      let spin2 = TUIStatus.Bits.spinner(
        sequence: spinner2, end: (success: "✔︎", failure: "╳"), kern: nil)
      var bar4 = TUIStatus(
        format: [spin2, .text(" "), .message], message: "")
      for i in 1...100
      {
        bar4.advance(message: "Hello world! : \(i)")
        Thread.sleep(forTimeInterval: 0.05)
      }
    }
  }
}
