function gch -d 'find and switch to git branch'
    git branch | fzf | sed -e "s/\* //g" | awk "{print \$1}" | read branch
	[ -n "$branch" ]; and git switch $branch
end
