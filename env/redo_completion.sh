#!/bin/bash

# takes in an argument, likely `what` or `what_predefined`
__redo_cmd_parsed () {
    redo "$1" 2>&1 | tail +2 | sed 's/^redo //' | sed 's/\n/ /' | echo "$(cat -)
what" | grep -v "^$"
    return ${PIPESTATUS[0]} # i.e. status of redo what
}

# for all these functions:
# path arg should not contain a trailing slash

__what_parsed () {
    local path=$1
    __redo_cmd_parsed "$path/what"
}

__what_predef_parsed () {
    local path=$1
    __redo_cmd_parsed "$path/what_predefined"
}






__cache_ok () {
    local path=$1
    [ -f "$path"/build/redo/what_cache.txt ] || return 1
    [ -n "$(cat "$path"/build/redo/what_cache.txt)" ] || return 1
    # check for file integrity, timestamp, etc?
    return 0
}

__do_caching () {
    # echo  - ">f do caching enter"
    local path=$1
    local res status
    res="$(__what_parsed "$path")"
    status=$?
    echo "$res"
    [ "$status" = 0 ] || return 2
    mkdir -p "$path"/build/redo && echo "$res" > "$path"/build/redo/what_cache.txt
    [ "$?" = 0 ] || return 1
    # echo  - ">f do caching exit"
    return 0
}




# i.e. can we assume that the cache in this directory is completely up to date?
__dir_first_visit () {
    local path=$1 filename=./build/redo/what_cache_dirs.txt
    [ -f "$filename" ] || return 0

    cat "$filename" | grep "^$path\$" >/dev/null && return 1
    return 0
}

__dir_do_visit () {
    local path=$1 
    mkdir -p ./build/redo/ && echo "$path" >> ./build/redo/what_cache_dirs.txt
}

# doesn't take a path, since dir cache is always relative to ./
__dir_cache_clean () {
    local filename=./build/redo/what_cache_dirs.txt
    [ -f "$filename" ] && rm "$filename"
}




__save_last_confirmed_dir () {
    local dir=$1
    # echo - "saved $dir"
    mkdir -p ./build/redo/ && echo "$dir" > ./build/redo/what_cache_lastdir.txt
}

__get_last_confirmed_dir () {
    local filename=./build/redo/what_cache_lastdir.txt
    [ -f "$filename" ] || return 1

    local dir
    dir=$(cat "$filename")
    [ $? = 0 ] || return 1

    LAST_DIR="$dir"
    return 0
}




__prepend () {
    while read -r line; do
        echo "$1$line"
    done
}




# if $1 is formatted dir///other//stuff,
# split into LEAD_DIR=dir RES=other//stuff
__try_trim_leading_dir () {
    local basepath=$1 string=$2
    local all_ifs=false
    LEAD_DIR=
    REST=
    if echo "$string" | grep '/' >/dev/null; then
        # lmao, the sed command is replace 1 or more slashes with just 1 slash
        LEAD_DIR=$(echo "$string" | sed 's/\/\/*/\//' | cut -d '/' -f 1)
        if [ "$LEAD_DIR" != build ] && [ -d "$basepath/$LEAD_DIR" ]; then
            all_ifs=true
            REST=$(echo "$string" | sed 's/\/\/*/\//' | cut -d '/' -f 2-)
        fi
    fi

    [ "$all_ifs" = true ] && return 0
    return 1
}



