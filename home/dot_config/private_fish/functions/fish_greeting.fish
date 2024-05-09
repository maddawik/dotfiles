function fish_greeting
    if test (random 1 100) -gt 97
        set -l colors (set_color --print-colors)
        set -l outer (random choice $colors)
        set -l medium (random choice $colors)
        set -l inner (random choice $colors)
        fish_logo $outer $medium $inner
    end
end
