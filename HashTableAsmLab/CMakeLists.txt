cmake_minimum_required(VERSION 3.15)
project(HashTableAsmLab)

set(CMAKE_CXX_STANDARD 17)
# set(CMAKE_CXX_FLAGS "-pg -g")
include_directories(.)

add_executable(HashTableAsmLab main.cpp hash_table.h hash_table.cpp)