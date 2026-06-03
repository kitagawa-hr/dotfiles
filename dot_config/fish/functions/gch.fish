function gch -d 'find and switch to git branch'
    git branch --format '%(refname:lstrip=2)' | fzf | read branch
    if test -n "$branch"
        git switch $branch
    end
end
