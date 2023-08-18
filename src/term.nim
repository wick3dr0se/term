import termios, terminal, random

type ColorType* = enum
  fg = 3
  bg = 4

var termAttrs, ogTermAttrs: Termios

## TUI
proc rawMode*(vmin: int = 2, vtime: int = 0, time: cint = TCSANOW) =
  discard tcGetAttr(0, addr termAttrs)
  ogTermAttrs = termAttrs
  
  termAttrs.c_lflag = termAttrs.c_lflag and not Cflag(ECHO or ICANON or IEXTEN or ISIG)
  termAttrs.c_iflag = termAttrs.c_iflag and not Cflag(ICRNL or INPCK or ISTRIP)
  termAttrs.c_oflag = termAttrs.c_oflag and not Cflag(OPOST)

  termAttrs.c_cc[VMIN] = vmin.char
  termAttrs.c_cc[VTIME] = vtime.char

  discard tcSetAttr(0, time, addr termAttrs)

proc cookedMode*() = discard tcSetAttr(0, TCSANOW, addr ogTermAttrs)

proc echoOff*() =
  discard tcGetAttr(0, addr termAttrs)
  ogTermAttrs = termAttrs

  termAttrs.c_lflag = termAttrs.c_lflag and not Cflag(ECHO)

  discard tcSetAttr(0, TCSANOW, addr termAttrs)

proc echoOn*() =
  discard tcGetAttr(0, addr termAttrs)
  ogTermAttrs = termAttrs
  
  termAttrs.c_lflag = termAttrs.c_lflag or Cflag(ECHO)
  
  discard tcSetAttr(0, TCSANOW, addr termAttrs)

proc readIn*(vmin: int = 1): string =
  rawMode(vmin)
  
  var buf: string
  
  while vmin > buf.len:
    let c = readChar(stdin)
    if c != '\0':
      buf.add(c)
    else:
      break

  cookedMode()

  return buf

## ANSI
proc enableMouse*() = stdout.write("\e[?1000h")

proc disableMouse*() = stdout.write("\e[?1000l")

proc setTitle*(title: string) = stdout.write("\e]0;" & title & "\x07")

proc altBuffer*() = stdout.write("\e[?1049h")

proc mainBuffer*() = stdout.write("\e[?1049l")

proc saveScreen*() = stdout.write("\e[?47h")

proc restoreScreen*() = stdout.write("\e[?47l")

proc lineBreak*() = stdout.write("\e[?25l")

proc lineWrap*() = stdout.write("\e[?25h")

proc scrollUp*(rows: int = 1) = stdout.write("\e[", rows, "S")

proc scrollDown*(rows: int = 1) = stdout.write("\e[", rows, "T")

proc sendBell*() = stdout.write("\a")

proc randColorSeq*(colorType: ColorType = fg): string =
  var ctype = $colorType

  randomize()
  enableTrueColors()
  if isTrueColorSupported():
    var (r, g, b) = (rand(256), rand(256), rand(256))

    result = "\e[" & ctype & "8;2;" & $r & ";" & $g & ";" & $b & "m"
  else:
    result = "\e[" & ctype & $rand(7) & "m"

proc echoRandColor*(text: string) = stdout.writeLine(randColorSeq(), text, "\e[m")