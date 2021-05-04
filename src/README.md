Istruzioni per la compilazione dei vari pezzi della catena:

1. creare ENV/$cluster (di solito basta la copia di uno esistente) e fare git add/commit
2. per ogni pezzo, fare tar -xvf <name>.tar.gz (o varianti per scompattare l'archivio)
3. dentro alla relativa cartella, lanciare lo script ./my-configure
4. per le coreutils, prima di compilare commentare la riga 1012 nel file lib/stdio.h (poi commentare il configure e lanciare solo il make/make install)
5. ordine consigliato: coreutils, ncftp, curl, zlib, szip, hdf5, netcdf-c, netcdf-fortran, parallel-netcdf, udunits, antlr, nco, petsc, pngquant, geos
6. virtualenv: prima di lanciare, controllare che il my-configure sia pronto per il cluster di riferimento (possono servire NETCDF4_DIR, HDF5_DIR e GEOS_DIR). Nella stringa di installazione di netcdf, controllare che il path alle librerie intel sia corretto
   - nota: per la creazione dell'ambiente prod, il virtualenv va installato e non copiato
