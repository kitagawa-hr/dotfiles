# dotfiles

my dotfiles using [chezmoi](https://github.com/twpayne/chezmoi)

## How to init

```sh
# install chezmoi
curl -sfL https://git.io/chezmoi | sh && cp ./bin/chezmoi /usr/local/bin/chezmoi

# init
chezmoi init --apply https://github.com/kitagawa-hr/dotfiles.git
```
