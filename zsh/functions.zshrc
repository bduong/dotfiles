BLACK="\033[1;30m"
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
PINK="\033[0;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
GREY="\033[0;37m"
END="\033[0m"

echo_bold () {
  message=${1}
  echo -e "\033[1m${message}\033[0m"
}
echo_color() {
  color=${1}
  message=${2}
  echo -e "${color}${message}$END"  
}

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

function rebase-remote() {
        CURRENT=$(git branch|grep "*" | sed s/"* "//)
        git checkout master
        git rebase origin/master
        git checkout $CURRENT
        git rebase origin/master
}

function gitup() {
        echo_bold "Fetching..............................."
        git fetch --all
        echo_bold "Rebasing..............................."
        rebase-remote
        echo_bold "Pushing................................"
        gpush
}


function color_maven() {
$MAVEN_HOME/bin/mvn $* | sed -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/$(echo -e '\e[1;97m')Tests run: \1$(echo -e '\e[0m'), $(echo -e '\e[1;91m')Failures: \2$(echo -e '\e[0m'), $(echo -e '\e[1;93m')Errors: \3$(echo -e '\e[0m'), $(echo -e '\e[1;94m')Skipped: \4$(echo -e '\e[0m')/g" \
    -e "s_\(\[WARN\].*\)_$(echo -e '\e[1;33m')\1$(echo -e '\e[0m')_g" \
    -e "s_\(\[WARNING\].*\)_$(echo -e '\e[1;33m')\1$(echo -e '\e[0m')_g" \
    -e "s_\(\[INFO\].*\)_$(echo -e '\e[1;34m')\1$(echo -e '\e[0m')_g" \
    -e "s_\(\[ERROR\].*\)_$(echo -e '\e[1;31m')\1$(echo -e '\e[0m')_g"
}

function color_git_log() {
 git log --stat $* |sed \
-e "s_\(commit\)\ \([0-9a-z]*\)_$(echo_color $YELLOW '\1')\ $(echo_color $YELLOW '\2')_g" \
-e "s_\(Author\):\ \([a-zA-Z0-9\. -]*\)\ <\([a-zA-Z0-9\.]*\)@\([a-zA-Z0-9\.-]*\)\.\([()a-zA-z]*\)>_$(echo_color $BLUE '\1')\ $(echo_color $WHITE '\2')\ <$(echo_color $CYAN '\3')@$(echo_color $BLUE '\4')\.$(echo_color $PINK '\5')>_g" \
-e "s_\(Date:\)\(.*\)_$(echo_color $MAGENTA '\1')$(echo_color $GREY '\2')_g" \
-e "s_\([0-9]*\ files\ changed\),\ \([0-9]*\ insertions(+)\),\ \([0-9]* deletions(-)\)_$(echo_color $BLUE '\1'),\ $(echo_color $GREEN '\2'),\ $(echo_color $RED '\3')_g" \
-e "s_\([-_\./a-zA-Z0-9]*\)\([ ]*\)|\([ ]*\)\([0-9]*\)\ \([+]*\)\([-]*\)_$(echo_color $BLUE '\1')\2|\3$(echo_color $WHITE '\4')\ $(echo_color $GREEN '\5')$(echo_color $RED '\6')_g" \
|more -R 
}



