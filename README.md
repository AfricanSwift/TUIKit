# Terminal UIKit

![Platforms](https://img.shields.io/badge/Platforms-OSX-ff2974.svg)<BR>
![Swift version](https://img.shields.io/badge/Swift-3.0-FF2974.svg)<BR>
![ANSI support](https://img.shields.io/badge/Ansi-ECMA%2048-ff2974.svg?style=flat)

## Description
Swift native UIKit for the terminal with functionality similar to ncurses.

## Objective
- Implement a cross platform native Swift implementation of ncurses with a simpler and full featured API.
- Implement a UI element and extended widget API.

## Planned Goals
- Support multiple render modes: 
  - **Character:** ASCII, Unicode and Drawille (braille).
  - **Color:** Mono, 16 Color, 256 Color and RGB
- **UI Elements:** View, Button, Label, Rich Text Label
- **Line graphics:** Pixel, Line, Arc, Ellipse, Rectangle, Rounded Rectangle, Pie, Polygon, Polyhedron, Star

### Extended Features
- Progress bar and Spinners
- Table views
- **Charting:** Bar, Stacker Bar, Line, Pie
- Gauges
- Menus
- Image view
- Sprites
- Run loop
- Support terminfo / termcap databases for terminal compatibilty

# Ansi Control Sequences 

The following *xterm control sequence introducer (CSI*) categories are supported:

1. Select Graphic Rendition
2. Cursor Control
3. Display Control
4. Line Control
5. Tab Control
6. Window Control
7. Private Mode: Set / Reset

#### Select Graphic Rendition ![ANSI build](https://img.shields.io/badge/Build-Complete-29bb74.svg?style=flat)

|       Character | Control Sequences                        |
| --------------: | ---------------------------------------- |
|      Attributes | Reset, Bold, Dim, Italic, Underline, Blink, Rapid Blink, Inverse, Positive Visible, Invisible, Crossed-Out, Double Underline. |
| Standard Colors | Black, Red, Green, Brown, Blue, Magenta, Cyan, Light Gray.<BR> ![Standard Colors](https://raw.githubusercontent.com/AfricanSwift/TUIKit/master/TUIKit/Source/Reference/Ansi-StandardColors.png) |
|   Bright Colors | Dark Gray, Light Red, Light Green, Yellow, Light Blue, Light Magenta, Light Cyan, White.<BR>![Bright Colors](https://raw.githubusercontent.com/AfricanSwift/TUIKit/master/TUIKit/Source/Reference/Ansi-BrightColors.png) |
|      256 Colors | 16 Base Colors + 216 Component Colors + 24 Grayscale. <BR><BR>![256 Colors](https://raw.githubusercontent.com/AfricanSwift/TUIKit/master/TUIKit/Source/Reference/Ansi-256Colors.png) |
|      RGB Colors | 24-bit Colors — ISO-8613-3.              |

#### Cursor Control ![ANSI build](https://img.shields.io/badge/Build-Complete-29bb74.svg?style=flat)

|      Cursor | Control Sequences                        |
| ----------: | ---------------------------------------- |
| Directional | Up, Down, Forward, Backward, Absolute Position (row, column) |
|      Column | Absolute (move to specific column), Relative (offset from current column) |
|         Row | Absolute (move to specific row), Relative (offset from current row) |
|       Style | Blinking Block, Steady Block, Blinking Underline, Steady Underline, Blinking Bar, Steady Bar. |
|       State | Save Cursor, Restore Cursor              |

#### Display Control
- Erase: Below, Above, All, Saved Lines (scroll back buffer).

#### Line Control
- Next, Previous, Insert, Delete.
- Erase: Cursor To Right, Cursor To Left, All.
- Scroll: Up, Down, Set Region.

#### Tab Control
- Forward, Backward
- Clear: Current Column, All

#### Window Control
- Move window to absolute x, y
- Resize window to absolute x, y
- Resize Text Area to absolute x, y
- De-inconify Window
- Raise to front of stack order
- Lower to bottom of stack order
- Refresh Window
- Restore Maximized Window
- Maximize Window
- Report: Position, Pixel Size, Character Text Area Size, Character Screen Size, Icon Label
- Change Icon Name and Window Title
- Change Icon Name
- Change Window Title

#### Private Mode Set / Reset
- Keyboard Action Mode
- Insert / Replace Mode
- Send / Receive Mode
- Linefeed Mode
- Cursors Keys Mode
- Designate Character Set
- Column Mode (80 / 132)
- Scroll Mode (Smooth / Jump)
- Video Mode (Reverse / Normal)
- Origin Mode
- Wrap Around Mode
- Auto Repeat Keys Mode
- Show Toolbar Mode
- Print Modes
- Cursor Mode (On / Off)
- Scrollbar Mode
- Font Shifting Function Mode
- Tektronic Mode
- Margin Bell Mode
- Reverse Wraparound Mode
- Logging Mode
- Screen Buffer Mode (Normal / Alternate)
- Keypad Modes
- Mouse Modes

## Current Status
Not ready for projects, however a few parts are working well, whilst others are rough 1st drafts:
- Ansi parts are almost feature/API complete, including but not limited to: Color, Attribute, etc...
- Ansi Views, Progress bars, etc... are still Alpha
- Figlet Fonts - Most fonts work; full standard not yet supported.

#### This library aims to:
- Simplify the use of Ansi Control Codes in terminal apps.
- Provide an alternative to ncurses.
- Provide extended widgets: Progress Bars, Menus, Bar & Line charts, etc...
- Image to ASCII / Braille Pixel conversion
- Support Figlet Fonts

General overview of toolkits what it does etc.....

- [x] @mentions, #refs, [links](), **formatting**, and <del>tags</del> supported
- [x] list syntax required (any unordered or ordered list supported)
- [x] this is a complete item
- [ ] this is an incomplete item

## Ansi Colors
The ANSI / VT100 terminals and terminal emulators are not just able to display 
black and white text, they can display colors and formatted text.

| Terminal   | 8    | 16   | 256  | RGB  |
| ---------- | ---- | ---- | ---- | ---- |
| aTerm      | ok   | ~    | -    | -    |
| Eterm      | ok   | ~    | ok   | -    |
| GNOME      | ok   | ok   | ok   | -    |
| Guake      | ok   | ok   | ok   | -    |
| Konsole    | ok   | ok   | ok   | -    |
| Nautilus   | ok   | ok   | ok   | -    |
| rxvt       | ok   | ok   | -    | -    |
| Terminator | ok   | ok   | ok   | -    |
| Tilda      | ok   | ok   | -    | -    |
| XFCE4      | ok   | ok   | ok   | -    |
| XTerm      | ok   | ok   | ok   | -    |
| xvt        | -    | -    | -    | -    |
| Linux TTY  | ok   | ~    | -    | -    |
| VTE        | ok   | ok   | ok   | -    |
| iTerm2     | ok   | ok   | ok   | -    |
| iTerm3     | ok   | ok   | ok   | ok   |

### Base Colors
There are eight base ansi colors, each with "standard" and "bright" intensity variants. 

<table style="font: normal 12px/80% monospace;">
<tr style="border: none">
<td style="border: none;"><B>Standard</B></td>
<td style="border: 2px ridge;background-color:#000000; color:#FFFFFF">Black</td>
<td style="border: 2px ridge;background-color:#990000; color:#FFFFFF">Red</td>
<td style="border: 2px ridge;background-color:#009900; color:#FFFFFF">Green</td>
<td style="border: 2px ridge;background-color:#999900; color:#FFFFFF">Brown</td>
<td style="border: 2px ridge;background-color:#000099; color:#FFFFFF">Blue</td>
<td style="border: 2px ridge;\-color:#990099; color:#FFFFFF">magenta</td>
<td style="border: 2px ridge;background-color:#009999; color:#FFFFFF">Cyan</td>
<td style="border: 2px ridge;background-color:#999999; color:#FFFFFF">Light Gray</td>
</tr>
<tr style="border: none">
<td style="border: none;background-color:#FFFFFF;"></td>
</tr>
<tr style="border: none">
<td style="border: none;"><B>Bright</B></td>
<td style="border: 2px ridge;background-color:#666666; color:#FFFFFF;">Dark Gray</td>
<td style="border: 2px ridge;background-color:#FF0000; color:#000000">Light Red</td>
<td style="border: 2px ridge;background-color:#00FF00; color:#00000">Light Green</td>
<td style="border: 2px ridge;background-color:#FFFF00; color:#000000">Yellow</td>
<td style="border: 2px ridge;background-color:#0000FF; color:#FFFFFF">Light Blue</td>
<td style="border: 2px ridge;background-color:#FF00FF; color:#000000">Light Magenta</td>
<td style="border: 2px ridge;background-color:#00FFFF; color:#000000">Light Cyan</td>
<td style="border: 2px ridge;background-color:#FFFFFF; color:#000000">White</td>
</tr>
</table>

#### Example
TKit's control codes are easily interchangeable and/or concatenated with Strings

```swift
typealias FG = Ansi.Color.Foreground
typealias BG = Ansi.Color.Background
let title = FG.Red + "Name: " + FG.White + "Mr Magoo" + FG.Reset
let heading = BG.LightRed + FG.Black + "Swift Colors" + FG.Reset + BG.Reset
```

##### Output:
<table style="font: normal 16px/150% monospace;width:100%;">
<tr style="border: none">
<td style="border: 2px ridge;background-color:#000000; color:#FFFFFF">
<a style="color:#990000;">Name: </a>Mr Magoo
<BR>
<a style="background-color:#FF0000;color:#000000;">Swift Colors</a>
<BR>
</td>
</tr>
</table>

#### String Insertion Codes
An alternative way to embed control codes is use insertion codes which are then substituted for the equivalent TKit control code.

```swift
let title = "<T:FG.Red>Name: <T:FG.White>Mr Magoo<T:FG.Reset>".toAnsi()
let heading = "<T:BG.LightRed><T:FG.Black>Swift Colors<T:FG.Reset><T:BG.Reset>".toAnsi()
```
<a name="256-colors"></a>
### 256 Colors 
![256 Colors](https://raw.githubusercontent.com/AfricanSwift/TKit/master/Documentation/256Colors.png)

### Contributing
If you have comments, complaints and/or feature requests: open an issue or a pull request.

### Author and license
African Swift

* [github.com/AfricanSwift](https://github.com/AfricanSwift)
* [twitter.com/SwiftAfricanus](http://twitter.com/SwiftAfricanus)

TKit is available under the MIT license. See the LICENSE file for more info.