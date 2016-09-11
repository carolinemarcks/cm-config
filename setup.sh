#!/bin/sh

differ () {
	local ver1="ver1"
	local ver2="ver2"
	if hash md5 2>/dev/null; then
		ver1=`md5 -q $1`
		ver2=`md5 -q $2`
	elif hash sha334sum 2>/dev/null; then
		ver1=`sha224sum $1 | cut -d " " -f 1`
		ver2=`sha224sum $2 | cut -d " " -f 1`
	else
		echo "$1 and $2 could not be compared"
	fi

	if [ "$ver1" = "$ver2" ]; then
		return 1 # false, they're the same
	else
		return 0 # true, they differ
	fi
}

setup () {
	local dotfile="$1"
	if [ -e ~/.$dotfile ]; then
		if  differ  ~/.$dotfile  ~/projects/cm-dotfiles/$dotfile; then
			local millis=`date +%s`
			local newname=".$dotfile-$millis"
			echo "~/.$dotfile differs from cm-dotfiles version. archiving to ~/$newname"
			mv ~/.$dotfile ~/$newname
		fi
	fi
	cp ~/projects/cm-dotfiles/$dotfile ~/.$dotfile
}


if [ ! -d ~/.oh-my-zsh ]; then
	git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
	git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions 
fi

if [ ! -d ~/.oh-my-zsh/custom/themes ]; then
	mkdir ~/.oh-my-zsh/custom/themes 
fi

setup zshrc
setup screenrc
setup vimrc

cp ~/projects/cm-dotfiles/ztheme ~/.oh-my-zsh/custom/themes/cm-zsh-theme.zsh-theme

echo "Setup complete!"
