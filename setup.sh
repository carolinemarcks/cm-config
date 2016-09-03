#!/bin/sh

setup () {
	local dotfile="$1"
	if [ -e ~/.$dotfile ]; then
		local ver1=`md5 -q ~/.$dotfile`
		local ver2=`md5 -q $dotfile`
		if [ ! "$ver1" = "$ver2" ]; then
			local millis=`date +%s`
			local newname=".$dotfile-$millis"
			echo "~/.$dotfile differs from cm-dotfiles version. archiving to ~/$newname"
			mv ~/.$dotfile ~/$newname
		fi
	fi
	cp $dotfile ~/.$dotfile
}


if [ ! -d ~/.oh-my-zsh ]; then
	git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

setup zshrc
setup screenrc
setup vimrc

echo "Setup complete!"
