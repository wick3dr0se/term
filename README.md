<div align="center">
<h1>Term :books:</h1>
<p>This library provides functionality for interacting with the terminal, manipulating terminal modes, screen buffers, cursor behavior, generating colors and more. <code>term</code> among many things, can assist in building a TUI without a dependency to curses, abstract the difficulty of working with the terminal and ANSI escape sequences</p>
 
<p>The convienently (clearly not creatively) named <code>term</code> library mainly utilizies the termios library, raw ANSI escape sequences and other standard Nim libraries</p>
<a href='#'><img src="https://img.shields.io/badge/Made%20with-Nim-&?style=flat-square&labelColor=232329&color=FFE953&logo=nim"/></a>
<a href='#'><img src="https://img.shields.io/badge/Maintained%3F-Yes-green.svg?style=flat-square&labelColor=232329&color=5277C3"></img></a>
<br/>

<a href='#'><img src="https://img.shields.io/github/size/wick3dr0se/term/src/term.nim?branch=main&color=%231DBF73&label=Size&logo=files&logoColor=%231DBF73&style=flat-square&labelColor=232329"/></a>
<a href="https://discord.gg/W4mQqNnfSq">
<img src="https://discordapp.com/api/guilds/913584348937207839/widget.png?style=shield"/></a>
</div>

# Installation
Install `term` from `nimble`
```bash
nimble install https://github.com/wick3dr0se/term
```

# Usage
Import `term`
```python
import term
```

## A basic few implementations

Set the terminal to raw, canonical, noecho or cooked (default) mode
```python
setMode(noecho) # disable echoing to the terminal

setMode(cooked) # *reset* the terminal
```

Scroll the terminal screen
```python
scrollUp(10) # scroll up 10 lines

scrollDown() # scroll down 1 (implicit) line
```

Switch to the alternative screen buffer
```python
altBuffer()

mainBuffer() # switch back to the main buffer
```

Output a random colored string
```python
echoRandColor("test") # will print in true color if possible
```
