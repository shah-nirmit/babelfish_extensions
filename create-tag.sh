#!/usr/bin/zsh

set -e

# Set user name and email
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

export usage="$(basename "$0") [-h] [-c commit] [-r repo][-m]\n
  -h    help\n
  -c    commit hash; Default commit:HEAD\n
  -t    tag name"


while getopts hc:t:m flag
do
    case "${flag}" in
        h) echo -e "Usage: $usage"
            exit;;
        c) commit=${OPTARG};;
        t) new=${OPTARG};;
    esac
done

echo ${new}
echo ${commit}
echo ${message}
# get current commit hash for tag if not provided
if [ -z "$commit" ]
then
    commit=$(git rev-parse HEAD)
fi

# if tagname is not provided, fetch the latest tag and increment the patch
# version by 1.
if [ -z "$new" ]
then
    echo "Error: Tag not provided!"
    exit 1
fi

# check the tag format
format=BABEL_2_2_
if ! [[ "$new" =~ "$format"[0-9]+ ]]
then
    echo "Error: Invalid tag prefix, expected: ${format}<number>"
    exit 1
fi

git remote -vv
git branch -vv

echo Creating tag $new for commit $commit

git tag -a "${new}" -m "${message}" $commit
git push origin "${new}"
