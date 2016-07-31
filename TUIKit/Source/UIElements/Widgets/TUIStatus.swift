//
//          File:   TUIStatus.swift
//    Created by:   African Swift

import Foundation

public struct TUIStatus
{
  /// Start time
  private let start = Date()
  
  /// Format Bits
  public var format: [Bits]
  
  /// Message buffer
  private var messages = [String]()
  
  /// Progress view
  private var view: TUIView
  
  /// Percent complete
  private var percent = 0
  
  /// Bit Colors
  public var color = Color()
  
  /// Status
  private var status: Status
  
  /// Active / Inactive
  private var isActive: Bool
  
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
  
  /// Default initiliazer
  ///
  /// - Parameters:
  ///   - format: [TUIStatus.Bits]
  ///   - message: String
  public init(format: [Bits], message: String)
  {
    self.format = format
    self.messages.append(message)
    self.status = .busy
    self.isActive = true
    
    guard let current = TUIWindow.ttysize()?.character else { exit(EXIT_FAILURE) }
    let viewParam = TUIView.Parameter(border: .none)
    self.view = TUIView(x: 0, y: 0, width: Int(current.width) * 2, height: 4, parameters: viewParam)
    self.draw()
  }
  
  /// Secondary initiliazer
  ///  50% |⣿⣿⣿⣿⣿⣿⠶⠶⠶⠶⠶⠶| status message
  ///
  /// - Parameters:
  ///   - message: String
  public init(message: String)
  {
    let format: [TUIStatus.Bits] = [
      .percent,
      .text(" "),
      .complete(sequence: ["⣿"], width: 6, kern: nil),
      .incomplete(filler: "⠶", width: 6, kern: nil),
      .text(" "), .message
    ]
    self.init(format: format, message: message)
  }
  
  /// Status
  private enum Status
  {
    case success, failure, busy
  }
  
  public struct Color
  {
    public var percent = Ansi.Color.Foreground.color256(index: 151)
    public var message = Ansi.Color.Foreground.reset()
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
    public var spinFail = Ansi.Color.Foreground.lightRed()
    public var spinSuccess = Ansi.Color.Foreground.lightGreen()
  }
  
  public enum Bits
  {
    /// % complete
    case percent
    
    /// Status message
    case message
    
    /// Elapsed time in seconds
    case elapsed
    
    /// Estimated total duration
    case eta
    
    /// Estimated time remaining
    case remaining
    
    /// Current rate of progression per second
    case rate
    
    /// Custom text
    case text(String)
    
    /// Complete character / sequence
    ///
    /// **Parameters:**
    /// - sequence: [Character]
    /// - width: Int
    /// - kern: Character?
    case complete(sequence: [Character], width: Int, kern: Character?)
    
    /// Incomplete character
    ///
    /// **Parameters:**
    /// - filler: Character
    /// - width: Int
    /// - kern: Character?
    case incomplete(filler: Character, width: Int, kern: Character?)
    
    /// Scan Activity Indicator
    ///
    /// **Parameters:**
    /// - line: Character
    /// - filler: Character
    /// - width: Int
    /// - kern: Character?
    case scan(line: Character, filler: Character, width: Int, kern: Character?)
    
    /// Cylon Activity Indicator (Battlestar Galatica's namesake)
    ///
    /// **Parameters:**
    /// - eye: Character
    /// - filler: Character
    /// - width: Int
    /// - kern: Character?
    case cylon(eye: Character, filler: Character, width: Int, kern: Character?)
    
    /// Animation Progression Indicator
    ///
    /// **Parameters:**
    /// - sequence: [Character]
    /// - filler: Character
    /// - kern: Character?
    case animate(sequence: [Character], filler: Character, kern: Character?)
    
    /// Spinner Activity and Completion Indicator
    ///
    /// **Parameters:**
    /// - sequence: [Character]
    /// - end: Character
    /// - kern: Character?
    case spinner(sequence: [Character],
      end: (success: Character, failure: Character), kern: Character?)
  }

  public struct Spinners { }
  public struct Bars { }
}


// MARK: -
// MARK: TUIBarBits Formatters -
public extension TUIStatus
{
  private func animate(sequence: [Character], fill: Character, kern: Character?) -> String
  {
    let index = Int((Double(self.percent) / 100) * Double(sequence.count - 1))
    let result = (0..<sequence.count)
      .map { $0 == index ? String(sequence[index]) : String(fill) }
      .joined(separator: "")
    guard let kernAdjust = kern else { return result }
    return result + String(kernAdjust)
  }
  
  private func scanner(ray: Character, fill: Character, width: Int, kern: Character?) -> String
  {
    let result = (0..<width)
      .map { $0 == (self.percent % width) ?
        String(ray) : String(fill) }
      .joined(separator: "")
    guard let kernAdjust = kern else { return result }
    return result + String(kernAdjust)
  }
  
  private func spinner(sequence: [Character],
                       end: (success: Character, failure: Character),
                       kern: Character?) -> String
  {
    var result = ""
    switch self.status
    {
    case .busy:
      result = String(sequence[self.percent % sequence.count])
    case .success:
      result = String(end.success)
    case .failure:
      result = String(end.failure)
    }
    guard let kernAdjust = kern else { return result }
    return result + String(kernAdjust)
  }
  
