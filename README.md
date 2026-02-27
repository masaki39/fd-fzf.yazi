# fd-fzf.yazi

A [Yazi](https://github.com/sxyazi/yazi) plugin to jump to directories using [fd](https://github.com/sharkdp/fd) and [fzf](https://github.com/junegunn/fzf).

## Requirements

- [fd](https://github.com/sharkdp/fd)
- [fzf](https://github.com/junegunn/fzf)

## Installation

```sh
ya pkg add masaki39/fd-fzf
```

## Update

```sh
ya pkg upgrade masaki39/fd-fzf
```

## Configuration

Add a keybinding in `~/.config/yazi/keymap.toml`:

```toml
[[mgr.prepend_keymap]]
on = ["s", "z"]
run = "plugin fd-fzf"
desc = "Jump to directory"
```

## Customization

The fd command in `main.lua` can be modified directly to pass additional arguments:

```lua
:arg("fd --type d | fzf")
```

For example, to search hidden directories or limit depth:

```lua
:arg("fd --type d --hidden | fzf")
:arg("fd --type d --max-depth 5 | fzf")
```

## License

MIT
