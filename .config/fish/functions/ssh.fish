function ssh --wraps=ssh --description 'ssh wrapper: disable RemoteCommand when cmd passed'
    set -l has_cmd 0
    set -l skip 0
    for arg in $argv
        if test $skip -eq 1
            set skip 0
            continue
        end
        switch $arg
            case '-b' '-c' '-D' '-E' '-e' '-F' '-I' '-i' '-J' '-L' '-l' '-m' '-O' '-o' '-p' '-Q' '-R' '-S' '-W' '-w'
                set skip 1
            case '-*'
            case '*'
                if test $has_cmd -eq 0
                    set has_cmd 1
                else
                    set has_cmd 2
                    break
                end
        end
    end
    if test $has_cmd -eq 2
        command ssh -o RemoteCommand=none -o RequestTTY=no $argv
    else
        command ssh $argv
    end
end
