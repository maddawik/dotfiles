function fish_greeting
    if test (random 1 100) -gt 97
        set -l colors (set_color --print-colors)

        set o (set_color (random choice $colors))
        set m (set_color (random choice $colors))
        set i (set_color (random choice $colors))
        set mouth '['
        set eye O

        echo '                 '$o'___
  ___======____='$m'-'$i'-'$m'-='$o')
/T            \_'$i'--='$m'=='$o')
'$mouth' \ '$m'('$i$eye$m')   '$o'\~    \_'$i'-='$m'='$o')
 \      / )J'$m'~~    '$o'\\'$i'-='$o')
  \\\\___/  )JJ'$m'~'$i'~~   '$o'\)
   \_____/JJJ'$m'~~'$i'~~    '$o'\\
   '$m'/ '$o'\  '$i', \\'$o'J'$m'~~~'$i'~~     '$m'\\
  (-'$i'\)'$o'\='$m'|'$i'\\\\\\'$m'~~'$i'~~       '$m'L_'$i'_
  '$m'('$o'\\'$m'\\)  ('$i'\\'$m'\\\)'$o'_           '$i'\=='$m'__
   '$o'\V    '$m'\\\\'$o'\) =='$m'=_____   '$i'\\\\\\\\'$m'\\\\
          '$o'\V)     \_) '$m'\\\\'$i'\\\\JJ\\'$m'J\)
                      '$o'/'$m'J'$i'\\'$m'J'$o'T\\'$m'JJJ'$o'J)
                      (J'$m'JJ'$o'| \UUU)
                       (UU)'(set_color normal)
    end
end