__redo_completion_helper () {
    local path=$1 arg=$2

    if pwd | grep '/build$' >/dev/null || ! __what_predef_parsed "$path" >/dev/null; then
        # nothing to do here, `redo what` isn't even available
    #     echo - dip
        return 1
    fi

    # clean up $path / $arg -- replace instances of ./ with nothing
    path=$(echo "$path" | sed 's/\b\.\///')
    arg=$(echo "$arg" | sed 's/\b\.\///')
    [ "$arg" = . ] && arg=./ # just bc the user must have typed it in

    # path only gets edited when we recurse, so this is safe
    __save_last_confirmed_dir "$path"


    # return value
    RES=

    # locals
    local compgen_arg first_run=false
    if __dir_first_visit "$path"; then
        first_run=true
        __dir_do_visit "$path"
    fi

    # echo - "enter: path=($path) arg=($arg) first_run=$first_run"
    
    # logic
    
    # I assume that if someone types `redo <tab>`,
    # they probably want an up-to-date list of commands
    # but if someone types `redo b<tab>` for example,
    # they probably intended to autocomplete build/
    # which is likely still available, and useful to provide instantly

    # if typed `redo <tab>`, bypass cache
    if [ "$first_run" = true ] && [ -z "$arg" ]; then
        do_synchronous
        prepend_path
        return 0
    fi


    if __cache_ok "$path"; then
    #     echo - '> cache ok'
        compgen_arg=$(cat "$path"/build/redo/what_cache.txt)
    else
    #     echo - '> cache fallback to what_predef'
        # fallback to `redo what_predefined`
        compgen_arg=$(__what_predef_parsed "$path")
    fi

    # generate completions
    RES=$(compgen -W "$compgen_arg" "$arg")

    # if something matches, use the result and update caches in background
    # if no matches yet, check for redo's path syntax
    # -> if matches, recurse using subdirectory
    # if still no matches, match against directory names
    # if *still* no matches, synchronously run `redo what`

    if [ -n "$RES" ]; then

    #     echo - '> used cache'

        (do_async &)

        prepend_path
        return 0
    fi

    # echo - '> cache miss'

    # no match, so check for a path in the arg
    if __try_trim_leading_dir "$path" "$arg"; then
        # these are set by __try_trim_leading_dir
        local dir_prefix=$LEAD_DIR trimmed_arg=$REST

        
    #     echo - "arg ($arg) vs trimmed halves ($dir_prefix) ($trimmed_arg)"

        if [ "$path" = . ]; then
            path=$dir_prefix
        else
            path=$path/$dir_prefix
        fi

    #     echo - "> recurse: path ($path) arg ($trimmed_arg)"


        __redo_completion_helper "$path" "$trimmed_arg"
        local status=$?

        # don't unset -- recursive call already took care of that
        return $status
    fi

    # echo - '> no recurse'

    # echo - pre-full arg: "path ($path) arg ($arg)"
    # match against directories in $path
    local full_arg
    if [ "$path" = . ]; then
        full_arg=$arg
    elif [ -z "$arg" ]; then
        full_arg=$path
    else
        full_arg=$path/$arg
    fi
    RES=$(compgen -d "$full_arg" | grep -v '\bbuild\b' | sed 's/$/\//')

    # echo - full arg: $full_arg

    if [ -n "$RES" ]; then
    #     echo - '> matched compgen -d'
        # we have a match, may as well start a bg task in this dir
        # if ! __bg_pid_alive "$path"; then
        #     (do_async &)
        # fi
        (do_async &)

        return 0
    fi

    # echo - '> synchronous time'

    # now there's really nothing to match
    # so do synchronous anyway, but only on first run
    # this is useful for i.e. autocompleting build/ in a directory for the first time after making a few .yaml files
    if [ "$first_run" = true ]; then
        do_synchronous
        prepend_path
        return 0
    fi
}


__redo_completion () {
    local underscore=$_ # must be very first command
    local special_arg=____redo_completion_special_arg
    local first_run=false
    [ "$underscore" != "$special_arg" ] && first_run=true


    # $_ is set to the argument of the last executed command
    # so on the first run, it will depend on what the user just ran
    # the second run onwards, it will be set to $special_arg
    # this function runs once after every tab completion,
    # so we can use this to detect whether this is the user's first tab press

    # helps us figure out whether blocking on `redo what` is a waste
    # if first_run=true then the user might have run commands 
    # which might change the output of `redo what`
    if [ $first_run = true ]; then
        __dir_cache_clean
    fi

    local cmdname=$1 this_word=$2 prev_word=$3

    # echo -
    # echo - start: "first_run=$first_run this_word=$this_word"

    # make "local" functinos for helper function
    do_synchronous () {
        compgen_arg=$(__do_caching "$path")
        RES=$(compgen -W "$compgen_arg" "$arg")
    }

    do_async () {
        __do_caching "$path" >/dev/null
        # __save_bg_pid "$path" $!
    }

    prepend_path () {
        if [ $path != . ] && [ -n "$RES" ]; then
            RES=$(echo "$RES" | __prepend "$path/")
        fi
    }

    local subdir trimmed_arg
    try_cached_dir () {
        subdir= trimmed_arg=
        local all_ifs=false
        if __get_last_confirmed_dir; then
            local lastdir=$LAST_DIR

            # check if arg starts with dir
            if echo "$this_word" | grep "^$lastdir" >/dev/null; then
                subdir=$lastdir
                # apparently, trims prefix from string (note trailing slash)
                trimmed_arg=$(echo "${this_word#*$subdir}" | sed 's/^\///')
    #             echo - "last confirmed: subdir=$subdir trimmed_arg=$trimmed_arg"
                all_ifs=true
            fi
        fi
        [ "$all_ifs" = true ] && return 0 || return 1
    }

    # helper function sets the RES variable
    if [ "$first_run" = false ] && try_cached_dir; then
        # this saves a few recursions 
        # see recursion in helper function for when this gets cached
    #     echo - "> insta-recurse"
        __redo_completion_helper "$subdir" "$trimmed_arg"
    else
        __redo_completion_helper . "$this_word"
    fi

    unset -f do_synchronous unset_funcs task prepend_path

    if [ $? = 0 ]; then
        # if it ends with a slash, it's a path
        # so if it doesn't end with a slash, we should add a space to it
        if [ -n "$RES" ] && ! echo "$RES" | grep '/$' >/dev/null; then
            RES=$(echo "$RES" | sed 's/$/ /')
        fi

        oldifs=$IFS
        IFS="
"
        COMPREPLY=($RES)
        IFS=$oldifs
        unset oldifs
    fi
    
    # must be very last command, see top
    echo $special_arg > /dev/null
}

# the reason we can't use `complete -o dirnames` is that
# we need to exclude ./build (and want to exclude hidden dirs)
complete -o nospace -o nosort -F __redo_completion redo


