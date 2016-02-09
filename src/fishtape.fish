function fishtape -d "TAP producer and test harness for Fish"
    if not set -q argv[1]
        fishtape -h
        return 1
    end

    set -l fishtape_version

    set -l files
    set -l pipes
    set -l print source
    set -l error /dev/stderr

    printf "%s\n" $argv | sed -E 's/(^--?[a-z]+)=?/\1 /' | while read -l 1 2
        switch "$1"
            case --pipe
                if test -z "$2"
                    read 2
                end

                set pipes $pipes $2

            case -q --quiet
                set error /dev/null

            case -n -d --dry-run
                set print cat

            case -v --version
                printf "fishtape version %s\n" $fishtape_version
                return

            case -h --help
                printf "usage: fishtape [<file> [...]] [--dry-run] [--pipe=<utility>]\n"
                printf "                [--quiet] [--help] [--version]\n\n"

                printf "     --pipe=<utility>  Pipe line buffered output into <utility>\n"
                printf "         -d --dry-run  Print preprocessed files to stdout\n"
                printf "           -q --quiet  Set quiet mode\n"
                printf "         -v --version  Show version information\n"
                printf "            -h --help  Show help\n"
                return

            case -- -

            case -\*
                printf "fishtape: '%s' is not a valid option.\n" $1 >& 2
                fishtape -h >& 2
                return 1

            case \*
                if test ! -e "$1"
                    printf "fishtape: '%s' is not a valid file name\n" $1 > $error
                    return 1
                end

                set files $files $1
        end
    end

    if test ! -z "$pipes"
        fish -c "fish -c \"fishtape $files\""(printf " |%s" $pipes)

        return
    end

    awk (
        for name in runtime total locals reset setup count teardown
          printf "%s\n" -v $name=(
              functions __fishtape@{$name} | sed '1d;$d;s/\\\/\\\\\\\/g' | paste -sd ';' -)
        end
        ) '

    # FISHTAPE #

    ' $files | fish -c "$print" ^ $error
end
