set -U fish_greeting
fish_vi_key_bindings

# Environment
set -gx EDITOR "nvim"
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_DATA_DIRS /usr/local/share:/usr/share

set -gx FZF_DEFAULT_COMMAND 'fd --exclude .git --max-depth 5 --hidden'
set -gx FZF_DEFAULT_OPTS '--height 40% --reverse --border'

# Path
fish_add_path -m \
		/bin \
		/usr/bin \
		/usr/local/bin \
		~/.local/bin \
		~/.cargo/bin \
		~/go/bin \
 		~/.volta/bin
 
if not status is-interactive
	return
end

# key bindings
bind -M insert \ca beginning-of-line
bind -M insert \ce end-of-line
bind -M insert \ch backward-delete-char
bind           \cw backward-kill-word
bind -M insert \cw backward-kill-word
bind -M visual \cw backward-kill-word
bind             H beginning-of-line
bind           d,H backward-kill-line
bind           y,H backward-kill-line yank
bind -M visual   H beginning-of-line
bind             L end-of-line
bind           d,L kill-line
bind           y,L kill-line yank
bind -M visual   L end-of-line

# abbr
abbr v 'nvim'
abbr gs 'git status'
abbr gss 'git status --short'
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

##############
# tools      #
##############
set -l conf_dir $__fish_config_dir/conf.d
test (which starship) -nt $conf_dir/starship.fish && starship init fish > $conf_dir/starship.fish
test (which zoxide) -nt $conf_dir/zoxide.fish && zoxide init fish > $conf_dir/zoxide.fish
cod init $fish_pid fish | source

## claude
set -gx CLAUDE_CONFIG_DIR $XDG_CONFIG_HOME/claude

## nix
if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

# key bindings

bind ! edit_command_buffer

function __fzf_complete -d "search completions using fzf"

    set -f output (complete -C (commandline -cp) | fzf -1 | awk '{print $1}')
    if test $status -eq 0
        commandline --current-token --replace -- $output
    end
    commandline --function repaint
end

bind --mode insert ctrl-i __fzf_complete


function __fzf_fd -d "search files using fd and fzf"
    set -f expanded_token (eval "printf '%s' "(commandline -t))
    set -f output (fd . --exclude .git --max-depth 5 --hidden $expanded_token | fzf -1 --preview 'bat -n --color=always {}')
    if test $status -eq 0
        commandline --current-token --replace -- $output
    end
    commandline --function repaint
end

bind --mode insert ctrl-f __fzf_fd

