//
// Created by Mark on 19/07/2020.
//



#ifndef CINTCODE_LIBRARY_H
#define CINTCODE_LIBRARY_H
#include <tcl.h>
enum state {
    Idle,
    Running,
    InputPending,
    Stopped
};
enum mode {
    Pos = 0,
    Imm,
    Rel
};
typedef struct {
    int max_idx;
    Tcl_WideInt * mem;
    int PC;
    int base;
    Tcl_Obj * inputs;
    Tcl_Obj * outputs;
    enum state state;
} machine;

Tcl_WideInt * reg(machine* m, Tcl_WideInt idx, enum mode mode);
int Run(Tcl_Interp *pInterp, machine *m, int objc, Tcl_Obj *const objv[]);
int SetMem(Tcl_Interp *pInterp, machine *m, int objc, Tcl_Obj *const objv[]);
int Mem(Tcl_Interp * interp, machine *m, int objc, Tcl_Obj *const objv[]);
int Input(Tcl_Interp * interp, machine *m, int objc, Tcl_Obj *const objv[]);
int State(Tcl_Interp * interp, machine *m, int objc, Tcl_Obj *const objv[]);
int Outputs(Tcl_Interp * interp, machine *m, int objc, Tcl_Obj *const objv[]);
int ClearOutputs(Tcl_Interp * interp, machine *m, int objc, Tcl_Obj *const objv[]);
int Clone(Tcl_Interp * interp, machine *m, int objc, Tcl_Obj *const objv[]);
int Program(Tcl_Interp * interp, machine *m, int objc, Tcl_Obj *const objv[]);

#endif //CINTCODE_LIBRARY_H
