cd ~

ln -s .dotfiles/etc/zprofile                .zprofile
ln -s .dotfiles/etc/zshenv                  .zshenv
ln -s .dotfiles/etc/zshrc                   .zshrc

ln -s .dotfiles/etc/gitconfig               .gitconfig
ln -s .dotfiles/etc/gitignore               .gitignore
ln -s .dotfiles/etc/screenrc                .screenrc
ln -s .dotfiles/etc/tmux.conf               .tmux.conf

ln -s .dotfiles/etc/vim                     .vim
ln -s .vim/vimrc-mac                        .vimrc

#ln -s .dotfiles/etc/inputrc                 .inputrc
#ln -s .dotfiles/etc/irssi                   .irssi
#ln -s .dotfiles/etc/lldbinit                .lldbinit

mkdir -p .ssh/config.d
ln -s .dotfiles/etc/ssh/config											.ssh/config
ln -s .dotifles/etc/ssh/config.d/disable-dhcp-host-key-checking.conf	.ssh/config.d/disable-dhcp-host-key-checking.conf
chmod -R a=,u=rwX .ssh

mkdir -p ~/tmp
