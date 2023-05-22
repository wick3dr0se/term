import termios

var term: Termios

type Mode* = enum
  raw
  canonical
  cooked

proc setMode*(mode: Mode, time: cint = TCSAFLUSH) =
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

proc lineBreak*() = stdout.write("\e[?25l")

proc lineWrap*() = stdout.write("\e[?25h")

proc sendBell*() = stdout.write("\a")