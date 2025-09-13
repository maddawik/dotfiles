# Overrides the builtin fish function
function ll --wraps=ls --description 'List contents of directory using long format'
    ls -l $argv
end
