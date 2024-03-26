create or replace PACKAGE BODY operazioniClienti as

    procedure visualizzaBustePaga is
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
        
        htp.prn ('<td>'); 
        htp.prn (busta_paga.FK_DIPENDENTE); 
        htp.prn ('</td>');

        htp.prn ('<td>'); 
        htp.prn (busta_paga.Data); 
        htp.prn ('</td>');
        
        htp.prn ('<td>'); 
        htp.prn (busta_paga.Importo); 
        htp.prn ('</td>');
        
        htp.prn ('<td>'); 
        htp.prn (busta_paga.Bonus); 
        htp.prn ('</td>');

        htp.prn ('<td>'); 
        htp.prn (busta_paga.FK_CONTABILE); 
        htp.prn ('</td>');
        
        gui.ChiudiRigaTabella;
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
        
        htp.prn ('<td>'); 
        htp.prn (busta_paga.Data); 
        htp.prn ('</td>');
        
        htp.prn ('<td>'); 
        htp.prn (busta_paga.Importo); 
        htp.prn ('</td>');
        
        
        
        htp.prn ('<td>'); 
        htp.prn (busta_paga.Bonus); 
        htp.prn ('</td>');

        htp.prn ('<td>'); 
        htp.prn (busta_paga.FK_CONTABILE); 
        htp.prn ('</td>');
        
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

    htp.prn ('<td>'); 
    htp.prn (ricarica.IDRicarica); 
    htp.prn ('</td>');

    htp.prn ('<td>'); 
    htp.prn (ricarica.FK_Cliente); 
    htp.prn ('</td>');

    htp.prn ('<td>'); 
    htp.prn (ricarica.Importo); 
    htp.prn ('</td>');

    htp.prn ('<td>'); 
    htp.prn (ricarica.Data); 
    htp.prn ('</td>');

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
    
    htp.prn ('<td>'); 
    htp.prn (ricarica.Importo); 
    htp.prn ('</td>');

    htp.prn ('<td>'); 
    htp.prn (ricarica.Data); 
    htp.prn ('</td>');

    gui.ChiudiRigaTabella;
    end LOOP; 

    END visualizzaRicaricheCliente; 

  procedure visualizzazioneClienti IS
    /*DECLARE

    TYPE array_di_stringhe IS VARRAY(10) OF VARCHAR2(100);
    */
    BEGIN
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

    htp.prn ('<td>'); 
    htp.prn (clienti.IDCliente); 
    htp.prn ('</td');

    htp.prn ('<td>'); 
    htp.prn (clienti.Nome); 
    htp.prn ('</td');

    htp.prn ('<td>'); 
    htp.prn (clienti.Cognome); 
    htp.prn ('</td');

    htp.prn ('<td>'); 
    htp.prn (clienti.DataNascita); 
    htp.prn ('</td');

    htp.prn ('<td>'); 
    htp.prn (clienti.Sesso); 
    htp.prn ('</td');

    htp.prn ('<td>'); 
    htp.prn (clienti.Ntelefono); 
    htp.prn ('</td');

    htp.prn ('<td>'); 
    htp.prn (clienti.Email); 
    htp.prn ('</td');

    htp.prn ('<td>'); 
    htp.prn (clienti.Stato); 
    htp.prn ('</td');

    htp.prn ('<td>'); 
    htp.prn (clienti.Saldo); 
    htp.prn ('</td');

    gui.ChiudiRigaTabella;
    end LOOP;
      

END visualizzazioneClienti; 

procedure visualizzazioneConvenzioni is
BEGIN

   gui.APRIFORMFILTRO(azione => 'GET'); 

   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataInizio', placeholder => 'Data-inizio'); 
   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataFine', placeholder => 'Data-fine');  
   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'Submit', tipo => 'submit', value => 'Submit');

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

    htp.prn ('<td>'); 
    htp.prn (convenzioni.IDConvenzione); 
    htp.prn ('</td>');

    htp.prn ('<td>'); 
    htp.prn (convenzioni.Nome); 
    htp.prn ('</td>');

    htp.prn ('<td>'); 
    htp.prn (convenzioni.Ente); 
    htp.prn ('</td>');

    htp.prn ('<td>'); 
    htp.prn (convenzioni.Sconto); 
    htp.prn ('</td>');

    htp.prn ('<td>'); 
    htp.prn (convenzioni.CodiceAccesso); 
    htp.prn ('</td>');

    htp.prn ('<td>'); 
    htp.prn (convenzioni.DataInizio); 
    htp.prn ('</td>');

    htp.prn ('<td>'); 
    htp.prn (convenzioni.DataFine); 
    htp.prn ('</td>');

    htp.prn ('<td>'); 
    htp.prn (convenzioni.Cumulabile); 
    htp.prn ('</td>');

    gui.ChiudiRigaTabella;
    end LOOP; 

    END visualizzazioneConvenzioni; 


end operazioniClienti; 