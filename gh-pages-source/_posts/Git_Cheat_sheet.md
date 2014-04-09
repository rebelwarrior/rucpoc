#Git Config

`.gitconfig`

```{bash}
[user]
	name = Name LastName
	email = blahblah@example.com
[alias]
	co = checkout
	branch-out = checkout -b
	switch-branch = checkout
	com = commit -am
	sb = checkout
	br = branch
	st = status
[apply]
	whitespace = nowarn
[color]
	ui = true
[core]
	excludesfile = ~/.gitignore_global
	editor = mate -w
```  

#Removing Data from Git Commits

To remove data from git use BFG to change it in the git tree to REMOVED.