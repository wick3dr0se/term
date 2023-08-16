import termios, terminal, random

type ColorType* = enum
  fg = 3
  bg = 4

var termAttrs, ogTermAttrs: Termios

proc rawMode*(vmin: int = 1, vtime: int = 0, time: cint = TCSAFLUSH) =
  discard tcGetAttr(0, addr termAttrs)
  
  termAttrs.c_lflag = termAttrs.c_lflag and not Cflag(ECHO or ICANON or IEXTEN or ISIG)
  termAttrs.c_iflag = termAttrs.c_iflag and not Cflag(ICRNL or INPCK or ISTRIP)
  termAttrs.c_oflag = termAttrs.c_oflag and not Cflag(OPOST)

  termAttrs.c_cc[VMIN] = vmin.char
  termAttrs.c_cc[VTIME] = vtime.char

  discard tcSetAttr(0, time, addr ogTermAttrs)

proc cookedMode*() =
  discard tcGetAttr(0, addr termAttrs)
  
  termAttrs.c_lflag = termAttrs.c_lflag or Cflag(ECHO or ICANON or IEXTEN or ISIG)
  
  discard tcSetAttr(0, TCSANOW, addr ogTermAttrs)

proc echoOff*() =
  discard tcGetAttr(0, addr termAttrs)

  termAttrs.c_lflag = termAttrs.c_lflag and not Cflag(ECHO)

  discard tcSetAttr(0, TCSANOW, addr ogTermAttrs)

proc echoOn*() =
  discard tcGetAttr(0, addr termAttrs)
  
  termAttrs.c_lflag = termAttrs.c_lflag or Cflag(ECHO)
  
  discard tcSetAttr(0, TCSANOW, addr ogTermAttrs)

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