import termios, terminal, random

var termAttrs, ogTermAttrs: Termios

## ANSI
proc enableMouse*() = stdout.write("\e[?1000h")

proc disableMouse*() = stdout.write("\e[?1000l")

proc setTitle*(title: string) = stdout.write("\e]0;" & title & "\x07")

proc altBuffer*() = stdout.write("\e[?1049h")

proc mainBuffer*() = stdout.write("\e[?1049l")

proc saveCursor*() = stdout.write("\e7")

proc restoreCursor*() = stdout.write("\e8")

proc saveScreen*() = stdout.write("\e[?47h")

proc restoreScreen*() = stdout.write("\e[?47l")

proc lineBreak*() = stdout.write("\e[?25l")

proc lineWrap*() = stdout.write("\e[?25h")

proc scrollUp*(rows: int = 1) = stdout.write("\e[", rows, "S")

proc scrollDown*(rows: int = 1) = stdout.write("\e[", rows, "T")

proc sendBell*() = stdout.write("\a")

proc randColorSeq*(cType = "fg"): string =
  var color: int

  if cType == "bg":
    color = 4
  else:
    color = 3

  randomize()
  enableTrueColors()
  if isTrueColorSupported():
    var (r, g, b) = (rand(256), rand(256), rand(256))

    result = "\e[" & $color & "8;2;" & $r & ";" & $g & ";" & $b & "m"
  else:
    result = "\e[" & $color & $rand(7) & "m"

proc echoRandColor*(text: string) = stdout.writeLine(randColorSeq(), text, "\e[m")

## TUI
proc rawMode*(vmin: int = 1, vtime: int = 0, time: cint = TCSANOW) =
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

proc readC*(): char =
  rawMode()
  
  let c =  readChar(stdin)
  
  cookedMode()

  return c

proc readIn*(count: int): string =
  var buf: string

  while count > buf.len:
    buf.add(readC())

  return buf

proc readKey*(mouse: bool = false): string =
  var
    buf, s: string
    c: char

  if mouse:
      enableMouse()

  c = readC()
  buf.add(c)

  if c == '\e':
    s = readIn(2)
    buf.add(s)

    if buf == "\e[M":
      s = readIn(3)
      buf.add(s)

      disableMouse()

      result = buf
    else:
      result = buf
  else:
    return