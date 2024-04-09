SET DEFINE OFF; 

create or replace PACKAGE BODY operazioniClienti as

--registrazioneCliente : procedura che instanzia la pagina HTML adibita al ruolo di far registrare il cliente al sito
    procedure registrazioneCliente IS
    BEGIN   
    gui.APRIPAGINA(titolo => 'Registrazione', idSessione => 0);
    gui.AGGIUNGIFORM (url => 'g_giannessi.operazioniClienti.inserisciDati');  

        gui.AGGIUNGIRIGAFORM;   
            gui.aggiungiIntestazione(testo => 'Registrazione', dimensione => 'h2');
            gui.AGGIUNGIGRUPPOINPUT; 
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-user', nome => 'Nome', placeholder => 'Nome');        
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-user', nome => 'Cognome', placeholder => 'Cognome');        
                gui.AGGIUNGICAMPOFORM (tipo => 'email', classeIcona => 'fa fa-envelope', nome => 'Email', placeholder => 'Indirizzo Email');   
                gui.AGGIUNGICAMPOFORM (tipo => 'password', classeIcona => 'fa fa-key', nome => 'Password', placeholder => 'Password'); 
                gui.AGGIUNGICAMPOFORM (tipo => 'tel', classeIcona => 'fa fa-phone', nome => 'Telefono', placeholder => 'Telefono'); 
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
        
        INSERT INTO CLIENTI ( Nome, Cognome, DataNascita, Sesso, NTelefono, Email, Password, Stato, Saldo) 
        VALUES ( Nome, Cognome, DataNascita, Sesso, TO_NUMBER(Telefono),Email,Password,1,0); 
        gui.AggiungiPopup(True, 'Registrazione avvenuta con successo!');
        */

        INSERT INTO CLIENTI (Nome, Cognome, DataNascita, Sesso, NTelefono, Email, Password, Stato, Saldo) 
        VALUES (Nome, Cognome, DataNascita, Sesso, TO_NUMBER(Telefono),Email,Password,1,0); 

        gui.AggiungiPopup(True, 'Registrazione avvenuta con successo!');

        --END IF; 

    EXCEPTION
    WHEN OTHERS /*ClienteEsistente*/ THEN
        --visualizza popup di errore
        gui.AggiungiPopup(False, 'Registrazione fallita, cliente già presente sul sito!');
    end inserisciDati;   

