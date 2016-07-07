//
//          File:   TUIView+ProgressBar.swift
//    Created by:   African Swift

import Darwin


public struct TUIProgress
{
  private var percent: Double
  private let style: TUIProgressStyle
  private var status = [String]()
  
  internal init(
//    origin: TUIPoint,
//    size: TUISize,
    style: TUIProgressStyle,
    percent: Double,
    status: String)
  {
    self.percent = percent
    self.style = style
    self.status.append(status)
  }
  
  
  internal mutating func update(_ percent: Double, status: String)
  {
    self.percent = percent
    self.status.append(status)
  }
  
  internal func draw()
  {
    guard let style = self.style.toParts() else { return }
    let status = self.status.last ?? ""
    let width = style.width
    let complete = Int(self.percent * Double(width))
    let incomplete = width - complete
    let value = Int(self.percent * 100)
    let progress = String(format: "%3d", value)
    
    let prefix = style
      .prefix
      .replacingOccurrences(of: "<p>", with: progress)
      .replacingOccurrences(of: "<s>", with: status)
    
    let suffix = style
      .suffix
      .replacingOccurrences(of: "<p>", with: progress)
      .replacingOccurrences(of: "<s>", with: status)
    
    let midfix = style
      .midfix
      .replacingOccurrences(of: "<p>", with: progress)
    
    let barComplete: String
    let barInComplete: String
    if style.complete.count > 1
    {
      let completeWidth = Int(Double(style.complete.count) * self.percent)
      barComplete = (0..<completeWidth)
        .map
        { style
          .complete[$0]
        }.joined(separator: "")
      let incompleteWidth = width - completeWidth
      barInComplete = (0..<incompleteWidth)
        .map
        { _ in style
          .incomplete
        }.joined(separator: "")
    }
    else
    {
      barComplete = (0..<complete)
        .map
        { _ in style
          .complete
          .joined(separator: "")
        }.joined(separator: "")
      
      barInComplete = (0..<incomplete)
        .map
        { _ in style
          .incomplete
        }.joined(separator: "")
    }
    
//    Ansi.Display.Erase.all().stdout()
//    Ansi.Cursor.position().stdout()
    print(prefix + barComplete.foreground(.color256(31)) + midfix.attribute(.reset) +
      barInComplete.foreground(.color256(234)) + suffix.attribute(.reset), terminator: "")
  }
  
}

// MARK: -
// MARK: Progress Bar Styles -
public enum TUIProgressStyle
{
  /// ````
  /// .bar1:
  /// 50% ⣿⣿⣿⣿⣿⣿⠶⠶⠶⠶⠶⠶ status message
  ///
  /// .bar2:
  /// ▓▓▓▓▓▓░░░░░░  50% status message
  ///
  /// .bar3:
  /// ▓▓▓▓▓▓ 50% ░░░░░░ status message
  ///
  /// .bar4:
  ///  50% |▓▓▓▓▓▓░░░░░░| status message
  ///
  /// .bar5:
  /// |▓▓▓▓▓▓░░░░░░|  50% status message
  ///
  /// .bar6:
  /// |▓▓▓▓▓▓▓ 50% ░░░░░░| status message
  ///
  /// .bar7:
  ///┌────────────┐
  ///│▓▓▓▓▓▓░░░░░░│  50% status message
  ///└────────────┘
  ///
  /// .bar8:
  ///     ┌────────────┐
  /// 50% │▓▓▓▓▓▓░░░░░░│ status message
  ///     └────────────┘
  /// ````
  case bar1, bar2, bar3, bar4, bar5, bar6, bar7, bar8
  
  /// ````
  /// .gradient1: 
  /// 100% |▁▁▃▃▄▄▅▅▆▆▇▇██| status message
  ///
  /// .gradient2: 
  /// 100% |▉▊▋▌▍▎▏▎▍▌▋▊▉| status message
  ///
  /// .dot1: 
  ///  50% |⚫︎⚫︎⚫︎⚫︎⚫︎⚫︎⚪︎⚪︎⚪︎⚪︎⚪︎⚪︎| status message
  ///
  /// .dot2: 
  ///  50% |✺✺✺✺✺✺......| status message
  ///
  /// .bracket1: 
  ///  50% |⸩⸩⸩⸩⸩⸩......| status message
  ///
  /// .bracket2: 
  ///  50% |⸩⸩⸩⸩⸩⸩------| status message
  ///
  /// .dash1: 
  ///  50% |======❘......| status message
  ///
  /// .dash2: 
  /// |------  50% ------| status message
  /// ````
  case gradient1, gradient2, dot1, dot2, bracket1, bracket2, dash1, dash2
  
