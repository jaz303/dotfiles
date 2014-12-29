cd ~

ln -s .dotfiles/etc/gitconfig               .gitconfig
ln -s .dotfiles/etc/gitignore               .gitignore
ln -s .dotfiles/etc/inputrc                 .inputrc
ln -s .dotfiles/etc/screenrc                .screenrc
ln -s .dotfiles/etc/irssi                   .irssi
ln -s .dotfiles/etc/tmux.conf               .tmux.conf
ln -s .dotfiles/etc/lldbinit                .lldbinit

ln -s .dotfiles/etc/zprofile                .zprofile
ln -s .dotfiles/etc/zshenv                  .zshenv
ln -s .dotfiles/etc/zshrc                   .zshrc

ln -s .dotfiles/etc/vim                     .vim
ln -s .vim/vimrc-mac                        .vimrc

mkdir -p .ssh
ln -s Google\ Drive/dotfiles/ssh_config     .ssh/config

mkdir -p ~/tmp
