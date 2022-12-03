import md5
from tclstubs as Tcl import nil

proc Md5_Cmd(clientData: Tcl.PClientData, interp: Tcl.PInterp, objc: cint, objv: Tcl.PPObj): cint =
  if objc != 2: 
    Tcl.WrongNumArgs(interp,1,objv,"string");
    return Tcl.ERROR;
  let origString = $Tcl.GetString(objv[1])  
  let md5String = $toMD5(origString)
  Tcl.SetObjResult(interp, Tcl.NewStringObj(cstring(md5String),-1))
  return Tcl.OK


proc Aocmd5_Init(interp: Tcl.PInterp): cint {.exportc,dynlib.} =
  echo Tcl.InitStubs(interp, "8.5",0)
  echo Tcl.PkgProvideEx(interp, "aocmd5","0.1", nil)
  if Tcl.CreateObjCommand(interp, "aoc::md5", Md5_Cmd, nil, nil)!=nil:
    return Tcl.OK
  else:
    return Tcl.ERROR