  /// ````
  /// .minimum1:
  /// |100%| status message
  ///
  /// .minimum2:
  /// 100% > status message
  ///
  /// .minimum3:
  ///  50% |▓▓░░| status message
  ///
  /// .minimum4:
  ///  50% ▓▓░░ status message
  ///
  /// .minimum5:
  ///  100% |▁▃▄▅▆▇█| status message
  /// ````
  case minimum1, minimum2, minimum3, minimum4, minimum5
  
  internal static var allCases: [TUIProgressStyle] =
    [.bar1, .bar2, .bar3, .bar4, .bar5, .bar6, .bar7, .bar8,
     .gradient1, .gradient2, .dot1, .dot2, .bracket1, .bracket2,
     .dash1, .dash2, .minimum1, .minimum2, .minimum3, .minimum4, .minimum5]
  
  internal func toParts() -> TUIProgressParts?
  {
    return matchBars1()
  }
}

// MARK: -
// MARK: toParts: matchBars1 -
private extension TUIProgressStyle
{
  private func matchBars1() -> TUIProgressParts?
  {
    switch self
    {
      // 123456789012345678901234567890
      //  50% ⣿⣿⣿⣿⣿⣿⠶⠶⠶⠶⠶⠶ status message
      case bar1:
        return TUIProgressParts(
          prefix: "<p>% ",
          midfix: "",
          suffix: " <s>",
          complete: ["⣿"],
          incomplete: "⠒",
          width: 12)
        
      // 123456789012345678901234567890
      // ▓▓▓▓▓▓░░░░░░  50% status message
      case bar2:
        return TUIProgressParts(
          prefix: "",
          midfix: "",
          suffix: " <p>% <s>",
          complete: ["▫️"],
          incomplete: "░",
          width: 12)
        
      // 123456789012345678901234567890
      // ▓▓▓▓▓▓ 50% ░░░░░░ status message
      case bar3:
        return TUIProgressParts(
          prefix: "",
          midfix: " <p>% ",
          suffix: " <s>",
          complete: ["█"],
          incomplete: "░",
          width: 12)
      
      // 123456789012345678901234567890
      //  50% |▓▓▓▓▓▓░░░░░░| status message
      case bar4:
        return TUIProgressParts(
          prefix: "<p>% |",
          midfix: "",
          suffix: "| <s>",
          complete: ["█"],
          incomplete: "░",
          width: 12)
      default:
        return matchBars2()
    }
  }
}

// MARK: -
// MARK: toParts: matchBars2 -
private extension TUIProgressStyle
{
  private func matchBars2() -> TUIProgressParts?
  {
    switch self
    {
      // 123456789012345678901234567890
      // |▓▓▓▓▓▓░░░░░░|  50% status message
      case bar5:
        return TUIProgressParts(
          prefix: "|",
          midfix: "",
          suffix: "| <p>% <s>",
          complete: ["█"],
          incomplete: "░",
          width: 12)
        
      // 123456789012345678901234567890
      // |▓▓▓▓▓▓▓ 50% ░░░░░░| status message
      case bar6:
        return TUIProgressParts(
          prefix: "|",
          midfix: " <p>% ",
          suffix: "| <s>",
          complete: ["█"],
          incomplete: "░",
          width: 12)
      
      // 123456789012345678901234567890
      // ┌────────────┐
      // │▓▓▓▓▓▓░░░░░░│ 50% status message
      // └────────────┘
      case bar7:
        return TUIProgressParts(
          prefix: "┌────────────┐\n|",
          midfix: "",
          suffix: "| <p>% <s>\n└────────────┘",
          complete: ["█"],
          incomplete: "░",
          width: 12)
      
      // 123456789012345678901234567890
      //      ┌────────────┐
      //  50% │▓▓▓▓▓▓░░░░░░│ status message
      //      └────────────┘
      case bar8:
        return TUIProgressParts(
          prefix: "┌────────────┐\n<p>% |",
          midfix: "",
          suffix: "| <s>\n└────────────┘",
          complete: ["█"],
          incomplete: "░",
          width: 12)
      default:
        return matchGradients()
    }
  }
}

// MARK: -
// MARK: toParts: matchGradients -
private extension TUIProgressStyle
{
  private func matchGradients() -> TUIProgressParts?
  {
    switch self
    {
      // 123456789012345678901234567890
      // 100% |▁▁▃▃▄▄▅▅▆▆▇▇██| status message
      case gradient1:
        return TUIProgressParts(
          prefix: "<p>% |",
          midfix: "",
          suffix: "| <s>",
          complete: ["▁", "▁", "▃", "▃", "▄", "▄", "▅", "▅", "▆", "▆", "▇", "▇", "█", "█"],
          incomplete: " ",
          width: 14)
        
      // 123456789012345678901234567890
      // 100% |▉▊▋▌▍▎▏▎▍▌▋▊▉| status message
      case gradient2:
        return TUIProgressParts(
          prefix: "<p>% |",
          midfix: "",
          suffix: "| <s>",
          complete: ["▉", "▊", "▋", "▌", "▍", "▎", "▏", "▎", "▍", "▌", "▋", "▊", "▉"],
          incomplete: ".",
          width: 13)
      default:
        return matchDots()
    }
  }
}

