# dotfiles

![prompt](prompt.png)

- zsh package manager: [zinit](https://github.com/zdharma/zinit)
- prompt: [starship](https://github.com/starship/starship)
- dotfiles management: [chezmoi](https://github.com/twpayne/chezmoi)

## How to init

```sh
# install chezmoi
curl -sfL https://git.io/chezmoi | sh && cp ./bin/chezmoi /usr/local/bin/chezmoi

# init
chezmoi init --apply https://github.com/kitagawa-hr/dotfiles.git
```
