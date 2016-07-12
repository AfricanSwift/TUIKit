//
//          File:   UIBarStyle.swift
//    Created by:   African Swift

import Foundation


public enum TUIBarStyle
{
  /// ````
  /// .bar1:
  ///  50% |⣿⣿⣿⣿⣿⣿⠶⠶⠶⠶⠶⠶| status message
  ///
  /// .bar2:
  ///  50% |▓▓▓▓▓▓░░░░░░| status message
  ///
  /// .bar3:
  ///  50% [☓☓☓☓☓☓......] status message
  ///
  /// .bar4:
  ///  50% |⬜️⬜️⬜️⬜️⬜️⬜️......| status message
  ///
  /// .bar5:
  ///  50% |▫️▫️▫️▫️▫️▫️⠒⠒⠒⠒⠒⠒| status message
  /// ````
  case bar1, bar2, bar3, bar4, bar5
  
  /// ````
  /// .gradient1:
  /// 100% |🌕🌖🌗🌘🌑🌒🌓🌔🌕| status message
  ///
  /// .gradient2:
  /// 100% ▁▃▄▅▆▇█ status message
  ///
  /// .micro1:
  /// |100%| status message
  ///
  /// .micro2:
  ///  50% |▓▓░░| status message
  ///
  /// ````
  case gradient1, gradient2, micro1, micro2
  
  /// ,custom(bar: TUIBar):
  ///
  /// ````
  /// let c = [Character("0")]
  /// let i = Character(".")
  /// let cBar = TUIBar(format: [.percent, .text(" {"),
  ///                            .complete(c), .incomplete(i),
  ///                            .text("} "), .elapsed,
  ///                            .text(" "), .message], 
  ///                   width: 12)
  ///
  /// var bar = TUIProgress(style: .custom(bar: cBar), message: "Hello world!")
  ///
  /// // result = 50% {000000......} 00:05 Hello world!
  /// ````
  case custom(bar: TUIBar)
  
  internal static var allCases: [TUIBarStyle] =
    [.bar1, .bar2, .bar3, .bar4, .bar5, .gradient1, .gradient2, .micro1, .micro2]
  
  internal func toTUIBar() -> TUIBar
  {
    return matchBars1()
  }
}

// MARK: -
// MARK: matchBars1 -
public extension TUIBarStyle
{
  private func matchBars1() -> TUIBar
  {
    switch self
    {
    ///  50% |⣿⣿⣿⠶⠶⠶| status message
    case .bar1:
      let c: [Character] = ["⣿"]
      let i: Character = "⠶"
      let bits: [TUIBarBits] = [.percent, .text(" |"),
                                .complete(c), .incomplete(i),
                                .text("| "), .message]
      return TUIBar(format: bits, width: 6)
      
    ///  50% |▓▓▓░░░| status message
    case .bar2:
      let c: [Character] = ["▓"]
      let i: Character = "░"
      let bits: [TUIBarBits] = [.percent, .text(" |"),
                                .complete(c), .incomplete(i),
                                .text("| "), .message]
      return TUIBar(format: bits, width: 6)
      
    ///  50% |☓☓☓...| status message
    case .bar3:
      let c: [Character] = ["☓"]
      let i: Character = "."
      let bits: [TUIBarBits] = [.percent, .text(" |"),
                                .complete(c), .incomplete(i),
                                .text("| "), .message]
      return TUIBar(format: bits, width: 6)
      
    ///  50% |⬜️⬜️⬜️...| status message
    case .bar4:
      let c: [Character] = ["⬜️"]
      let i: Character = " "
      let bits: [TUIBarBits] = [.percent, .text(" |"),
                                .complete(c), .incomplete(i),
                                .text("| "), .message]
      return TUIBar(format: bits, width: 6, kern: " ")
      
    ///  50% |▫️▫️▫️⠒⠒⠒| status message
    case .bar5:
      let c: [Character] = ["▫️"]
      let i: Character = " "
      let bits: [TUIBarBits] = [.percent, .text(" |"),
                                .complete(c), .incomplete(i),
                                .text("| "), .message]
      return TUIBar(format: bits, width: 6, kern: " ")
      
    default:
      return matchGradient()
    }
  }
}

// MARK: -
// MARK: matchGradient -
public extension TUIBarStyle
{
  private func matchGradient() -> TUIBar
  {
    switch self
    {
    /// 100% |🌕🌖🌗🌘🌑🌒🌓🌔🌕| status message
    case .gradient1:
      let c: [Character] = ["🌕", "🌖", "🌗", "🌘", "🌑", "🌒", "🌓", "🌔", "🌕"]
      let i: Character = " "
      let bits: [TUIBarBits] = [.percent, .text(" |"),
                                .complete(c), .incomplete(i),
                                .text("| "), .message]
      return TUIBar(format: bits, width: 4, kern: " ")
    
    /// 100% ▁▃▄▅▆▇█ status message
    case .gradient2:
      let c: [Character] = ["▁", "▃", "▅", "▆", "▇"]
      let i: Character = " "
      let bits: [TUIBarBits] = [.percent, .text(" "), .complete(c),
                                .incomplete(i), .text(" "), .message]
      return TUIBar(format: bits, width: 4)
      
    default:
      return matchMicro()
    }
  }
}

// MARK: -
// MARK: matchMicro -
public extension TUIBarStyle
{
  private func matchMicro() -> TUIBar
  {
    switch self
    {
    /// [ 100%] status message
    case .micro1:
      let bits: [TUIBarBits] = [.text("["), .percent, .text("] "), .message]
      return TUIBar(format: bits, width: 0)
      
    ///  50% |▓▓░░| status message
    case .micro2:
      let c: [Character] = ["▓"]
      let i: Character = "░"
      let bits: [TUIBarBits] = [.percent, .text(" |"),
                                .complete(c), .incomplete(i),
                                .text("| "), .message]
      return TUIBar(format: bits, width: 4)

    /// Custom Progressbar
    case .custom(let bar):
      return bar
      
    default:
      let c: [Character] = ["⣿"]
      let i: Character = "⠶"
      let bits: [TUIBarBits] = [.percent, .text(" |"),
                                .complete(c), .incomplete(i),
                                .text("| "), .message]
      return TUIBar(format: bits, width: 6)
    }
  }
}
