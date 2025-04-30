function g -d 'find and cd to ghq repo'
    ghq list | fzf | read select
    [ -n "$select" ]; and cd "$(ghq root)/$select"
end
