#include <tcl.h>
#include <stdlib.h>
#define __unused __attribute__((unused))


int Speak_Cmd(__unused ClientData cdata, Tcl_Interp * interp, int objc, Tcl_Obj * const objv[]) {
    Tcl_WideInt turns;
    Tcl_Obj ** numbers;
    int length;
    Tcl_WideInt prevturn;
    Tcl_WideInt turn;
    Tcl_WideInt last;
    Tcl_WideInt speak;
    Tcl_WideInt * ll;

    if (objc != 3) {
        Tcl_WrongNumArgs(interp,1,objv,"numbers turns");
        return TCL_ERROR;
    }
    if (Tcl_ListObjGetElements(interp,objv[1], &length, &numbers)!=TCL_OK) {
        return TCL_ERROR;
    }
    if (Tcl_GetWideIntFromObj(interp,objv[2],&turns)!=TCL_OK) {
        return TCL_ERROR;
    }
    // fprintf(stderr,"Turns: %ld\n",turns);
    ll = ckalloc(turns*sizeof(Tcl_WideInt));	
    for (Tcl_WideInt idx = 0 ; idx < turns ; idx++) {
	ll[idx] = -1L;    
    }
    turn = 1;
    for (Tcl_WideInt idx = 0 ; idx < length-1 ; idx++) {    
	
        if (Tcl_GetWideIntFromObj(interp,numbers[idx],&speak)!=TCL_OK) {
            return TCL_ERROR;
        }
	ll[speak] = turn;
	turn ++;
    }
    if (Tcl_GetWideIntFromObj(interp,numbers[length-1],&speak)!=TCL_OK) {
	    return TCL_ERROR;
    }
    while (turn < turns) {
    	prevturn = turn;
	turn++;
	last = ll[speak];
	ll[speak]  = prevturn;
	// fprintf(stderr, "=== Turn %ld\nSpoke %ld\n  last at %ld and %ld\n", turn, speak, prevturn, last);
	switch(last) {
		case -1:
			speak = 0;
			break;
		default:
			speak = prevturn - last;
			break;

	}
	//fprintf(stderr,"-> %ld\n", speak);
    }
    ckfree(ll);
    Tcl_SetObjResult(interp ,Tcl_NewWideIntObj(speak));
    return TCL_OK;
}

DLLEXPORT __unused  int Speak_Init(Tcl_Interp * interp) {
    Tcl_InitStubs(interp, "8.5", 0);
    Tcl_CreateObjCommand(interp,"speak", Speak_Cmd,NULL, NULL);
    return TCL_OK;
}
