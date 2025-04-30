set -U fish_greeting
fish_vi_key_bindings

# Environment
set -x EDITOR "nvim"
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_STATE_HOME $HOME/.local/state

# Path
fish_add_path -m /bin
fish_add_path -m /usr/bin
fish_add_path -m /usr/local/bin
fish_add_path -m ~/.local/bin
 
if not status is-interactive
	return
end

# key bindings
bind -M insert \ca beginning-of-line
bind -M insert \ce end-of-line
bind -M insert \ch backward-delete-char

# abbr
abbr v 'nvim'
abbr gs 'git status'
abbr cm 'git commit -m'
abbr push 'git push origin HEAD'
abbr pull 'git pull origin $(git rev-parse --abbrev-ref HEAD) --prune'
abbr add 'git add'
abbr commit 'git commit'
abbr ... '../..'

if type -q eza
	abbr ls 'eza --icons=auto'
	abbr ll 'eza -l --icons=auto'
	abbr la 'eza -la --icons=auto'
	abbr tree 'eza --tree --icons=auto'
end

# tools
set -l conf_dir $__fish_config_dir/conf.d
test (which mcfly) -nt $conf_dir/mcfly.fish	&& mcfly init fish > $conf_dir/mcfly.fish
test (which starship) -nt $conf_dir/starship.fish && starship init fish > $conf_dir/starship.fish
test (which zoxide) -nt $conf_dir/zoxide.fish && zoxide init fish > $conf_dir/zoxide.fish

# nix
if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
	. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
end

function fzf_complete
    set -f output (complete -C (commandline -cp) | fzf -1 | awk '{print $1}')
    if test $status -eq 0
        commandline --current-token --replace -- $output
    end
    commandline --function repaint
end

bind --mode insert ctrl-i fzf_complete
