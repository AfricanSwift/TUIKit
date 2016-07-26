//
//          File:   main.swift
//    Created by:   African Swift

//import Darwin
import Foundation

// WWDC 2016 Logo Example
Ansi.Set.cursorOff().stdout()
Example.WWDC.demo()
Ansi.Display.Erase.all().stdout()

// Fig Font Example
Ansi.Set.cursorOff().stdout()
try Example.Figfont.demo()
Thread.sleep(forTimeInterval: 2)
Ansi.Display.Erase.all().stdout()

// Demo of line graphics
Ansi.Set.cursorOff().stdout()
Example.LineGraphics.demo()
Thread.sleep(forTimeInterval: 1)
Ansi.Display.Erase.all().stdout()

// Random views
Ansi.Set.cursorOff().stdout()
Example.RandomViews.demo()
Thread.sleep(forTimeInterval: 1)
Ansi.Display.Erase.all().stdout()

// ProgressBars
Ansi.Set.cursorOff().stdout()
Ansi.Cursor.position().stdout()
Example.ProgressBars.demo()
Thread.sleep(forTimeInterval: 1)
print()
Ansi.Display.Erase.all().stdout()

// Wavefront
Ansi.Set.cursorOff().stdout()
try Example.Wavefront.demo()
Thread.sleep(forTimeInterval: 3)
Ansi.Display.Erase.all().stdout()

Ansi.resetAll().stdout()
Ansi.Set.cursorOn().stdout()
