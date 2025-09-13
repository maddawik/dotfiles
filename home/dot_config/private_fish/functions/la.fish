# Overrides the builtin fish function
function la --wraps=ls --description 'List contents of directory, including hidden files in directory using long format'
    ls -lA $argv
end
