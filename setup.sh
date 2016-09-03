#!/bin/sh

setup () {
	local dotfile="$1"
	if [ -e ~/.$dotfile ]; then
		local ver1=`md5 -q ~/.$dotfile`
		local ver2=`md5 -q ~/projects/cm-dotfiles/$dotfile`
		if [ ! "$ver1" = "$ver2" ]; then
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

if [ ! -e ~/.oh-my-zsh/custom/themes/cm-zsh-theme.zsh-theme ]; then
	echo "GET THE CUSTOM THEME" #todo version control this
fi

setup zshrc
setup screenrc
setup vimrc

echo "Setup complete!"
