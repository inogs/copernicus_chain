#! /bin/bash

#         builder_ogstm_bfm.sh

#      Edit sections 1,2,3,4 in order to configure compilation and linking.

################################################################### 
#  Section 1. Choose the *.inc file, with the definition of compiler flags, to be included in Makefile
#             
#             This is a machine dependent operation, flags for
#             most popular compilers (gnu, intel, xl) are provided.
#             In the following example user will select the file x86_64.LINUX.intel.dbg.inc
#             both in bfm/compilers/ and ogstm/compilers 

OGSTM_ARCH=x86_64
OGSTM_OS=LINUX
OGSTM_COMPILER=intel
DEBUG=       # this is the choice for production flags 
#DEBUG=.dbg   # this is the one for debug flags


################################################################### 
#  Section 2. Use of OpenMP threads, to improve the parallelization of ogstm.
# Just comment one of thes lines:
export OPENMP_FLAG=-fopenmp  # OpenMP activated
export OPENMP_FLAG=          # OpenMP deactivated


###################################################################
# Section 3.  Module loads (and set of environment variables)

# This is a machine dependent operation. Modules are usually used on clusters.
# User can write his module file, in the directory below there are some examples.
# Warning : this choice must be consistent with Section 1. 

# Just comment the two following lines you are not using modules. 
export MODULEFILE=$PWD/ogstm/compilers/machine_modules/galileo.intel
source $MODULEFILE



###################################################################
# Section 4.  Oceanvar inclusion in model
# Set OCEANVAR=true         to include oceanvar.
#     DEBUG_OCEANVAR=.dbg   to use debug flags

OCEANVAR=true
DEBUG_OCEANVAR=
###################################################################




usage() {
echo "SYNOPSYS"
echo "Build BFM and ogstm model"
echo "builder_ogstm_bfm.sh [ BFMDIR ] [ OGSTMDIR ]"
echo ""
echo " Dirs have to be expressed as full paths "
echo "EXAMPLE"
echo " ./builder_ogstm_bfm.sh $PWD/bfm $PWD/ogstm "

}

