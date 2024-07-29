if [ -z "$1" ]; then
    echo "Usage: sh check.sh file.c"
elif [ -z "$2" ]; then
    echo "Usage: sh check.sh file.c -> 'input'"
elif [ -f "$1" ]; then
    COLORED='\033[0;31m'
    DEFAULT='\033[0m'
    echo "\033[0;32m.C Checker\033[m\n"
    echo "CLANG Formating..."
    
    # clang-format -style=file:../materials/linters/.clang-format -i $1
    
    touch .clang-format
    echo "---\nBasedOnStyle: Google\nIndentWidth: 4\nColumnLimit: 110\n" >> .clang-format
    clang-format -i $1
    rm .clang-format
    
    echo "CPP-CHECKing...${COLORED}" $(cppcheck --enable=all --suppress=missingIncludeSystem $1) "${DEFAULT}"
    
    echo "Flag-leaks Testing...${COLORED}"
    # echo $(gcc -fsanitize=address $1)
    # echo $(printf "$2" | ./a.out)
    
    echo $(gcc -fsanitize=leak $1) $(printf "$2" | ./a.out)
    
    # echo $(gcc -fsanitize=undefined $1)
    # echo $(printf "$2" | ./a.out)
    
    echo "${DEFAULT}"
    
    echo "Compilation -W Testing...${COLORED}" $(gcc -Wall -Werror -Wextra $1) "${DEFAULT}"
    
    echo "Execute Testing...${COLORED}" $(printf "$2" | ./a.out) "${DEFAULT}"
    
    echo "\033[0;33m\nType \n     leaks -atExit -q -- ./a.out\nto leaks check${DEFAULT}"
    
    # echo "Leaks Testing..." $(printf "$2" | leaks -atExit -q -- ./a.out)
else
    echo "Файл не найден"
fi