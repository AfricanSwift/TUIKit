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
  ///  50% |▓▓▓▓▓▓░░░░░░| status message
  ///
  /// .bar3:
  ///  50% |⎕⎕⎕⎕⎕⎕......| status message
  ///
  /// .bar4:
  ///  50% |⏥⏥⏥⏥⏥⏥......| status message
  /// 
  /// .bar5:
  ///  50% |⟩⟩⟩⟩⟩⟩......| status message
  ///
  /// .bar6:
  ///  50% [☓☓☓☓☓☓......] status message
  ///
  /// .bar7:
  ///  50% |||||||------| status message
  ///
  /// .bar8:
  ///  50% |⚫︎⚫︎⚫︎⚫︎⚫︎⚫︎⚪︎⚪︎⚪︎⚪︎⚪︎⚪︎| status message
  ///
  /// .bar9:
  ///  50% |⸩⸩⸩⸩⸩⸩------| status message
  ///
  /// .bar10:
  ///  50% |⭕️⭕️⭕️⭕️⭕️⭕️......| status message
  ///
  /// .bar11:
  ///  50% |⬜️⬜️⬜️⬜️⬜️⬜️......| status message
  ///
  /// .bar12:
  ///  50% |▫️▫️▫️▫️▫️▫️⠒⠒⠒⠒⠒⠒| status message
  /// ````
  case bar1, bar2, bar3, bar4, bar5, bar6, bar7, bar8,
  bar9, bar10, bar11, bar12
  
  /// ````
  /// .gradient1:
  /// 100% |🌕🌖🌗🌘🌑🌒🌓🌔🌕| status message
  ///
  /// .gradient2:
  /// 100% |▁▁▃▃▄▄▅▅▆▆▇▇██| status message
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
  case gradient1, gradient2, micro1, micro2, micro3, micro4
  
  internal static var allCases: [TUIBarStyle] =
    [.bar1, .bar2, .bar3, .bar4, .bar5, .bar6, .bar7, .bar8, .bar9, .bar10,
     .bar11, .bar12, .gradient1, .gradient2, .micro1, .micro2, .micro3, .micro4]
  
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
        let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                  .complete(c), .incomplete(i),
                                  .text("|"), .space, .message]
        return TUIBar(format: bits, width: 6)
      
      ///  50% |▓▓▓░░░| status message
      case .bar2:
        let c: [Character] = ["▓"]
        let i: Character = "░"
        let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                  .complete(c), .incomplete(i),
                                  .text("|"), .space, .message]
        return TUIBar(format: bits, width: 6)
      
      ///  50% |⎕⎕⎕...| status message
      case .bar3:
        let c: [Character] = ["⎕"]
        let i: Character = "."
        let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                  .complete(c), .incomplete(i),
                                  .text("|"), .space, .message]
        return TUIBar(format: bits, width: 6)
      
    ///  50% |⏥⏥⏥...| status message
    case .bar4:
      let c: [Character] = ["⏥"]
      let i: Character = " "
      let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                .complete(c), .incomplete(i),
                                .text("|"), .space, .message]
      return TUIBar(format: bits, width: 6, kern: " ")

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
      ///  50% |▹▹▹...| status message
      case .bar5:
        let c: [Character] = ["▹"]
        let i: Character = "."
        let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                  .complete(c), .incomplete(i),
                                  .text("|"), .space, .message]
        return TUIBar(format: bits, width: 6)
      
    ///  50% |☓☓☓...| status message
    case .bar6:
      let c: [Character] = ["☓"]
      let i: Character = "."
      let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                .complete(c), .incomplete(i),
                                .text("|"), .space, .message]
      return TUIBar(format: bits, width: 6)
      
    ///  50% ||||---| status message
    case .bar7:
      let c: [Character] = ["|"]
      let i: Character = "-"
      let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                .complete(c), .incomplete(i),
                                .text("|"), .space, .message]
      return TUIBar(format: bits, width: 6)
      
    ///  50% |⚫︎⚫︎⚫︎   | status message
    case .bar8:
      let c: [Character] = ["⚫︎"]
      let i: Character = " "
      let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                .complete(c), .incomplete(i),
                                .text("|"), .space, .message]
      return TUIBar(format: bits, width: 6, kern: " ")
  
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
    ///  50% |⸩⸩⸩---| status message
    case .bar9:
      let c: [Character] = ["⸩"]
      let i: Character = "-"
      let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                .complete(c), .incomplete(i),
                                .text("|"), .space, .message]
      return TUIBar(format: bits, width: 6)
      
    ///  50% |⭕️⭕️⭕️...| status message
    case .bar10:
      let c: [Character] = ["⭕️"]
      let i: Character = " "
      let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                .complete(c), .incomplete(i),
                                .text("|"), .space, .message]
      return TUIBar(format: bits, width: 6, kern: " ")
    
    ///  50% |⬜️⬜️⬜️...| status message
    case .bar11:
      let c: [Character] = ["⬜️"]
      let i: Character = " "
      let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                .complete(c), .incomplete(i),
                                .text("|"), .space, .message]
      return TUIBar(format: bits, width: 6, kern: " ")
      
    ///  50% |▫️▫️▫️⠒⠒⠒| status message
    case .bar12:
      let c: [Character] = ["▫️"]
      let i: Character = " "
      let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                .complete(c), .incomplete(i),
                                .text("|"), .space, .message]
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
      let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                .complete(c), .incomplete(i),
                                .text("|"), .space, .message]
      return TUIBar(format: bits, width: 4, kern: " ")
      
    /// 100% |▁▁▃▃▄▄▅▅▆▆▇▇██| status message
    case .gradient2:
      let c: [Character] = ["▁", "▁", "▃", "▃", "▅", "▅", "▆", "▆", "▇", "▇"]
      let i: Character = " "
      let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                .complete(c), .incomplete(i),
                                .text(" |"), .space, .message]
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
      let bits: [TUIBarBits] = [.text("["), .percent, .text("]"), .space, .message]
      return TUIBar(format: bits, width: 0)
      
    ///  50% |▓▓░░| status message
    case .micro2:
      let c: [Character] = ["▓"]
      let i: Character = "░"
      let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                .complete(c), .incomplete(i),
                                .text("|"), .space, .message]
      return TUIBar(format: bits, width: 4)
      
    ///  50% |⣿⣿⠶⠶| status message
    case .micro3:
      let c: [Character] = ["⣿"]
      let i: Character = "⠶"
      let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                .complete(c), .incomplete(i),
                                .text("|"), .space, .message]
      return TUIBar(format: bits, width: 4)
    
    /// 100% ▁▃▄▅▆▇█ status message
    case .micro4:
      let c: [Character] = ["▁", "▃", "▅", "▆", "▇"]
      let i: Character = " "
      let bits: [TUIBarBits] = [.percent, .space, .complete(c),
                                .incomplete(i), .space, .message]
      return TUIBar(format: bits, width: 4)
      
    default:
      let c: [Character] = ["⣿"]
      let i: Character = "⠶"
      let bits: [TUIBarBits] = [.percent, .space, .text("|"),
                                .complete(c), .incomplete(i),
                                .text("|"), .space, .message]
      return TUIBar(format: bits, width: 6)
    }
  }
}