// MARK: -
// MARK: toParts: matchDots -
private extension TUIProgressStyle
{
  private func matchDots() -> TUIProgressParts?
  {
    switch self
    {
      // 123456789012345678901234567890
      //  50% |⚫︎⚫︎⚫︎⚫︎⚫︎⚫︎⚪︎⚪︎⚪︎⚪︎⚪︎⚪︎| status message
      case dot1:
        return TUIProgressParts(
          prefix: "<p>% |",
          midfix: "",
          suffix: "| <s>",
          complete: ["⚫︎"],
          incomplete: "⚪︎",
          width: 12)
        
      // 123456789012345678901234567890
      //  50% |✺✺✺✺✺✺......| status message
      case dot2:
        return TUIProgressParts(
          prefix: "<p>% |",
          midfix: "",
          suffix: "| <s>",
          complete: ["✺"],
          incomplete: ".",
          width: 12)
        
      default:
        return matchBrackets()
    }
  }
}

// MARK: -
// MARK: toParts: matchBrackets -
private extension TUIProgressStyle
{
  private func matchBrackets() -> TUIProgressParts?
  {
    switch self
    {
      // 123456789012345678901234567890
      //  50% |⸩⸩⸩⸩⸩⸩......| status message
      case bracket1:
        return TUIProgressParts(
          prefix: "<p>% |",
          midfix: "",
          suffix: "| <s>",
          complete: ["⸩"],
          incomplete: ".",
          width: 12)
        
      // 123456789012345678901234567890
      //  50% |⸩⸩⸩⸩⸩⸩------| status message
      case bracket2:
        return TUIProgressParts(
          prefix: "<p>% |",
          midfix: "",
          suffix: "| <s>",
          complete: ["⸩"],
          incomplete: "-",
          width: 12)
        
      default:
        return matchDashes()
    }
  }
}

// MARK: -
// MARK: toParts: matchDashes -
private extension TUIProgressStyle
{
  private func matchDashes() -> TUIProgressParts?
  {
    switch self
    {
      // 123456789012345678901234567890
      //  50% |======❘......| status message
      case dash1:
        return TUIProgressParts(
          prefix: "|",
          midfix: "|",
          suffix: "| <p>% <s>",
          complete: ["="],
          incomplete: ".",
          width: 12)
        
      // 123456789012345678901234567890
      // |------  50% ------| status message
      case dash2:
        return TUIProgressParts(
          prefix: "|",
          midfix: " <p>% ",
          suffix: "| <s>",
          complete: ["-"],
          incomplete: "-",
          width: 12)
      default:
        return matchesMinimum()
    }
  }
}

private extension TUIProgressStyle
{
  private func matchesMinimum() -> TUIProgressParts?
  {
    switch self
    {
      // 123456789012345678901234567890
      // |100%| status message
      case minimum1:
        return TUIProgressParts(
          prefix: "|",
          midfix: "<p>%",
          suffix: "| <s>",
          complete: [""],
          incomplete: "",
          width: 4)
      
      // 123456789012345678901234567890
      // 100% > status message
      case minimum2:
        return TUIProgressParts(
          prefix: "",
          midfix: "<p>%",
          suffix: " > <s>",
          complete: [""],
          incomplete: "",
          width: 4)
      
      // 123456789012345678901234567890
      //  50% |▓▓░░| status message
      case minimum3:
        return TUIProgressParts(
          prefix: "<p>% |",
          midfix: "",
          suffix: "| <s>",
          complete: ["▓"],
          incomplete: "░",
          width: 4)
        
      // 123456789012345678901234567890
      //  50% ▓▓░░ status message
      case minimum4:
        return TUIProgressParts(
          prefix: "<p>% ",
          midfix: "",
          suffix: " <s>",
          complete: ["▓"],
          incomplete: "░",
          width: 4)
        
      // 123456789012345678901234567890
      // 100% |▁▃▄▅▆▇█| status message
      case minimum5:
        return TUIProgressParts(
          prefix: "<p>% |",
          midfix: "",
          suffix: "| <s>",
          complete: ["▁", "▃", "▄", "▅", "▆", "▇", "█"],
          incomplete: " ",
          width: 7)
        
      default:
        return nil
    }
  }
}

// MARK: -
// MARK: Progress Bar Parts -
public struct TUIProgressParts
{
  let prefix: String
  let midfix: String
  let suffix: String
  let complete: [String]
  let incomplete: String
  let width: Int
}
