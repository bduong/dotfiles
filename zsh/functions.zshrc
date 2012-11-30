echo_bold () {
  message=${1}
  echo -e "\033[1m${message}\033[0m"
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

function git-up() {
        echo_bold "Fetching..............................."
        git fetch --all
        echo_bold "Rebasing..............................."
        rebase-remote
        echo_bold "Pushing................................"
        gpush
}


color_maven() {
mvn $* | sed -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/$(echo -e '\e[1;97m')Tests run: \1$(echo -e '\e[0m'), $(echo -e '\e[1;91m')Failures: \2$(echo -e '\e[0m'), $(echo -e '\e[1;93m')Errors: \3$(echo -e '\e[0m'), $(echo -e '\e[1;94m')Skipped: \4$(echo -e '\e[0m')/g" \
    -e "s_\(\[WARN\].*\)_$(echo -e '\e[1;33m')\1$(echo -e '\e[0m')_g" \
    -e "s_\(\[WARNING\].*\)_$(echo -e '\e[1;33m')\1$(echo -e '\e[0m')_g" \
    -e "s_\(\[INFO\].*\)_$(echo -e '\e[1;34m')\1$(echo -e '\e[0m')_g" \
    -e "s_\(\[ERROR\].*\)_$(echo -e '\e[1;31m')\1$(echo -e '\e[0m')_g"
}


