import termios

var term: Termios

proc rawMode*(time: cint = TCSAFLUSH) =
  discard tcGetAttr(0, addr term)
  term.c_iflag = term.c_iflag and not Cflag(BRKINT or ICRNL or INPCK or ISTRIP or IXON)
  term.c_oflag = term.c_oflag and not Cflag(OPOST)
  term.c_cflag = (term.c_cflag and not Cflag(CSIZE or PARENB)) or CS8
  term.c_lflag = term.c_lflag and not Cflag(ECHO or ICANON or IEXTEN or ISIG)
  term.c_cc[VMIN] = '1'
  term.c_cc[VTIME] = '0'
  discard tcSetAttr(0, time, addr term)

proc cookedMode*(time: cint = TCSAFLUSH) =
  discard tcGetAttr(0, addr term)
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

proc altBuffer*() = stdout.write("\e[?1049h")

proc mainBuffer*() = stdout.write("\e[?1049l")