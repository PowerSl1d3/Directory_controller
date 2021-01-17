#! /usr/bin/bash

# Created by Aksenenko Oleg 01/17/2021

#TODO: parsing arguments
#TODO: add new argument - git

##############################################################################
# Directory controller.
# Arguments:
# $1 - name of creating folder
# $2 - count of creating subdirectories
# $3 - name of creating subdirectories (they will have $3{1..$2} names)
##############################################################################
# Exit code interpretation:
# 0 : everything are good
# 1 : bad count of arguments
# 2 : second argument not an integer number
##############################################################################

# Constants

NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'

# Checking arguments

if [[ $# -lt 3 ]]
then
    echo -e "${RED}Waiting for a 3 arguments"
    exit 1
fi

re='^[0-9]+$'

if ! [[ $2 =~ $re ]]
then
    echo -e "${RED}Second argument not a number"
    exit 2
fi

# Checking excising of directory

if [[ -d $1 ]]
then
    echo -e "${RED}The directory is excisting, it has several files...${NC}"
    ls -1 $1
    echo -e "Do you want do delete this directory?(${GREEN}yes${NC}/${RED}no${NC})"
    read -p "Answer only yes or no: " answer
    until [[ $answer == "yes" || $answer == "no" ]]
    do
            echo -e "${RED}Please, enter yes or no!${NC}"
            read answer
    done
    if [[ $answer == "yes" ]]
    then
	    rm -rf $1
    elif [[ $answer == "no" ]]
    then 
	    exit 0  
    fi
fi

# Creating directory

echo "Creating all directories..."
mkdir $1
cd $1
for (( i=1; i<=$2; i++ ))
do
    folder=$3$i
    mkdir $folder
    cd $folder
    mkdir build
    printf "#include <iostream>\nint main(int argc, char* argv[]) {\n	std::cout << \"Hello world\" << std::endl;\n	return 0;\n}" > main.cpp
    printf "cmake_minimum_required(VERSION 3.5)\n\nproject(Project$3$i LANGUAGES CXX)\n\nset(CMAKE_CXX_STANDARD 17)\nset(CMAKE_CXX_STANDARD_REQUIRED ON)\n\nadd_executable(\${PROJECT_NAME} main.cpp)" > CMakeLists.txt
    cd ../
done
echo -e "${GREEN}Done${NC}"
