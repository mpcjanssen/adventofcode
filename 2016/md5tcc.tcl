# md5tcc.tcl - 
#
# Wrapper for RSA's Message Digest in C
#
# Written by Jean-Claude Wippler <jcw@equi4.com>
# Adapted for tcc by Mark Janssen
#

package require tcc4tcl;                 # needs tcc4tcl
package provide md5tcc 0.0.1;              # 

namespace eval ::md5 {
  set handle [tcc4tcl::new]
 
  set source_dir [file dirname [info script]] 
  $handle add_include_path $source_dir
  $handle ccode {#include "md5.c"}


  $handle cproc md5tcc {Tcl_Interp* interp char* data} ok {
      unsigned char digest[16];
      int len;
      struct MD5Context context;


      MD5Init(&context);
      MD5Update(&context, data, strlen(data));
      MD5Final(digest, &context);
        
      Tcl_SetObjResult(ip, Tcl_NewByteArrayObj(digest,16));
      return TCL_OK;
    }

  $handle go
}