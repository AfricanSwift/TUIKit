//
//          File:   TUIProgress.swift
//    Created by:   African Swift

import Foundation

public enum TUIBarStyle
{
  /// ````
  /// .bar1:
  ///  50% |⣿⣿⣿⣿⣿⣿⠶⠶⠶⠶⠶⠶| status message
  ///
  /// .bar2:
  ///  50% |🄞🄞🄞🄞🄞🄞......| status message
  ///
  /// .bar3:
  ///  50% |▓▓▓▓▓▓░░░░░░| status message
  ///
  /// .bar4:
  ///  50% |⎕⎕⎕⎕⎕⎕......| status message
  ///
  /// .bar5:
  ///  50% |⌽⌽⌽⌽⌽⌽......| status message
  ///
  /// .bar6:
  ///  50% |⏥⏥⏥⏥⏥⏥......| status message
  ///
  /// .bar7:
  ///  50% |🅞🅞🅞🅞🅞🅞......| status message
  ///
  /// .bar8:
  ///  50% |🄾🄾🄾🄾🄾🄾......| status message
  /// 
  /// .bar9:
  ///  50% |⟩⟩⟩⟩⟩⟩......| status message
  ///
  /// .bar10:
  ///  50% |⟫⟫⟫⟫⟫⟫......| status message
  ///
  /// .bar11:
  ///  50% |♡♡♡♡♡♡......| status message
  ///
  /// .bar12:
  ///  50% |☆☆☆☆☆☆......| status message
  ///
  /// .bar13:
  ///  50% [★★★★★★......] status message
  ///
  /// .bar14:
  ///  50% [☓☓☓☓☓☓......] status message
  ///
  /// .bar15:
  ///  50% |🀆🀆🀆🀆🀆🀆......| status message
  ///
  /// .bar16:
  ///  50% |╳╳╳╳╳╳------| status message
  ///
  /// .bar17:
  ///  50% |║║║║║║------| status message
  ///
  /// .bar18:
  ///  50% [||||||------] status message
  ///
  /// .bar19:
  ///  50% |⚫︎⚫︎⚫︎⚫︎⚫︎⚫︎⚪︎⚪︎⚪︎⚪︎⚪︎⚪︎| status message
  ///
  /// .bar20:
  ///  50% |✺✺✺✺✺✺......| status message
  ///
  /// .bar21:
  ///  50% |⸩⸩⸩⸩⸩⸩......| status message
  ///
  /// .bar22:
  ///  50% |⸩⸩⸩⸩⸩⸩------| status message
  ///
  /// .bar23:
  ///  50% |======❘......| status message
  ///
  /// .bar24:
  ///  50% |🎯🎯🎯🎯🎯🎯......| status message
  ///
  /// .bar25:
  ///  50% |🔮🔮🔮🔮🔮🔮......| status message
  ///
  /// .bar26:
  ///  50% |💊💊💊💊💊💊......| status message
  ///
  /// .bar27:
  ///  50% |⭕️⭕️⭕️⭕️⭕️⭕️......| status message
  ///
  /// .bar28:
  ///  50% |🔆🔆🔆🔆🔆🔆......| status message
  ///
  /// .bar29:
  ///  50% |🔴🔴🔴🔴🔴🔴......| status message
  ///
  /// .bar30:
  ///  50% |🔶🔶🔶🔶🔶🔶......| status message
  ///
  /// .bar31:
  ///  50% |⬜️⬜️⬜️⬜️⬜️⬜️......| status message
  ///
  /// .bar32:
  ///  50% |▫️▫️▫️▫️▫️▫️⠒⠒⠒⠒⠒⠒| status message
  /// ````
  case bar1, bar2, bar3, bar4, bar5, bar6, bar7, bar8, bar9, bar10,
  bar11, bar12, bar13, bar14, bar15, bar16, bar17, bar18, bar19, bar20,
  bar21, bar22, bar23, bar24, bar25, bar26, bar27, bar28, bar29, bar30,
  bar31, bar32
  
  /// ````
  /// .gradient1:
  /// 100% |🌕🌖🌗🌘🌑🌒🌓🌔🌕| status message
  ///
  /// .gradient2:
  /// 100% |▁▁▃▃▄▄▅▅▆▆▇▇██| status message
  ///
  /// .gradient3:
  /// 100% |▉▊▋▌▍▎▏▎▍▌▋▊▉| status message
  ///
  /// .micro1:
  /// |100%| status message
  ///
  /// .micro2:
  ///  50% |▓▓░░| status message
  ///
  /// .micro3:
  ///  50% |⣿⣿⠶⠶| status message
  ///
  /// .micro4:
  ///  100% |▁▃▄▅▆▇█| status message
  /// ````
  case gradient1, gradient2, gradient3, micro1, micro2, micro3, micro4
  
