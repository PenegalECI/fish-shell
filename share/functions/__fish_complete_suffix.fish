#
# Find files that complete $argv[1], has the suffix $argv[2], and
# output them as completions with the optional description $argv[3] Both
# $argv[1] and $argv[3] are optional, if only one is specified, it is
# assumed to be the argument to complete.
#

function __fish_complete_suffix -d "Complete using files"

    # Variable declarations

    set -l comp
    set -l suff
    set -l desc
    set -l files

    switch (count $argv)

        case 1
            set comp (commandline -ct)
            set suff $argv
            set desc ""

        case 2
            set comp $argv[1]
            set suff $argv[2]
            set desc ""

        case 3
            set comp $argv[1]
            set suff $argv[2]
            set desc $argv[3]

    end

    # Strip leading ./ as it confuses the detection of base and suffix
    # It is conditionally re-added below.
    set -l base_temp (string replace -r '^\./' '' -- $comp)

    set base (string replace -r '\.[^.]*$' '' -- $base_temp | string trim -c '\'"') # " make emacs syntax highlighting happy
    # echo "base: $base" > /dev/tty
    # echo "suffix: $suff" > /dev/tty

    # If $comp is "./ma" and the file is "main.py", we'll catch that case here,
    # but complete.cpp will not consider it a match, so we have to output the
    # correct form.
    if string match -qr '^\./' -- $comp
        eval "set files ./$base*$suff"
    else
        eval "set files $base*$suff"
    end

    if test $files[1]
        printf "%s\t$desc\n" $files
    end

    #
    # Also do directory completion, since there might be files
    # with the correct suffix in a subdirectory
    # No need to describe directories (#279)
    #

    __fish_complete_directories $comp ""

end
