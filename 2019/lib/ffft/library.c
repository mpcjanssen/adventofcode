#include <tcl.h>
#include <stdlib.h>
#define __unused __attribute__((unused))

inline void swapIntP(int ** a, int ** b) {
    void * temp = *a;
    *a = *b ;
    *b = temp;
}

int Ffft_Cmd(__unused ClientData cdata, Tcl_Interp * interp, int objc, Tcl_Obj * const objv[]) {
    int length;
    int patterns[] = {0, 1, 0 ,-1};
    Tcl_WideInt phase;
    Tcl_Obj ** items;
    Tcl_Obj * result;
    int * oldDigits;
    int * digits;


    if (objc != 3) {
        Tcl_WrongNumArgs(interp,1,objv,"digits phases");
        return TCL_ERROR;
    }
    if (Tcl_ListObjGetElements(interp,objv[1], &length, &items)!=TCL_OK) {
        return TCL_ERROR;
    }
    if (Tcl_GetWideIntFromObj(interp,objv[2],&phase)!=TCL_OK) {
        return TCL_ERROR;
    }
    oldDigits = ckalloc(length * sizeof(int));
    digits = ckalloc(length * sizeof(int));

    for (int idx = 0 ; idx < length ; idx++) {
        if (Tcl_GetIntFromObj(interp,items[idx],&digits[idx])!=TCL_OK) {
            return TCL_ERROR;
        }
    }

    while (phase > 0) {
        swapIntP(&digits,&oldDigits);
        for (int n = 0 ; n < length ; n++) {
            Tcl_WideInt sum = 0;
            for (int idx = n ; idx < length ; idx++ ) {
                int pat = patterns[(idx+1) / (n+1) % 4] ;
//                printf("%d\n", pat);
                sum += pat * oldDigits[idx];
            }
            digits[n] = llabs(sum) % 10;
        }
        phase--;
    }
    result = Tcl_NewListObj(length,NULL);
    for (int idx = 0 ; idx < length ; idx++) {
        if (Tcl_ListObjAppendElement(interp, result, Tcl_NewIntObj(digits[idx]))!=TCL_OK) {
            return TCL_ERROR;
        }
    }
    ckfree(oldDigits);
    ckfree(digits);
    Tcl_SetObjResult(interp ,result);
    return TCL_OK;
}

DLLEXPORT __unused  int Ffft_Init(Tcl_Interp * interp) {
    Tcl_InitStubs(interp, "8.5", 0);
    Tcl_CreateObjCommand(interp,"ffft", Ffft_Cmd,NULL, NULL);
    return TCL_OK;
}
