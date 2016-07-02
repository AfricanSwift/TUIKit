//
//          File:   Ansi+View+Progressbar.swift
//    Created by:   African Swift

import Foundation
//
// insertion tags
// <p>           % complete (rounded ceiling integer, formatted as 3 digits 0 to 100)
// <s>            status message (length chopped at screen width)

// Format()       multiple input types: array, character, string
//  - Character:  single value
//  - String:     multiple value, with/wihout insertion types"
//  - Array:      array of single value; index calculate as % offset of completion

// width:         width of progress bar (excludes prefix & suffix), midfix is
//                centered without affecting width.
// note:          midfix is added inline to progressbar without extending width

internal struct ProgressBarType
{
  internal let prefix: String
  internal let midfix: String
  internal let suffix: String
  internal let complete: [String]
  internal let incomplete: String
  internal let width: Int
}

internal struct ProgressBarStyle
{
  // ███████░░░░░░░░░
  // 123456789012345678901234567890
  //  12%|████░░░░░░░░| status message
  internal static let standardPrefix = ProgressBarType(
    prefix: "<p>%|",
    midfix: "",
    suffix: "| <s>",
    complete: ["█"],
    incomplete: "░",
    width: 14)
  
  // 123456789012345678901234567890
  // |████░░░░░░░░| 12% : status message
  internal static let standardSuffix = ProgressBarType(
    prefix: "|",
    midfix: "",
    suffix: "|<p>% | <s>",
    complete: ["█"],
    incomplete: "░",
    width: 14)
  
  // 123456789012345678901234567890
  // |█████ 12%░░░░░░░░░| status message
  internal static let standardMidfix = ProgressBarType(
    prefix: "|",
    midfix: "<p>%",
    suffix: "| <s>",
    complete: ["█"],
    incomplete: "░",
    width: 18)
  
  // 123456789012345678901234567890
  // ┌──────────────┐
  // │██████████░░░░│100%
  // └──────────────┘
  // status message
  internal static let bordered1 = ProgressBarType(
    prefix: "┌──────────────┐\n|",
    midfix: "",
    suffix: "|<p>%\n└──────────────┘\n<s>",
    complete: ["█"],
    incomplete: "░",
    width: 14)
  
  // 123456789012345678901234567890
  //     ┌──────────────┐
  // 100%│██████████░░░░│ status message
  //     └──────────────┘
  internal static let bordered2 = ProgressBarType(
    prefix: "    ┌──────────────┐\n<p>%|",
    midfix: "",
    suffix: "| <s>\n    └──────────────┘\n",
    complete: ["█"],
    incomplete: "░",
    width: 14)
  
  // 123456789012345678901234567890
  // 100%|▁▃▄▅▆▇█| status message
  internal static let gradient = ProgressBarType(
    prefix: "<p>%|",
    midfix: "",
    suffix: "| <s>",
    complete: ["▁","▃","▄","▅","▆","▇","█"],
    incomplete: "▁",
    width: 10)
  
  // 123456789012345678901234567890
  // 100%|▉▊▋▌▍▎▏▎▍▌▋▊▉| status message
  internal static let gradient2 = ProgressBarType(
    prefix: "|",
    midfix: "",
    suffix: "|<p>% <s>",
    complete: ["▉","▊","▋","▍","▎","▏","▎","▍","▋","▊","▉"],
    incomplete: "",
    width: 13)
}


internal class ProgressBar
{
  internal private(set) var percent: Double
  private let style: ProgressBarType
  internal private(set) var status = [String]()
  
  internal init(
    origin: TUIPoint,
    size: TUISize,
//    stack: Stack,
//    border: Border,
    style: ProgressBarType,
    percent: Double,
    status: String)
  {
    self.percent = percent
    self.style = style
    self.status.append(status)
//    super.init(
//      origin: origin,
//      size: size,
//      stack: stack,
//      border: border)
  }
  
  internal func update(_ percent: Double, status: String)
  {
    self.percent = percent
    self.status.append(status)
//    self.invalidate = true
  }
  
