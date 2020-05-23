#include <x86intrin.h>
#include "hash_table.h"

/*
size_t HashTable::Hash(const char* hashed) { // SDBM algorithm
    std::string hashed_string(hashed);
    size_t hash = 0;
    for (char i : hashed_string) {
        hash = i + (hash << 6) + (hash << 16) - hash;
    }
    return hash;
}//*/

size_t HashTable::Hash(const char* hashed) {
  size_t hash = 0;
  for (size_t i = 0; i < strlen(hashed); i++) {
      hash = _mm_crc32_u8(hash, hashed[i]);
  }
  return hash;
}//*/

/*
ssize_t HashTable::Find(const char* possibly_hashed) {
    size_t hash = Hash(possibly_hashed) % items_.size();
    auto it = items_[hash].begin();
    auto it_end = items_[hash].end();
    while (it != it_end) {
        if (strcmp(*it, possibly_hashed) == 0) {
            return hash;
        }
        ++it;
    }
    return -1;
}//*/


ssize_t HashTable::Find(const char* possibly_hashed) {
    ssize_t hash = Hash(possibly_hashed) % items_.size();
    const char** begin_ptr = &(*items_[hash].begin());  // list begin pointer
    const size_t items_size = items_[hash].size();
    __asm__ __volatile__ (
        ".intel_syntax noprefix\n\t"
        "nop\n\t"
        "mov r11, -1\n\t"
        "sub rbx, 8\n\t"
        ".loop:\n\t"
        "inc r11\n\t"
        "xor rax, rax\n\t"
        "xor r12, r12\n\t"
        "xor r13, r13\n\t"
        "add rbx, 8\n\t"
        "xor rdi, rdi\n\t"
        "cmp r11, rdx\n\t"
        "je .not_found\n\t\n\t"
        ".loop_str:\n\t"
        "mov r12, [rbx]\n\t"
        "mov al, [r12 + rdi]\n\t"
        "mov r13b, [rsi + rdi]\n\t"
        "inc rdi\n\t"
        "cmp al, r13b\n\t"
        "jne .loop\n\t"
        "cmp al, 0\n\t"
        "je .end\n\t"
        "jmp .loop_str\n\t\n\t"
        ".not_found:\n\t"
        "mov rcx, -1\n\t\n\t"
        ".end:\n\t"
        "nop\n\t\n\t"
        ".att_syntax \n\t"
        : "=c"(hash)
        : "0"(hash), "b"(begin_ptr), "d"(items_size), "S"(possibly_hashed)
        : "%rax", "%rdi", "%r11","%r12", "%r13"
    );
    return hash;
}//*/

bool HashTable::Contains(const char* hashed) {
    auto find_result = Find(hashed);
    return find_result != -1;
}

bool HashTable::Insert(const char* hashed) {
    if (!Contains(hashed)) {
        items_[Hash(hashed) % items_.size()].push_front(hashed);
        return true;
    }
    return false;
}