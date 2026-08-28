function _tide_item_aws_expiry
    set -l exp $AWS_SESSION_EXPIRATION
    test -z "$exp"; and set exp $AWS_CREDENTIAL_EXPIRATION
    test -z "$exp"; and return

    # Split "2026-08-28T01:40:38-04:00" into base time + numeric UTC offset
    set -l base (string replace -r '[+-][0-9]{2}:[0-9]{2}$' '' -- $exp)
    set -l off (string match -r '[+-][0-9]{2}:[0-9]{2}$' -- $exp)

    set -l epoch_utc (date -j -u -f "%Y-%m-%dT%H:%M:%S" "$base" +%s 2>/dev/null)
    test -z "$epoch_utc"; and return

    set -l offsec 0
    if test -n "$off"
        set -l sign (string sub -l 1 -- $off)
        set -l hh (string sub -s 2 -l 2 -- $off)
        set -l mm (string sub -s 5 -l 2 -- $off)
        set offsec (math "$hh * 3600 + $mm * 60")
        test "$sign" = -; and set offsec (math "-$offsec")
    end

    set -l expiry (math "$epoch_utc - $offsec")
    set -l now (date +%s)
    set -l diff (math "$expiry - $now")

    if test $diff -le 0
        tide_aws_expiry_bg_color=$tide_aws_expiry_bg_color_critical \
            tide_aws_expiry_color=$tide_aws_expiry_color_critical \
            _tide_print_item aws_expiry "(expired)"
        return
    end

    set -l h (math -s0 "floor($diff / 3600)")
    set -l m (math -s0 "floor(($diff % 3600) / 60)")
    set -l s (math -s0 "$diff % 60")

    set -l label
    if test $h -gt 0
        set label "$h"h"$m"m
    else
        set label "$m"m"$s"s
    end

    if test $diff -le $tide_aws_expiry_critical_threshold
        tide_aws_expiry_bg_color=$tide_aws_expiry_bg_color_critical \
            tide_aws_expiry_color=$tide_aws_expiry_color_critical \
            _tide_print_item aws_expiry "($label)"
    else
        _tide_print_item aws_expiry "($label)"
    end
end
