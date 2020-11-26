#!/usr/bin/env bash

#######################################################
# constants:
SELF_DIR=$(cd "$(dirname "$0")" || exit 1; pwd)
PROJECT_ROOT=$SELF_DIR/..

ALL_MODULES=(A B C D)

#######################################################
# colorful std output
function cecho {
  local code="\033["
  case "$1" in
    black  | bk) color="${code}0;30m";;
    red    |  r) color="${code}1;31m";;
    green  |  g) color="${code}1;32m";;
    yellow |  y) color="${code}1;33m";;
    blue   |  b) color="${code}1;34m";;
    purple |  p) color="${code}1;35m";;
    cyan   |  c) color="${code}1;36m";;
    gray   | gr) color="${code}0;37m";;
    *) local text="$1"
  esac

  [[ -z "${text}" ]] && local text="${color}$2${code}0m"
  echo -e "${text}"
}

#######################################################
# build:
#   mvn -pl "$MODULES" -am clean $SUB_CMD $OPTS || exit 1
function build() {
  cd "$PROJECT_ROOT" || exit 1

  case $MODE in
    publish|install|p|i)
      cecho b "publish to local .m2 repo..."
      SUB_CMD="install"
      OPTS="-DskipTests"
      ;;
    release|r)
      cecho b "publish to remote repo..."
      SUB_CMD="deploy"
      OPTS="-DskipTests"
      ;;
    package)
      cecho b "build jar without dependencies..."
      SUB_CMD="package"
      OPTS="-DskipTests"
      ;;
    assembly|a)
      cecho b "assembly fat-jars..."
      SUB_CMD="package"
      OPTS="-DskipTests $ASSEMBLY_OPTS"
      ;;
    test|t)
      cecho b "unit test"
      SUB_CMD="test"
      OPTS=""
      ;;
    *) usage
      ;;
  esac

  PKG_VERSION=$(sed -n 's|^.*<revision>\(.*\)</revision>|\1|p' "$PROJECT_ROOT/P/pom.xml")
  cecho b "building $MODULES with version ${PKG_VERSION}"
  mvn clean
  mvn -pl "$MODULES" -am $SUB_CMD $OPTS || exit 1
}

# join array by first arg
function join_by {
  local delimiter=$1; shift
  echo -n "$1"; shift
  printf "%s" "${@/#/$delimiter}"
  # printf " | %s" "${ALL_MODULES[@]}"
}

function usage() {
  joined_modules=$(join_by " | " "${ALL_MODULES[@]}")
  cat << EOF
  Usage:
    bash $0 sub_command modules
  sub_command:
    - publish: publish to local .m2 repo
    - release: publish to remote repo
    - assembly: build fat-jar
    - package: build jar without dependencies
    - test: unit test
  modules:
    ${joined_modules} | all
EOF
  exit 1
}

################################
# parse global env:
#   MODE, MODULES, ASSEMBLY_OPTS
function args() {
  if [[ $# -lt 2 ]]; then
      usage
  fi

  MODE=$1
  # parse modules to build
  case $2 in
    all) MODULE_ARR=( "${ALL_MODULES[@]}" );;
    *) MODULE_ARR=( "${@:2}" );;
  esac

  # for assembly mode, pass options -Dmodule.skip.assembly=false to enable assembly specified modules.
  case $MODE in
    assembly)
      ASSEMBLY_OPTS=$(printf -- "-D%s.skip.assembly=false " "${MODULE_ARR[@]}");;
    *)
      ASSEMBLY_OPTS=""
  esac

  MODULES=$(join_by "," "${MODULE_ARR[@]}")

  cecho g ">>>>> $MODE modules: $MODULES..."
}

############################### main ############################
args "$@"

start=$(date +%s)
build
end=$(date +%s)
cecho r ">>>>> ($MODE) ALL_DONE in $(( end - start ))s"
