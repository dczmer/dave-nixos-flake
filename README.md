# Dave's NixOS Flake

This is the unified nixos + home-manager configuration for all of my home systems, implemented as a flake.

I'm keeping the primary repository on my local file server but I'll sync a fork to github for convenience.

Notes:

- Checkout to some place in user-space: `/home/dave/source/dave-nixos-flake` and link to `/etc/nixos`
    - Rebuild with `sudo nixos-rebuild switch --flake /home/dave/source/dave-nixos-flake [--upgrade]`
    - The git checkout needs to be in user space and allow my non-root user to edit it (but only root can realize the configuration changes)
    - But the original config was stored in `/etc/nixos` and owned by root...
    - Actually, I bet we don't need to link this flake to `/etc/nixos` at all, except that if we rebuild without `--flake` it will look there by default.
- Does not contain secrets:
    - Secrets (ssh keys, etc) should not be managed in this repo because nix will put them in the store and the store is world-readable.
    - Easiest thing to do for home use is to create the secrets manaually, when re-installing, and update configs that reference the public keys.
    - Another option is to backup/store the keys to an ecnrypted USB drive and copy them in when re-installing.
    - There are secrets manager solutions but I don't think those are needed for home PCs but maybe for development and production hosts (nixops).
