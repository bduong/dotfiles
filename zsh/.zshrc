# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git mvn grails)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

export GREP_COLOR='1;35'
export MAVEN_HOME="/usr/bin/mvn"
export CATALINA_HOME="/Library/Tomcat"
export GRAILS_HOME=/usr/local/grails-2.1.1
export GROOVY_HOME=/usr/local/groovy-1.8.2
export GRADLE_HOME=/usr/local/gradle-1.2
export P4USER=bduong
export P4EDITOR=nano
export P4PORT=perforce-rhino.eng.vmware.com:1800
export P4CLIENT=bduong-mac-client
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_09.jdk/Contents/Home
export MYSQL_HOME="/usr/local/mysql-5.5.17-osx10.6-x86_64/"

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/usr/local/git/bin:/Users/bduong/bin:/usr/local/bin:/usr/local/android-sdk-mac_x86/platform-tools:/usr/local/groovy-1.8.2/bin:/usr/local/mysql/:/opt/subversion/bin:$HOME/vmware-git-tools/bin
export PATH=$PATH:$GRAILS_HOME/bin:$GROOVY_HOME/bin:$GRADLE_HOME/bin:$MYSQL_HOME/bin

function gpush() {
if [ $# -eq 0 ]; then
	git push origin HEAD:master
	else

	for repo in $*; do
		git push $repo HEAD:master		
		done

fi
	CURRENT=$(git branch|grep "*" | sed s/"* "//)
	git checkout master
	git pull
	git checkout $CURRENT
}

alias gdiff="git diff --color=auto"
alias grep="grep --color=auto"
alias glg="git log --stat"
alias la="ls -la"
alias lll="ll -ha"
alias sbash="source ~/.zshrc"
alias runMIN="open -a MINSensory.app"
alias branch="git branch"
alias branchv="git branch -vv"
alias vlc="/Applications/VLC.app/Contents/MacOS/VLC"
alias logTomcat="tail -f $CATALINA_HOME/logs/catalina.out"
alias startTomcat="startTomcat.sh"
alias startLTomcat="startTomcat; logTomcat"
alias stopTomcat="stopTomcat.sh"
alias stopLTomcat="stopTomcat; logTomcat"
alias gedit="/Applications/gedit.app/Contents/MacOS/gedit"
#alias gpush="git push origin HEAD:master"

function rebase-remote() {
	CURRENT=$(git branch|grep "*" | sed s/"* "//)
	git checkout master
	git rebase origin/master
	git checkout $CURRENT
	git rebase origin/master		
}

if [ -f ~/.zsh_nocorrect ]; then
    while read -r COMMAND; do
        alias $COMMAND="nocorrect $COMMAND"
    done < ~/.zsh_nocorrect
fi
