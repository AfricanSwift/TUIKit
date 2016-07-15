//
//          File:   TUIStatus+Spinner.swift
//    Created by:   African Swift

import Darwin

public extension TUIStatus.Bars
{
  ///  50% |⣿⣿⣿⠶⠶⠶| status message
  public static let bar1: [TUIStatus.Bits] =
    [.percent, .text(" |"), .complete(sequence: ["⣿"], width: 6, kern: nil),
     .incomplete(filler: "⠶", width: 6, kern: nil),
     .text("| "), .message]
  
  ///  50% |▓▓▓▓▓▓░░░░░░| status message
  public static let bar2: [TUIStatus.Bits] =
    [.percent, .text(" |"),
     .complete(sequence: ["▓"], width: 6, kern: nil),
     .incomplete(filler: "░", width: 6, kern: nil),
     .text("| "), .message]
  
  ///  50% [☓☓☓☓☓☓......] status message
  public static let bar3: [TUIStatus.Bits] =
    [.percent, .text(" |"),
     .complete(sequence: ["☓"], width: 6, kern: nil),
     .incomplete(filler: ".", width: 6, kern: nil),
     .text("| "), .message]
  
  ///  50% |⬜️⬜️⬜️...| status message
  public static let bar4: [TUIStatus.Bits] =
    [.percent, .text(" |"),
     .complete(sequence: ["⬜️"], width: 6, kern: " "),
     .incomplete(filler: " ", width: 6, kern: " "),
     .text("| "), .message]
  
  ///  50% |▫️▫️▫️⠒⠒⠒| status message
  public static let bar5: [TUIStatus.Bits] =
    [.percent, .text(" |"),
     .complete(sequence: ["▫️"], width: 6, kern: " "),
     .incomplete(filler: " ", width: 6, kern: " "),
     .text("| "), .message]
  
  /// 100% |🌑🌒🌓🌔🌕🌖🌗🌘| status message
  public static let gradient1: [TUIStatus.Bits] =
    [.percent, .text(" |"),
     .complete(sequence: TUIStatus.Spinners.moon.characters.map { $0 }, width: 8, kern: " "),
     .incomplete(filler: " ", width: 8, kern: " "),
     .text("| "), .message]
  
  /// 100% ▁▃▄▅▆▇█ status message
  public static let gradient2: [TUIStatus.Bits] =
    [.percent, .text(" "),
     .complete(sequence: TUIStatus.Spinners.growUp.characters.map { $0 }, width: 6, kern: nil),
     .incomplete(filler: " ", width: 6, kern: nil),
     .text(" "), .message]
  
  /// [ 100%] status message
  public static let micro1: [TUIStatus.Bits] =
    [.text("["), .percent, .text("] "), .message]
  
  ///  50% |▓▓░░| status message
  public static let micro2: [TUIStatus.Bits] =
    [.percent, .text(" |"),
     .complete(sequence: ["▓"], width: 4, kern: nil),
     .incomplete(filler: "░", width: 4, kern: nil),
     .text("| "), .message]
}
