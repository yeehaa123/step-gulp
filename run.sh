#!/bin/sh
# return true if local npm package is installed at ./node_modules, else false
# example
# echo "gulpacular : $(npm_package_is_installed gulpacular)"
function npm_package_is_installed {
  # set to true initially
  local return_=true
  # set to false if not found
  ls node_modules | grep $1 >/dev/null 2>&1 || { local return_=false; }
  # return value
  echo "$return_"
}

# First make sure gulp is installed
if ! type gulp &> /dev/null ; then
    # Check if it is in repo
    if ! $(npm_package_is_installed gulp-cli) ; then
        info "gulp not installed globally, trying to install it through npm"

        if ! type npm &> /dev/null ; then
            fail "npm not found, make sure you have npm or gulp installed globally"
        else
            info "npm is available"
            debug "npm version: $(npm --version)"

            info "installing gulp globally"
            npm config set ca "" --silent
            sudo npm install npm -g --silent
            sudo npm install -g --silent gulp
            gulp_command="gulp"
        fi
    else
        info "gulp is available locally"
        debug "gulp version: $(./node_modules/gulp/bin/gulp --version)"
        gulp_command="./node_modules/gulp/bin/gulp"
    fi
else
    info "gulp is available"
    debug "gulp version: $(gulp --version)"
    gulp_command="gulp"
fi

gulp_working_path=""

# # Parse some variable arguments
# if [ "$WERCKER_gulp_DEBUG" = "true" ] ; then
#     gulp_command="$gulp_command --debug"
# fi
# 
# if [ "$WERCKER_gulp_STACK" = "true" ] ; then
#     gulp_command="$gulp_command --stack"
# fi
# 
# if [ -n "$WERCKER_gulp_gulpFILE" ] ; then
#     gulp_command="$gulp_command --gulpfile $WERCKER_gulp_gulpFILE"
# fi
# 
# if [ -n "$WERCKER_gulp_TASKS" ] ; then
#     gulp_command="$gulp_command $WERCKER_gulp_TASKS"
# fi

gulp_command="gulp test"

debug "$gulp_command"

set +e
$gulp_command
result="$?"
set -e

if [[ result -ne 0 && result -ne 6 ]]
then
  warn "$result"
  fail "$gulp_command failed"
else
  success "finished $gulp_command"
fi
