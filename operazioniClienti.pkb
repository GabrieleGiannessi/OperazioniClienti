create or replace PACKAGE BODY operazioniClienti as

    procedure visualizzaBustePaga is
    BEGIN

    /*
    gui.APRIFORMFILTRO(azione => 'GET'); 

    gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataInizio', placeholder => 'Data-inizio'); 
    gui.AGGIUNGICAMPOFORMFILTRO (nome => 'Data Fine', placeholder => 'Data-fine');  
    gui.AGGIUNGICAMPOFORMFILTRO (nome => 'Submit', tipo => 'submit', value => 'Submit');

    htp.prn('<br>'); 
    gui.CHIUDIFORMFILTRO; */
    gui.apriPagina; 
    gui.APRITABELLA; 
    gui.APRIHEADERTABELLA; 
    gui.AGGIUNGIHEADERTABELLA(elemento => 'Dipendente');
    gui.AGGIUNGIHEADERTABELLA(elemento => 'Data');
    gui.AGGIUNGIHEADERTABELLA(elemento => 'Importo');
    gui.AGGIUNGIHEADERTABELLA(elemento => 'Bonus');
    gui.AGGIUNGIHEADERTABELLA(elemento => 'Contabile');

    gui.CHIUDIHEADERTABELLA; 

    for busta_paga IN
    (SELECT FK_Dipendente, Data, Importo, Bonus, FK_CONTABILE FROM BUSTEPAGA) 
    LOOP
        gui.AGGIUNGIRIGATABELLA; 

            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.FK_DIPENDENTE); 
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Data);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Importo);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Bonus);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.FK_CONTABILE);

        gui.CHIUDIRIGATABELLA;
        end LOOP; 

    END visualizzaBustePaga; 

    procedure visualizzaBustePagaDipendente (IDDipendente NUMBER) is
    BEGIN

    /*
    gui.APRIFORMFILTRO(azione => 'GET'); 

    gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataInizio', placeholder => 'Data-inizio'); 
    gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataFine', placeholder => 'Data-fine');  
    gui.AGGIUNGICAMPOFORMFILTRO (nome => 'Submit', tipo => 'submit', value => 'Submit');

    htp.prn('<br>'); 
    gui.CHIUDIFORMFILTRO; */

    gui.apriPagina;
    gui.APRITABELLA; 
    gui.APRIHEADERTABELLA; 

    gui.AGGIUNGIHEADERTABELLA(elemento => 'Data');
    gui.AGGIUNGIHEADERTABELLA(elemento => 'Importo');
    gui.AGGIUNGIHEADERTABELLA(elemento => 'Bonus');
    gui.AGGIUNGIHEADERTABELLA(elemento => 'Contabile');

    gui.CHIUDIHEADERTABELLA; 

    for busta_paga IN
    (SELECT Data, Importo, Bonus, FK_CONTABILE FROM BUSTEPAGA where FK_DIPENDENTE = IDDipendente ORDER BY Data DESC) 
    LOOP
        gui.AGGIUNGIRIGATABELLA; 
        
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Data); 
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Importo);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Bonus); 
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.FK_CONTABILE); 

        gui.ChiudiRigaTabella;
        end LOOP; 

    END visualizzaBustePagaDipendente;

    procedure visualizzaRicarica is
    BEGIN

/*
   gui.APRIFORMFILTRO(azione => 'GET'); 

   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataInizio', placeholder => 'Data-inizio'); 
   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataFine', placeholder => 'Data-fine');  
   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'Submit', tipo => 'submit', value => 'Submit');

   htp.prn('<br>'); 
   gui.CHIUDIFORMFILTRO; */

   gui.APRITABELLA; 
   gui.APRIHEADERTABELLA;
   gui.AGGIUNGIHEADERTABELLA(elemento => 'IDricarica');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'FK_Cliente'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Importo'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Data'); 
   gui.CHIUDIHEADERTABELLA; 

   for ricarica IN
   (SELECT IDRicarica, FK_Cliente, Importo, Data FROM RICARICHE) 
   LOOP
    gui.AGGIUNGIRIGATABELLA; 

        gui.AGGIUNGIELEMENTOTABELLA(elemento => ricarica.IDRicarica);
        gui.AGGIUNGIELEMENTOTABELLA(elemento => ricarica.FK_Cliente);
        gui.AGGIUNGIELEMENTOTABELLA(elemento => ricarica.Importo);
        gui.AGGIUNGIELEMENTOTABELLA(elemento => ricarica.Data);

    gui.ChiudiRigaTabella;
    end LOOP; 

    END visualizzaricarica; 
 

    procedure visualizzaRicaricheCliente (IDcliente NUMBER) is
    BEGIN

