# beautiful-wmux

A Windows bootstrap that installs wmux and applies a colorful desk setup.

## Language

**Bootstrap**:
The one-shot setup run that installs and configures the desk.
_Avoid_: Installer only, setup wizard

**Desk setup**:
The full look of the terminal after bootstrap: prompt, icons, colors, wmux theme, and font.
_Avoid_: Beautify, theme pack, skin

**Main script**:
`setup.ps1`, the entry point that calls helper scripts in order.
_Avoid_: Installer, orchestrator

**Helper script**:
A focused script under `scripts/` that owns one setup step.
_Avoid_: Module, plugin

**Force mode**:
A `-Force` run that overwrites configs even when setup already looks complete.
_Avoid_: Reset, reinstall-all (unless the helper truly reinstalls)

**Session patch**:
Writing wmux appearance values into `%APPDATA%\wmux\session.json` after wmux is closed.
_Avoid_: Live theme RPC, CDP hack