  private func cylon(eye: Character, fill: Character, width: Int, kern: Character?) -> String
  {
    let result = (0..<width)
      .map {
        let value = (self.percent / width) % 2 == 0 ?
          self.percent % width :
          width - 1 - (self.percent % width)
        return $0 == value ? String(eye) : String(fill) }
      .joined(separator: "")
    guard let kernAdjust = kern else { return result }
    return result + String(kernAdjust)
  }
  
  /// Generate complete bit
  ///
  /// - Parameters:
  ///   - value: [Character]
  /// - Returns: String
  private func complete(sequence: [Character], width: Int, kern: Character?) -> String
  {
    let percent = Double(self.percent) / 100.0
    let complete = Int(percent * Double(width))
    let kernAdjust = kern == nil ? "" : String(kern ?? " ")
    
    if sequence.count > 1
    {
      let completeWidth = Int(Double(sequence.count) * percent)
      let result = (0..<completeWidth)
        .map { String(sequence[$0]) }
        .joined(separator: kernAdjust)
      return result.characters.count == 0 ? "" : result + kernAdjust
    }
    else
    {
      let value = kern == nil ? String(sequence[0]) : String(sequence[0]) + kernAdjust
      return String(repeating: value, count: complete)
    }
  }
  
  /// Generate incomplete bit
  ///
  /// - Parameters:
  ///   - value: Character
  /// - Returns: String
  private func incomplete(fill: Character, width: Int, kern: Character?) -> String
  {
    let percent = Double(self.percent) / 100.0
    let complete = Int(percent * Double(width))
    let incomplete = width - complete
    let kernAdjust = kern == nil ? "" : String(kern ?? " ")
    let value = kern == nil ? String(fill) : String(fill) + kernAdjust
    return String(repeating: value, count: incomplete)
  }
}

// MARK: -
// MARK: Advance & Update -
public extension TUIStatus
{
  
  /// Mark Status as failed
  public mutating func failed()
  {
    self.status = .failure
    self.isActive = false
    self.draw()
    print()
  }
  
  /// Advance by 1 with message
  ///
  /// - Parameters:
  ///   - message: String?
  public mutating func advance(message: String? = nil)
  {
    self.advance(by: 1, message: message)
  }
  
  
  /// Advance by value
  ///
  /// - Parameters:
  ///   - by: Int
  public mutating func advance(by value: Int, message: String? = nil)
  {
    if !isActive
    {
      return
    }
    
    if let msg = message
    {
      self.messages.append(msg)
    }
    
    self.percent += value
    if self.percent >= 100
    {
      if case .busy = status {
        self.status = .success
      }
      self.percent = 100
    }
    self.draw()
  }
  
  /// Update message
  ///
  /// - Parameters:
  ///   - message: String
  public mutating func update(message: String)
  {
    self.advance(by: 0, message: message)
  }
}

// MARK: -
// MARK: Render & Draw -
public extension TUIStatus
{
  private func render() -> String
  {
    return self.format
      .map { $0.render(status: self) }
      .joined(separator: "") + Ansi.Color.resetAll().toString()
  }
  
  public mutating func draw()
  {
    self.view.drawAnsiText(x: 0, y: 0, text: self.render())
    self.view.render(parameters: TUIRenderParameter())
    let result = self.view.cache.map { $0.toString() }.joined(separator: "")
    print("\(result)\r", terminator: "")
    if self.percent == 100
    {
      print()
      self.isActive = false
    }
    Ansi.flush()
  }
}

// MARK: -
// MARK: TUIStatus.Bits render -
private extension TUIStatus.Bits
{
  private func render(status: TUIStatus) -> String
  {
    switch self
    {
      case percent:
        return status.color.percent.toString() +
          String(format: "%3d", status.percent) + "%"
      case message:
        return status.color.message.toString() + (status.messages.last ?? "")
      case elapsed:
        return status.color.elapsed.toString() + status.elapsed
      case eta:
        return status.color.eta.toString() + status.eta
      case .remaining:
        return status.color.remaining.toString() + status.remaining
      case rate:
        return status.color.rate.toString() + status.rate
      case text(let value):
        return status.color.text.toString() + value
      default:
        return renderAdvanced(status: status)
    }
  }
}

private extension TUIStatus.Bits
{
  private func renderAdvanced(status: TUIStatus) -> String
  {
    switch self
    {
    case complete(let sequence, let width, let kern):
      let result = status.complete(sequence: sequence, width: width, kern: kern)
      return result.characters.count > 0 ? status.color.complete.toString() + result : result
    case .incomplete(let fill, let width, let kern):
      let result = status.incomplete(fill: fill, width: width, kern: kern)
      return result.characters.count > 0 ? status.color.incomplete.toString() + result : result
    case .cylon(let eye, let fill, let width, let kern):
      return status.color.cylon.toString() +
        status.cylon(eye: eye, fill: fill, width: width, kern: kern)
    case .scan(let ray, let fill, let width, let kern):
      return status.color.scanner.toString() +
        status.scanner(ray: ray, fill: fill, width: width, kern: kern)
    case .animate(let sequence, let fill, let kern):
      return status.color.animate.toString() +
        status.animate(sequence: sequence, fill: fill, kern: kern)
    case .spinner(let sequence, let end, let kern):
      let color = status.status == .busy ? status.color.spinner :
        status.status == .failure ? status.color.spinFail : status.color.spinSuccess
      return color.toString() +
        status.spinner(sequence: sequence, end: end, kern: kern)
    default:
      return ""
    }
  }
}