  internal static var allCases: [TUIBarStyle] =
    [.bar1, .bar2, .bar3, .bar4, .bar5, .bar6, .bar7, .bar8, .bar9, .bar10,
     .bar11, .bar12, .bar13, .bar14, .bar15, .bar16, .bar17, .bar18, .bar19, .bar20,
     .bar21, .bar22, .bar23, .bar24, .bar25, .bar26, .bar27, .bar28, .bar29, .bar30,
     .bar31, .bar32, .gradient1, .gradient2, .gradient3, .micro1, .micro2, .micro3, .micro4]
  
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
      ///  50% |⣿⣿⣿⣿⣿⣿⠶⠶⠶⠶⠶⠶| status message
      case .bar1:
        let gauge = TUIBarGauge(complete: ["⣿"], incomplete: "⠶", width: 12)
        return TUIBar(gauge: gauge)
      
      ///  50% |🄞🄞🄞🄞🄞🄞......| status message
      case .bar2:
        let gauge = TUIBarGauge(complete: ["🄞"], incomplete: " ", width: 6, kernFiller: " ")
        return TUIBar(gauge: gauge)
      
      ///  50% |▓▓▓▓▓▓░░░░░░| status message
      case .bar3:
        let gauge = TUIBarGauge(complete: ["▓"], incomplete: "░", width: 12)
        return TUIBar(gauge: gauge)
      
      ///  50% |⎕⎕⎕⎕⎕⎕......| status message
      case .bar4:
        let gauge = TUIBarGauge(complete: ["⎕"], incomplete: ".", width: 12)
        return TUIBar(gauge: gauge)

      default:
        return matchBars2()
    }
  }
}

// MARK: -
// MARK: matchBars2 -
public extension TUIBarStyle
{
  private func matchBars2() -> TUIBar
  {
    switch self
    {
      ///  50% |⌽⌽⌽⌽⌽⌽......| status message
      case .bar5:
        let gauge = TUIBarGauge(complete: ["⌽"], incomplete: " ", width: 6, kernFiller: " ")
        return TUIBar(gauge: gauge)
        
      ///  50% |⏥⏥⏥⏥⏥⏥......| status message
      case .bar6:
        let gauge = TUIBarGauge(complete: ["⏥"], incomplete: ".", width: 12)
        return TUIBar(gauge: gauge)
        
      ///  50% |🅞🅞🅞🅞🅞🅞......| status message
      case .bar7:
        let gauge = TUIBarGauge(complete: ["🅞"], incomplete: " ", width: 6, kernFiller: " ")
        return TUIBar(gauge: gauge)
        
      ///  50% |🄾🄾🄾🄾🄾🄾......| status message
      case .bar8:
        let gauge = TUIBarGauge(complete: ["🄾"], incomplete: " ", width: 6, kernFiller: " ")
        return TUIBar(gauge: gauge)

      default:
        return matchBars3()
    }
  }
}

// MARK: -
// MARK: matchBars3 -
public extension TUIBarStyle
{
  private func matchBars3() -> TUIBar
  {
    switch self
    {
      ///  50% |⟩⟩⟩⟩⟩⟩......| status message
      case .bar9:
        let gauge = TUIBarGauge(complete: ["⟩"], incomplete: ".", width: 12)
        return TUIBar(gauge: gauge)
        
      ///  50% |⟫⟫⟫⟫⟫⟫......| status message
      case .bar10:
        let gauge = TUIBarGauge(complete: ["⟫"], incomplete: ".", width: 12)
        return TUIBar(gauge: gauge)
        
      ///  50% |♡♡♡♡♡♡......| status message
      case .bar11:
        let gauge = TUIBarGauge(complete: ["♡"], incomplete: ".", width: 12, kernFiller: " ")
        return TUIBar(gauge: gauge)
        
      ///  50% |☆☆☆☆☆☆......| status message
      case .bar12:
        let gauge = TUIBarGauge(complete: ["☆"], incomplete: ".", width: 12, kernFiller: " ")
        return TUIBar(gauge: gauge)
  
      default:
        return matchBars4()
    }
  }
}

