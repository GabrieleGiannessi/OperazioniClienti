create or replace PACKAGE BODY operazioniClienti as

    procedure registrazioneCliente IS
    BEGIN
    gui.APRIPAGINA(titolo => 'Registrazione');
    gui.AGGIUNGIFORM (url => 'g_giannessi.operazioniClienti.inserisciDati');  

        gui.AGGIUNGIRIGAFORM;   
            gui.aggiungiIntestazione(testo => 'Registrazione', dimensione => 'h2');
            gui.AGGIUNGIGRUPPOINPUT; 
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-user', nome => 'Nome', placeholder => 'Nome');        
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-user', nome => 'Cognome', placeholder => 'Cognome');        
                gui.AGGIUNGICAMPOFORM (tipo => 'email', classeIcona => 'fa fa-envelope', nome => 'Email', placeholder => 'Indirizzo Email');   
                gui.AGGIUNGICAMPOFORM (tipo => 'password', classeIcona => 'fa fa-key', nome => 'Password', placeholder => 'Password'); 
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-phone', nome => 'Telefono', placeholder => 'Telefono'); 
            gui.CHIUDIGRUPPOINPUT;
        gui.CHIUDIRIGAFORM; 

        gui.AGGIUNGIRIGAFORM; 
           gui.APRIDIV (classe => 'col-half');
           gui.aggiungiIntestazione(testo => 'Data di nascita', dimensione => 'h4'); 

                gui.AGGIUNGIGRUPPOINPUT; 
                    gui.APRIDIV (classe => 'col-third');
                        gui.AGGIUNGIINPUT (placeholder => 'DD', nome => 'Day', classe => ''); 
                    gui.CHIUDIDIV;

                    gui.APRIDIV (classe => 'col-third');
                        gui.AGGIUNGIINPUT (placeholder => 'MM', nome => 'Month', classe => ''); 
                    gui.CHIUDIDIV;

                    gui.APRIDIV (classe => 'col-third');
                        gui.AGGIUNGIINPUT (placeholder => 'YYYY', nome => 'Year', classe => ''); 
                    gui.CHIUDIDIV;
                gui.CHIUDIGRUPPOINPUT; 

            gui.CHIUDIGRUPPOINPUT;

            gui.APRIDIV (classe => 'col-half'); 
                gui.aggiungiIntestazione(testo => 'Sesso', dimensione => 'h4');

                    gui.AGGIUNGIGRUPPOINPUT; 
                        gui.AGGIUNGIINPUT (nome => 'gender', ident => 'gender-male', tipo => 'radio', value => 'M');
                        gui.AGGIUNGILABEL (target => 'gender-male', testo => 'Maschio');  
                        gui.AGGIUNGIINPUT (nome => 'gender', ident => 'gender-female', tipo => 'radio', value => 'F');
                        gui.AGGIUNGILABEL (target => 'gender-female', testo => 'Femmina'); 
                    gui.CHIUDIGRUPPOINPUT;  
            gui.CHIUDIDIV;
        gui.CHIUDIRIGAFORM; 

        gui.AGGIUNGIRIGAFORM;
            gui.AGGIUNGIGRUPPOINPUT; 
                gui.AGGIUNGIBOTTONESUBMIT (value => 'Registra'); 
            gui.CHIUDIGRUPPOINPUT; 
        gui.CHIUDIRIGAFORM; 

    gui.CHIUDIFORM; 
    END registrazioneCliente; 

    procedure inserisciDati (Nome VARCHAR2 DEFAULT NULL,
    Cognome VARCHAR2 DEFAULT NULL,
    Email VARCHAR2 DEFAULT NULL,
    Password VARCHAR2 DEFAULT NULL,
    Telefono VARCHAR2 DEFAULT NULL,
    Day VARCHAR2 DEFAULT NULL,   
    Month VARCHAR2 DEFAULT NULL,
    Year VARCHAR2 DEFAULT NULL,
    Gender VARCHAR2 DEFAULT NULL) IS

    DataNascita DATE; 
    Sesso CHAR(1); 

    begin
        gui.ApriPagina ('Registrazione');
 
        DataNascita := TO_DATE (Day || '/' || Month || '/' || Year, 'DD/MM/YYYY'); 
        Sesso := SUBSTR(Gender, 1, 1);  -- cast da varchar2 a char(1)


        --Inserimento dei dati nella tabella Clienti : per gli id usiamo la sequenza sequenceIDClienti
        /*
        drop sequence sequenceIDClienti; 
        CREATE SEQUENCE sequenceIdClienti START WITH 1 INCREMENT BY 1 MAXVALUE 4294967295 ;
        */

        INSERT INTO CLIENTI (IDCliente, Nome, Cognome, DataNascita, Sesso, NTelefono, Email, Password, Stato, Saldo) 
        VALUES (sequenceIDClienti.nextval, Nome, Cognome, DataNascita, Sesso, TO_NUMBER(Telefono),Email,Password,1,0); 

        gui.AggiungiPopup(True, 'Registrazione avvenuta con successo!');

    EXCEPTION
    WHEN OTHERS THEN
        --visualizza popup di errore
        gui.AggiungiPopup(False, 'Registrazione fallita!');
    end inserisciDati; 

    procedure modificaCliente IS
    BEGIN
    gui.APRIPAGINA(titolo => 'Modifica dati cliente');
    gui.AGGIUNGIFORM (url => 'g_giannessi.operazioniClienti.inserisciDati');  

        gui.AGGIUNGIRIGAFORM;   
            gui.aggiungiIntestazione(testo => 'Modifica dati', dimensione => 'h1');
            gui.AGGIUNGIGRUPPOINPUT;    
                gui.AGGIUNGIINTESTAZIONE (testo => 'Email', dimensione => 'h2');
                gui.ACAPO; 
                gui.AGGIUNGIINTESTAZIONE (testo => 'Vecchia : ', dimensione => 'h3');
                gui.AGGIUNGIPARAGRAFO (testo => 'Esempio');    
                gui.ACAPO; 
                gui.AGGIUNGIINTESTAZIONE (testo => 'Nuova : ', dimensione => 'h3');  
                gui.AGGIUNGICAMPOFORM (tipo => 'email', classeIcona => 'fa fa-envelope', nome => 'Email', placeholder => 'Nuova mail');
            gui.CHIUDIGRUPPOINPUT; 


            gui.AGGIUNGIGRUPPOINPUT;
                gui.AGGIUNGIINTESTAZIONE (testo => 'Password', dimensione => 'h2');
                gui.ACAPO; 
                gui.AGGIUNGIINTESTAZIONE (testo => 'Vecchia : ', dimensione => 'h3');
                gui.AGGIUNGIPARAGRAFO (testo => 'Esempio');    
                gui.ACAPO; 
                gui.AGGIUNGIINTESTAZIONE (testo => 'Nuova : ', dimensione => 'h3');  
                gui.AGGIUNGICAMPOFORM (tipo => 'password', classeIcona => 'fa fa-key', nome => 'Password', placeholder => 'Password'); 

            gui.CHIUDIGRUPPOINPUT; 

            gui.AGGIUNGIGRUPPOINPUT; 
                gui.AGGIUNGIINTESTAZIONE (testo => 'Telefono', dimensione => 'h2');
                gui.ACAPO; 
                gui.AGGIUNGIINTESTAZIONE (testo => 'Vecchio numero : ', dimensione => 'h3');
                gui.AGGIUNGIPARAGRAFO (testo => 'Esempio');    
                gui.ACAPO; 
                gui.AGGIUNGIINTESTAZIONE (testo => 'Nuovo numero : ', dimensione => 'h3'); 
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-phone', nome => 'Telefono', placeholder => 'Telefono'); 
            gui.CHIUDIGRUPPOINPUT;
        gui.CHIUDIRIGAFORM; 

        gui.AGGIUNGIRIGAFORM;
            gui.AGGIUNGIGRUPPOINPUT; 
                gui.AGGIUNGIBOTTONESUBMIT (value => 'Modifica'); 
            gui.CHIUDIGRUPPOINPUT; 
        gui.CHIUDIRIGAFORM; 

    gui.CHIUDIFORM; 
    END modificaCliente; 

    procedure visualizzaBustePaga is

    head gui.StringArray; 

    BEGIN   

    head := gui.StringArray ('Dipendente', 'Data', 'Importo', 'Bonus', 'Contabile'); 
    gui.apriPagina (titolo => 'visualizza Buste paga'); 
    gui.APRIFORMFILTRO(/*u_root||'.visualizzaBustePaga'*/);     

    gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataInizio', placeholder => 'Data-inizio'); 
    gui.AGGIUNGICAMPOFORMFILTRO (nome => 'Data Fine', placeholder => 'Data-fine');  
    gui.AGGIUNGICAMPOFORMFILTRO (nome => 'Submit', tipo => 'submit', value => 'Filtra');
    gui.CHIUDIFORMFILTRO; 
    gui.aCapo;

    gui.APRITABELLA (elementi => head); 

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
        gui.ChiudiTabella; 

    END visualizzaBustePaga; 

    procedure visualizzaBustePagaDipendente (IDDipendente NUMBER) is
    head gui.StringArray; 

    BEGIN

    gui.APRIFORMFILTRO(); 
    gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataInizio', placeholder => 'Data-inizio'); 
    gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataFine', placeholder => 'Data-fine');  
    gui.AGGIUNGICAMPOFORMFILTRO (nome => 'Submit', tipo => 'submit', value => 'Filtra');

    gui.CHIUDIFORMFILTRO; 

    head := gui.StringArray('Data', 'Importo', 'Bonus', 'Contabile'); 
    gui.apriPagina ('visualizza buste paga dipendenti');
    gui.APRITABELLA (elementi => head); 

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

        gui.ChiudiTabella; 

    END visualizzaBustePagaDipendente;

    procedure visualizzaRicarica (
        r_Cliente in varchar2 default null,
        r_Data in varchar2 default null,
        r_Importo in varchar2 default null
    ) 
    is

    head gui.StringArray; 
    BEGIN

   head := gui.StringArray ('IDRicarica', 'Cliente', 'Importo', 'Data');
   gui.APRIPAGINA ('visualizza ricariche');
   gui.APRIFORMFILTRO(/*u_root || '.visualizzaRicarica'*/); 

   gui.aggiungiCampoFormFiltro(nome => 'r_Cliente', placeholder => 'Cliente');
   gui.aggiungiCampoFormFiltro(nome => 'r_Importo', placeholder => 'Importo');
   gui.aggiungiCampoFormFiltro(tipo => 'date',nome => 'r_Data', placeholder => 'Data'); 
   gui.aggiungiCampoFormFiltro('submit', '', 'Filtra', '');
   gui.CHIUDIFORMFILTRO; 
   gui.aCapo; 

   gui.APRITABELLA (elementi => head); 
   for ricarica IN
   (SELECT *
    FROM RICARICHE
    WHERE (RICARICHE.FK_Cliente = r_Cliente or r_Cliente is null) AND ((trunc(RICARICHE.Data) = to_date(r_Data, 'YYYY-MM-DD')) or r_Data is null)
    AND (RICARICHE.Importo = to_number(r_Importo) or r_Importo is null)
    ) 
   LOOP

        gui.AGGIUNGIRIGATABELLA; 
        gui.AGGIUNGIELEMENTOTABELLA( elemento => ricarica.IDRicarica );
        gui.AGGIUNGIELEMENTOTABELLA( elemento => ricarica.FK_CLIENTE );
        gui.AGGIUNGIELEMENTOTABELLA( elemento => ricarica.importo );
        gui.AGGIUNGIELEMENTOTABELLA( elemento => ricarica.data );
        gui.AggiungiPulsanteCancellazione; 
        gui.aggiungiPulsanteModifica (collegamento1 => '#'); 

        gui.ChiudiRigaTabella;


    end LOOP; 

    gui.CHIUDITABELLA;      
    END visualizzaricarica;
 
    procedure visualizzaRicaricheCliente (IDcliente NUMBER) is
    head gui.stringArray; 
    BEGIN
    gui.apriPagina (titolo => 'Visualizzazione Ricariche cliente'); 

   gui.APRIFORMFILTRO(); 

   gui.aggiungiCampoFormFiltro(nome => 'r_Cliente', placeholder => 'Cliente');
   gui.aggiungiCampoFormFiltro(nome => 'r_Importo', placeholder => 'Importo');
   gui.aggiungiCampoFormFiltro(tipo => 'date',nome => 'r_Data', placeholder => 'Data'); 
   gui.aggiungiCampoFormFiltro('submit', '', 'Filtra', '');

   htp.prn('<br>'); 
   gui.CHIUDIFORMFILTRO; 
 
   head := gui.StringArray('Importo', 'Data', '');
   gui.APRITABELLA (elementi => head); 

   for ricarica IN
   (SELECT Importo, Data FROM RICARICHE where FK_CLIENTE = IDcliente) 
   LOOP
    gui.AGGIUNGIRIGATABELLA; 
    
        gui.AGGIUNGIELEMENTOTABELLA(elemento => ricarica.Importo);
        gui.AGGIUNGIELEMENTOTABELLA(elemento => ricarica.Data);

    gui.ChiudiRigaTabella;
    end LOOP; 

    gui.ChiudiTabella; 
    END visualizzaRicaricheCliente; 

  procedure visualizzazioneClienti IS

   head gui.StringArray; 

   BEGIN
   head := gui.StringArray ('IDCliente', 'Nome', 'Cognome', 'DataNascita', 'Sesso', 'NTelefono', 'Email', 'Stato', 'Saldo'); 
   gui.apriPagina ('visualizza clienti'); 
     
   gui.APRITABELLA (elementi => head); 

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
            gui.AggiungiPulsanteCancellazione; 
            gui.aggiungiPulsanteModifica (collegamento1 => '#'); 

    gui.ChiudiRigaTabella;

    end LOOP;
    gui.CHIUDITABELLA; 
      
END visualizzazioneClienti; 

procedure visualizzazioneConvenzioni (DataInizio VARCHAR2 DEFAULT NULL,
    DataFine VARCHAR2 DEFAULT NULL,
    Ente VARCHAR2 DEFAULT NULL
    /*cumulabile*/) is 

    head gui.StringArray; 

BEGIN

   head := gui.StringArray ('IDConvenzione', 'Nome', 'Ente', 'Sconto', 'CodiceAccesso', 'DataInizio', 'DataFine', 'Cumulabile'); 
   gui.apriPagina ('visualizza Convenzioni');
   gui.APRIFORMFILTRO(/*u_root||'.visualizzazioneConvenzioni'*/); 

   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataInizio', placeholder => 'Data-inizio'); 
   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataFine', placeholder => 'Data-fine');  
   gui.AggiungiCampoFormFiltro(tipo =>'submit', nome => 'Submit', value => 'Filtra'); 
   gui.CHIUDIFORMFILTRO; 
   gui.aCapo; 

   gui.APRITABELLA (head); 

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

    gui.ChiudiTabella; 

    END visualizzazioneConvenzioni; 

end operazioniClienti; 