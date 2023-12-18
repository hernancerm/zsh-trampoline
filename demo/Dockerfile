FROM debian:stable-slim

# Install Homebrew dependencies
RUN apt-get update
RUN apt-get -y install build-essential curl file git
# Install Homebrew
RUN NONINTERACTIVE=1 sh -c "$(curl -fsSL \
   https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv 2> /dev/null)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# Install the shell
RUN brew install zsh

# Create a user
RUN adduser --ingroup sudo --shell "$(which zsh)" \
    --gecos '' --disabled-password hernan

WORKDIR /home/hernan

# Setup shell configuration
COPY .zshrc /home/hernan

# Install a nice font
RUN brew tap homebrew/linux-fonts
RUN brew install font-iosevka
RUN mkdir /usr/share/fonts/homebrewlinuxfonts
RUN ln -s /home/linuxbrew/.linuxbrew/share/fonts \
    -t /usr/share/fonts/homebrewlinuxfonts

# Install utilities
RUN apt-get install sudo
RUN brew install nvim

# Install Sheldon
RUN brew install sheldon
RUN mkdir -p /home/hernan/.config/sheldon
COPY plugins.toml /home/hernan/.config/sheldon

# Install Starship
RUN brew install starship
RUN mkdir -p /home/hernan/.config
COPY starship.toml /home/hernan/.config

# Install dependencies for Vhs
RUN apt-get -y install chromium
RUN brew install ffmpeg ttyd
# Install Vhs
RUN brew install vhs
ENV VHS_NO_SANDBOX "true"

# Install dependencies for zsh-trampoline and add configuration
RUN brew install gawk fzf
RUN mkdir -p /home/hernan/.config/zt
COPY config.csv /home/hernan/.config/zt

# Create demo directory structure
RUN mkdir -p /home/hernan/dev
RUN mkdir /home/hernan/dev/gc
RUN git clone --depth 1 https://gitlab.gnome.org/GNOME/gimp.git \
    /home/hernan/dev/gc/gimp
RUN git clone --depth 1 https://github.com/neovim/neovim.git \
    /home/hernan/dev/gc/neovim
RUN mkdir /home/hernan/dev/gc/vhs
RUN git clone --depth 1 https://github.com/charmbracelet/vhs.git \
    /home/hernan/dev/gc/vhs
RUN mkdir /home/hernan/dev/gr
RUN git clone --depth 1 https://github.com/HerCerM/poc-spring-vue.git \
    /home/hernan/dev/gr/poc-spring-vue
RUN git clone --depth 1 https://github.com/HerCerM/hercerm-contacts-app.git \
    /home/hernan/dev/gr/hercerm-contacts-app
RUN mkdir /home/hernan/dev/spub
RUN mkdir /home/hernan/dev/spri
RUN mkdir /home/hernan/.dotfiles
RUN mkdir /home/hernan/dev/temp

COPY demo.tape /home/hernan
