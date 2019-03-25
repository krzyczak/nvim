# /bin/bash

uninstall () {
  echo "Removing ~/.local/share/nvim"
  rm -rf ~/.local/share/nvim
  echo "Removing ~/.config/nvim"
  rm -rf ~/.config/nvim

  echo "Removing ~/.vimrc"
  rm -rf ~/.vimrc

  echo "Removing ~/.vim"
  rm -rf ~/.vim

  echo "Done."
}

install () {
  if [[ $1 == "vim" ]]; then
    CONFIG_PATH="$HOME/.vimrc"
    PLUG_PATH="$HOME/.vim/autoload/plug.vim"
  fi

  if [[ "$1" == "nvim" ]]; then
    mkdir -p $HOME/.config/nvim
    CONFIG_PATH="$HOME/.config/nvim/init.vim"
    PLUG_PATH="$HOME/.local/share/nvim/site/autoload/plug.vim"
  fi

  echo "Installing vim.plug"
  curl -fsSLo $PLUG_PATH --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "vim.plug installed successfully."

  echo "Creating configuration..."
  curl -fsSL https://raw.githubusercontent.com/krzyczak/nvim/master/vim_config > $CONFIG_PATH

  echo "Installing plugins..."
  $1 +"PlugInstall --sync" +qa

  echo "" >> $CONFIG_PATH
  echo "syntax on" >> $CONFIG_PATH
  echo "colorscheme onedark" >> $CONFIG_PATH
  echo "Configuration finished"
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

  if [[ "$(uname)" == "Linux" ]]; then
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:nvim-ppa/stable
    sudo apt-get -y update
    sudo apt-get install -y $1
  fi

  if [[ "$(uname)" == "Darwin" ]]; then
    brew install $1
  fi

  echo "$1 installed successfully."
}

# Action:
if [[ "$1" == "uninstall" ]]; then
  uninstall
  exit 0
fi

EDITOR=${1:-vim}

if [[ "$EDITOR" != "vim" ]] && [[ "$EDITOR" != "nvim" ]] && [[ "$EDITOR" != "neovim" ]]; then
  EDITOR="vim"
fi

if [[ "$EDITOR" == "neovim" ]]; then
  EDITOR="nvim"
fi

if [[ "$EDITOR" == "nvim" ]]; then
  SOFTWARE_NAME="neovim"
else
  SOFTWARE_NAME="vim"
fi

if [[ "$2" == "--with-deps" ]]; then
  install_deps $SOFTWARE_NAME
fi

echo "Installing $EDITOR"
install $EDITOR
