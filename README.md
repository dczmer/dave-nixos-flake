# Dave's NixOS Flake

This is the unified nixos + home-manager configuration for all of my home systems, implemented as a flake.

# TODO

## Color Scheme / Palette

A color scheme is starting to emerge: dark background with bright, high-contrast colors. Here are the accent colors i've been using most:

- <pre style="background: #5eff6c">#5eff6c</span>
- <pre style="background: #ff6e5e">#ff6e5e</span>
- <pre style="background: #4EA1FF">#4EA1FF</span>
- <pre style="background: #BD5EFF">#BD5EFF</span>
- <pre style="background: #ffbd5e">#ffbd5e</span>

- create a palette object and pass as argument to all of these different configs
- formalize that color scheme across i3, tmux, vim, zsh; replace hard-coded colors

## i3

- [ ] rework i3 config... i don't think i need all of the options because i can just directly override properties instead
- [ ] break i3 config file into (sub)modules

## Other

- [ ] `backup.sh` uses `pass` integration instead of hard-coding the vault key in the script
- [ ] `taskwarrior` sync server (`taskchampion` on server)
