cd ~

#
# Temp Dir

mkdir -p ~/tmp

#
# Basic Config

ln -s .dotfiles/etc/zprofile                .zprofile
ln -s .dotfiles/etc/zshenv                  .zshenv
ln -s .dotfiles/etc/zshrc                   .zshrc

ln -s .dotfiles/etc/gitconfig               .gitconfig
ln -s .dotfiles/etc/gitignore               .gitignore
ln -s .dotfiles/etc/screenrc                .screenrc
ln -s .dotfiles/etc/tmux.conf               .tmux.conf

ln -s .dotfiles/etc/vim                     .vim
ln -s .vim/vimrc-linux                      .vimrc

#ln -s .dotfiles/etc/inputrc                 .inputrc
#ln -s .dotfiles/etc/irssi                   .irssi
#ln -s .dotfiles/etc/lldbinit                .lldbinit

mkdir -p .config
pushd .config
ln -s ../.dotfiles/etc/nvim
# TODO: i3, i3status
# TODO: alacritty (need different configs for Mac/Linux)
popd

#
# SSH

mkdir -p .ssh/config.d

pushd ~/.ssh
ln -s ../.dotfiles/etc/ssh/config

pushd config.d
for FILE in ../../.dotfiles/etc/ssh/config.d/*
do
	ln -s $FILE
done

popd
popd

chmod -R a=,u=rwX .ssh
