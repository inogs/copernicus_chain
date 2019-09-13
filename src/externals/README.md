Istruzioni per la compilazione degli eseguibili della catena e per la copia degli ambienti necessari alla creazione ed elaborazione dei prodotti:

1. creare il file $cluster.intel prendendo spunto da un file esistente e modificandolo secondo necesita'. Fare git add/commit (ed escluderlo dal .gitignore)
2. downloader_ogstm_bfm.sh: lanciare controllando prima il suo contenuto per tenere conto delle varie credenziali che servono
3. builder_ogstm_bfm.sh: controllare alla riga 37 che il source al file $cluster.intel sia corretto e poi lanciare.
4. copiare le cartelle "bitsea" e "preproc" in HOST/$cluster
