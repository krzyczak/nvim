# /bin/bash

uninstall () {
  echo "Removing ~/.local/share/nvim"
  rm -rf ~/.local/share/nvim
  echo "Removing ~/.config/nvim"
  rm -rf ~/.config/nvim
  echo "Done."
}

install_deps () {
  echo "Installing $1..."

  # case "$OSTYPE" in
  #   solaris*) echo "SOLARIS" ;;
  #   darwin*)  echo "OSX" ;;
  #   linux*)   echo "LINUX" ;;
  #   bsd*)     echo "BSD" ;;
  #   msys*)    echo "WINDOWS" ;;
  #   *)        echo "unknown: $OSTYPE" ;;
  # esac

  # case "$OSTYPE" in
  #   darwin*)  EXECUTOR="brew";;
  #   linux*)   EXECUTOR="sudo apt-get";;
  # esac

  if [[ "$(uname)" == "Linux" ]]
  then
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt-get -y update
    sudo apt-get install -y $1
  fi

  if [[ "$(uname)" == "Darwin" ]]
  then
    brew install $1
  fi

  echo "$1 installed successfully."
}

main () {
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

  echo "" >> ~/.config/nvim/init.vim
  echo "syntax on" >> ~/.config/nvim/init.vim
  echo "colorscheme onedark" >> ~/.config/nvim/init.vim
  echo "Configuration finished"
}

if [[ "$0" == "uninstall" ]] || [[ "$1" == "uninstall" ]]
then
  uninstall
  exit 0
fi

if [[ "$0" == "vim" ]] || [[ "$1" == "vim" ]]
then
  install_deps "vim"
fi

if [[ "$0" == "nvim" ]] || [[ "$1" == "nvim" ]]
then
  install_deps "neovim"
fi

main