public enum TUIBarBits
{
  /// TUIBarBits
  /// - **percent**: % complete
  /// - **message**: Status message
  /// - **elapsed**: Elapsed time in seconds
  /// - **eta**: Estimate time to complete
  /// - **rate**: Current rate of progression per second
  /// - **space**: Space Character
  /// - **text**: Custom text
  /// - **complete**: Complete character / sequence
  /// - **incomplete**: Incomplete character
  case percent, message, elapsed, eta, rate, space,
  text(String), complete([Character]), incomplete(Character)
  
  private func status(progress: TUIProgress) -> String
  {
    switch self
    {
      case percent:
        return progress.color.percent.toString() + String(format: "%3d", progress.percent) + "%"
      case message:
        return progress.color.message.toString() + (progress.messages.last ?? "")
      case elapsed:
        return progress.color.elapsed.toString() + progress.elapsed
      case eta:
        return progress.color.eta.toString() + progress.eta
      case rate:
        return progress.color.rate.toString() + progress.rate
      case space:
        return " "
      case text(let value):
        return progress.color.text.toString() + value
      case complete(let values):
        return progress.color.complete.toString() + progress.complete(values)
      case .incomplete(let value):
        return progress.color.incomplete.toString() + progress.incomplete(value)
    }
  }
}

public struct TUIBar
{
  public let format: [TUIBarBits]
  public let width: Int
  public let kern: Character?
  
  public init(format: [TUIBarBits], width: Int = 6, kern: Character? = nil)
  {
    self.format = format
    self.width = width
    self.kern = kern
  }
}

