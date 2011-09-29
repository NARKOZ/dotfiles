# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cloud"
# not bad themes: robbyrussell kennethreitz kphoen juanghurtado macovsky simple sunrise

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to enable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew bundler gem osx rails3 rvm)
# not bad plugins: cake cap compleat extract lol node npm ruby svn textmate yum

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
. ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Test and then source alias definitions.
if [ -f $HOME/.aliases ]; then
        source ~/.aliases
else
        print "Note: $HOME/.aliases is unavailable."
fi

# Test and then source the functions.
if [ -f $HOME/.functions ]; then
        source $HOME/.functions
else
        print "Note: $HOME/.functions is unavailable."
fi

export PATH=$PATH:$HOME/bin

# Test and then setup Amazon EC2 command-line tools.
if [ -d $HOME/.ec2 ]; then
        export EC2_HOME=$HOME/.ec2
        export PATH=$PATH:$EC2_HOME/bin
        export EC2_PRIVATE_KEY=`ls $EC2_HOME/pk-*.pem`
        export EC2_CERT=`ls $EC2_HOME/cert-*.pem`
else
        print "Note: $HOME/.ec2 is unavailable."
fi
