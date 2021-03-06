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

function color_git_original() {
 git log --stat --pretty=fuller $* |sed \
-e "s_\(commit\)\ \([0-9a-z]*\)_$(echo_color $YELLOW '\1')\ $(echo_color $YELLOW '\2')_g" \
-e "s_\(Author\):\ \([a-zA-Z0-9\. -]*\)\ <\([a-zA-Z0-9\.]*\)@\([a-zA-Z0-9\.-]*\)\.\([()a-zA-Z]*\)>_$(echo_color $BLUE '\1':)\ $(echo_color $WHITE '\2')\ <$(echo_color $CYAN '\3')@$(echo_color $BLUE '\4')\.$(echo_color $PINK '\5')>_g" \
-e "s_\(Commit\):\ \ \ \([a-zA-Z0-9\. -]*\)\ <\([a-zA-Z0-9\.]*\)@\([a-zA-Z0-9\.-]*\)\.\([()a-zA-Z]*\)>_$(echo_color $BLUE '\1'er:)\ $(echo_color $WHITE '\2')\ <$(echo_color $CYAN '\3')@$(echo_color $BLUE '\4')\.$(echo_color $PINK '\5')>_g" \
-e "s_\(^.*\)Date:\(.*\)_$(echo_color $MAGENTA '\1'\ Date:)$(echo_color $GREY '\2')_g" \
-e "s_\([0-9]*\ files\ changed\),\ \([0-9]*\ insertions(+)\),\ \([0-9]* deletions(-)\)_$(echo_color $BLUE '\1'),\ $(echo_color $GREEN '\2'),\ $(echo_color $RED '\3')_g" \
-e "s_\([-_\./a-zA-Z0-9]*\)\([ ]*\)|\([ ]*\)\([0-9]*\)\ \([+]*\)\([-]*\)_$(echo_color $BLUE '\1')\2|\3$(echo_color $WHITE '\4')\ $(echo_color $GREEN '\5')$(echo_color $RED '\6')_g" \
-e "s_\(Testing Done:\)\(.*\)_$(echo_color $YELLOW '\1')$(echo_color $YELLOW '\2')_g" \
-e "s_\(Bug Number:\)\(.*\)_$(echo_color $RED '\1')$(echo_color $RED '\2')_g" \
-e "s_\(Reviewed by:\)\(.*\)_$(echo_color $WHITE '\1')$(echo_color $WHITE '\2')_g" \
-e "s_\(Review URL:\)\(.*\)_$(echo_color $WHITE '\1')$(echo_color $WHITE '\2')_g" \
|less -X -r
}

function color_git_log() {
 git log --stat=150 --pretty=fuller --decorate $* |awk '/^Commit:.*$/ {printf("%s ", $0); next} 1' | awk '/^Author:.*$/ {printf("%s ", $0); next} 1' \
 | sed \
-e "s_\(commit\)\ \([0-9a-z]*\)\( (.*)\)\{0,1\}_$(echo_color $YELLOW '\1')\ $(echo_color $YELLOW '\2')  $(echo_color $CYAN '\3')_g" \
-e "s_\(Author\):\ \([a-zA-Z0-9\. -]*\)\ <\([a-zA-Z0-9\.]*\)@\([a-zA-Z0-9\.-]*\)\.\([()a-zA-Z]*\)>[ ]*\(.*\)Date:\(.*\)_$(echo_color $BLUE '\1':)\ $(echo_color $WHITE '\2')\ <$(echo_color $CYAN '\3')@$(echo_color $BLUE '\4')\.$(echo_color $PINK '\5')>	$(echo_color $MAGENTA '\6'\ Date:)$(echo_color $GREY '\7')_g" \
-e "s_\(Commit\):\ \ \ \([a-zA-Z0-9\. -]*\)\ <\([a-zA-Z0-9\.-]*\)@\([a-zA-Z0-9\.-]*\)\.\([()a-zA-Z]*\)>[ ]*\(.*\)Date:\(.*\)_$(echo_color $BLUE '\1'er:)\ $(echo_color $WHITE '\2')\ <$(echo_color $CYAN '\3')@$(echo_color $BLUE '\4')\.$(echo_color $PINK '\5')>	$(echo_color $MAGENTA '\6'\ Date:)$(echo_color $GREY '\7')_g" \
-e "s_\([0-9]*\ files\ changed\),\ \([0-9]*\ insertions(+)\),\ \([0-9]* deletions(-)\)_$(echo_color $BLUE '\1'),\ $(echo_color $GREEN '\2'),\ $(echo_color $RED '\3')_g" \
-e "s_\([-_\./a-zA-Z0-9]*\)\([ ]*\)|\([ ]*\)\([0-9]*\)\ \([+]*\)\([-]*\)_$(echo_color $BLUE '\1')\2|\3$(echo_color $WHITE '\4')\ $(echo_color $GREEN '\5')$(echo_color $RED '\6')_g" \
-e "s_\(Testing Done:\)\(.*\)_$(echo_color $YELLOW '\1')$(echo_color $YELLOW '\2')_g" \
-e "s_\(Bug Number:\)\(.*\)_$(echo_color $RED '\1')$(echo_color $RED '\2')_g" \
-e "s_\(Reviewed by:\)\(.*\)_$(echo_color $WHITE '\1')$(echo_color $WHITE '\2')_g" \
-e "s_\(Review URL:\)\(.*\)_$(echo_color $WHITE '\1')$(echo_color $WHITE '\2')_g" \
|less -X -r
}


function delete-behind() {
 git branch -vvv |grep behind |grep -v ahead | awk '{print $1}' |grep -v sp-main |grep -v '*'| while read line; do; git branch -d $line; done
}

function delete-merged() {
 git branch -vvv |grep sp-main |grep -v ahead | awk '{print $1}' |grep -v sp-main |grep -v '*'| while read line; do; git branch -d $line; done
}

function delete-behind-all() {
 git branch -vvv | grep -v release | awk '{print $1}' |grep -v develop |grep -v master | grep -v release |grep -v '*' | while read line; do; git branch -D $line; done
}

fix-move () 
{ 
    if [ $# -ne 3 ]; then
        echo "Usage: $FUNCNAME old new cl";
        return 65;
    fi;
    p4 revert $1;
    p4 open $1;
    cp $2 $1;
    p4 revert $2;
    rm $2;
    p4 move -c $3 $1 $2
}

function cleanup-branches() {
 COUNTER=0
 git branch -vv --sort=-committerdate | awk '{print $1}' | while read line 
	do
	if [ $COUNTER -gt $1 ]; then
		if [ $# -eq 2 ]; then 
			echo $line
		else
			git branch -D $line
		fi
	fi
	COUNTER=$((COUNTER + 1)); 
	done
}
