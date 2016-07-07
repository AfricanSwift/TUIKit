//
//          File:   TUIView+ProgressBar.swift
//    Created by:   African Swift

import Darwin


public struct TUIProgress
{
  private var percent: Double
  private let Style: TUIProgressStyle
  private var status = [String]()
  
}


public enum TUIProgressStyle
{
  // 123456789012345678901234567890
  //  50% ▓▓▓▓▓▓░░░░░░ status message
  case bar1
  
  // 123456789012345678901234567890
  // ▓▓▓▓▓▓░░░░░░  50% status message
  case bar2
  
  // 123456789012345678901234567890
  // ▓▓▓▓▓▓ 50% ░░░░░░ status message
  case bar3
  
  // 123456789012345678901234567890
  //  50% |▓▓▓▓▓▓░░░░░░| status message
  case bar4
  
  // 123456789012345678901234567890
  // |▓▓▓▓▓▓░░░░░░|  50% status message
  case bar5
  
  // 123456789012345678901234567890
  // |▓▓▓▓▓▓▓ 50% ░░░░░░| status message
  case bar6
  
  // 123456789012345678901234567890
  // ┌────────────┐
  // │▓▓▓▓▓▓░░░░░░│  50% status message
  // └────────────┘
  case bar7
  
  // 123456789012345678901234567890
  //      ┌────────────┐
  //  50% │▓▓▓▓▓▓░░░░░░│ status message
  //      └────────────┘
  case bar8
  
  // 123456789012345678901234567890
  // 100% ▁▁▃▃▄▄▅▅▆▆▇▇██| status message
  case gradient1
  
  // 123456789012345678901234567890
  // 100% |▉▊▋▌▍▎▏▎▍▌▋▊▉| status message
  case gradient2
  
  // 123456789012345678901234567890
  // |⚫︎⚫︎⚫︎⚫︎⚫︎⚫︎⚪︎⚪︎⚪︎⚪︎⚪︎⚪︎|  50% status message
  case dot1
  
  // 123456789012345678901234567890
  // |✺✺✺✺✺✺......|  50% status message
  case dot2
  
  // 123456789012345678901234567890
  // |⸩⸩⸩⸩⸩⸩......|  50% status message
  case bracket1
  
  // 123456789012345678901234567890
  // |⸩⸩⸩⸩⸩⸩------|  50% status message
  case bracket2
  
  // 123456789012345678901234567890
  // |======❘......|  50% status message
  case dash1
  
  // 123456789012345678901234567890
  // |------  50% ------|  50% status message
  case dash2
  
  
  internal static var allCases: [TUIProgressStyle] =
    [.bar1, .bar2, .bar3, .bar4, .bar5, .bar6, .bar7, .bar8,
     .gradient1, .gradient2, .dot1, .dot2, .bracket1, .bracket2,
     .dash1, .dash2]
  
  internal func toParts() -> TUIProgressParts?
  {
    return matchBars()
  }
  
  private func matchBars() -> TUIProgressParts?
  {
    switch self
    {
    case bar1:
      return TUIProgressParts(
        prefix: "<p>% ",
        midfix: "",
        suffix: " <s>",
        complete: ["█"],
        incomplete: "░",
        width: 12)
    case bar2:
      return TUIProgressParts(
        prefix: "",
        midfix: "",
        suffix: " <p>% <s>",
        complete: ["█"],
        incomplete: "░",
        width: 12)
    case bar3:
    case bar4:
    case bar5:
    case bar6:
    case bar7:
    case bar8:
    default:
      
    }
  }
  
}

public struct TUIProgressParts
{
  let prefix: String
  let midfix: String
  let suffix: String
  let complete: [String]
  let incomplete: String
  let width: Int
}