// MARK: -
// MARK: matchBars4 -
public extension TUIBarStyle
{
  private func matchBars4() -> TUIBar
  {
    switch self
    {
    ///  50% |★★★★★★......| status message
    case .bar13:
      let gauge = TUIBarGauge(complete: ["★"], incomplete: ".", width: 12, kernFiller: " ")
      return TUIBar(gauge: gauge)
      
    ///  50% |☓☓☓☓☓☓......| status message
    case .bar14:
      let gauge = TUIBarGauge(complete: ["☓"], incomplete: ".", width: 12)
      return TUIBar(gauge: gauge)
      
    ///  50% |🀆🀆🀆🀆🀆🀆......| status message
    case .bar15:
      let gauge = TUIBarGauge(complete: ["🀆"], incomplete: ".", width: 12)
      return TUIBar(gauge: gauge)
      
    ///  50% |╳╳╳╳╳╳------| status message
    case .bar16:
      let gauge = TUIBarGauge(complete: ["╳"], incomplete: "-", width: 12, kernFiller: " ")
      return TUIBar(gauge: gauge)

    default:
      return matchBars5()
    }
  }
}

// MARK: -
// MARK: matchBars5 -
public extension TUIBarStyle
{
  private func matchBars5() -> TUIBar
  {
    switch self
    {
    ///  50% |║║║║║║------| status message
    case .bar17:
      let gauge = TUIBarGauge(complete: ["║"], incomplete: "-", width: 12)
      return TUIBar(gauge: gauge)
      
    ///  50% |||||||------| status message
    case .bar18:
      let gauge = TUIBarGauge(complete: ["|"], incomplete: "-", width: 12)
      return TUIBar(gauge: gauge)
      
    ///  50% |⚫︎⚫︎⚫︎⚫︎⚫︎⚫︎⚪︎⚪︎⚪︎⚪︎⚪︎⚪︎| status message
    case .bar19:
      let gauge = TUIBarGauge(complete: ["⚫︎"], incomplete: "⚪︎", width: 12)
      return TUIBar(gauge: gauge)
      
    ///  50% |✺✺✺✺✺✺......| status message
    case .bar20:
      let gauge = TUIBarGauge(complete: ["✺"], incomplete: ".", width: 12, kernFiller: " ")
      return TUIBar(gauge: gauge)
      
    default:
      return matchBars6()
    }
  }
}

// MARK: -
// MARK: matchBars6 -
public extension TUIBarStyle
{
  private func matchBars6() -> TUIBar
  {
    switch self
    {
    ///  50% |⸩⸩⸩⸩⸩⸩|......| status message
    case .bar21:
      let infix = TUIBarAffix(character: "|", status: [])
      let gauge = TUIBarGauge(complete: ["⸩"], incomplete: ".", width: 12)
      return TUIBar(infix: infix, gauge: gauge)
      
    ///  50% |⸩⸩⸩⸩⸩⸩------| status message
    case .bar22:
      let gauge = TUIBarGauge(complete: ["⸩"], incomplete: "-", width: 12)
      return TUIBar(gauge: gauge)
      
    ///  50% |======❘......| status message
    case .bar23:
      let infix = TUIBarAffix(character: "|", status: [])
      let gauge = TUIBarGauge(complete: ["="], incomplete: ".", width: 12)
      return TUIBar(infix: infix, gauge: gauge)
      
    ///  50% |🎯🎯🎯🎯🎯🎯......| status message
    case .bar24:
      let gauge = TUIBarGauge(complete: ["🎯"], incomplete: " ", width: 6, kernFiller: " ")
      return TUIBar(gauge: gauge)

    default:
      return matchBars7()
    }
  }
}

// MARK: -
// MARK: matchBars7 -
public extension TUIBarStyle
{
  private func matchBars7() -> TUIBar
  {
    switch self
    {
    ///  50% |🔮🔮🔮🔮🔮🔮......| status message
    case .bar25:
      let gauge = TUIBarGauge(complete: ["🔮"],
                              incomplete: " ", width: 6, kernFiller: " ")
      return TUIBar(gauge: gauge)
      
    ///  50% |💊💊💊💊💊💊......| status message
    case .bar26:
      let gauge = TUIBarGauge(complete: ["💊"], incomplete: " ", width: 6, kernFiller: " ")
      return TUIBar(gauge: gauge)
      
    ///  50% |⭕️⭕️⭕️⭕️⭕️⭕️......| status message
    case .bar27:
      let gauge = TUIBarGauge(complete: ["⭕️"], incomplete: " ", width: 6, kernFiller: " ")
      return TUIBar(gauge: gauge)
      
    ///  50% |🔆🔆🔆🔆🔆🔆......| status message
    case .bar28:
      let gauge = TUIBarGauge(complete: ["🔆"], incomplete: " ", width: 6, kernFiller: " ")
      return TUIBar(gauge: gauge)

    default:
      return matchBars8()
    }
  }
}