  internal func draw()
  {
    let status = self.status.last ?? ""
    let width = self.style.width
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
    if self.style.complete.count > 1
    {
      let completeWidth = Int(Double(style.complete.count) * self.percent)
      barComplete = (0..<completeWidth)
        .map
        { self.style
          .complete[$0]
        }.joined(separator: "")
      let incompleteWidth = width - completeWidth
      barInComplete = (0..<incompleteWidth)
        .map
        { _ in self.style
          .incomplete
        }.joined(separator: "")
    }
    else
    {
      barComplete = (0..<complete)
        .map
        { _ in self.style
          .complete
          .joined(separator: "")
        }.joined(separator: "")
      
      barInComplete = (0..<incomplete)
        .map
        { _ in self.style
          .incomplete
        }.joined(separator: "")
    }
    
    Ansi.Display.Erase.all().stdout()
    Ansi.Cursor.position().stdout()
    print(prefix + barComplete.foreground(.color256(166)) + midfix.attribute(.reset) +
      barInComplete.foreground(.white) + suffix.attribute(.reset), terminator: "")
  }
  
}





// insertion tags
// <p3>           % complete (rounded ceiling integer, formatted as 3 digits 0 to 100)
// <s>            status message (length chopped at screen width)

// Format()       multiple input types: array, character, string
//  - Character:  single value
//  - String:     multiple value, with/wihout insertion types"
//  - Array:      array of single value; index calculate as % offset of completion

// width:         width of progress bar (excludes prefix & suffix), midfix is
//                centered without affecting width.
// note:          midfix is added inline to progressbar without extending width

// example 1:
// 123456789012345678901234567890
// |██████████░░░░░░░░░░░░░░| 12% : status message
//
// prefix:      Format("|")
// suffix:      Format("|<p3>% : <s>")
// midfix:      Format("")
// incomplete:  Format("░")
// completed:   Format("▓")
// width:       24

// Example 2:
// 123456789012345678901234567890
//  12%|██████████░░░░░░░░░░░░░░| status message
//
// prefix:      Format("<p3>%|")
// suffix:      Format("| <s>")
// midfix:      Format("")
// incomplete:  Format("░")
// completed:   Format("▓")
// width:       24

// Example 3:
// 123456789012345678901234567890
// |██████████ 12%░░░░░░░░░░░░░░| status message
//
// prefix:      Format("|")
// suffix:      Format("| <s>")
// midfix:      Format("<p3>% ")
// incomplete:  Format("░")
// completed:   Format("▓")
// width:       28

// Example 4:
// 123456789012345678901234567890
// |▁▂▃▅▆▇| status message
//
// prefix:      Format("|")
// suffix:      Format("| <s>")
// midfix:      Format("")
// incomplete:  Format("")
// complete:    Format(["▁","▂","▃","▅","▆","▇"])
// width:       10

// Example 5:
// 123456789012345678901234567890
// |▁▁▂▂▃▃▅▅▆▆▇▇|100% : status message
//
// prefix:      Format("|")
// suffix:      Format("| <s>")
// midfix:      Format("")
// incomplete:  Format("")
// complete:    Format(["▁","▂","▃","▅","▆","▇"])
// width:       20

// Example 6:
// 123456789012345678901234567890
// ┌────────────────────────┐
// │▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░│100%
// └────────────────────────┘
// status message
//
// prefix:      Format("┌────────────────────────┐\n|")
// suffix:      Format("|<p3>% <s>\n└────────────────────────┘\n<s>")
// midfix:      Format("")
// incomplete:  Format("░")
// completed:   Format("▓")
// width:       24

// More examples:
// |⚫︎⚫︎⚫︎⚫︎⚫︎⚫︎⚫︎⚫︎⚪︎⚪︎⚪︎⚪︎⚪︎⚪︎⚪︎⚪︎⚪︎⚪︎⚪︎⚪︎|
// |✺✺✺✺✺✺✺✺✺✺✺...........|
// [----◣ 12%◢--------------]
// |▁▁▂▂▃▃▅▅▅▆▆▆▇▇▇|
// |⸩⸩⸩⸩⸩⸩...................|
//  33% [======❘..............]
// |⸩⸩⸩⸩⸩⸩-------------------|

// ▓▓▓▓▓▓▓▓░░░░░░░ 50%
// ▓▓▓▓▓▓▓▓░░░░░░░ 50%
