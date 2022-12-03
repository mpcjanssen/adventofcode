#include <tcl.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "library.h"

long num = 0;

int CintCode_Inst_Cmd(ClientData cdata, Tcl_Interp * interp, int objc, Tcl_Obj * const objv[]) {

    int index;
    machine * m = (machine *)cdata;

    if (objc < 2) {
        Tcl_WrongNumArgs(interp,1,objv,"subcmd ....");
        return TCL_ERROR;
    }
    enum subcmds {
        RUN,
        SETMEM,
        MEM,
        INPUT,
        STATE,
        OUTPUTS,
        CLEAROUTPUTS,
        CLONE,
        PROGRAM
    };
    static CONST char *subcmds[] = {
            "run",
            "setmem",
            "mem",
            "input",
            "state",
            "outputs",
            "clearoutputs",
            "clone",
            "program",
            (char *) NULL
    };
    if (Tcl_GetIndexFromObj(interp, objv[1], subcmds, "subcmd", 0,
                            &index) != TCL_OK) {
        return TCL_ERROR;
    }
    switch (index) {
        case RUN:
            return Run(interp,m,objc, objv);
        case SETMEM:
            return SetMem(interp,m,objc, objv);
        case MEM:
            return Mem(interp,m,objc, objv);
        case INPUT:
            return Input(interp,m,objc, objv);
        case STATE:
            return State(interp,m,objc, objv);
        case OUTPUTS:
            return Outputs(interp,m,objc, objv);
        case CLEAROUTPUTS:
            return ClearOutputs(interp,m,objc,objv);
        case CLONE:
            return Clone(interp,m,objc,objv);
        case PROGRAM:
            return Program(interp,m,objc,objv);
        default:
            Tcl_AppendResult(interp, "never has happened",NULL);
            return TCL_ERROR;
    }
}

int ClearOutputs(Tcl_Interp * interp, machine *m, int objc, Tcl_Obj *const objv[]) {
    if (objc != 2) {
        Tcl_WrongNumArgs(interp,2,objv,"");
        return TCL_ERROR;
    }
    Tcl_DecrRefCount(m->outputs);
    m->outputs = Tcl_NewListObj(0,NULL);
    Tcl_IncrRefCount(m->outputs);
    return TCL_OK;
};

int Program(Tcl_Interp * interp, machine *m, int objc, Tcl_Obj *const objv[]) {
    Tcl_Obj * list;
    int ret = TCL_OK;
    if (objc != 2) {
        Tcl_WrongNumArgs(interp,2,objv,"");
        return TCL_ERROR;
    }
    list = Tcl_NewListObj(m->max_idx+1, NULL);
    for (int i = 0 ; i <=m->max_idx ; i++ ) {
        ret = Tcl_ListObjAppendElement(interp,list, Tcl_NewWideIntObj(m->mem[i]));
        if (ret != TCL_OK) {
            return ret;
        }
    }
    Tcl_SetObjResult(interp,list);
    return TCL_OK;
}

int Mem(Tcl_Interp * interp, machine *m, int objc, Tcl_Obj *const objv[]) {
    Tcl_WideInt loc;
    Tcl_WideInt res;
    int ret = TCL_OK;
    if (objc != 3) {
        Tcl_WrongNumArgs(interp,2,objv,"idx");
        return TCL_ERROR;
    }
    ret = Tcl_GetWideIntFromObj(NULL,objv[2],&loc);
    if (ret != TCL_OK) {
        return ret;
    }
    res = *reg(m,loc,Imm);
    Tcl_SetObjResult(interp,Tcl_NewWideIntObj(res));
    return TCL_OK;
}

int Outputs(Tcl_Interp * interp, machine *m, int objc, Tcl_Obj *const objv[]) {
    Tcl_SetObjResult(interp,m->outputs);
    return TCL_OK;
}

int Input(Tcl_Interp * interp, machine *m, int objc, Tcl_Obj *const objv[]) {
    if (objc != 3) {
        Tcl_WrongNumArgs(interp,2,objv,"value");
        return TCL_ERROR;
    }
    if (Tcl_IsShared(m->inputs)) {
        m->inputs = Tcl_DuplicateObj(m->inputs);
    }
    Tcl_ListObjAppendElement(interp,m->inputs,objv[2]);
    Tcl_IncrRefCount(m->inputs);
    return TCL_OK;
}

int State(Tcl_Interp * interp, machine *m, int objc, Tcl_Obj *const objv[]) {
    if (objc != 2) {
        Tcl_WrongNumArgs(interp,2,objv,"");
        return TCL_ERROR;
    }
    switch(m->state) {
        case Idle:
            Tcl_SetObjResult(interp,Tcl_NewStringObj("idle",-1));
            break;
        case Running:
            Tcl_SetObjResult(interp,Tcl_NewStringObj("running",-1));
            break;
        case InputPending:
            Tcl_SetObjResult(interp,Tcl_NewStringObj("input-pending",-1));
            break;
        case Stopped:
            Tcl_SetObjResult(interp,Tcl_NewStringObj("stopped",-1));
            break;
    }
    return TCL_OK;
}