if [ $# -eq 1 ] || [ $# -gt 2 ]; then
   usage
   exit 1
fi

if [ $# -eq 2 ] ; then
   BFMDIR=$1
   OGSTMDIR=$2
else
   BFMDIR=$PWD/bfm
   OGSTMDIR=$PWD/ogstm
fi


   THREEDVARDIR=$PWD/3DVar




# -------------- 3d_var _____
if [ $OCEANVAR == true ] ; then
   cd 3DVar
   INC_FILE=${OGSTM_ARCH}.${OGSTM_OS}.${OGSTM_COMPILER}${DEBUG_OCEANVAR}.inc
   cp $INC_FILE compiler.inc
   # make clean
   gmake
   if [ $? -ne 0 ] ; then  echo  ERROR; exit 1 ; fi
export DA_INC=$PWD
   echo DA_INC= $DA_INC
fi

# ----------- BFM library ---------------------
cd $BFMDIR
A=`svn info 2>&1 `  # exit status 1 if bfmv5
if [ $? == 0 ] ; then 
   BFMversion=BFMv2
else
   BFMversion=bfmv5
fi

INC_FILE=${OGSTM_ARCH}.${OGSTM_OS}.${OGSTM_COMPILER}${DEBUG}.inc

if [ $BFMversion == BFMv2 ] ; then
   cd ${BFMDIR}/compilers
   cp $INC_FILE compiler.inc

   ###################################################### just because R1.3 does not have include/
   mkdir -p  ${BFMDIR}/include

   cd ${BFMDIR}/build
   ./config_BFM.sh -a ${OGSTM_ARCH} -c ogstm
   cd BLD_OGSTMBFM
   # make clean
   gmake

else
   # in-place replace the entire ARCH line
   sed -i "s/.*ARCH.*/        ARCH    = '$INC_FILE'  /"  build/configurations/OGS_PELAGIC/configuration
   cd $BFMDIR/build
   ./bfm_configure.sh -gcv -o ../lib/libbfm.a -p OGS_PELAGIC
   if [ $? -ne 0 ] ; then  echo  ERROR; exit 1 ; fi
fi

export BFM_INC=${BFMDIR}/include
export BFM_LIB=${BFMDIR}/lib


CMAKE=1

cd $OGSTMDIR/..
if [ $CMAKE -eq 1 ] ; then
  # ------------ new OGSTM builder based on cmake -----------------
        if [[ $DEBUG == .dbg ]] ; then
           CMAKE_BUILD_TYPE=Debug
           OGSTM_BLD_DIR=OGSTM_BUILD_DBG
        else
           CMAKE_BUILD_TYPE=Release
           OGSTM_BLD_DIR=OGSTM_BUILD
        fi
	export BFM_INCLUDE=$BFM_INC
	export BFM_LIBRARY=$BFM_LIB

	
	mkdir -p $OGSTM_BLD_DIR
	cd $OGSTM_BLD_DIR


    CMAKE_COMMONS=" -DCMAKE_VERBOSE_MAKEFILE=ON -DMPI_Fortran_COMPILER=mpiifort -DCMAKE_C_COMPILER=icc -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} "
    CMAKE_COMMONS+=" -DNETCDF_INCLUDES_C=$NETCDF_INC -DNETCDF_LIBRARIES_C=$NETCDF_LIB/libnetcdf.so -DNETCDFF_INCLUDES_F90=$NETCDFF_INC -DNETCDFF_LIBRARIES_F90=$NETCDFF_LIB/libnetcdff.so"
    CMAKE_COMMONS+=" -D${BFMversion}=ON"

	if [ $OCEANVAR == true ] ; then
	    export DA_INCLUDE=$DA_INC
	    export DA_LIBRARY=$DA_INC
	    export PETSC_LIB=$PETSC_LIB/libpetsc.so

	    cp ../ogstm/DataAssimilation.cmake ../ogstm/CMakeLists.txt
        cmake ../ogstm/ $CMAKE_COMMONS -DPETSC_LIBRARIES=$PETSC_LIB -DPNETCDF_LIBRARIES=$PNETCDF_LIB/libpnetcdf.a

	else
	    cp ../ogstm/GeneralCmake.cmake ../ogstm/CMakeLists.txt
	    echo $CMAKE_COMMONS
	    cmake ../ogstm/ $CMAKE_COMMONS
	    
	fi
    make
    mkdir -p ${OGSTMDIR}/lib
    mkdir -p ${OGSTMDIR}/bin
    cp *.a ${OGSTMDIR}/lib
    cp ogstm.xx ${OGSTMDIR}/bin

else

  # ----------- standard OGSTM builder -----------------

	cd ${OGSTMDIR}/compilers
	INC_FILE=${OGSTM_ARCH}.${OGSTM_OS}.${OGSTM_COMPILER}${DEBUG}.inc
	cp $INC_FILE compiler.inc
	
	cd ${OGSTMDIR}/build
	./config_OGSTM.sh ${OGSTM_ARCH} 
	cd BLD_OGSTM
	make clean
	make -f MakeLib
	rm -f get_mem_mod.o
	gmake

fi


if [ $? -ne 0 ] ; then  echo  ERROR; exit 1 ; fi

### OGSTM NAMELIST GENERATION (also by Frequency Control )

mkdir -p ${OGSTMDIR}/ready_for_model_namelists/

if [ $BFMversion == bfmv5 ] ; then
   cp ${BFMDIR}/build/tmp/OGS_PELAGIC/namelist.passivetrc ${OGSTMDIR}/bfmv5/
   cd ${OGSTMDIR}/bfmv5/
   python2 ogstm_namelist_gen.py #generates namelist.passivetrc_new

   cp ${OGSTMDIR}/src/namelists/namelist*    ${OGSTMDIR}/ready_for_model_namelists/ 
   cp namelist.passivetrc_new                ${OGSTMDIR}/ready_for_model_namelists/namelist.passivetrc #overwriting
   cp ${BFMDIR}/build/tmp/OGS_PELAGIC/*.nml  ${OGSTMDIR}/ready_for_model_namelists/
else
   #V2
   cp ${OGSTMDIR}/src/namelists/namelist*    ${OGSTMDIR}/ready_for_model_namelists/
   cp ${BFMDIR}/src/namelist/*.nml           ${OGSTMDIR}/ready_for_model_namelists/
fi

#INSTALL
cp ${THREEDVARDIR}/libvar_3d.a ${OPA_HOME}/HOST/${OPA_HOSTNAME}/lib
cp ${THREEDVARDIR}/libnc-medlevel/libnc-medlevel.a ${OPA_HOME}/HOST/${OPA_HOSTNAME}/lib
cp ${BFM_LIB}/libbfm.a ${OPA_HOME}/HOST/${OPA_HOSTNAME}/lib
cp ${OGSTMDIR}/bin/* ${OPA_HOME}/HOST/${OPA_HOSTNAME}/bin
cp ${OGSTMDIR}/lib/* ${OPA_HOME}/HOST/${OPA_HOSTNAME}/lib
OGSTM_FLOATPRE=${OGSTMDIR}/src/DA/external_scripts/float_preproc
cp ${OGSTM_FLOATPRE}/float_extractor.py ${OGSTM_FLOATPRE}/Float_misfit_gen.sh ${OGSTM_FLOATPRE}/preproc.py ${OGSTM_FLOATPRE}/merge_arg_mis.py ${OPA_HOME}/HOST/${OPA_HOSTNAME}/bin

# /galileo/home/usera07ogs/a07ogs00/OPA/V6C-dev/HOST/galileo/postproc/prodotti/get_daily_product_in_DU.sh

