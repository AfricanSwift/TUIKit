//
//          File:   TUIProgress.swift
//    Created by:   African Swift

import Foundation

public enum TUIBarBits
{
  /// TUIBarBits
  /// - **percent**: % complete
  /// - **message**: Status message
  /// - **elapsed**: Elapsed time in seconds
  /// - **eta**: Estimated total duration
  /// - **remaining**: Estimate time remaining
  /// - **rate**: Current rate of progression per second
  /// - **space**: Space Character
  /// - **text**: Custom text
  /// - **complete**: Complete character / sequence
  /// - **incomplete**: Incomplete character
  /// - **scanner**: left to right activity scanner
  /// - **cylon**: similar to Battlestar Galatica namesake
  /// - **animate**: sequence animation
  /// - **spinner**: sequence spinner
  case percent, message, elapsed, eta, remaining, rate,
  text(String), complete([Character]), incomplete(Character),
  scanner(Character, Character), cylon(Character, Character),
  animate([Character], Character), spinner([Character])
}

// MARK: -
// MARK: TUIBarBits status -
private extension TUIBarBits
{
  private func status(progress: TUIProgress) -> String
  {
    switch self
    {
      case percent:
        return progress.color.percent.toString() +
          String(format: "%3d", progress.percent) + "%"
      case message:
        return progress.color.message.toString() + (progress.messages.last ?? "")
      case elapsed:
        return progress.color.elapsed.toString() + progress.elapsed
      case eta:
        return progress.color.eta.toString() + progress.eta
      case .remaining:
        return progress.color.remaining.toString() + progress.remaining
      case rate:
        return progress.color.rate.toString() + progress.rate
      case text(let value):
        return progress.color.text.toString() + value
      default:
        return advancedStatus(progress: progress)
    }
  }
}

private extension TUIBarBits
{
  private func advancedStatus(progress: TUIProgress) -> String
  {
    switch self
    {
      case complete(let values):
        return progress.color.complete.toString() + progress.complete(values)
      case .incomplete(let value):
        return progress.color.incomplete.toString() + progress.incomplete(value)
      case .cylon(let eye, let fill):
        return progress.color.cylon.toString() + progress.cylon(eye, fill)
      case .scanner(let scan, let fill):
        return progress.color.scanner.toString() + progress.scanner(scan, fill)
      case .animate(let animate, let fill):
        return progress.color.animate.toString() + progress.animate(animate, fill)
      case .spinner(let spinner):
        return progress.color.spinner.toString() + progress.spinner(spinner)
      default:
        return ""
    }
  }
}

// MARK: -
// MARK: TUIBar -
public struct TUIBar
{
  private let format: [TUIBarBits]
  public var width: Int
  private let kern: Character?
  
  public init(format: [TUIBarBits], width: Int = 6, kern: Character? = nil)
  {
    self.format = format
    self.width = width
    self.kern = kern
  }
}

// MARK: -
// MARK: TUIBarBits Colors -
public struct TUIBarColor
{
  public var percent = Ansi.Color.Foreground.color256(index: 151)
  public var message = Ansi.Color.Foreground.color256(index: 252)
  public var elapsed = Ansi.Color.Foreground.color256(index: 139)
  public var eta = Ansi.Color.Foreground.color256(index: 175)
  public var remaining = Ansi.Color.Foreground.color256(index: 65)
  public var rate = Ansi.Color.Foreground.color256(index: 207)
  public var text = Ansi.Color.Foreground.color256(index: 32)
  public var complete = Ansi.Color.Foreground.color256(index: 116)
  public var incomplete = Ansi.Color.Foreground.color256(index: 136)
  public var cylon = Ansi.Color.Foreground.color256(index: 36)
  public var scanner = Ansi.Color.Foreground.color256(index: 43)
  public var animate = Ansi.Color.Foreground.color256(index: 70)
  public var spinner = Ansi.Color.Foreground.color256(index: 66)
}

// MARK: -
// MARK: TUIProgress -
public struct TUIProgress
{
  /// Start time
  private let start = Date()
  
  /// Progress style
  public var style: TUIBar
  
  /// Message buffer
  private var messages = [String]()
  
  /// Progress view
  private var view: TUIView
  
  /// Percent complete
  private var percent = 0
  
  /// Progress Bit Colors
  public var color = TUIBarColor()
  
  /// % rate per second
  private var rate: String {
    return String(format: "%.2f", Double(percent) / elapsedTime)
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
  
  /// Estimated remaining time to completion (minutes:seconds)
  /// Calculation = (eta - elapsed)
  private var remaining: String {
    guard percent > 0 else { return "00:00" }
    let eta =  (100.0 / Double(percent)) * self.elapsedTime
    let remaining = eta - self.elapsedTime
    let minutes = Int(remaining / 60)
    let seconds = Int((remaining / 60 - Double(minutes)) * 60)
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
  public init(style: TUIBarStyle, message: String)
  {
    self.style = style.toTUIBar()
    self.messages.append(message)
    
    guard let current = TUIWindow.ttysize()?.character else { exit(EXIT_FAILURE) }
    self.view = TUIView(x: 0, y: 0,
                        width: Int(current.width) * 2, height: 4, border: .none)
    //    self.view.drawAnsiText(x: 0, y: 0, text: draw())
  }
}

// MARK: -
// MARK: TUIBarBits Formatters -
public extension TUIProgress
{
  private func animate(_ animate: [Character], _ fill: Character) -> String
  {
    let index = Int((Double(self.percent) / 100) * Double(animate.count - 1))
    return (0..<animate.count)
      .map { $0 == index ? String(animate[index]) : String(fill) }
      .joined(separator: "")
  }
  
  private func scanner(_ scanner: Character, _ fill: Character) -> String
  {
    return (0..<self.style.width)
      .map { $0 == (self.percent % self.style.width) ?
        String(scanner) : String(fill) }
      .joined(separator: "")
  }
  
  private func spinner(_ spinner: [Character]) -> String
  {
    return String(spinner[self.percent % spinner.count])
  }
  
  private func cylon(_ eye: Character, _ fill: Character) -> String
  {
    return (0..<self.style.width)
      .map {
        let value = (self.percent / self.style.width) % 2 == 0 ?
          self.percent % self.style.width :
          self.style.width - 1 - (self.percent % self.style.width)
        return $0 == value ? String(eye) : String(fill) }
      .joined(separator: "")
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
      let rValue = style.kern == nil ?
        String(values[0]) : String(values[0]) + kern
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
}

// MARK: -
// MARK: Advance & Update -
public extension TUIProgress
{
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
}

// MARK: -
// MARK: Render & Draw -
public extension TUIProgress
{
  private func render() -> String
  {
    return self.style.format
      .map { $0.status(progress: self) }
      .joined(separator: "") + Ansi.Color.resetAll().toString()
  }
  
  public func draw()
  {
    print("\(self.render())\r", terminator: "")
    Ansi.flush()
  }
}
