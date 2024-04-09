create or replace PROCEDURE provapl is
    headers gui.StringArray;  
begin 
    headers := gui.stringArray ('Ciao', 'Ciao', 'Ciao','Ciao');  
    gui.APRIPAGINA('prova Form hidden'); 
    gui.APRITABELLA (headers); 
    for cliente in (
    SELECT * FROM CLIENTI
    )
    LOOP
        gui.AGGIUNGIFORMHIDDENRIGATABELLA (azione => 'g_giannessi.operazioniClienti.eliminazioneCliente');
        gui.AGGIUNGIRIGATABELLA; 

        gui.AGGIUNGIELEMENTOTABELLA (Cliente.Nome);
        gui.AGGIUNGIINPUT (nome => 'Nome', tipo => 'hidden', value => cliente.Nome);  

        gui.AGGIUNGIELEMENTOTABELLA (Cliente.Cognome);
        gui.AGGIUNGIINPUT (nome => 'Cognome', tipo => 'hidden', value => cliente.Cognome);  
        
        gui.AGGIUNGIELEMENTOTABELLA (Cliente.Email);
        gui.AGGIUNGIINPUT (nome => 'Email', tipo => 'hidden', value => cliente.Email);  
        
        gui.AGGIUNGIPULSANTECANCELLAZIONE ('g_giannessi.operazioniClienti.eliminazioneCliente'); 

        gui.CHIUDIRIGATABELLA; 
        gui.CHIUDIFORMHIDDENRIGATABELLA;  


    END LOOP; 
end provapl;  