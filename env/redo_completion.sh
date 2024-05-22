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
    local path=$1
    local res status
    res="$(__what_parsed "$path")"
    status=$?
    echo "$res"
    [ "$status" = 0 ] || return 2
    mkdir -p "$path"/build/redo && echo "$res" > "$path"/build/redo/what_cache.txt
    [ "$?" = 0 ] || return 1
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




__save_bg_pid () {
    local path=$1 pid=$2

    mkdir -p "$path"/build/redo/ && echo "$pid" > "$path"/build/redo/what_cache_pid.txt
}

# __unsave_bg_pid () {
#     local path=$1

#     rm "$path"/build/redo/what_cache_pid.txt
# }

__echo_bg_pid () {
    local path=$1 filename=./build/redo/what_cache_pid.txt
    [ -f "$filename" ] || return 1

    local pid=$(cat "$filename")
    [ $? = 0 ] || return 1

    echo "$pid"
    return 0
}




# if $1 is formatted dir///other//stuff,
# split into LEAD_DIR=dir RES=other//stuff
__try_trim_leading_dir () {
    local all_ifs=false
    LEAD_DIR= 
    REST=
    if echo "$1" | grep '/' >/dev/null; then
        # lmao, the sed command is replace 1 or more slashes with just 1 slash
        LEAD_DIR=$(echo "$1" | sed 's/\/\/*/\//' | cut -d '/' -f '1')
        if [ "$LEAD_DIR" != build ] && [ -d "$LEAD_DIR" ]; then
            all_ifs=true
            REST=$(echo $1 | sed 's/\/\/*/\//' | cut -d '/' -f 2-)
        fi
    fi

    [ "$all_ifs" = true ] && return 0
    return 1
}




__redo_completion_helper () {
    local arg=$1 path=$2 empty_args=$3

    # our return value
    RES=

    if ! __what_predef_parsed $path >/dev/null; then
        # nothing to do here, redo what isn't even available
        return 1
    fi


    local compgen_arg do_synch=false onlywhat=false

    local first_run=false
    __dir_first_visit "$path" && first_run=true

    # echo - first_run = $first_run
    # echo - path = $path


    do_synchronous () {
        compgen_arg=$(__do_caching "$path")
        RES=$(compgen -W "$compgen_arg" "$arg")
    }

    do_async () {
        __do_caching "$path" >/dev/null
        __save_bg_pid "$path" $!
    }

    unset_funcs ()  {
        unset -f finish
        unset -f do_synchronous
    }

    finish () {
        __dir_do_visit "$path"
        unset_funcs
        if [ -n "$RES" ] && ! echo "$RES" | grep '/$' >/dev/null; then
            RES=$(echo "$RES" | sed 's/$/ /')
        fi
    }

    # I assume that if someone types `redo <tab>`,
    # they probably want an up-to-date list of commands
    # but if someone types `redo b<tab>` for example,
    # they probably intended to autocomplete build/
    # which is likely still available, and useful to provide instantly

    # if typed `redo <tab>`, bypass cache
    # if __dir_first_visit "$path" && [ "$empty_args" = true ]; then
    if [ "$first_run" = true ] && [ -z "$arg" ]; then
        do_synchronous
        finish
        return 0
    fi


    if __cache_ok "$path"; then
        compgen_arg=$(cat "$path"/build/redo/what_cache.txt)
    else
        # fallback to `redo what_predefined`
        compgen_arg=$(__what_predef_parsed "$path")
    fi


    # generate completions
    RES=$(compgen -W "$compgen_arg" "$arg")

    # use cache for responsiveness
    # but make sure a background task is fetching up-to-date results

    # if nothing in the cache matches, 
    # we should check if they are using redo's path syntax
    if [ -z "$RES" ]; then
        if __try_trim_leading_dir "$arg" && [ "$LEAD_DIR" != build ]; then
            # if so, recurse
            __redo_completion_helper "$REST" "$LEAD_DIR" "$empty_args"
            local status=$?


            if [ -n "$RES" ]; then
                # prepend $LEAD_DIR to all entries
                RES=$(echo "$RES" | sed "s/^/$LEAD_DIR\//")
            fi
            
            # no need to `finish`, already ran in other function call
            return $status
        fi

        # $arg both doesn't have a match and doesn't contain a path
        # but it might be a half-typed path
        # so let's try giving completions for paths (that aren't ./build)
        RES=$(compgen -d "$this_word" | grep -v '\bbuild\b' | sed 's/$/\//')

        if [ -z "$RES" ] && __dir_first_visit "$path"; then
            # now there's really nothing to match
            # so do synchronous anyway
            # but only on first run
            # this is useful for i.e. autocompleting build/ in a directory for the first time after making a few .yaml files
            do_synchronous
            finish
            return 0
        fi
    fi

    # we used the cache, 
    # so start a `redo what` background thread if not started
    if ! ps p "$(__echo_bg_pid "$path")" &>/dev/null; then
        # pid is not alive, so start bg process
        (do_async &)
    fi


    # # if nothing in cache matches, do synchronous anyway 
    # # (but only on first run to make it responsive)
    # if __dir_first_visit $path && [ -z "$compgen_res" ]; then
    #     do_synchronous
    #     finish

    # elif ! bg_thread_alive; then
    #     # pid is not alive, so start bg process
    #     do_async
    # fi

    finish
    return 0
}

__redo_completion () {
    # $_ is set to the argument of the last executed command
    # on the first run, it will depend on what the user just ran
    # the second run onwards, it will be set to $special_arg
    # this function runs once after every tab completion,
    # so we can use this to detect whether this is the user's first tab press

    local underscore=$_ # must be very first command
    local special_arg=____redo_completion_special_arg

    local first_run=false
    [ "$underscore" != "$special_arg" ] && first_run=true

    # echo
    # echo - cleaned cache = $first_run
    if [ $first_run = true ]; then
        __dir_cache_clean
    fi

    local cmdname=$1 this_word=$2 prev_word=$3

    local empty_args=false
    [ -z "$this_word" ] && [ "$prev_word" = "$cmdname" ] && empty_args=true

    __redo_completion_helper "$this_word" . "$empty_args"

    oldifs=$IFS
    IFS="
"
    COMPREPLY=($RES)
    IFS=$oldifs
    unset oldifs
    # unset RES

    # must be very last command, see top
    echo $special_arg > /dev/null
}

# the reason we can't use `complete -o dirnames` is that
# we need to exclude ./build (and want to exclude hidden dirs)
complete -o nospace -F __redo_completion redo






