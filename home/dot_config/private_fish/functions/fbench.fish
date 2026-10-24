function __fbench_ms_color --argument-names ms
    if test $ms -lt 50
        set_color green
    else if test $ms -lt 100
        set_color yellow
    else
        set_color red
    end
end

function __fbench_us_color --argument-names us threshold
    if test $us -ge (math "$threshold * 10")
        set_color red
    else if test $us -ge (math "$threshold * 3")
        set_color yellow
    else
        set_color normal
    end
end

function __fbench_us_fmt --argument-names us
    if test $us -ge 1000
        printf '%.1f ms' (math "$us / 1000")
    else
        printf '%d µs' $us
    end
end

# Wall time of one command in ms; its output is discarded
function __fbench_time
    perl -MTime::HiRes=time -e '
        open my $o, ">&", \*STDOUT; open STDOUT, ">", "/dev/null";
        my $t = time; system @ARGV;
        printf $o "%.1f", (time - $t) * 1000' $argv
end

function __fbench_avg
    math "("(string join + $argv)") / "(count $argv)
end

function fbench --description 'Benchmark fish startup time'
    argparse h/help 'n/runs=!_validate_int --min 1' 't/threshold=!_validate_int --min 0' 'o/output=' -- $argv
    or return

    if set -q _flag_help
        echo "Usage: fbench [-n RUNS] [-t MICROSECONDS] [-o PROFILE]"
        echo
        echo "  -n, --runs       timed runs (default 10, plus one warmup)"
        echo "  -t, --threshold  hide profile calls faster than this (default 100 µs)"
        echo "  -o, --output     profile file (default \$XDG_CACHE_HOME/fish/fishprof_<date>.txt)"
        return
    end

    set -l runs (set -q _flag_runs; and echo $_flag_runs; or echo 10)
    set -l threshold (set -q _flag_threshold; and echo $_flag_threshold; or echo 100)
    set -l outfile $_flag_output
    test -n "$outfile"; or set outfile $XDG_CACHE_HOME/fish/fishprof_(date '+%Y%m%d_%H%M%S').txt
    test -d (path dirname $outfile); or mkdir -p (path dirname $outfile)

    set -l normal (set_color normal)
    set -l bold (set_color --bold)
    set -l dim (set_color brblack)
    set -l accent (set_color cyan)

    echo
    echo $bold$accent"fbench"$normal$dim" · $runs runs of "$normal"fish -i -c exit"$dim" (+1 warmup)"$normal
    echo

    # The first run pays for cold caches, so it isn't counted
    __fbench_time fish -i -c exit >/dev/null
    __fbench_time fish --no-config -i -c exit >/dev/null

    # Baseline runs are interleaved so both series see the same system load.
    # Bars are absolute: 40 cells = 100 ms, so runs are comparable across invocations.
    set -l times
    set -l base_times
    for i in (seq $runs)
        set -l ms (__fbench_time fish -i -c exit)
        set -a base_times (__fbench_time fish --no-config -i -c exit)
        set -a times $ms
        set -l cells (math "min(40, max(1, round($ms / 2.5)))")
        printf '  %srun %2d%s  %s%6.1f ms%s  %s%s%s\n' \
            $dim $i $normal (__fbench_ms_color $ms) $ms $normal \
            (__fbench_ms_color $ms) (string repeat -n $cells █) $normal
    end

    set -l n (count $times)
    set -l sorted (printf '%s\n' $times | sort -n)
    set -l min $sorted[1]
    set -l max $sorted[-1]
    set -l avg (__fbench_avg $times)
    set -l mid (math "floor(($n + 1) / 2)")
    set -l median $sorted[$mid]
    if test (math "$n % 2") -eq 0
        set -l next (math $mid + 1)
        set median (math "($sorted[$mid] + $sorted[$next]) / 2")
    end
    set -l sq
    for t in $times
        set -a sq "($t - $avg)^2"
    end
    set -l stddev (math "sqrt(("(string join + $sq)") / $n)")

    set -l ticks ▁ ▂ ▃ ▄ ▅ ▆ ▇ █
    set -l spark
    for t in $times
        set -l idx 4
        test $max != $min; and set idx (math "round(($t - $min) / ($max - $min) * 7) + 1")
        set -a spark $ticks[$idx]
    end

    set -l base (__fbench_avg $base_times)
    set -l overhead (math "$avg - $base")
    set -l share (math "round(max(0, $overhead) / $avg * 100)")

    echo
    printf '  %savg%s  %s%s%.1f ms%s  %s± %.1f%s   %s%s%s\n' \
        $dim $normal $bold (__fbench_ms_color $avg) $avg $normal \
        $dim $stddev $normal $accent (string join '' $spark) $normal
    printf '  %smin%s %.1f  %smedian%s %.1f  %smax%s %.1f\n' \
        $dim $normal $min $dim $normal $median $dim $normal $max
    printf '  %sconfig%s %s%+.1f ms%s %s(%d%%)%s  %sfish alone%s %.1f ms\n' \
        $dim $normal $bold $overhead $normal $dim $share $normal $dim $normal $base

    fish -i --profile-startup=$outfile -c exit

    # Each conf.d file shows up in the profile as an anonymous `source $file`,
    # so pair those lines with the file list fish iterates over, in order
    set -l files (fish -c '
        set -l seen
        for file in $__fish_config_dir/conf.d/*.fish $__fish_sysconf_dir/conf.d/*.fish $__fish_vendor_confdirs/*.fish
            set -l name (path basename $file)
            contains -- $name $seen; and continue
            set -a seen $name
            test -f $file -a -r $file; and echo $file
        end')
    set -l sums (awk '
        /^ *[0-9]+ +[0-9]+ > for file in \$__fish_config_dir\/conf.d/ { loop = 1; next }
        loop && /^ *[0-9]+ +[0-9]+ > / { loop = 0 }
        loop && /^ *[0-9]+ +[0-9]+ -> source \$file$/ { print $2 }' $outfile)
    set -l rows
    if test (count $files) -eq (count $sums)
        for i in (seq (count $files))
            set -l label (path basename $files[$i])
            string match -q "$__fish_config_dir/conf.d/*" -- $files[$i]
            or set label "$label "$dim"("(string replace -r "^$HOME" '~' -- (path dirname $files[$i]))")"$normal
            set -a rows "$sums[$i]"\t"$label"
        end
    end
    for line in (awk '/^ *[0-9]+ +[0-9]+ > builtin source .*config\.fish$/ { print $2 "\t" $NF }' $outfile)
        set -l f (string split \t -- $line)
        set -a rows "$f[1]"\t(string replace -r "^$HOME" '~' -- $f[2])
    end

    echo
    echo $bold"Config files"$normal$dim" (incl. everything they call)"$normal
    if test (count $files) -ne (count $sums)
        echo "  "$dim"couldn't match conf.d files to the profile ("(count $files)" files, "(count $sums)" entries)"$normal
    end
    set -l rows (printf '%s\n' $rows | sort -t \t -k1,1nr)
    set -l top (string split -f1 \t -- $rows[1])
    for row in $rows[1..10]
        set -l f (string split -m1 \t -- $row)
        set -l cells (math "max(1, round($f[1] / $top * 20))")
        printf '  %s%9s%s  %s%-20s%s  %s\n' \
            (__fbench_us_color $f[1] $threshold) (__fbench_us_fmt $f[1]) $normal \
            $accent (string repeat -n $cells ▬) $normal $f[2]
    end

    echo
    echo $bold"Slowest calls"$normal$dim" (self > "(__fbench_us_fmt $threshold)")"$normal
    printf '  %s%9s %9s  %s%s\n' $dim self sum command $normal
    set -l width (math "max(20, $COLUMNS - 26)")
    for line in (awk -v t=$threshold 'NR > 1 && $1 > t' $outfile | sort -k1,1nr | head -25)
        set -l f (string match -r '^\s*(\d+)\s+(\d+)\s+(-*>)\s(.*)$' -- $line)
        or continue
        printf '  %s%9s%s %s%9s%s  %s%s %s\n' \
            (__fbench_us_color $f[2] $threshold) (__fbench_us_fmt $f[2]) $normal \
            $dim (__fbench_us_fmt $f[3]) $normal \
            $dim $f[4] $normal(string shorten -m $width -- $f[5])
    end
    echo
    echo $dim"profile: $outfile"$normal
end
