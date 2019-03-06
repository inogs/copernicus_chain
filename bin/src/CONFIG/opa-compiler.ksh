#!/bin/ksh

sed	-e "s%@@(I:OPA_HOME)%${OPA_HOME}%g"			\
	-e "s%@@(I:OPA_MODULE)%${OPA_MODULE}%g"			\
	-e "s%@@(I:OPA_HOSTNAME)%${OPA_HOSTNAME}%g"		\
	-e "s%@@(I:OPA_WORKDIR)%${OPA_WORKDIR}%g"		\
	-e "s%@@(I:OPA_BACKUP)%${OPA_BACKUP}%g"			\
	-e "s%@@(I:OPA_ARCH)%${OPA_ARCH}%g"			\
	-e "s%@@(I:OPA_OS)%${OPA_OS}%g"				\
	-e "s%@@(I:OPA_COMPILER)%${OPA_COMPILER}%g"		\
	-e "s%@@(I:OPA_VERSION_NUMBER)%${OPA_VERSION_NUMBER}%g"	\
	-e "s%@@(I:OPA_VERSION)%${OPA_VERSION}%g"		\
	-e "s%@@(I:OPA_EXTENSION)%${OPA_EXTENSION}%g"		\
	-e "s%@@(I:OPA_STAGE)%${OPA_STAGE}%g"			\
	$1 > $2