// MARK: -
// MARK: matchBars8 -
public extension TUIBarStyle
{
  private func matchBars8() -> TUIBar
  {
    switch self
    {
    ///  50% |🔴🔴🔴🔴🔴🔴......| status message
    case .bar29:
      let gauge = TUIBarGauge(complete: ["🔴"], incomplete: " ", width: 6, kernFiller: " ")
      return TUIBar(gauge: gauge)
      
    ///  50% |🔶🔶🔶🔶🔶🔶......| status message
    case .bar30:
      let gauge = TUIBarGauge(complete: ["🔶"], incomplete: " ", width: 6, kernFiller: " ")
      return TUIBar(gauge: gauge)
      
    ///  50% |⬜️⬜️⬜️⬜️⬜️⬜️......| status message
    case .bar31:
      let gauge = TUIBarGauge(complete: ["⬜️"], incomplete: " ", width: 6, kernFiller: " ")
      return TUIBar(gauge: gauge)
      
    ///  50% |▫️▫️▫️▫️▫️▫️⠒⠒⠒⠒⠒⠒| status message
    case .bar32:
      let gauge = TUIBarGauge(complete: ["▫️"], incomplete: "⠒", width: 6)
      return TUIBar(gauge: gauge)
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
      let gauge = TUIBarGauge(
        complete: ["🌕", "🌖", "🌗", "🌘", "🌑", "🌒", "🌓", "🌔", "🌕"],
        incomplete: " ", width: 9, kernFiller: " ")
      return TUIBar(gauge: gauge)
      
    /// 100% |▁▁▃▃▄▄▅▅▆▆▇▇██| status message
    case .gradient2:
      let gauge = TUIBarGauge(
        complete: ["▁", "▁", "▃", "▃", "▄", "▄", "▅", "▅", "▆", "▆", "▇", "▇", "█", "█"],
        incomplete: " ", width: 14)
      return TUIBar(gauge: gauge)
      
    /// 100% |▉▊▋▌▍▎▏▎▍▌▋▊▉| status message
    case .gradient3:
      let gauge = TUIBarGauge(
        complete: ["▉", "▊", "▋", "▌", "▍", "▎", "▏", "▎", "▍", "▌", "▋", "▊", "▉"],
        incomplete: " ", width: 13, kernFiller: " ")
      return TUIBar(gauge: gauge)
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
    /// |100%| status message
    case .micro1:
      let gauge = TUIBarGauge(complete: [" "], incomplete: " ", width: 0)
      return TUIBar(gauge: gauge)
      
    ///  50% |▓▓░░| status message
    case .micro2:
      let gauge = TUIBarGauge(complete: ["▓"], incomplete: "░", width: 4)
      return TUIBar(gauge: gauge)
      
    ///  50% |⣿⣿⠶⠶| status message
    case .micro3:
      let gauge = TUIBarGauge(complete: ["⣿"], incomplete: "⠶", width: 4)
      return TUIBar(gauge: gauge)
    
    /// 100% |▁▃▄▅▆▇█| status message
    case .micro4:
      let gauge = TUIBarGauge(complete: ["▁", "▃", "▄", "▅", "▆", "▇", "█"],
                              incomplete: " ", width: 7)
      return TUIBar(gauge: gauge)
      
    default:
      let gauge = TUIBarGauge(complete: ["▓"], incomplete: "░", width: 12)
      return TUIBar(gauge: gauge)
    }
  }
}

public enum TUIBarStatus
{
  /// TUIBarStatus
  /// - **percent**: % complete
  /// - **message**: Status message
  /// - **elapsed**: Elapsed time in seconds
  /// - **eta**: Estimate time to complete
  /// - **rate**: Current rate of progression per second
  case percent, message, elapsed, eta, rate
  
