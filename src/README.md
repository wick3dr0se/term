# Types

### TermMode - enum
- `noecho`: Represents terminal echo off mode
- `raw`: Represents terminal raw mode
- `canonical`: Represents terminal canonical mode
- `cooked`: Represents terminal cooked (default) mode

### ColorType - enum
- `fg`: Represents the foreground color
- `bg`: Represents the background color

# Procedures

### `setMode(mode: TermMode, time: cint = TCSAFLUSH): void`
Sets the terminal mode to the specified `TermMode` type. Optionally, provide the `time` parameter

### `setTitle(title: string): void`
Sets the title of the terminal window

### `altBuffer(): void`
Switch to the alternate screen buffer

### `mainBuffer(): void`
Switch back to the main screen buffer

### `saveScreen(): void`
Save the current contents of the screen

### `restoreScreen(): void`
Restore the saved contents of the screen

### `lineBreak(): void`
Disable line wrapping

### `lineWrap(): void`
Enable line wrapping

### `scrollUp(rows: int = 1): void`
Scroll the contents of the terminal up by specified number of `rows`

### `scrollDown(rows: int = 1): void`
Scrolls the contents of the terminal down by specified number of `rows`

### `sendBell(): void`
Sends a bell character to the terminal, producing an audible beep

### `randColorSeq(colorType: ColorType = fg): string`
Generates a random ANSI color sequence based on the specified `colorType`, `fg` (fallback) or `bg` type. Returns the ANSI color sequence as a string

### `echoRandColor(text: string): void`
Prints the specified `text`, with a newline, in a random color
