//cutils.h

#ifndef CUTILS_H
#define CUTILS_H

#include <stddef.h>
#include <stdio.h>
#include <memory.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>

/*****************************************************************************
 *                                                                           *
 *                            MISC C UTILITIES                               *
 *                                                                           *
 ****************************************************************************/
#define STRLEN(s) (sizeof(s)-1) // STRLEN#

#define _die            do{ fprintf(stderr, "Died at %s line %d\n", __FILE__, __LINE__); exit(1); } while(0)
#define _fatal(x)       do{ fprintf(stderr, "FATAL: %s in %s()\n", x, __func__); _die; } while(0)
#define _warn(x)        do{ fprintf(stderr, "WARNING: %s in %s() at %s line %d\n", x, __func__, __FILE__, __LINE__); fflush(stderr); } while(0)
#define _error(x)       do{ fprintf(stderr, "ERROR: %s in %s() at %s line %d\n", x, __func__, __FILE__, __LINE__); fflush(stderr); } while(0)
#define _enhance(x)     do{ fprintf(stderr, "NOT IMPLEMENTED: %s in %s() at %s line %d\n", x, __func__, __FILE__, __LINE__); _die; } while(0)
#define _pigs_fly       _fatal("Pigs CAN fly...")

#define _d(x)           do{ fprintf(stderr, "%s %x\n", #x, (unsigned)x); fflush(stderr); } while(0)
#define _dq(x)          do{ fprintf(stderr, "%s %016lx\n", #x, (uint64_t)x); fflush(stderr); } while(0)
#define _dw(x)          do{ fprintf(stderr, "%08x ", (unsigned)x); fflush(stderr); } while(0)
#define _dc(x)          do{ fprintf(stderr, "%02x ",  (uint8_t)x); fflush(stderr); } while(0)
#define _dd(x)          do{ fprintf(stderr, "%s %d\n", #x, (unsigned)x); } while(0)
#define _df(x)          do{ fprintf(stderr, "%s %f\n", #x, (float)x); } while(0)
#define _du(x)          do{ fprintf(stderr, "%s %u\n", #x, (unsigned)x); } while(0)

#define _h(x)           do{ fprintf(stderr, "%08x", (unsigned)x); fflush(stderr); } while(0)
#define _hc(x)          do{ fprintf(stderr, "%02x",  (uint8_t)x); fflush(stderr); } while(0)

#define _endl           do{ fprintf(stderr, "\n"); fflush(stderr); } while(0)
#define _prn(x)         do{ fprintf(stderr, "%s", x); fflush(stderr); } while(0)
#define _say(x)         do{ fprintf(stderr, "%s\n", x); fflush(stderr); } while(0)
#define _msg(x)         do{ _say("CUTILS: " x); } while(0)
#define _trace          do{ fprintf(stderr, "TRACE: %s() in %s line %d\n", __func__, __FILE__, __LINE__); fflush(stderr); } while(0)


#define _mem(x,y)                                                       \
    for(dev_i=0; dev_i<y; dev_i++){                     \
        fprintf(stderr, "%016lx", *((uint64_t*)x+dev_i));           \
    }

#endif // CUTILS_H

