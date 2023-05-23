import termios, terminal, random

var term: Termios

type TermMode* = enum
  raw
  canonical
  cooked

type ColorType* = enum
  fg
  bg

proc setMode*(mode: TermMode, time: cint = TCSAFLUSH) =
  discard tcGetAttr(0, addr term)

  case mode
  of raw:
    term.c_iflag = term.c_iflag and not Cflag(BRKINT or ICRNL or INPCK or ISTRIP or IXON)
    term.c_oflag = term.c_oflag and not Cflag(OPOST)
    term.c_cflag = (term.c_cflag and not Cflag(CSIZE or PARENB)) or CS8
    term.c_lflag = term.c_lflag and not Cflag(ECHO or ICANON or IEXTEN or ISIG)
  of canonical:
    term.c_lflag = term.c_lflag or Cflag(ECHO or ICANON or IEXTEN or ISIG)
    term.c_iflag = term.c_iflag and not Cflag(BRKINT or ICRNL or INPCK or ISTRIP or IXON)
    term.c_cc[VERASE] = 8.char
    term.c_cc[VKILL] = 21.char
  of cooked:
    term.c_lflag = term.c_lflag or Cflag(ECHO or ICANON or IEXTEN or ISIG)

  term.c_cc[VMIN] = '1'
  term.c_cc[VTIME] = '0'

  discard tcSetAttr(0, time, addr term)

proc echoOff*(time: cint = TCSAFLUSH) =
  discard tcGetAttr(0, addr term)
  term.c_lflag = term.c_lflag and not Cflag(ECHO)
  discard tcSetAttr(0, time, addr term)

proc echoOn*(time: cint = TCSAFLUSH) =
  discard tcGetAttr(0, addr term)
  term.c_lflag = term.c_lflag or Cflag(ECHO)
  discard tcSetAttr(0, time, addr term)

proc setTitle*(title: string) = stdout.write("\e]0;" & title & "\x07")

proc altBuffer*() = stdout.write("\e[?1049h")

proc mainBuffer*() = stdout.write("\e[?1049l")

proc saveScreen*() = stdout.write("\e[?47h")

proc restoreScreen*() = stdout.write("\e[?47l")

proc lineBreak*() = stdout.write("\e[?25l")

proc lineWrap*() = stdout.write("\e[?25h")

proc sendBell*() = stdout.write("\a")

proc randColorSeq*(colorType: ColorType = fg): string =
  var ctype = "3"
  if colorType == bg: ctype = "4"
 
  enableTrueColors()
  randomize()
  if isTrueColorSupported():
    var (r, g, b) = (rand(256), rand(256), rand(256))

    result = "\e[" & ctype & "8;2;" & $r & ";" & $g & ";" & $b & "m"
  else:
    result = "\e[" & ctype & $rand(7) & "m"

  return result