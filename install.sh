cd ~

ln -s .dotfiles/etc/bash_profile            .bash_profile
ln -s .dotfiles/etc/gitconfig               .gitconfig
ln -s .dotfiles/etc/gitignore               .gitignore
ln -s .dotfiles/etc/inputrc                 .inputrc
ln -s .dotfiles/etc/screenrc                .screenrc
ln -s .dotfiles/etc/irssi                   .irssi

ln -s .dotfiles/etc/vim                     .vim
ln -s .vim/vimrc-mac                        .vimrc

mkdir -p .ssh
ln -s Google\ Drive/dotfiles/ssh_config     .ssh/config

mkdir -p ~/tmp
