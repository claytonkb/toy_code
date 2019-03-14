// pearson.h

#ifndef PEARSON_H
#define PEARSON_H

#include <stdint.h>

#define PERM_TABLE_SIZE 256
#define BITS_PER_BYTE 8
#define HASH_BIT_SIZE (uint64_t)128
#define HASH_BYTE_SIZE (uint64_t)(HASH_BIT_SIZE/BITS_PER_BYTE)
#define ROTL64(x,y) ((x << y) | (x >> (64 - y)))

void pearson128(uint64_t *result, const uint64_t *init, const char *key, const unsigned strlen);
//void pearson128(hash result, const bstruct init, const char *key, const unsigned strlen);
//hash pearson_hash8(babel_env *be, const bstruct init, const char *key, const unsigned strlen);
static const char pearson_perm[PERM_TABLE_SIZE];

#endif //PEARSON_H

//Clayton Bauman 2018

