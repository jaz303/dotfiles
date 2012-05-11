cd ~

ln -s .dotfiles/etc/bash_proile     .bash_profile
ln -s .dotfiles/etc/gitconfig       .gitconfig
ln -s .dotfiles/etc/gitignore       .gitignore
ln -s .dotfiles/etc/inputrc         .inputrc
ln -s .dotfiles/etc/screenrc        .screenrc
ln -s .dotfiles/etc/irssi           .irssi

mkdir -p .ssh
ln -s Dropbox/dotfiles/ssh_config   .ssh/config