int SetMem(Tcl_Interp * interp, machine *m, int objc, Tcl_Obj *const objv[]) {
    Tcl_WideInt loc;
    Tcl_WideInt value;
    int res;
    if (objc != 4) {
        Tcl_WrongNumArgs(interp,2,objv,"idx value");
        return TCL_ERROR;
    }
    res = Tcl_GetWideIntFromObj(NULL,objv[2],&loc);
    if (res!=TCL_OK) {
        return res;
    }
    res = Tcl_GetWideIntFromObj(NULL,objv[3],&value);
    if (res!=TCL_OK) {
        return res;
    }
    *reg(m,loc,Imm) = value;
    return TCL_OK;
}

Tcl_WideInt getmem(machine * m, int idx) {
    if (idx <= m->max_idx) {
        return m->mem[idx];
    } else {
        return 0;
    }
 }
// Return the address of the register
Tcl_WideInt * reg(machine* m, Tcl_WideInt idx, enum mode mode) {
    Tcl_WideInt  res;

    switch (mode) {
        case Imm:
            res = idx;
            break;
        case Pos:
            res =  getmem(m, idx);
            break;

        case Rel:
            res =  getmem(m, idx) + m->base;
            break;

    }
    if (m->max_idx < res ) {
//        fprintf(stderr,"Resizing from %d to %d\n", m->max_idx+1, res+100);
        m->mem = ckrealloc(m->mem,(res+100) * sizeof(Tcl_WideInt));
        for (int i = m->max_idx+1 ; i < res + 100 ; i++) {
            m->mem[i] = 0;
        }
        m->max_idx = res+100-1;
    }
    return (m->mem + res);
}

int Run(Tcl_Interp *interp, machine *m, int objc, Tcl_Obj *const objv[]) {
    m->state = Running;
    while(m->state == Running) {
        Tcl_Obj * res;
        Tcl_WideInt val1,val2,val3;
        int count;
        Tcl_WideInt item;

        Tcl_WideInt inst = *reg(m,m->PC,Imm);
        int opcode = inst % 100;
        int mode1 = inst / 100 % 10;
        int mode2 = inst / 1000 % 10;
        int mode3 = inst / 10000 % 10;
        // fprintf(stderr,"m[%d], inst: %d(%d %d|%d|%d)\n", m->PC, inst,opcode,mode1,mode2,mode3);
        switch (opcode) {
            case 1:
                val1 = *reg(m,m->PC+1,mode1);
                val2 = *reg(m,m->PC+2,mode2);
                val3 = val1 + val2;
//                fprintf(stderr,"\t%d + %d = %d\n", val1,val2,val3);
                *reg(m,m->PC+3,mode3) = val3;
                m->PC += 4;
                break;
            case 2:
                val1 = *reg(m,m->PC+1,mode1);
                val2 = *reg(m,m->PC+2,mode2);
                val3 = val1 * val2;
//                fprintf(stderr,"\t%d * %d = %d\n", val1,val2,val3);
                *reg(m,m->PC+3,mode3) = val3;
                m->PC += 4;
                break;
            case 3:
                Tcl_ListObjLength(interp, m->inputs,&count);
                if (count == 0) {
                    m->state = InputPending;
                } else {
                    Tcl_ListObjIndex(interp, m->inputs, 0, &res);
                    Tcl_GetWideIntFromObj(interp, res, reg(m, m->PC + 1, mode1));
                    if (Tcl_IsShared(m->inputs)) {
                        m->inputs = Tcl_DuplicateObj(m->inputs);
                    }
                    Tcl_ListObjReplace(interp, m->inputs, 0, 1, 0, NULL);
                    Tcl_IncrRefCount(m->inputs);
                    m->PC += 2;
                }
                break;
            case 4:
                item = *reg(m,m->PC+1,mode1);
                if (Tcl_IsShared(m->outputs)) {
                    m->outputs = Tcl_DuplicateObj(m->outputs);
                }
                Tcl_ListObjAppendElement(interp, m->outputs,Tcl_NewWideIntObj(item));
                Tcl_IncrRefCount(m->outputs);
                m->PC += 2;
                break;
            case 5:
                if (*reg(m,m->PC+1,mode1)!=0) {
                    m->PC = *reg(m,m->PC+2,mode2);
                } else {
                    m->PC += 3;
                }
                break;
            case 6:
                if (*reg(m,m->PC+1,mode1)==0) {
                    m->PC = *reg(m,m->PC+2,mode2);
                } else {
                    m->PC += 3;
                }
                break;
            case 7:
                if (*reg(m,m->PC+1,mode1)<*reg(m,m->PC+2,mode2)) {
                    *reg(m,m->PC+3,mode3) = 1;
                } else {
                    *reg(m,m->PC+3,mode3) = 0;
                }
                m->PC += 4;
                break;
            case 8:
                if (*reg(m,m->PC+1,mode1)==*reg(m,m->PC+2,mode2)) {
                    *reg(m,m->PC+3,mode3) = 1;
                } else {
                    *reg(m,m->PC+3,mode3) = 0;
                }
                m->PC += 4;
                break;
            case 9:
                m->base += *reg(m,m->PC+1,mode1);
                m->PC += 2;
                break;
            case 99:
                m->state = Stopped;
                break;
            default:
                res = Tcl_NewStringObj("invalid opcode: ", -1);
                Tcl_AppendObjToObj(res, Tcl_NewIntObj(opcode));
                Tcl_SetObjResult(interp,res);
                return TCL_ERROR;
        }
    }
    return TCL_OK;
}

