# Script for testing modify.sh
# Script is divided into 4 sections:
# 1. No recursion - checks only simple cases of -u, -l and sed pattern applied to one and many filenames.
# 2. Recursion - checks -r and -u, -l and sed pattern.
# 3. Errors handling - provide not existing paths, apply not correct flags etc.
# 4. Problematic file names - provide filenames staring with a minus, space-speoarated, containg numbers and signs, etc.



mkdir tf
touch tf/a



echo -e "\n***1. NO RECURSION***\n"

echo -e "\n1.1 CORRECT CASES\n"

echo -e "\nSINGLE FILE\n"

echo -e "\nStarting folder tf"
ls tf

echo "1.1.1 Change 1 file name to uppercase - [./modify.sh -u tf/a]"
./modify.sh -u tf/a
ls tf

echo "1.1.2 Change 1 file name to lowercase - [./modify.sh -l tf/A]"
./modify.sh -l tf/A
ls tf

echo "1.1.3 Change 1 file name with sed pattern - [./modify.sh 's/test/sed_name/g' tf/A]"
./modify.sh 's/a/sed_name/g' tf/a
ls tf

echo -e "\nMULTIPLE FILES\n"

./modify.sh 's/sed_name/a/g'  tf/sed_name
touch tf/b tf/c
echo -e "\nStarting folder tf"
ls tf


echo "1.1.4 Change multiple file names to upercase - [./modify.sh -u tf/a tf/b]"
./modify.sh -u tf/a tf/b 
ls tf

echo "1.1.5 Change multiple file names to lowercase - [./modify.sh -l tf/A tf/B] "
./modify.sh -l tf/A tf/B
ls tf

echo "1.1.6 Change multiple file names with sed pattern - [./modify.sh 's/c/sed_name/g' tf/c]"
./modify.sh 's/c/sed_name/g' tf/c
ls tf

echo -e "\nALL FILES IN A FOLDER\n"


echo "1.1.7 Change all filenames to uppercase in a folder - [./modify -u ./tf/*]"
./modify.sh -u ./tf/*
ls tf

echo "1.1.8 Change all filenames to lowercase in a folder - [./modify -l ./tf/*]"
./modify.sh -l ./tf/*
ls tf

echo -e "\nStarting folder tf"
ls tf


echo -e "\n1.2 INCORRECT CASES\n"

echo "1.2.1 Call modify with no arguments - [./modify.sh]"
./modify.sh

echo "1.2.2 Call modify with no flags - [./modify.sh a]"
./modify.sh a
ls tf

echo "1.2.3 Using incorrect sed pattern - [./modify.sh 's/a/b' A]"
./modify.sh 's/x/y' A

echo -e "1.2.4 Trying to modify non-existing file - [./modify.sh -l tf/z]"
./modify.sh -u tf/z
ls tf

echo -e "1.2.6 Trying to rename a file to a name that already exists in the directory - [./modify.sh 's/a/b' tf/a]"
./modify.sh 's/a/b' tf/a
ls tf


echo -e "\n***2. RECURSION***\n"

rm ./tf/*
mkdir tf/tf2
touch tf/a tf/b tf/c tf/tf2/d tf/tf2/e
echo -e "\nStarting folders tf and tf/tf2"

ls -R tf


echo -e "\n***2.1 CORRECT CASES***\n"

echo "\nSINGLE FILE\n"

echo "2.1.1 Modify 1 filename to uppercase"
./modify.sh -r -u tf/a
ls -R tf

echo "2.1.2 Modify 1 filename to lowercase"
./modify.sh -r -l tf/A
ls -R tf

echo "2.1.3 Modify 1 filename with sed pattern"
./modify.sh -r "s/tf/b/sed_name" tf/c
ls -R tf

echo -e "\nMULTIPLE FILES\n"




echo -e "\ALL FILES IN A FOLDER\N"

echo "2.1.7  Modify all filenames in tf and tf/tf2 to uppercase - [./modify.sh -r -u tf/]}"
./modify.sh -r -u tf
ls -R tf

echo "2.1.8 Modify all filenames in tf and tf/tf2 to lowercase - [./modify.sh -r -l tf/]}"
./modify.sh -r -l tf
ls -R tf

echo "2.1.9 Modify all filenames in tf and tf/tf2 with a sed pattern - []}"
./modify.sh -r 's/a/sed_name/g' tf
lsr -R tf

echo -e "2.2***INCORRECT CASES***" 

echo -e "2.1.4 Modify m "
ls -R tf

rm -R ./tf

