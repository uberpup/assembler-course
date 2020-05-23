#ifndef HASHTABLEASMLAB_HASH_TABLE_H
#define HASHTABLEASMLAB_HASH_TABLE_H

#include <cstddef>
#include <cstring>
#include <forward_list>
#include <string>
#include <vector>
#include <utility>

struct StringBucket;

class HashTable {
private:
    static inline size_t Hash(const char* hashed);
    /*inline*/ ssize_t Find(const char* possibly_hashed);

public:
    HashTable() = delete;
    HashTable(size_t buckets) : size_(buckets), items_(buckets) {}

    ~HashTable() = default;
    bool Contains(const char* hashed);
    bool Insert(const char* hashed);

private:
    const size_t size_;
    std::vector<StringBucket> items_;
};

struct StringBucket {
    std::forward_list<const char*> list_;
    size_t size_ = 0;

    size_t size() {
        return size_;
    }
    void push_front(const char* pushed) {
        list_.push_front(pushed);
        ++size_;
    }
    decltype(list_.begin()) begin() {
        return list_.begin();
    }
    decltype(list_.end()) end() {
        return list_.end();
    }
};

#endif //HASHTABLEASMLAB_HASH_TABLE_H
