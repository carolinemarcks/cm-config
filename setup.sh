#!/bin/sh

if [ ! -d ~/.oh-my-zsh ]; then
	#do vimrc check first?
	echo "installing oh-my-zsh.  please re-run setup.sh afterwards"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

archive () {
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

archive screenrc
archive vimrc
archive zshrc

echo "done"
