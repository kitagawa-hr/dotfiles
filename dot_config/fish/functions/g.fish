function g -d 'find and cd to ghq repo'
    ghq list | fzf | read select
    if test -n "$select"
        cd "$(ghq root)/$select"
    end
end
