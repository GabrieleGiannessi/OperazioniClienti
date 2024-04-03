create or replace PACKAGE BODY operazioniClienti as

--registrazioneCliente : procedura che instanzia la pagina HTML adibita al ruolo di far registrare il cliente al sito
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

--inserisciDati : procedura che prende i dati dal form di registrazioneCliente e provvede a inserire i dati nella tabella
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
    /*CURSOR controllo IS 
        SELECT * FROM CLIENTI c WHERE c.Nome = Nome AND c.Cognome = Cognome;  
    
    RigaControllo Controllo%ROWTYPE; 
    ClienteEsistente EXCEPTION; 
*/
    begin
        gui.ApriPagina ('Registrazione');
        DataNascita := TO_DATE (Day || '/' || Month || '/' || Year, 'DD/MM/YYYY'); 
        Sesso := SUBSTR(Gender, 1, 1);  -- cast da varchar2 a char(1)
       -- OPEN controllo; 
       -- FETCH controllo INTO RigaControllo;  

       /* IF controllo%NOTFOUND 
            THEN RAISE ClienteEsistente;

        ELSE 

        DataNascita := TO_DATE (Day || '/' || Month || '/' || Year, 'DD/MM/YYYY'); 
        Sesso := SUBSTR(Gender, 1, 1);  -- cast da varchar2 a char(1)
        INSERT INTO CLIENTI (IDCliente, Nome, Cognome, DataNascita, Sesso, NTelefono, Email, Password, Stato, Saldo) 
        VALUES (sequenceIDClienti.nextval, Nome, Cognome, DataNascita, Sesso, TO_NUMBER(Telefono),Email,Password,1,0); 
        gui.AggiungiPopup(True, 'Registrazione avvenuta con successo!');

        --Inserimento dei dati nella tabella Clienti : per gli id usiamo la sequenza sequenceIDClienti
        /*
        drop sequence sequenceIDClienti; 
        CREATE SEQUENCE sequenceIdClienti START WITH 1 INCREMENT BY 1 MAXVALUE 4294967295 ;
        */

        INSERT INTO CLIENTI (IDCliente, Nome, Cognome, DataNascita, Sesso, NTelefono, Email, Password, Stato, Saldo) 
        VALUES (sequenceIDClienti.nextval, Nome, Cognome, DataNascita, Sesso, TO_NUMBER(Telefono),Email,Password,1,0); 

        gui.AggiungiPopup(True, 'Registrazione avvenuta con successo!');

        --END IF; 

    EXCEPTION
    WHEN OTHERS /*ClienteEsistente*/ THEN
        --visualizza popup di errore
        gui.AggiungiPopup(False, 'Registrazione fallita, cliente già presente sul sito!');
    end inserisciDati; 


--modificaCliente : procedura che instanzia la pagina HTML della modifica dati cliente
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