  private func status(progress: TUIProgress2) -> String
  {
    switch self
    {
    case percent:
      return String(format: "%3d", progress.percent) + "%"
    case message:
      return progress.messages.last ?? ""
    case elapsed:
      return progress.elapsed
    case eta:
      return progress.eta
    case rate:
      return progress.rate
    }
  }
}

public struct TUIBarAffix
{
  public let character: Character
  public let status: [TUIBarStatus]
}

public struct TUIBarGauge
{
  public let complete: [Character]
  public let incomplete: Character
  public let width: Int
  public let kernFiller: Character?
  
  public init(complete: [Character], incomplete: Character,
              width: Int, kernFiller: Character? = nil)
  {
    self.complete = complete
    self.incomplete = incomplete
    self.width = width
    self.kernFiller = kernFiller
  }
}

public struct TUIBar
{
  public let prefix: TUIBarAffix
  public let infix: TUIBarAffix
  public let suffix: TUIBarAffix
  public let gauge: TUIBarGauge
  
  // Default Parameter Values
  private static let prefix = TUIBarAffix(character: "|", status: [.percent])
  private static let infix = TUIBarAffix(character: " ", status: [])
  private static let suffix = TUIBarAffix(character: "|", status: [.message])
  
  public init(prefix: TUIBarAffix = TUIBar.prefix,
              infix: TUIBarAffix = TUIBar.infix,
              suffix: TUIBarAffix = TUIBar.suffix,
              gauge: TUIBarGauge)
  {
    self.prefix = prefix
    self.infix = infix
    self.suffix = suffix
    self.gauge = gauge
  }
}

public struct TUIProgress2
{
  /// Start time
  private let start = Date()
  
  /// Progress style
  private let style: TUIBar?
  
  /// Message buffer
  private var messages = [String]()
  
  /// Progress view
  private var view: TUIView
  
  /// Percent complete
  public var percent = 0

  /// % rate per second
  private var rate: String {
    return String(format: "%f.2", Double(percent) / elapsedTime)
  }
  
  /// Elapsed time in seconds
  private var elapsedTime: Double {
    let start = self.start.timeIntervalSince1970
    let now = Date().timeIntervalSince1970
    return now - start
  }
  
