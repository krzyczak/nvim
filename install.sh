# /bin/bash

uninstall () {
  echo "Removing ~/.local/share/nvim"
  rm -rf ~/.local/share/nvim
  echo "Removing ~/.config/nvim"
  rm -rf ~/.config/nvim
  echo "Done."
}

main () {
  # TODO: make it configurable.
  echo "Installing neovim..."
  # brew install neovim
  echo "neovim installed successfully."

  echo "Installing vim.plug"
  # Vim:
  # curl -fsSLo ~/.vim/autoload/plug.vim --create-dirs \
  #   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # Neovim:
  curl -fsSLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "vim.plug installed successfully."

  echo "Creating configuration..."
  # TODO: check if neovinm in installed.
  # If it is then:
  mkdir -p ~/.config/nvim
  curl -fsSL https://raw.githubusercontent.com/krzyczak/nvim/master/vim_config > ~/.config/nvim/init.vim
  #
  # If neovim is not installed but vim is installed:
  # curl -fsSL https://raw.githubusercontent.com/krzyczak/nvim/master/vim_config > ~/.vimrc

  # echo "Installing plugins..."
  nvim +"PlugInstall --sync" +qa
  # nvim --cmd "PlugInstall --sync" --cmd qa
  # echo "Configuration finished"

}

if [[ "$0" == "uninstall" ]] || [[ "$1" == "uninstall" ]]
then
  uninstall
else
  main
fi
