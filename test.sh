#!/bin/bash

set -e  # Exit on error

echo "Start Tests..."

# Change to the project directory
cd /path/to/project

# Check toolchain intstallation
check_toolchain() {
    echo "Checking toolchain installation..."
    if make check-toolchain &>> test.log ; then
        printf "\e[0;32m✓\e[0m "
        echo "Toolchain is installed"
    else
        printf "\e[0;31m✗\e[0m "
        echo "Toolchain is not installed or not configured properly"
        exit 1
    fi
}
check_toolchain

# Check file integrity
check_file_integrity() {
    echo "Checking file integrity..."
    if sha256sum -c .sha256sums &>> test.log ; then
        printf "\e[0;32m✓\e[0m "
        echo "Given files are unchanged"
    else
        printf "\e[0;31m✗\e[0m "
        echo "Given files have been modified"
    fi
}
check_file_integrity

# Compile and run program
echo "Compiling and running program..."
if make clean main &>> test.log && make run &>> test.log ; then
    printf "\e[0;32m✓\e[0m "
    echo "Program runs without errors"
else
    printf "\e[0;31m✗\e[0m "
    echo "Program failed to compile or run"
fi

# Run tests
echo "Running tests..."
mkdir -p tests
declare -i i=-1
incr () {
    i=$((i+1))
}

run_c_test () {
    test_name=$1
    array_size=${2:-20}
    seed=${3:-12309183}
    incr
    cat << EOF > tests/main.$i.c
#include "../libRA.c"
extern int max(int* arr, int len);

void _start() {
    int array_size = $array_size;
    int random_data[array_size];
    srand($seed);
    int first = (int) rand();
    random_data[0] = first;
    int acc = first;
    for (int c = 1; c < array_size; c++) {
        int num = (int) rand();
        random_data[c] = num;
        if (num > acc) acc = num;
    }
    int max_element = max(random_data, array_size);

    if (array_size <= 0 || max_element == acc) {
        println("The function returns the desired result.");
        exit(0);
    } else {
        println("The function returns not the desired result.");
        exit(1);
    }
}
EOF
    echo "Running test
