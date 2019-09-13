# V5C

Catena operativa Copernicus, versione V5C

Una volta scaricato il pacchetto con git clone, seguire questi passaggi per l'installazione della catena:

1. creare cartella nuova HOST/$cluster (+.gitignore) e fare git add/commit
2. cd src, compilazione dei vari pezzi della catena (controllare il Readme all'interno della cartella src)
3. cd src/externals, compilazione eseguibili catena (controllare il Readme all'interno della cartella src/externals)
4. cd HOST/$cluster/venv/lib/python2.7/site-packages/subprocess32.py, commentare le righe 143-146 relative ad un warning fastidioso (questi file non sono regolati da git. La prima riga è: import warnings). Cancellare anche il relativo subprocess.pyc
   - nota: questo va fatto anche in prod perché il file è creato al momento dell'installazione del virtualenv
5. cd etc/static-data. Dentro ognuna di queste sottocartelle: MODEL, MODEL/BC, MODEL/FORCINGS, MED24_125, MED24_141 lanciare il comando: for I in `ls *gz`; do gzip -dc $I > ${I%.gz}; done
6. cd bin/src. Controllare l'esistenza del file opa_profile__$cluster.src.inc, eventualmente creare e/o modificare opportunamente. Assicurarsi che il Makefile lo contempli, e poi git add/commit.
   Poi make e make install.
7. lancio di opa_setup_directories.ksh (setup directories) e opa_setup_environment.ksh (setup ambiente)
8. opa_downloader.ksh per il primo download (la prima volta sarà molto lungo)