public struct TUIBarColor
{
  public var percent = Ansi.Color(red: 65/255, green: 55/255, blue: 146/255, alpha: 1).foreground256()
  public var message = Ansi.Color(red: 99/255, green: 168/255, blue: 69/255, alpha: 1).foreground256()
  public var elapsed = Ansi.Color(red: 185/255, green: 124/255, blue: 80/255, alpha: 1).foreground256()
  public var eta = Ansi.Color(red: 179/255, green: 55/255, blue: 55/255, alpha: 1).foreground256()
  public var rate = Ansi.Color(red: 185/255, green: 124/255, blue: 80/255, alpha: 1).foreground256()
  public var text = Ansi.Color(red: 1, green: 1, blue: 1, alpha: 1).foreground256()
  public var complete = Ansi.Color(red: 147/255, green: 56/255, blue: 135/255, alpha: 1).foreground256()
  public var incomplete = Ansi.Color(red: 185/255, green: 124/255, blue: 80/255, alpha: 1).foreground256()
}

public struct TUIProgress
{
  /// Start time
  private let start = Date()
  
  /// Progress style
  private let style: TUIBar
  
  /// Message buffer
  private var messages = [String]()
  
  /// Progress view
  private var view: TUIView
  
  /// Percent complete
  public var percent = 0
  
  /// Progress Bit Colors
  public var color = TUIBarColor()
  
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
    return self.color.elapsed.toString() + String(format: "%02d:%02d", minutes, seconds)
  }
  
  /// Estimated time to completion (minutes:seconds)
  private var eta: String {
    guard percent > 0 else { return "00:00" }
    let eta =  (100.0 / Double(percent)) * self.elapsedTime
    let minutes = Int(eta / 60)
    let seconds = Int((eta / 60 - Double(minutes)) * 60)
    return self.color.eta.toString() + String(format: "%02d:%02d", minutes, seconds)
  }
  
  public init(style: TUIBarStyle, message: String)
  {
    self.style = style.toTUIBar()
    self.messages.append(message)
    
    guard let current = TUIWindow.ttysize()?.character else { exit(EXIT_FAILURE) }
    self.view = TUIView(x: 0, y: 0, width: Int(current.width) * 2, height: 4, border: .none)
    //    self.view.drawAnsiText(x: 0, y: 0, text: draw())
  }
  
  /// Generate complete bit
  ///
  /// - Parameters:
  ///   - value: [Character]
  /// - Returns: String
  private func complete(_ values: [Character]) -> String
  {
    let percent = Double(self.percent) / 100.0
    let complete = Int(percent * Double(self.style.width))
    let kern = self.style.kern == nil ? "" : String(self.style.kern ?? " ")
    
    if values.count > 1
    {
      let completeWidth = Int(Double(values.count) * percent)
      return (0..<completeWidth)
        .map { String(values[$0]) }
        .joined(separator: kern) + kern
    }
    else
    {
      let rValue = style.kern == nil ? String(values[0]) : String(values[0]) + kern
      return String(repeating: rValue, count: complete)
    }
  }
  
  /// Generate incomplete bit
  ///
  /// - Parameters:
  ///   - value: Character
  /// - Returns: String
  private func incomplete(_ value: Character) -> String
  {
    let completeCount = self.style.format.flatMap { bit -> Int? in
      switch bit
      {
      case .complete(let values):
        return values.count
      default:
        return nil
      }
      }.last
    
    guard let count = completeCount else { exit(EXIT_FAILURE) }
    let percent = Double(self.percent) / 100.0
    let complete = count > 1 ?
      Int(percent * Double(count)) : Int(percent * Double(self.style.width))
    let incomplete = count > 1 ? count - complete : self.style.width - complete
    let kern = self.style.kern == nil ? "" : String(self.style.kern ?? " ")
    let rValue = style.kern == nil ? String(value) : String(value) + kern
    return String(repeating: rValue, count: incomplete)
  }
  
  /// Advance by 1
  public mutating func advance()
  {
    self.percent += 1
    if self.percent > 100
    {
      self.percent = 100
    }
  }
  
  /// Advance by 1 with message
  ///
  /// - Parameters:
  ///   - message: String
  public mutating func advance(message: String)
  {
    self.update(message: message)
    self.advance()
  }
  
  /// Advance by value
  ///
  /// - Parameters:
  ///   - by: Int
  public mutating func advance(by value: Int)
  {
    self.percent += value
    if self.percent > 100
    {
      self.percent = 100
    }
  }
  
  /// Advance by value with message
  ///
  /// - Parameters:
  ///   - by: Int
  ///   - message: String
  public mutating func advance(by value: Int, message: String)
  {
    self.update(message: message)
    self.advance(by: value)
  }
  
  /// Update message
  ///
  /// - Parameters:
  ///   - message: String
  public mutating func update(message: String)
  {
    self.messages.append(message)
  }
  
  public func draw() -> String
  {
    return self.style.format
      .map { $0.status(progress: self) }
      .joined(separator: "") + Ansi.Color.resetAll().toString()
  }
}
