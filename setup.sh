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
	local config="$1"
	if [ -e ~/.$config ]; then
		if  differ  ~/.$config  ~/projects/cm-config/$config; then
			local millis=`date +%s`
			local newname=".$config-$millis"
			echo "~/.$config differs from cm-config version. archiving to ~/$newname"
			mv ~/.$config ~/$newname
		fi
	fi
	cp ~/projects/cm-config/$config ~/.$config
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

#TODO don't overwrite these two when there are diffs
cp ~/projects/cm-config/ztheme ~/.oh-my-zsh/custom/themes/cm-zsh-theme.zsh-theme
cp -r ~/projects/cm-config/cm-vi-mode ~/.oh-my-zsh/custom/plugins/cm-vi-mode

echo "Setup complete!"
