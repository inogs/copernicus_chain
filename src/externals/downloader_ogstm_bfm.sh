#! /bin/bash


  BFM_version=bfmv5   #  BFMv2 or bfmv5
  BFM_RELEASE=ogs_release-5.0

 OGSTM_BRANCH=release-4.1
 VAR3D_BRANCH=release-3.3

SVN_USER=svnogs01  # user on https://hpc-forge.cineca.it/
# ----------- BFM library ---------------------

OGSTM_HOME=$PWD

git clone https://github.com/CMCC-Foundation/BiogeochemicalFluxModel.git bfm
cd bfm
git checkout -b $BFM_RELEASE $BFM_RELEASE
#maranicineca Rk3tfe181085

cd $OGSTM_HOME
git clone https://gitlab.hpc.cineca.it/OGS/ogstm.git
cd ogstm
git checkout -b $OGSTM_BRANCH $OGSTM_BRANCH
#credenziali a07ogs00

cd $OGSTM_HOME
git clone https://gitlab.hpc.cineca.it/OGS/3DVar.git
cd 3DVar
git checkout -b $VAR3D_BRANCH $VAR3D_BRANCH
#credenziali a07ogs00

git clone https://gitlab.hpc.cineca.it/OGS/bitsea.git
# commit 07b485759f9
#credenziali a07ogs00

git clone https://gitlab.hpc.cineca.it/OGS/postproc.git
git checkout -b chainV5C origin/chainV5C
# commit 8d91f2248fd
#credenziali a07ogs00

cp ${OPA_HOSTNAME}.intel ogstm/compilers/machine_modules
