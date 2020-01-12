# creates symlink to this repository, backup previous config.

mkdir -p ./backup
cp ~/.emacs ./backup/emacs
cp ~/.xmobarrc ./backup/xmobarrc
cp ~/.xmonad/xmonad.hs ./backup/xmonad.hs
cp ~/.tmux.conf ./backup/xmonad.hs


rm ~/.xmobarrc 
rm ~/.emacs 
rm ~/.xmonad/xmonad.hs
rm ~/.tmux.conf


ln -s $(pwd)/emacs_config.el ~/.emacs 
ln -s $(pwd)/xmobarrc ~/.xmobarrc 
ln -s $(pwd)/xmonad.hs ~/.xmonad/xmonad.hs
ln -s $(pwd)/tmux.conf ~/.tmux.conf