  /// Elapsed time (minutes:seconds)
  private var elapsed: String {
    let minutes = Int(self.elapsedTime / 60)
    let seconds = Int((self.elapsedTime / 60 - Double(minutes)) * 60)
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
  /// Estimated time to completion (minutes:seconds)
  private var eta: String {
    guard percent > 0 else { return "00:00" }
    let eta =  (100.0 / Double(percent)) * self.elapsedTime
    let minutes = Int(eta / 60)
    let seconds = Int((eta / 60 - Double(minutes)) * 60)
    return String(format: "%02d:%02d", minutes, seconds)
  }

  public init(style: TUIBarStyle, message: String)
  {
    self.style = style.toTUIBar()
    self.messages.append(message)
    
    guard let current = TUIWindow.ttysize()?.character else { exit(EXIT_FAILURE) }
    
//    let current = TUIWindow.ttysize()?.character ?? TUISize(width: 80, height: 1)
    
//    let current = Ansi.Window.Report.characterTextAreaSize() ?? TUISize(width: 80, height: 1)
    self.view = TUIView(x: 0, y: 0, width: Int(current.width) * 2, height: 4, border: .none)
//    self.view.drawAnsiText(x: 0, y: 0, text: draw())
  }
  
  /// Increment by 1
  public mutating func increment()
  {
    self.percent += 1
    if self.percent > 100 { self.percent = 100 }
  }
  
  /// Increment by value
  ///
  /// - Parameters:
  ///   - by: Int
  public mutating func increment(by value: Int)
  {
    self.percent += value
    if self.percent > 100 { self.percent = 100 }
  }
  
  public func draw() -> String
  {
    guard let style = self.style else { return "" }
    let width = style.gauge.width
    let percent = Double(self.percent) / 100.0
    let complete = Int(percent * Double(width))
    let incomplete = width - complete
    
    let prefix = style.prefix.status
      .map { $0.status(progress: self) }
      .joined(separator: " ") + " " + String(style.prefix.character).trim()
    
    let infix = String(style.infix.character).trim() + " " + style.infix.status
      .map { $0.status(progress: self) }
      .joined(separator: " ") + " "
    
    let suffix = String(style.suffix.character).trim() + " " + style.suffix.status
      .map { $0.status(progress: self) }
      .joined(separator: " ")
    
    let barComplete: String
    let barInComplete: String
    if style.gauge.complete.count > 1
    {
      let completeWidth = Int(Double(style.gauge.complete.count) * percent)
      barComplete = (0..<completeWidth)
        .map { String(style.gauge.complete[$0]) }
        .joined(separator: style.gauge.kernFiller == nil ? "" : String(style.gauge.kernFiller ?? " "))
      let incompleteWidth = width - completeWidth
      barInComplete = (0..<incompleteWidth)
        .map { _ in String(style.gauge.incomplete)}
        .joined(separator: style.gauge.kernFiller == nil ? "" : String(style.gauge.kernFiller ?? " "))
    }
    else
    {
      if style.gauge.kernFiller == nil
      {
        barComplete = String(repeating: style.gauge.complete[0], count: complete)
        barInComplete = String(repeating: style.gauge.incomplete, count: incomplete)
      }
      else
      {
        barComplete = String(repeating: String(style.gauge.complete[0]) +
          String(style.gauge.kernFiller ?? " "), count: complete)
        barInComplete = String(repeating: String(style.gauge.incomplete) +
          String(style.gauge.kernFiller ?? " "), count: incomplete)
      }
    }
    
    return prefix + barComplete.foreground(.color256(31)) + infix.attribute(.reset) +
      barInComplete.foreground(.color256(234)) + suffix.attribute(.reset)

  }
  
}


//public struct TUIProgress
//{
//  private var view: TUIView
//  private var percent: Double
//  private let style: TUIProgressStyle
//  private var status = [String]()
//  
//  internal init(
////    origin: TUIPoint,
////    size: TUISize,
//    style: TUIProgressStyle,
//    percent: Double,
//    status: String)
//  {
//    self.percent = percent
//    self.style = style
//    self.status.append(status)
//    let current = Ansi.Window.Report.characterTextAreaSize() ?? TUISize(width: 80, height: 1)
//    self.view = TUIView(x: 0, y: 0, width: Int(current.width) * 2, height: 4, border: .none)
//    self.view.drawAnsiText(x: 0, y: 0, text: draw())
//  }
//  
//  internal mutating func update(_ percent: Double, status: String)
//  {
//    self.percent = percent
//    self.status.append(status)
//    self.view.drawAnsiText(x: 0, y: 0, text: draw())
//    
//    let parameters = TUIRenderParameter()
//    
//    if self.view.invalidate
//    {
//      self.view.render(parameters: parameters)
//    }
//
//    self.view.cache.forEach { ($0 + "\r").stdout() }
//    
////    print("\(self.view.cache[0])\r", terminator: "")
//    Ansi.flush()
//  }
//    
//  internal func draw() -> String
//  {
//    guard let style = self.style.toParts() else { return "" }
//    let status = self.status.last ?? ""
//    let width = style.width
//    let complete = Int(self.percent * Double(width))
//    let incomplete = width - complete
//    let value = Int(self.percent * 100)
//    let progress = String(format: "%3d", value)
//    
//    let prefix = style
//      .prefix
//      .replacingOccurrences(of: "<p>", with: progress)
//      .replacingOccurrences(of: "<s>", with: status)
//    
//    let suffix = style
//      .suffix
//      .replacingOccurrences(of: "<p>", with: progress)
//      .replacingOccurrences(of: "<s>", with: status)
//    
//    let midfix = style
//      .midfix
//      .replacingOccurrences(of: "<p>", with: progress)
//    
//    let barComplete: String
//    let barInComplete: String
//    if style.complete.count > 1
//    {
//      let completeWidth = Int(Double(style.complete.count) * self.percent)
//      barComplete = (0..<completeWidth)
//        .map
//        { style
//          .complete[$0]
//        }.joined(separator: "")
//      let incompleteWidth = width - completeWidth
//      barInComplete = (0..<incompleteWidth)
//        .map
//        { _ in style
//          .incomplete
//        }.joined(separator: "")
//    }
//    else
//    {
//      barComplete = (0..<complete)
//        .map
//        { _ in style
//          .complete
//          .joined(separator: "")
//        }.joined(separator: "")
//      
//      barInComplete = (0..<incomplete)
//        .map
//        { _ in style
//          .incomplete
//        }.joined(separator: "")
//    }
//    
//    return prefix + barComplete.foreground(.color256(31)) + midfix.attribute(.reset) +
//      barInComplete.foreground(.color256(234)) + suffix.attribute(.reset)
//  }
//  
//}