/*
   gui.APRIFORMFILTRO(azione => 'GET'); 

   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataInizio', placeholder => 'Data-inizio'); 
   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataFine', placeholder => 'Data-fine');  
   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'Submit', tipo => 'submit', value => 'Submit');

   htp.prn('<br>'); 
   gui.CHIUDIFORMFILTRO; */

   gui.APRITABELLA; 
   gui.APRIHEADERTABELLA;
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Importo'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Data'); 
   gui.CHIUDIHEADERTABELLA; 

   for ricarica IN
   (SELECT Importo, Data FROM RICARICHE where FK_CLIENTE = IDcliente) 
   LOOP
    gui.AGGIUNGIRIGATABELLA; 
    
        gui.AGGIUNGIELEMENTOTABELLA(elemento => 'ricarica.Importo');
        gui.AGGIUNGIELEMENTOTABELLA(elemento => 'ricarica.Data');

    gui.ChiudiRigaTabella;
    end LOOP; 

    END visualizzaRicaricheCliente; 

  procedure visualizzazioneClienti IS
    /*DECLARE

    TYPE array_di_stringhe IS VARRAY(10) OF VARCHAR2(100);
    */
    BEGIN
   gui.apriPagina;     
   gui.APRITABELLA; 
   gui.APRIHEADERTABELLA;
   gui.AGGIUNGIHEADERTABELLA(elemento => 'IDCliente');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Nome'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Cognome'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'DataNascita'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Sesso');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'NTelefono');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Email');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Stato');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Saldo');

   gui.CHIUDIHEADERTABELLA; 

   for clienti IN
   (SELECT IDCliente, Nome, Cognome, DataNascita, Sesso, Ntelefono, Email, Stato, Saldo FROM Clienti) 
   LOOP
    gui.AGGIUNGIRIGATABELLA; 

            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.IDCliente);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.nome);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Cognome);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.DataNascita);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Sesso);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Ntelefono);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Email);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Stato);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Saldo);

    gui.ChiudiRigaTabella;
    end LOOP;
      
END visualizzazioneClienti; 

procedure visualizzazioneConvenzioni is
BEGIN

   gui.apriPagina;
   htp.prn('<br>');
   gui.APRIFORMFILTRO(azione => 'GET'); 

   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataInizio', placeholder => 'Data-inizio'); 
   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataFine', placeholder => 'Data-fine');  
   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'Submit', tipo => 'submit', value => 'Filtra');

   gui.CHIUDIFORMFILTRO; 

   htp.prn('<br>'); 

   gui.APRITABELLA; 
   gui.APRIHEADERTABELLA;
   gui.AGGIUNGIHEADERTABELLA(elemento => 'IDConvenzione');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Nome'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Ente'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Sconto'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'CodiceAccesso');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'DataInizio');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'DataFine');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Cumulabile');

   gui.CHIUDIHEADERTABELLA; 

   for convenzioni IN
   (SELECT IDConvenzione, Nome, Ente, Sconto, CodiceAccesso, DataInizio, DataFine, Cumulabile FROM CONVENZIONI) 
   LOOP
    gui.AGGIUNGIRIGATABELLA; 

                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.IDConvenzione);
                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.Nome);
                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.Ente);
                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.Sconto);
                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.CodiceAccesso);
                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.DataInizio);
                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.DataFine);
                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.Cumulabile);

    gui.ChiudiRigaTabella;
    end LOOP; 

    END visualizzazioneConvenzioni; 


end operazioniClienti; 