# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="amuse"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git z)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='subl -w'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# --------------------
#
# ALIASES
#
# --------------------

#
# config files
#
alias rcfile="subl ~/.zshrc"
alias hammerspoonrc="subl ~/.hammerspoon/init.lua"

#
# macOS
#
alias brewup="brew update && brew upgrade"
alias bundleid="/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier'"
alias restartaudio="sudo launchctl stop com.apple.audio.coreaudiod && sudo launchctl start com.apple.audio.coreaudiod"

#
# general
#
alias l="ls -hlF"
alias ll="ls -AhlF"
alias o="open ."
alias reload="[ -f ~/.zshrc ] && . ~/.zshrc && echo '✅ rcfile reloaded'"
alias rghist="history | rg -i"
alias x="xed ."
function rmtrash { mv "$@" ~/.Trash/; }

#
# network
#
alias dg="dig +short"
alias dnsflush="sudo killall -HUP mDNSResponder; sleep 2"
alias listeningports="lsof -iTCP -sTCP:LISTEN -n -P"
alias myip='echo $(curl --silent https://ifconfig.me)'
alias server3="python3 -m http.server"

#
# images & video
#
alias exif="exiftool -s -G" # group by raw tag names
alias stripexif="exiftool -all= -overwrite_original" # strip exif in-place

alias happend="convert +append" # horizontal append images
alias vappend="convert -append" # vertical append images

alias yt="youtube-dl --format best -o '~/Downloads/_ytdl/%(title)s.%(ext)s'"
alias ytsub="yt --sub-lang en --write-sub"


# --------------------
#
# FUNCTIONS
#
# --------------------

function aspectratio {
    desired_ratio=$1
    input_image=$2

    width=$(identify -format '%w' $input_image)
    height=$(identify -format '%h' $input_image)
    ratio=$(echo "scale=2 ; $width / $height" | bc)
    echo "current size: $width x $height"
    echo "current aspect ratio: $ratio"

    if (( $(echo "$ratio > $desired_ratio" | bc) )); then
        # increase height
        height=$(echo "scale=0; $width / $desired_ratio" | bc)
    else
        # increase width
        width=$(echo "scale=0; $height * $desired_ratio" | bc)
    fi
    echo "new size: $width x $height"
    mogrify -background black -gravity center -extent "${width}x${height}" $input_image
}

function squarify {
    aspectratio 1.00 "$1"
}

function scale_video {
    input_video="$1"
    desired_height="$2"

    filename=$(basename -- "$input_video")
    extension="${filename##*.}"
    filename="${filename%.*}"

    ffmpeg -i "$input_video" -filter:v scale="-1:$desired_height" -c:a copy "${filename}_${desired_height}p.${extension}"
}

# time format: [-][<HH>:]<MM>:<SS>[.<m>...]
# HH expresses the number of hours, MM the number of minutes for a maximum of 2 digits and SS the
# number of seconds for a maximum of 2 digits. The m at the end expresses decimal value for SS.
function extract_video {
    input_video="$1"
    time_from="$2"
    time_to="$3"

    ffmpeg -ss "$time_from" -to "$time_to" -i "$input_video" -codec copy ffmpeg_extracted.mp4
}

function lowercase_all_filenames {
    for f in *; do mv "$f" "$f.tmp"; mv "$f.tmp" "$(echo $f | tr '[:upper:]' '[:lower:]')"; done
}

# DateTimeOriginal == the time of the shutter actuation
# CreateDate == the time that the file was written to storage
function rename_files_using_exif {
    FORMAT='media_%Y-%m-%d_%H.%M.%S%%-c.%%le'

    # [0] lowercase all filenames & extensions of all supported media types + aae
    # exiftool -filename=%lf.%le -ext+ aae .

    # [1] rename all .aae files to the date tag of their corresponding media file (if available)
    exiftool -ext aae -progress -ee -dateFormat "$FORMAT" \
             -tagsfromfile %d%f.mov "-FileName<CreationDate" \
             -tagsfromfile %d%f.jpg "-FileName<DateTimeOriginal" \
             -tagsfromfile %d%f.png "-FileName<DateTimeOriginal" .

    # [2] rename all media files
    # QuickTime::CreationDate for MOV files. Uses the original timezone.
    exiftool -progress -ee -dateFormat "$FORMAT" '-FileName<CreationDate' -ext mov .
    # EXIF::DateTimeOriginal for images. Uses the original timezone.
    exiftool -fixBase -progress -ee -dateFormat "$FORMAT" '-FileName<DateTimeOriginal' -ext jpg -ext png .
}

#
# misc
#
function separator_for_dock {
    defaults write com.apple.dock persistent-apps -array-add '{tile-type="spacer-tile";}'
    killall Dock
}

[ -f ~/.aliases.zsh ] && . ~/.aliases.zsh