void CintCode_Del_Cmd(ClientData cdata) {
    machine * m = (machine *)cdata;
    Tcl_DecrRefCount(m->inputs);
    Tcl_DecrRefCount(m->outputs);
    ckfree(m->mem);
    ckfree(m);
}

int Clone(Tcl_Interp * interp, machine * m , int objc, Tcl_Obj * const objv[]) {
    int length;
    int res;

    Tcl_Obj ** items;
    Tcl_Obj * cmdName;
    if (objc != 2) {
        Tcl_WrongNumArgs(interp,2,objv,"");
        return TCL_ERROR;
    }
    machine * newm = ckalloc(sizeof(machine));

    newm->inputs = Tcl_NewListObj(0,NULL);
    newm->outputs = Tcl_NewListObj(0,NULL);
    Tcl_IncrRefCount(newm->inputs);
    Tcl_IncrRefCount(newm->outputs);

    newm->PC = m->PC;
    newm->state = m->state;
    newm->base = m->base;
    newm->max_idx = m->max_idx;
    newm->mem = ckalloc((newm->max_idx + 1) * sizeof(Tcl_WideInt));
    newm->mem = memcpy (newm->mem, m->mem, (newm->max_idx + 1) * sizeof(Tcl_WideInt));

    Tcl_Obj * numObj = Tcl_NewWideIntObj(num);
    cmdName = Tcl_NewStringObj("cintcode::",-1);
    Tcl_AppendObjToObj(cmdName, numObj);
    Tcl_CreateObjCommand(interp, Tcl_GetString(cmdName), CintCode_Inst_Cmd, newm, CintCode_Del_Cmd);
    Tcl_SetObjResult(interp,cmdName);
    num++;
    return TCL_OK;
}


int CintCode_Cmd(ClientData cdata, Tcl_Interp * interp, int objc, Tcl_Obj * const objv[]) {
    int length;
    int res;
    machine * m = ckalloc(sizeof(machine));
    Tcl_Obj ** items;
    Tcl_Obj * cmdName;
    if (objc != 2) {
        Tcl_WrongNumArgs(interp,1,objv,"mem");
        return TCL_ERROR;
    }
    if (Tcl_ListObjGetElements(interp,objv[1], &length, &items)!=TCL_OK) {
        return TCL_ERROR;
    }
    m->inputs = Tcl_NewListObj(0,NULL);
    m->outputs = Tcl_NewListObj(0,NULL);
    Tcl_IncrRefCount(m->inputs);
    Tcl_IncrRefCount(m->outputs);

    m->PC = 0;
    m->state = Idle;
    m->base = 0;
    m->max_idx = length-1;
    m->mem = ckalloc(length * sizeof(Tcl_WideInt));
    for (int i =0 ; i < length ; i++) {
        res = Tcl_GetWideIntFromObj(interp,items[i],&m->mem[i]);
        if (res!=TCL_OK) {
            return res;
        }
    }
    Tcl_Obj * numObj = Tcl_NewWideIntObj(num);
    cmdName = Tcl_NewStringObj("cintcode::",-1);
    Tcl_AppendObjToObj(cmdName, numObj);
    Tcl_CreateObjCommand(interp,Tcl_GetString(cmdName),CintCode_Inst_Cmd,m,CintCode_Del_Cmd);
    Tcl_SetObjResult(interp,cmdName);
    num++;
    return TCL_OK;
}

DLLEXPORT int Cintcode_Init(Tcl_Interp * interp) {
    Tcl_InitStubs(interp, "8.5", 0);
    Tcl_CreateObjCommand(interp,"CintCode", CintCode_Cmd,NULL, NULL);
    return TCL_OK;
}
