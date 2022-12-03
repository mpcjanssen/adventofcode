#include "tclInt.h"

#define __unused __attribute__((unused))



int Breakable_Cmd(__unused ClientData cdata, Tcl_Interp * interp, int objc, Tcl_Obj * const objv[]) {

    Tcl_Obj * result;




    result = Tcl_NewListObj(objc-1,NULL);
    for (int idx = 1 ; idx < objc ; idx++) {
        Tcl_ListObjAppendElement(interp, result, objv[idx]);
    }
    Interp * intInterp = (Interp *) interp;

    Tcl_SetObjResult(interp ,result);
    return TCL_OK;
}

DLLEXPORT __unused  int Breakable_Init(Tcl_Interp * interp) {
    Tcl_InitStubs(interp, "8.5", 0);
    Tcl_CreateObjCommand(interp,"breakable", Breakable_Cmd,NULL, NULL);
    return TCL_OK;
}
