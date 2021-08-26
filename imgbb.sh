#!/bin/bash

# Imgbb Script by Fahim F <sphincone@gmail.com>
# Version 1
# https://github.com/i3p9/imgbb.sh
# Public domain, no need to credit or link to anything if you end up using it

# Required: Grab API Key from https://api.imgbb.com/.
# DO NOT SHARE YOUR OWN API, DO NOT USE SOMEONE ELSES API KEY, ITS A PERSONAL KEY

api_key="" #CAN NOT BE EMPTY

if [ "$api_key" == "" ]; then
    echo "No API Key found. You must configure your own key before running imgbb.sh"
    echo "Grab an API key from https://api.imgbb.com/"
    exit 0
fi

#curl check
if [ -z "$(which curl)" ]; then
    echo "curl not found, install curl for the script to work"
    exit 0
fi


if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "Usage: $(basename $0) [<filename|URL> [...]]"
    echo
    echo "Supports uploading multiple images,"
    echo "Link gets copied to pbcopy (macOS), clip (Windows), xclip/xsel (Linux),"
    echo "Direct link to image and the delete link is displayed,"
    echo "Grabbing a API KEY from https://api.imgbb.com/ is a requirement, put it in api_key"
    exit 0
fi


function upload(){
    curl -s --location --request POST "https://api.imgbb.com/1/upload?key=$api_key" --form "image=$1"
}

#Start loop for uploading
for ((i = 1; i <= $#; i++ )); do
    if [[ "${!i}" =~ ^https?:// ]];then
        response=$(upload "${!i}")
    else
        response=$(upload "@${!i}")
    fi
    stat=$(sed -n 's|.*"id":"\([^"]*\)".*|\1|p' <<< "$response")
    if [ -z "$stat" ];then
        err_code=$(sed -n 's|.*"code":\([^"]*\),".*|\1|p' <<< "$response")
        err_msg=$(sed -n 's|.*"message":"\([^"]*\)".*|\1|p' <<< "$response")
        echo "Upload error: $err_code, $err_msg" >&2
    else
        url=$(sed -n 's|.*"url":"\([^"]*\)".*|\1|p' <<< "$response")
        del_link=$(sed -n 's|.*"delete_url":"\([^"]*\)".*|\1|p' <<< "$response")
        url=${url//\\/}
        del_link=${del_link//\\/}
        echo "$url"
        echo "Delete URL: $del_link" >&2
        clipboard+="$url"
        if [ $# -gt 0 ]; then
		    clipboard+=$'\n'
	    fi
    fi
done

# Copy to clipboard
if [ -n "$(which pbpaste)" ];then
    echo -n "$clipboard" | pbcopy
elif [ -n "$(which clip)" ];then
    echo -n "$clipboard" | clip
elif [ -n "$(which xclip)" ];then
    echo -n "$clipboard" | xclip
elif [ -n "$(which xsel)" ];then
    echo -n "$clipboard" | xsel -i
fi