--visualizzazioneBustePaga : procedura che visualizza tutte le buste paga presenti nel database
    procedure visualizzaBustePaga(
        r_dipendente in varchar2 default null,
		r_contabile  in varchar2 default null,
		r_data       in varchar2 default null,
		r_importo    in varchar2 default null,
		r_bonus      in varchar2 default null
    ) is

    head gui.StringArray; 

    BEGIN   

    head := gui.StringArray ('Dipendente', 'Data', 'Importo', 'Bonus', 'Contabile'); 
    gui.apriPagina(titolo => 'VisualizzazioneBustePaga'); 
    gui.APRIFORMFILTRO(/*root||'.visualizzaBustePaga'*/); 

        gui.aggiungicampoformfiltro(
		                           nome        => 'r_Dipendente',
		                           placeholder => 'Dipendente'
                                   );
		gui.aggiungicampoformfiltro(
		                           tipo        => 'date',
		                           nome        => 'r_Data',
		                           placeholder => 'Data'
		);
		gui.aggiungicampoformfiltro(
		                           nome        => 'r_Importo',
		                           placeholder => 'Importo'
		);
		gui.aggiungicampoformfiltro(
		                           nome        => 'r_Bonus',
		                           placeholder => 'Bonus'
		);
		gui.aggiungicampoformfiltro(
		                           nome        => 'r_Contabile',
		                           placeholder => 'Contabile'
		);
		gui.aggiungicampoformfiltro(
		                           'submit',
		                           '',
		                           'Filtra',
		                           ''
		);
    gui.CHIUDIFORMFILTRO; 
    gui.aCapo;

    gui.APRITABELLA (elementi => head); 

    for busta_paga IN
    (select *
			  from bustepaga b
			 where ( b.fk_dipendente = r_dipendente
			    or r_dipendente is null )
			   and ( b.fk_contabile = r_contabile
			    or r_contabile is null )
			   and ( ( trunc(
				b.data
			) = to_date(r_data,'YYYY-MM-DD') )
			    or r_data is null )
			   and ( b.importo = to_number(r_importo)
			    or r_importo is null )
			   and ( b.bonus = to_number(r_bonus)
			    or r_bonus is null )
			 order by data desc) 
    LOOP
        gui.AGGIUNGIRIGATABELLA; 

            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.FK_DIPENDENTE); 
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Data);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Importo);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Bonus);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.FK_CONTABILE);
            gui.AGGIUNGIPULSANTECANCELLAZIONE; 
            gui.AGGIUNGIPULSANTEMODIFICA;

        gui.CHIUDIRIGATABELLA;
    end LOOP; 
        gui.ChiudiTabella; 
    END visualizzaBustePaga; 

    procedure visualizzaBustePagaDipendente (
        r_idsessione in varchar2 default null,
		r_data       in varchar2 default null,
		r_importo    in varchar2 default null,
		r_bonus      in varchar2 default null
    ) is

    head gui.StringArray; 

    BEGIN

    gui.apriPagina ('visualizza buste paga dipendenti');
    gui.APRIFORMFILTRO(); 
    gui.aggiungicampoformfiltro(
		                           tipo        => 'date',
		                           nome        => 'r_Data',
		                           placeholder => 'Data'
		);

		gui.aggiungicampoformfiltro(
		                           nome        => 'r_Importo',
		                           placeholder => 'Importo'
		);
		gui.aggiungicampoformfiltro(
		                           nome        => 'r_Bonus',
		                           placeholder => 'Bonus'
		);
		gui.aggiungicampoformfiltro(
		                           'submit',
		                           '',
		                           'Filtra',
		                           ''
		);
    gui.CHIUDIFORMFILTRO; 
    gui.aCapo;

    head := gui.StringArray('Data', 'Importo', 'Bonus'); 
    gui.APRITABELLA (elementi => head); 

    for busta_paga IN
    (select data,
			       importo,
			       bonus
			  from bustepaga b
			 where ( b.fk_dipendente = sessionhandler.getiduser(r_idsessione) )
			   and ( ( trunc(
				b.data
			) = to_date(r_data,'YYYY-MM-DD') )
			    or r_data is null )
			   and ( b.importo = to_number(r_importo)
			    or r_importo is null )
			   and ( b.bonus = to_number(r_bonus)
			    or r_bonus is null )
			 order by data desc) 
    LOOP
        gui.AGGIUNGIRIGATABELLA; 
        
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Data); 
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Importo);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Bonus);  

        gui.ChiudiRigaTabella;
        end LOOP; 

        gui.ChiudiTabella; 

    END visualizzaBustePagaDipendente;

    procedure visualizzaRicarica (
        r_cliente in varchar2 default null,
		r_data    in varchar2 default null,
		r_importo in varchar2 default null
    ) 
    is

    head gui.StringArray; 

    BEGIN

   head := gui.StringArray ('IDRicarica', 'Cliente', 'Importo', 'Data');
   gui.APRIPAGINA ('visualizza ricariche');
   gui.APRIFORMFILTRO(/*root || '.visualizzaRicarica'*/); 

   gui.aggiungicampoformfiltro(
		                           nome        => 'r_Cliente',
		                           placeholder => 'Cliente'
		);
		gui.aggiungicampoformfiltro(
		                           nome        => 'r_Importo',
		                           placeholder => 'Importo'
		);
		gui.aggiungicampoformfiltro(
		                           tipo        => 'date',
		                           nome        => 'r_Data',
		                           placeholder => 'Data'
		);
		gui.aggiungicampoformfiltro(
		                           'submit',
		                           '',
		                           'Filtra',
		                           ''
		);
   gui.CHIUDIFORMFILTRO; 
   gui.aCapo; 

   gui.APRITABELLA (elementi => head); 
   for ricarica IN
   (select *
			  from ricariche
			 where ( ricariche.fk_cliente = r_cliente
			    or r_cliente is null )
			   and ( ( trunc(
				ricariche.data
			) = to_date(r_data,'YYYY-MM-DD') )
			    or r_data is null )
			   and ( ricariche.importo = to_number(r_importo)
			    or r_importo is null)
    ) 
   LOOP

        gui.AGGIUNGIRIGATABELLA; 
        gui.AGGIUNGIELEMENTOTABELLA( elemento => ricarica.IDRicarica );
        gui.AGGIUNGIELEMENTOTABELLA( elemento => ricarica.FK_CLIENTE );
        gui.AGGIUNGIELEMENTOTABELLA( elemento => ricarica.importo );
        gui.AGGIUNGIELEMENTOTABELLA( elemento => ricarica.data );
        gui.AggiungiPulsanteCancellazione; 
        gui.aggiungiPulsanteModifica(collegamento1 => '#'); 

        gui.ChiudiRigaTabella;


    end LOOP; 
    gui.CHIUDITABELLA;   

    END visualizzaricarica;
 
    procedure visualizzaRicaricheCliente (
        r_idsessione in varchar2 default null,
		r_data       in varchar2 default null,
		r_importo    in varchar2 default null
    ) is

    head gui.stringArray; 

    BEGIN
    gui.apriPagina (titolo => 'Visualizzazione Ricariche cliente'); 

   gui.APRIFORMFILTRO(); 

   gui.aggiungicampoformfiltro(
		                           nome        => 'r_Importo',
		                           placeholder => 'Importo'
		);
		gui.aggiungicampoformfiltro(
		                           tipo        => 'date',
		                           nome        => 'r_Data',
		                           placeholder => 'Data'
		);
		gui.aggiungicampoformfiltro(
		                           'submit',
		                           '',
		                           'Filtra',
		                           ''
		);

   gui.ACAPO; 
   gui.CHIUDIFORMFILTRO; 
 
   head := gui.StringArray('Identificativo','Importo', 'Data');
   gui.APRITABELLA (elementi => head); 

   for ricarica IN
   (select idricarica,
			       importo,
			       data
			  from ricariche r
			 where ( r.fk_cliente = sessionhandler.getiduser(r_idsessione) )
			   and ( ( trunc(
				r.data
			) = to_date(r_data,'YYYY-MM-DD') )
			    or r_data is null )
			   and ( r.importo = to_number(r_importo)
			    or r_importo is null )
			 order by data desc) 
   LOOP
    gui.AGGIUNGIRIGATABELLA; 
    
        gui.aggiungielementotabella(elemento => ricarica.idricarica);
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
   gui.APRIFORMFILTRO(/*root||'.visualizzazioneConvenzioni'*/); 

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