--modificaCliente : procedura che instanzia la pagina HTML della modifica dati cliente
    procedure modificaCliente(
        c_Email VARCHAR2 DEFAULT NULL,
        c_Password VARCHAR2 DEFAULT NULL,
        c_Telefono VARCHAR2 DEFAULT NULL,
        new_Email VARCHAR2 DEFAULT NULL,
        new_Password VARCHAR2 DEFAULT NULL,
        new_Telefono VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
    gui.APRIPAGINA(titolo => 'Modifica dati cliente');

    --aggiungere controlli sulla presenza dei valori nuovi : se true aggiungiPopup con scritto valori inseriti 
    gui.AGGIUNGIFORM ();  

        gui.AGGIUNGIRIGAFORM;   
            gui.aggiungiIntestazione(testo => 'Modifica dati', dimensione => 'h1');
            gui.AGGIUNGIGRUPPOINPUT;    
                gui.AGGIUNGIINTESTAZIONE (testo => 'Email', dimensione => 'h2');
                gui.ACAPO; 
                gui.AGGIUNGIINTESTAZIONE (testo => 'Vecchia : ', dimensione => 'h3');
                gui.AGGIUNGIPARAGRAFO (testo => 'Esempio');    
                gui.ACAPO; 
                gui.AGGIUNGIINTESTAZIONE (testo => 'Nuova : ', dimensione => 'h3');  
                gui.AGGIUNGICAMPOFORM (tipo => 'email', classeIcona => 'fa fa-envelope', nome => 'new_Email', placeholder => 'Nuova mail');
            gui.CHIUDIGRUPPOINPUT; 


            gui.AGGIUNGIGRUPPOINPUT;
                gui.AGGIUNGIINTESTAZIONE (testo => 'Password', dimensione => 'h2');
                gui.ACAPO; 
                gui.AGGIUNGIINTESTAZIONE (testo => 'Vecchia : ', dimensione => 'h3');
                gui.AGGIUNGIPARAGRAFO (testo => 'Esempio');    
                gui.ACAPO; 
                gui.AGGIUNGIINTESTAZIONE (testo => 'Nuova : ', dimensione => 'h3');  
                gui.AGGIUNGICAMPOFORM (tipo => 'password', classeIcona => 'fa fa-key', nome => 'new_Password', placeholder => 'Password'); 

            gui.CHIUDIGRUPPOINPUT; 

            gui.AGGIUNGIGRUPPOINPUT; 
                gui.AGGIUNGIINTESTAZIONE (testo => 'Telefono', dimensione => 'h2');
                gui.ACAPO; 
                gui.AGGIUNGIINTESTAZIONE (testo => 'Vecchio numero : ', dimensione => 'h3');
                gui.AGGIUNGIPARAGRAFO (testo => 'Esempio');    
                gui.ACAPO; 
                gui.AGGIUNGIINTESTAZIONE (testo => 'Nuovo numero : ', dimensione => 'h3'); 
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-phone', nome => 'new_Telefono', placeholder => 'Telefono'); 
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

    gui.APRIFORMFILTRO(); 
        gui.aggiungicampoformfiltro(nome => 'r_Dipendente', placeholder => 'Dipendente');
		gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
		gui.aggiungicampoformfiltro(nome => 'r_Importo', placeholder => 'Importo');
		gui.aggiungicampoformfiltro(nome => 'r_Bonus', placeholder => 'Bonus');
		gui.aggiungicampoformfiltro(nome => 'r_Contabile', placeholder => 'Contabile');
		gui.aggiungicampoformfiltro('submit', '',' Filtra','');
    gui.CHIUDIFORMFILTRO; 

    gui.aCapo;

    gui.APRITABELLA (elementi => head); 

    for busta_paga IN (
        select *
        from bustepaga b
        where ( b.fk_dipendente = r_dipendente or r_dipendente is null )
            and ( b.fk_contabile = r_contabile or r_contabile is null )
            and ( ( trunc(b.data) = to_date(r_data,'YYYY-MM-DD') ) or r_data is null )
            and ( b.importo = to_number(r_importo) or r_importo is null )
            and ( b.bonus = to_number(r_bonus) or r_bonus is null )
        order by data desc
    ) 
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
        gui.AGGIUNGIINPUT(tipo => 'hidden', nome => 'r_idsessione', value => r_idsessione);
        gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
        gui.aggiungicampoformfiltro(nome => 'r_Importo', placeholder => 'Importo');
		gui.aggiungicampoformfiltro(nome => 'r_Bonus', placeholder => 'Bonus');
		gui.aggiungicampoformfiltro('submit', '', 'Filtra','');
    gui.CHIUDIFORMFILTRO; 
    
    gui.aCapo;

    head := gui.StringArray('Data', 'Importo', 'Bonus'); 
    gui.APRITABELLA (elementi => head); 

    for busta_paga IN (
        select data, importo, bonus
		from bustepaga b
		where ( b.fk_dipendente = sessionhandler.getiduser(r_idsessione) )
			and ( ( trunc(b.data) = to_date(r_data,'YYYY-MM-DD')) or r_data is null )
			and ( b.importo = to_number(r_importo) or r_importo is null )
			and ( b.bonus = to_number(r_bonus) or r_bonus is null )
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


    function checkDipendente(r_IdDipendente in varchar2 default null) return boolean IS 
        count_d NUMBER;
    BEGIN
        SELECT COUNT(*) INTO count_d FROM DIPENDENTI d WHERE d.Matricola = r_IdDipendente;
        IF(count_d=1) THEN
            return true;
        ELSE
            return false;
        END IF;
    END checkDipendente;

    function checkContabile(r_IdContabile in varchar2 default null) return boolean IS 
        count_c NUMBER;
    BEGIN
        SELECT COUNT(*) INTO count_c FROM RESPONSABILI r WHERE r.FK_RESPONSABILE = r_IdContabile AND r.RUOLO=0;
        IF(count_c=1) THEN
            return true;
        ELSE
            return false;
        END IF;
    END checkContabile;

    procedure inserimentoBustaPaga(
        r_IdSessioneContabile in varchar2 default null, 
        r_FkDipendente in varchar2 default null,
        r_Importo in varchar2 default null) IS

    bonus_percent NUMBER := 0;
    
    head gui.StringArray; 

    BEGIN
        
        gui.APRIPAGINA(titolo => 'inserimentoBustaPaga', idSessione => r_IdSessioneContabile);
        gui.AGGIUNGIFORM (url => 'l_bindi.operazioniClienti.inserimentoBustaPaga');  

            gui.AGGIUNGIRIGAFORM;  
                gui.aggiungiIntestazione(testo => 'Inserimento Busta Paga', dimensione => 'h2');
                gui.AGGIUNGIGRUPPOINPUT; 
                    gui.AGGIUNGIINPUT(tipo=>'hidden', nome=>'r_IdSessioneContabile', value => r_IdSessioneContabile); 
                    gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-user', nome => 'r_FkDipendente', placeholder => 'Identificativo Dipendente');        
                    gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-money-bill', nome => 'r_Importo', placeholder => 'Importo');   
                gui.CHIUDIGRUPPOINPUT;
            gui.CHIUDIRIGAFORM; 

            gui.AGGIUNGIRIGAFORM;
                gui.AGGIUNGIGRUPPOINPUT; 
                    gui.AGGIUNGIBOTTONESUBMIT (nome => '', value => 'Inserisci'); 
                gui.CHIUDIGRUPPOINPUT; 
            gui.CHIUDIRIGAFORM; 
        gui.CHIUDIFORM;

        if(r_Importo > 0) THEN
            IF(checkDipendente(r_FkDipendente)) THEN 
                /* Recupero il bonus percentuale in dipendenti */
                SELECT d.Bonus INTO bonus_percent FROM DIPENDENTI d WHERE d.Matricola = sessionhandler.getiduser(r_IdSessioneContabile);
                /* Inserisco la busta paga calcolando il bonus */
                INSERT INTO BUSTEPAGA (FK_Dipendente, FK_Contabile, Data, Importo, Bonus) VALUES 
                (TO_NUMBER(r_FkDipendente), sessionhandler.getiduser(r_IdSessioneContabile), SYSDATE, TO_NUMBER(r_Importo), (TO_NUMBER(r_Importo)*bonus_percent)/100);
                /* Popup di successo */
                gui.AggiungiPopup(True, 'Busta paga inserita con successo!');
            ELSE
                gui.AggiungiPopup(False, 'Errori inserimento dati');
            END IF;
        END IF;
        

    END inserimentoBustaPaga;


    procedure visualizzaRicariche (
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
        gui.aggiungicampoformfiltro(nome => 'r_Cliente', placeholder => 'Cliente');
		gui.aggiungicampoformfiltro( nome => 'r_Importo', placeholder => 'Importo');
		gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
		gui.aggiungicampoformfiltro('submit', '', 'Filtra', '');
    gui.CHIUDIFORMFILTRO; 
    gui.aCapo; 

    gui.APRITABELLA (elementi => head); 
   for ricarica IN(
    select *
    from ricariche
	where ( ricariche.fk_cliente = r_cliente or r_cliente is null )
		and ( ( trunc( ricariche.data) = to_date(r_data,'YYYY-MM-DD') ) or r_data is null )
		and ( ricariche.importo = to_number(r_importo) or r_importo is null)
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

    END visualizzaRicariche;
 
    procedure visualizzaRicaricheCliente (
        r_IdSessioneCliente in varchar2 default null,
		r_Data       in varchar2 default null,
		r_Importo    in varchar2 default null
    ) is

    head gui.stringArray; 

    BEGIN
    gui.apriPagina (titolo => 'Visualizzazione Ricariche cliente'); 

    gui.APRIFORMFILTRO(); 
        gui.AGGIUNGIINPUT(tipo => 'hidden', nome => 'r_IdSessioneCliente', value => r_IdSessioneCliente);
        gui.aggiungicampoformfiltro(nome => 'r_Importo', placeholder => 'Importo');
            gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
            gui.aggiungicampoformfiltro('submit', '', 'Filtra', '');
        gui.ACAPO; 
    gui.CHIUDIFORMFILTRO; 
 
   head := gui.StringArray('Identificativo','Importo', 'Data');
   gui.APRITABELLA (elementi => head); 

   for ricarica IN (
        select idricarica, importo,data
        from ricariche r
        where ( r.fk_cliente = sessionhandler.getiduser(r_IdSessioneCliente) )
            and ( ( trunc(r.data) = to_date(r_Data,'YYYY-MM-DD') ) or r_Data is null )
            and ( r.importo = to_number(r_Importo) or r_Importo is null )
        order by data desc
    ) 
   LOOP
    gui.AGGIUNGIRIGATABELLA; 
    
        gui.aggiungielementotabella(elemento => ricarica.idricarica);
        gui.AGGIUNGIELEMENTOTABELLA(elemento => ricarica.Importo);
        gui.AGGIUNGIELEMENTOTABELLA(elemento => ricarica.Data);

    gui.ChiudiRigaTabella;
    end LOOP; 

    gui.ChiudiTabella; 
    END visualizzaRicaricheCliente; 

    procedure inserimentoRicarica (
        r_IdSessioneCliente in varchar2 default null,
        r_Importo in varchar2 default null
    )IS

    head gui.StringArray; 

    BEGIN
        gui.APRIPAGINA(titolo => 'inserimentoRicarica');
        gui.AGGIUNGIFORM (url => 'l_bindi.operazioniClienti.inserimentoRicarica');  

            gui.AGGIUNGIRIGAFORM;   
                gui.aggiungiIntestazione(testo => 'Inserimento Ricarica', dimensione => 'h2');
                gui.AGGIUNGIGRUPPOINPUT; 
                    gui.AGGIUNGIINPUT(tipo => 'hidden', nome => 'r_IdSessioneCliente', value => r_IdSessioneCliente);
                    gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-money-bill', nome => 'r_Importo', placeholder => 'Importo');   
                gui.CHIUDIGRUPPOINPUT;
            gui.CHIUDIRIGAFORM; 

            gui.AGGIUNGIRIGAFORM;
                gui.AGGIUNGIGRUPPOINPUT; 
                    gui.AGGIUNGIBOTTONESUBMIT (value => 'Inserisci'); 
                gui.CHIUDIGRUPPOINPUT; 
            gui.CHIUDIRIGAFORM; 
        gui.CHIUDIFORM;

        IF r_importo>0 
        THEN 
            /* Inserimento nuova ricarica */
            INSERT INTO RICARICHE VALUES(seq_IDricarica.NEXTVAL, sessionhandler.getiduser(r_IdSessioneCliente), SYSDATE, TO_NUMBER(r_Importo));
            /* Aggiornamento del Saldo */
            UPDATE CLIENTI SET Saldo = (SELECT c.Saldo FROM CLIENTI c WHERE c.IDCLIENTE = sessionhandler.getiduser(r_IdSessioneCliente)) + r_Importo 
            WHERE IDcliente = sessionhandler.getiduser(r_IdSessioneCliente);
            /* Pop Up all'utente */
            gui.AggiungiPopup(True, 'Ricarica inserita con successo!');
            /* Reindiriziamo alla pagina visualizzaRicaricheCliente */
            gui.REINDIRIZZA('l_bindi.operazioniClienti.visualizzaRicaricheCliente?r_IdSessioneCliente='||r_IdSessioneCliente);
        /*ELSE*/
        END IF; 
    end inserimentoRicarica;


  procedure visualizzaClienti(
    c_Nome VARCHAR2 default NULL,
    c_Cognome VARCHAR2 default NULL,
    c_DataNascita VARCHAR2 default NULL,
    c_Sesso VARCHAR2 default NULL,
    row_Nome VARCHAR2 default NULL, 
    row_Cognome VARCHAR2 default NULL,
    row_DataNascita VARCHAR2 default NULL,
    row_Sesso VARCHAR2 default NULL,
    row_Telefono VARCHAR2 default NULL,
    row_Email VARCHAR2 default NULL,
    Elimina VARCHAR2 default NULL
  ) IS

   head gui.StringArray; 

   BEGIN

    IF Elimina IS NOT NULL AND row_Email IS NOT NULL THEN
       DELETE FROM CLIENTI c WHERE c.Email = row_Email;  
    END IF;

   head := gui.StringArray ('Nome', 'Cognome', 'DataNascita', 'Sesso', 'Telefono', 'Email','',''); 
   gui.apriPagina ('visualizza clienti');  

   gui.APRIFORMFILTRO; 
        gui.aggiungicampoformfiltro(nome => 'c_Nome', placeholder => 'Nome');
		gui.aggiungicampoformfiltro( nome => 'c_Cognome', placeholder => 'Cognome');
		gui.aggiungicampoformfiltro(tipo => 'date', nome => 'c_DataNascita', placeholder => 'Birth');
        /*gui.aggiungicampoformfiltro(nome => 'c_Sesso', placeholder => 'Birth');*/
		gui.aggiungicampoformfiltro('submit', '', 'Filtra', 'filtra');
    gui.CHIUDIFORMFILTRO; 
    gui.aCapo; 

    gui.APRITABELLA (elementi => head);
   for clienti IN
   (SELECT Nome, Cognome, DataNascita, Sesso, Ntelefono, Email FROM Clienti 
        where ( Clienti.Nome = c_Nome or c_Nome is null )
		and ( ( trunc( Clienti.DATANASCITA) = to_date(c_DataNascita,'YYYY-MM-DD') ) or c_DataNascita is null )
		and ( Clienti.Cognome = c_Cognome or c_Cognome is null)
        and ( Clienti.SESSO = c_Sesso or c_Sesso is null)
    ) 
   LOOP
    gui.AGGIUNGIRIGATABELLA; 
            gui.aggiungiformhiddenrigatabella; 
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.nome);
            gui.AGGIUNGIINPUT (tipo => 'hidden', nome => 'row_Nome', value => clienti.Nome);

            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Cognome);
            gui.AGGIUNGIINPUT (tipo => 'hidden', nome => 'row_Cognome', value => clienti.Cognome);

            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.DataNascita);
            gui.AGGIUNGIINPUT (tipo => 'hidden', nome => 'row_DataNascita', value => clienti.DataNascita);

            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Sesso);
            gui.AGGIUNGIINPUT (tipo => 'hidden', nome => 'row_Sesso', value => clienti.Sesso);

            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Ntelefono);
            gui.AGGIUNGIINPUT (tipo => 'hidden', nome => 'row_Telefono', value => clienti.Ntelefono);

            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Email);
            gui.AGGIUNGIINPUT (tipo => 'hidden', nome => 'row_Email', value => clienti.Email);

            gui.AggiungiPulsanteCancellazione;  
            gui.CHIUDIFORMHIDDENRIGATABELLA;
     
            gui.aggiungiPulsanteModifica (collegamento1 => 'g_giannessi.operazioniClienti.modificaCliente?c_Email='||clienti.Email||'&c_Password='/*||clienti.PASSWORD*/||'&c_Telefono='||clienti.NTelefono||''); --tolto dal form
    gui.ChiudiRigaTabella;

    end LOOP;
    gui.CHIUDITABELLA; 

END visualizzaClienti; 

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
   gui.AggiungiCampoFormFiltro(tipo =>'submit', value => 'Filtra'); 
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


/* DA RIVEDERE CON L'ALTRO GRUPPO */
procedure inserimentoContabile (
    r_IdSessioneManager varchar2 default null,
    r_FkDipendente varchar2 default null
) 
IS
BEGIN

    INSERT INTO RESPONSABILI VALUES (TO_NUMBER(r_FkDipendente),1);


END inserimentoContabile;


end operazioniClienti;


