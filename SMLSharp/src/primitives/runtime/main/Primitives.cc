#include "IllegalArgumentException.hh"
#include "Log.hh"
#include "Debug.hh"
#include "Primitives.hh"

BEGIN_NAMESPACE(jp_ac_jaist_iml_runtime)

DBGWRAP(static LogAdaptor LOG = LogAdaptor("Primitives"));

// ToDo: Ptr_advance primitive

PrimitiveEntry primitives[] =
{
    {"Int_toString", IMLPrim_Int_toString},
    {"LargeInt_toString", IMLPrim_LargeInt_toString},
    {"LargeInt_toInt", IMLPrim_LargeInt_toInt},
    {"LargeInt_toWord", IMLPrim_LargeInt_toWord},
    {"LargeInt_fromInt", IMLPrim_LargeInt_fromInt},
    {"LargeInt_fromWord", IMLPrim_LargeInt_fromWord},
    {"LargeInt_pow", IMLPrim_LargeInt_pow},
    {"LargeInt_log2", IMLPrim_LargeInt_log2},
    {"LargeInt_orb", IMLPrim_LargeInt_orb},
    {"LargeInt_xorb", IMLPrim_LargeInt_xorb},
    {"LargeInt_andb", IMLPrim_LargeInt_andb},
    {"LargeInt_notb", IMLPrim_LargeInt_notb},
    {"Word_toString", IMLPrim_Word_toString},
    {"Real_fromInt", IMLPrim_Real_fromInt},
    {"Real_toString", IMLPrim_Real_toString},
    {"Real_floor", IMLPrim_Real_floor},
    {"Real_ceil", IMLPrim_Real_ceil},
    {"Real_trunc", IMLPrim_Real_trunc},
    {"Real_round", IMLPrim_Real_round},
    {"Real_split", IMLPrim_Real_split},
    {"Real_toManExp", IMLPrim_Real_toManExp},
    {"Real_fromManExp", IMLPrim_Real_fromManExp},
    {"Real_copySign", IMLPrim_Real_copySign},
    {"Real_equal", IMLPrim_Real_equal},
    {"Real_class", IMLPrim_Real_class},
    {"Real_dtoa", IMLPrim_Real_dtoa},
    {"Real_strtod", IMLPrim_Real_strtod},
    {"Real_nextAfter", IMLPrim_Real_nextAfter},
    {"Real_toFloat", IMLPrim_Real_toFloat},
    {"Real_fromFloat", IMLPrim_Real_fromFloat},
    {"Float_fromInt", IMLPrim_Float_fromInt},
    {"Float_toString", IMLPrim_Float_toString},
    {"Float_floor", IMLPrim_Float_floor},
    {"Float_ceil", IMLPrim_Float_ceil},
    {"Float_trunc", IMLPrim_Float_trunc},
    {"Float_round", IMLPrim_Float_round},
    {"Float_split", IMLPrim_Float_split},
    {"Float_toManExp", IMLPrim_Float_toManExp},
    {"Float_fromManExp", IMLPrim_Float_fromManExp},
    {"Float_copySign", IMLPrim_Float_copySign},
    {"Float_equal", IMLPrim_Float_equal},
    {"Float_class", IMLPrim_Float_class},
    {"Float_dtoa", IMLPrim_Float_dtoa},
    {"Float_strtod", IMLPrim_Float_strtod},
    {"Float_nextAfter", IMLPrim_Float_nextAfter},
    {"Char_toString", IMLPrim_Char_toString},
    {"Char_toEscapedString", IMLPrim_Char_toEscapedString},
    {"Char_ord", IMLPrim_Char_ord},
    {"Char_chr", IMLPrim_Char_chr},
    {"String_concat2", IMLPrim_String_concat2},
    {"String_sub", IMLPrim_String_sub},
    {"String_size", IMLPrim_String_size},
    {"String_substring", IMLPrim_String_substring},
    {"String_update", IMLPrim_String_update},
    {"String_allocateMutable", IMLPrim_String_allocateMutable},
    {"String_allocateImmutable", IMLPrim_String_allocateImmutable},
    {"String_copy", IMLPrim_String_copy},
    {"print", IMLPrim_print},
    {"Internal_IPToString", IMLPrim_Internal_IPToString},
    {"Time_gettimeofday", IMLPrim_Time_gettimeofday},
    {"GenericOS_errorName", IMLPrim_GenericOS_errorName},
    {"GenericOS_errorMsg", IMLPrim_GenericOS_errorMsg},
    {"GenericOS_syserror", IMLPrim_GenericOS_syserror},
    {"GenericOS_getSTDIN", IMLPrim_GenericOS_getSTDIN},
    {"GenericOS_getSTDOUT", IMLPrim_GenericOS_getSTDOUT},
    {"GenericOS_getSTDERR", IMLPrim_GenericOS_getSTDERR},
    {"GenericOS_fileOpen", IMLPrim_GenericOS_fileOpen},
    {"GenericOS_fileClose", IMLPrim_GenericOS_fileClose},
    {"GenericOS_fileRead", IMLPrim_GenericOS_fileRead},
    {"GenericOS_fileReadBuf", IMLPrim_GenericOS_fileReadBuf},
    {"GenericOS_fileWrite", IMLPrim_GenericOS_fileWrite},
    {"GenericOS_fileSetPosition", IMLPrim_GenericOS_fileSetPosition},
    {"GenericOS_fileGetPosition", IMLPrim_GenericOS_fileGetPosition},
    {"GenericOS_fileNo", IMLPrim_GenericOS_fileNo},
    {"GenericOS_fileSize", IMLPrim_GenericOS_fileSize},
    {"GenericOS_isRegFD", IMLPrim_GenericOS_isRegFD},
    {"GenericOS_isDirFD", IMLPrim_GenericOS_isDirFD},
    {"GenericOS_isChrFD", IMLPrim_GenericOS_isChrFD},
    {"GenericOS_isBlkFD", IMLPrim_GenericOS_isBlkFD},
    {"GenericOS_isLinkFD", IMLPrim_GenericOS_isLinkFD},
    {"GenericOS_isFIFOFD", IMLPrim_GenericOS_isFIFOFD},
    {"GenericOS_isSockFD", IMLPrim_GenericOS_isSockFD},
    {"GenericOS_poll", IMLPrim_GenericOS_poll},
    {"GenericOS_getPOLLINFlag", IMLPrim_GenericOS_getPOLLINFlag},
    {"GenericOS_getPOLLOUTFlag", IMLPrim_GenericOS_getPOLLOUTFlag},
    {"GenericOS_getPOLLPRIFlag", IMLPrim_GenericOS_getPOLLPRIFlag},
    {"GenericOS_system", IMLPrim_GenericOS_system},
    {"GenericOS_exit", IMLPrim_GenericOS_exit},
    {"GenericOS_getEnv", IMLPrim_GenericOS_getEnv},
    {"GenericOS_sleep", IMLPrim_GenericOS_sleep},
    {"GenericOS_openDir", IMLPrim_GenericOS_openDir},
    {"GenericOS_readDir", IMLPrim_GenericOS_readDir},
    {"GenericOS_rewindDir", IMLPrim_GenericOS_rewindDir},
    {"GenericOS_closeDir", IMLPrim_GenericOS_closeDir},
    {"GenericOS_chDir", IMLPrim_GenericOS_chDir},
    {"GenericOS_getDir", IMLPrim_GenericOS_getDir},
    {"GenericOS_mkDir", IMLPrim_GenericOS_mkDir},
    {"GenericOS_rmDir", IMLPrim_GenericOS_rmDir},
    {"GenericOS_isDir", IMLPrim_GenericOS_isDir},
    {"GenericOS_isLink", IMLPrim_GenericOS_isLink},
    {"GenericOS_readLink", IMLPrim_GenericOS_readLink},
    {"GenericOS_getFileModTime", IMLPrim_GenericOS_getFileModTime},
    {"GenericOS_setFileTime", IMLPrim_GenericOS_setFileTime},
    {"GenericOS_getFileSize", IMLPrim_GenericOS_getFileSize},
    {"GenericOS_remove", IMLPrim_GenericOS_remove},
    {"GenericOS_rename", IMLPrim_GenericOS_rename},
    {"GenericOS_isFileExists", IMLPrim_GenericOS_isFileExists},
    {"GenericOS_isFileReadable", IMLPrim_GenericOS_isFileReadable},
    {"GenericOS_isFileWritable", IMLPrim_GenericOS_isFileWritable},
    {"GenericOS_isFileExecutable", IMLPrim_GenericOS_isFileExecutable},
    {"GenericOS_tempFileName", IMLPrim_GenericOS_tempFileName},
    {"GenericOS_getFileID", IMLPrim_GenericOS_getFileID},
    {"CommandLine_name", IMLPrim_CommandLine_name},
    {"CommandLine_arguments", IMLPrim_CommandLine_arguments},
    {"Date_ascTime", IMLPrim_Date_ascTime},
    {"Date_localTime", IMLPrim_Date_localTime},
    {"Date_gmTime", IMLPrim_Date_gmTime},
    {"Date_mkTime", IMLPrim_Date_mkTime},
    {"Date_strfTime", IMLPrim_Date_strfTime},
    {"Timer_getTime", IMLPrim_Timer_getTime},
    {"Math_sqrt", IMLPrim_Math_sqrt},
    {"Math_sin", IMLPrim_Math_sin},
    {"Math_cos", IMLPrim_Math_cos},
    {"Math_tan", IMLPrim_Math_tan},
    {"Math_asin", IMLPrim_Math_asin},
    {"Math_acos", IMLPrim_Math_acos},
    {"Math_atan", IMLPrim_Math_atan},
    {"Math_atan2", IMLPrim_Math_atan2},
    {"Math_exp", IMLPrim_Math_exp},
    {"Math_pow", IMLPrim_Math_pow},
    {"Math_ln", IMLPrim_Math_ln},
    {"Math_log10", IMLPrim_Math_log10},
    {"Math_sinh", IMLPrim_Math_sinh},
    {"Math_cosh", IMLPrim_Math_cosh},
    {"Math_tanh", IMLPrim_Math_tanh},
    {"StandardC_errno", IMLPrim_StandardC_errno},
    {"UnmanagedMemory_allocate", IMLPrim_UnmanagedMemory_allocate},
    {"UnmanagedMemory_release", IMLPrim_UnmanagedMemory_release},
    {"UnmanagedMemory_sub", IMLPrim_UnmanagedMemory_sub},
    {"UnmanagedMemory_update", IMLPrim_UnmanagedMemory_update},
    {"UnmanagedMemory_subWord", IMLPrim_UnmanagedMemory_subWord},
    {"UnmanagedMemory_updateWord", IMLPrim_UnmanagedMemory_updateWord},
    {"UnmanagedMemory_subReal", IMLPrim_UnmanagedMemory_subReal},
    {"UnmanagedMemory_updateReal", IMLPrim_UnmanagedMemory_updateReal},
    {"UnmanagedMemory_import", IMLPrim_UnmanagedMemory_import},
    {"UnmanagedMemory_export", IMLPrim_UnmanagedMemory_export},
    {"UnmanagedString_size", IMLPrim_UnmanagedString_size},
    {"DynamicLink_dlopen", IMLPrim_DynamicLink_dlopen},
    {"DynamicLink_dlclose", IMLPrim_DynamicLink_dlclose},
    {"DynamicLink_dlsym", IMLPrim_DynamicLink_dlsym},
    {"GC_addFinalizable", IMLPrim_GC_addFinalizable},
    {"GC_doGC", IMLPrim_GC_doGC},
    {"GC_fixedCopy", IMLPrim_GC_fixedCopy},
    {"GC_releaseFLOB", IMLPrim_GC_releaseFLOB},
    {"GC_addressOfFLOB", IMLPrim_GC_addressOfFLOB},
    {"GC_copyBlock", IMLPrim_GC_copyBlock},
    {"GC_isAddressOfBlock", IMLPrim_GC_isAddressOfBlock},
    {"GC_isAddressOfFLOB", IMLPrim_GC_isAddressOfFLOB},
    {"Platform_getPlatform", IMLPrim_Platform_getPlatform},
    {"Platform_isBigEndian", IMLPrim_Platform_isBigEndian},
    {"Pack_packWord32Little", IMLPrim_Pack_packWord32Little},
    {"Pack_packWord32Big", IMLPrim_Pack_packWord32Big},
    {"Pack_unpackWord32Little", IMLPrim_Pack_unpackWord32Little},
    {"Pack_unpackWord32Big", IMLPrim_Pack_unpackWord32Big},
    {"Pack_packReal64Little", IMLPrim_Pack_packReal64Little},
    {"Pack_packReal64Big", IMLPrim_Pack_packReal64Big},
    {"Pack_unpackReal64Little", IMLPrim_Pack_unpackReal64Little},
    {"Pack_unpackReal64Big", IMLPrim_Pack_unpackReal64Big},
    {"Pack_packReal32Little", IMLPrim_Pack_packReal32Little},
    {"Pack_packReal32Big", IMLPrim_Pack_packReal32Big},
    {"Pack_unpackReal32Little", IMLPrim_Pack_unpackReal32Little},
    {"Pack_unpackReal32Big", IMLPrim_Pack_unpackReal32Big},
    {"SMLSharpCommandLine_executableImageName", IMLPrim_SMLSharpCommandLine_executableImageName},
    {"DynamicBind_importSymbol", IMLPrim_DynamicBind_importSymbol},
    {"DynamicBind_exportSymbol", IMLPrim_DynamicBind_exportSymbol},
    {"IEEEReal_setRoundingMode", IMLPrim_IEEEReal_setRoundingMode},
    {"IEEEReal_getRoundingMode", IMLPrim_IEEEReal_getRoundingMode},
};

const int NUMBER_OF_PRIMITIVES = sizeof(primitives) / sizeof(primitives[0]);

UInt32Value
find_primitive_index(const char *name)
{
    UInt32Value i;

    for (i = 0; i < NUMBER_OF_PRIMITIVES; i++) {
        if (strcmp(primitives[i].name, name) == 0)
            return i;
    }

    DBGWRAP(LOG.error("findPrimIndex: unknown primitive: %s", name));
    throw IllegalArgumentException();
}

END_NAMESPACE