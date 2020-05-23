#include <iostream>
#include <fstream>
#include "hash_table.h"

const size_t QUERIES_NUM = 1000000;

int main() {
    HashTable hash_table(500);

    std::ifstream infile("./formatted_newstest2011.txt");

    std::vector<std::string> dict;
    std::string inputted(1024, '\0');
    while (std::getline(infile, inputted)) {
        hash_table.Insert(inputted.c_str());
        dict.push_back(inputted);
    }

    for (int i = 0; i < QUERIES_NUM; ++i) {
        hash_table.Contains(dict[i % dict.size()].c_str());
    }

    //hash_table.Insert("a");
    //hash_table.Insert("aa");
    //hash_table.Contains("aa");
    //hash_table.Contains("aaa");
    return 0;
}