SET DEFINE OFF; 

create or replace PACKAGE BODY Gruppo3 as

--registrazioneCliente : procedura che instanzia la pagina HTML adibita al ruolo di far registrare il cliente al sito
    procedure registrazioneCliente IS
    BEGIN   
    gui.APRIPAGINA(titolo => 'Registrazione');
    gui.AGGIUNGIFORM (url => u_root || '.inserisciDati');  

          
            gui.aggiungiIntestazione(testo => 'Registrazione');
            gui.acapo;
            gui.AGGIUNGIGRUPPOINPUT;
                gui.aggiungiIntestazione(testo => 'Informazioni personali', dimensione => 'h2');
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-user', nome => 'Nome', placeholder => 'Nome');        
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-user', nome => 'Cognome', placeholder => 'Cognome');        
                gui.AGGIUNGICAMPOFORM (tipo => 'email', classeIcona => 'fa fa-envelope', nome => 'Email', placeholder => 'Indirizzo Email');   
                gui.AGGIUNGICAMPOFORM (tipo => 'password', classeIcona => 'fa fa-key', nome => 'Password', placeholder => 'Password'); 
                gui.AGGIUNGICAMPOFORM (tipo => 'tel', classeIcona => 'fa fa-phone', nome => 'Telefono', placeholder => 'Telefono'); 
            gui.CHIUDIGRUPPOINPUT;
          
    
           gui.aggiungiGruppoInput;
            gui.APRIDIV (classe => 'col-half');
                gui.aggiungiIntestazione(testo => 'Data di nascita', dimensione => 'h4');

                    gui.APRIDIV (classe => 'col-third');
                        gui.AGGIUNGIINPUT (placeholder => 'DD', nome => 'Day', classe => ''); 
                    gui.CHIUDIDIV;

                    gui.APRIDIV (classe => 'col-third');
                        gui.AGGIUNGIINPUT (placeholder => 'MM', nome => 'Month', classe => ''); 
                    gui.CHIUDIDIV;

                    gui.APRIDIV (classe => 'col-third');
                        gui.AGGIUNGIINPUT (placeholder => 'YYYY', nome => 'Year', classe => ''); 
                    gui.CHIUDIDIV;
                gui.chiudiDiv;

                    gui.APRIDIV (classe => 'col-half');
                        gui.aggiungiIntestazione(testo => 'Sesso', dimensione => 'h4');

                    gui.AGGIUNGIGRUPPOINPUT; 
                        gui.AGGIUNGIINPUT (nome => 'gender', ident => 'gender-male', tipo => 'radio', value => 'M');
                        gui.AGGIUNGILABEL (target => 'gender-male', testo => 'Maschio');  
                        gui.AGGIUNGIINPUT (nome => 'gender', ident => 'gender-female', tipo => 'radio', value => 'F');
                        gui.AGGIUNGILABEL (target => 'gender-female', testo => 'Femmina'); 
                    gui.CHIUDIGRUPPOINPUT;  
                gui.CHIUDIDIV;

           gui.CHIUDIGRUPPOINPUT;
           
            gui.AGGIUNGIGRUPPOINPUT; 
                    gui.aggiungiBottoneSubmit (value => 'Registra'); 
            gui.CHIUDIGRUPPOINPUT; 
        gui.CHIUDIFORM; 
        GUI.ACAPO(2);
    gui.ChiudiPagina;
        
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
   
    begin
        DataNascita := TO_DATE (Day || '/' || Month || '/' || Year, 'DD/MM/YYYY');
        Sesso := SUBSTR(Gender, 1, 1);  -- cast da varchar2 a char(1)

        INSERT INTO CLIENTI (Nome, Cognome, DataNascita, Sesso, NTelefono, Email, Password, Stato, Saldo) 
        VALUES (Nome, Cognome, DataNascita, Sesso, TO_NUMBER(Telefono),Email,Password,1,0); 

        --se l'inserimento va a buon fine, apro la pagina di login

        gui.HomePage (p_registrazione => true);

    EXCEPTION
    WHEN OTHERS THEN
        --visualizza popup di errore
        gui.ApriPagina ('Errore');
        gui.AggiungiPopup(False, 'Registrazione fallita, cliente già presente sul sito!');
    end inserisciDati;

--form per la insert della convenzione
PROCEDURE inserimentoConvenzione(
    idSess varchar 
) IS
BEGIN

    if NOT (SESSIONHANDLER.checkRuolo (idSess, 'Manager')) then
        gui.APRIPAGINA(titolo => 'Inserimento Convenzione');
        gui.aggiungiPopup (False, 'Non hai i permessi per accedere a questa pagina'); 
    return;  
    end if; 

    gui.APRIPAGINA(titolo => 'Inserimento Convenzione');
    gui.AGGIUNGIFORM (url => u_root || '.inseriscidatiConvenzione');  
    -- Inserimento dei campi del modulo
    gui.aggiungiIntestazione(testo => 'Inserimento Convenzione');
    gui.aCapo();
    gui.AggiungiGruppoInput;
     gui.aggiungiIntestazione (testo => 'Info', dimensione => 'h2');
    gui.AggiungiCampoForm(tipo => 'text', classeIcona => 'fa fa-user', nome => 'r_nome', placeholder => 'Nome');
    gui.AggiungiCampoForm(tipo => 'text', classeIcona => 'fa fa-user', nome => 'r_ente', placeholder => 'Ente');
    gui.AggiungiCampoForm(tipo => 'number', classeIcona => 'fa fa-money-bill', nome => 'r_sconto', placeholder => 'Sconto');
    gui.AggiungiCampoForm(tipo => 'number', classeIcona => 'fa fa-money-bill', nome => 'r_codiceAccesso', placeholder => 'Codice Accesso');
    gui.ChiudiGruppoInput;
    

    gui.AGGIUNGIGRUPPOINPUT;
        gui.aggiungiIntestazione (testo => 'Data inizio', dimensione => 'h2');
        gui.AggiungiCampoForm(tipo => 'date', nome => 'r_dataInizio', placeholder => 'Data Inizio');
        gui.aggiungiIntestazione (testo => 'Data fine', dimensione => 'h2');
        gui.AggiungiCampoForm(tipo => 'date', nome => 'r_dataFine', placeholder => 'Data Fine');
        gui.ApriSelectFormFiltro(nome => 'r_cumulabile', placeholder => 'Cumulabile');
        gui.AggiungiOpzioneSelect(value => '0', selected => false, testo => 'No');
        gui.AggiungiOpzioneSelect(value => '1', selected => false, testo => 'Sì');
        gui.ChiudiSelectFormFiltro;
    gui.chiudiGruppoInput;

    -- Bottone di submit per inviare il modulo
    gui.AGGIUNGIGRUPPOINPUT;
    gui.AggiungiBottoneSubmit(value => 'Inserisci');
    gui.ChiudiGruppoInput;
    

    -- Chiusura del modulo
        gui.ChiudiForm;
        gui.aCapo(2);
    gui.ChiudiPagina;
        

    -- Chiusura della pagina HTML
  --  gui.ChiudiPagina;
END inserimentoConvenzione;

--procedura per la insert convenzione nel form (adesso funziona, bisogna settare le sessioni e i relativi controlli)
procedure inseriscidatiConvenzione (
      --  r_IdSessioneManager varchar2,
        r_nome          varchar2 default null,
        r_ente          varchar2 default null,
        r_sconto        varchar2 default null,
        r_codiceAccesso varchar2 default null,
        r_dataInizio    varchar2 default null,
        r_dataFine      varchar2 default null,
        r_cumulabile    varchar2 default null
) IS
BEGIN

    -- Apre una pagina di registrazione
    gui.ApriPagina('Inserimento Convenzione');

    -- Inserimento dei dati nella tabella CONVENZIONI
    INSERT INTO CONVENZIONI (Nome, Ente, Sconto, CodiceAccesso, DataInizio, DataFine, Cumulabile)
    VALUES (r_nome, r_ente, TO_NUMBER(r_sconto), TO_NUMBER(r_codiceAccesso), TO_DATE(r_dataInizio,'(YYYY/MM/DD)'), TO_DATE(r_dataFine,'YYYY/MM/DD'), r_cumulabile);

    -- Messaggio di conferma dell'inserimento
    gui.AGGIUNGIPOPUP(TRUE,'Convenzione inserita correttamente.');
EXCEPTION
    WHEN OTHERS THEN
        -- Gestione dell'eccezione e stampa dell'errore
        gui.AGGIUNGIPOPUP(FALSE,'Errore durante l''inserimento della convenzione: ');

    END inseriscidatiConvenzione;

    procedure associaConvenzione (
		idSess varchar default null, --CLIENTE
        c_Nome varchar2 default null
	) IS 
        data_fine CONVENZIONI.DATAFINE%TYPE := NULL;
        id_convenzione CONVENZIONI.IDCONVENZIONE%TYPE := NULL;
        c_check CONVENZIONICLIENTI.FK_CLIENTE%TYPE := NULL; --uso questa variabile per il controllo sulla convenzione già associata
    BEGIN
        gui.apriPagina (titolo => 'Associa convenzione', idSessione => idSess); --se l'utente non è loggato torna alla pagina di login

        --controllo che l'utente sia un cliente
        if (NOT SESSIONHANDLER.checkRuolo (idSess, 'Cliente')) then
            gui.aggiungiPopup (FALSE, 'Non hai i permessi per accedere alla pagina!'); 
            return;
        end if; 



        --controllo sulla convenzione
        if c_Nome IS NOT NULL then 
            SELECT IDCONVENZIONE,DATAFINE INTO id_convenzione, data_fine FROM CONVENZIONI WHERE NOME = c_Nome; 
            if SQL%ROWCOUNT > 0 then --convenzione trovata

            --controllo che la convenzione non sia già associata al cliente
            SELECT FK_CLIENTE INTO c_check FROM CONVENZIONICLIENTI WHERE FK_CLIENTE = SESSIONHANDLER.getIDUser(idSess) AND FK_CONVENZIONE = id_convenzione;
             if SQL%ROWCOUNT > 0 then
                gui.aggiungiPopup (False, 'Convenzione già associata');
                gui.aCapo(2);

             else
                --controllo convenzione scaduta
                if data_fine < SYSDATE then
                    gui.aggiungiPopup (False, 'Convenzione scaduta'); 
                    gui.aCapo(2);

                end if;  

                INSERT INTO CONVENZIONICLIENTI (FK_CLIENTE, FK_CONVENZIONE) VALUES (SESSIONHANDLER.GETIDUSER(idSess), id_convenzione);
                gui.aggiungiPopup (True, 'Convenzione associata'); 
                gui.aCapo(2); 
                end if;
             end if;
        end if; 

        gui.aggiungiForm;
            gui.aggiungiInput (tipo => 'hidden', value => idSess, nome => 'idSess');
            gui.aggiungiIntestazione(testo => 'Associa convenzione', dimensione => 'h2');
            gui.aggiungiGruppoInput; 
                gui.bottoneAggiungi (testo => 'Torna indietro', url => u_root || '.visualizzaProfilo?idSess='||idSess||''); 
            gui.chiudiGruppoInput; 
       
            gui.acapo(2);

            gui.aggiungiGruppoInput;
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-check', nome => 'c_nome', placeholder => 'Nome',ident => 'c_nome',  required => true);
            gui.chiudiGruppoInput; 

            gui.acapo();
            gui.aggiungiGruppoInput;
                gui.aggiungiBottoneSubmit (value => 'Associa'); 
            gui.chiudiGruppoInput;
            
        gui.chiudiForm; 

        gui.aCapo(3); 
        gui.chiudiPagina; 

        EXCEPTION
        WHEN OTHERS then
            gui.aggiungiPopup (False, 'Convenzione non trovata');
            gui.chiudiPagina;

        END associaConvenzione; 

	procedure modificaConvenzione (
		idSess varchar default null,
        c_id varchar2, 
        c_sconto varchar2 default null, 
        c_dataInizio varchar2 default null, 
        c_dataFine varchar2 default null,
        c_cumulabile varchar2 default null
	) IS 
    current_sconto CONVENZIONI.SCONTO%TYPE := NULL;
    d_inizio CONVENZIONI.DATAINIZIO%TYPE := NULL; 
    d_fine CONVENZIONI.DATAFINE%TYPE := NULL;
    error_check boolean := false; 
    c int := 0; 
    current_cumulabile int;
      
    BEGIN
        gui.apriPagina (titolo => 'Modifica convenzione', idSessione => idSess); --se l'utente non è loggato torna alla pagina di login

        --controllo che l'utente sia un manager
        if (NOT SESSIONHANDLER.checkRuolo (idSess, 'Manager')) then
            gui.aggiungiPopup (FALSE, 'Non hai i permessi per accedere alla pagina!'); 
            return;
        end if; 

        --controlliamo che la convenzione sia modificabile (per essere modificabile non deve essere stata ancora pubblicata o essere scaduta)
        if c_id IS NOT NULL then 
            SELECT Sconto, DataInizio, DataFine, Cumulabile INTO current_sconto, d_inizio, d_fine, current_cumulabile FROM CONVENZIONI WHERE 
                IDCONVENZIONE = c_id; 
                if (d_fine < SYSDATE OR d_inizio < SYSDATE) then 
                    gui.aggiungiPopup (FALSE, 'Convenzione scaduta o già pubblicata!'); 
                    gui.acapo(2);
                end if; 
        end if; 

        --gestione delle modifiche

        if c_sconto IS NOT NULL AND c_sconto <> current_sconto then 
            IF 0 < c_sconto AND c_sconto < 100 THEN 
            UPDATE CONVENZIONI
                SET SCONTO = c_Sconto
                WHERE IDConvenzione = c_id;
                c := c+1;
                else 
                error_check:=true; 
                end if; 
        end if; 

        if c_dataInizio IS NOT NULL AND C_dataInizio <> d_inizio then 
            if c_dataInizio > SYSDATE+1 then 
            UPDATE CONVENZIONI
            SET DATAINIZIO = c_dataInizio
            WHERE IDConvenzione = c_id;
            c := c+1;
            else
                error_check:=true; 
            end if; 
            
        end if; 

        if c_dataFine IS NOT NULL AND c_dataFine <> d_fine then 
            if  c_DataFine > SYSDATE+1 then 
            UPDATE CONVENZIONI
                SET DATAFINE = c_dataFine
                WHERE IDConvenzione = c_id;
                c := c+1;
            else 
            error_check:=true; 
            end if; 
        end if; 

            IF error_check THEN
                gui.aggiungiPopup (FALSE, 'Modifiche non accettate, controllare i parametri');  
                gui.acapo(2);
            ELSE
                IF c > 1 THEN 
                    gui.aggiungiPopup (TRUE, 'Campi modificati');
                    gui.acapo(2);
                ELSE 
                    IF c = 1 THEN 
                        gui.aggiungiPopup (TRUE, 'Campo modificato');
                        gui.acapo(2);
                    END IF;
                END IF; 
            END IF;


        gui.aCapo(2);
        gui.aggiungiForm;  
        
        gui.aggiungiIntestazione (testo => 'Modifica convenzione'); 
        gui.aCapo(2); 
  
        gui.acapo; 

        gui.aggiungiInput (tipo => 'hidden', nome => 'idSess', value => idSess); 
        gui.aggiungiInput (tipo => 'hidden', nome => 'c_id', value => c_id); 

             gui.aggiungiGruppoInput; 
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-money-bill', nome => 'c_sconto', placeholder => 'Sconto',ident => 'c_sconto',  required => false);
                 gui.AGGIUNGIINTESTAZIONE (testo => 'Data di inizio', dimensione => 'h2');
                gui.AGGIUNGICAMPOFORM (tipo => 'date', classeIcona => 'fa fa-envelope', nome => 'c_dataInizio', placeholder => 'Data di inizio convenzione',ident => 'c_dataInizio',  required => false);
                 gui.AGGIUNGIINTESTAZIONE (testo => 'Data di scadenza', dimensione => 'h2');
                gui.AGGIUNGICAMPOFORM (tipo => 'date', classeIcona => 'fa fa-envelope', nome => 'c_dataFine', placeholder => 'Data di fine convenzione',ident => 'c_dataFine',  required => false);
             gui.chiudiGruppoInput; 

             gui.aggiungiIntestazione(testo => 'Cumulabile', dimensione => 'h2');
					gui.apriDiv(classe => 'row');
						gui.AGGIUNGIGRUPPOINPUT; 
							gui.AGGIUNGIINPUT (nome => 'c_cumulabile', ident => 'si', tipo => 'radio', value => '1');
							gui.AGGIUNGILABEL (target => 'si', testo => 'si');
							gui.AGGIUNGIINPUT (nome => 'c_cumulabile', ident => 'no', tipo => 'radio', value => '0'); 
							gui.AGGIUNGILABEL (target => 'no', testo => 'no');
                            gui.AGGIUNGIINPUT (nome => 'c_cumulabile', ident => 'default', tipo => 'radio', value => current_cumulabile, selected => true); --valore di default non cumulabile (cambiare con valore originale della convenzione)
						gui.CHIUDIGRUPPOINPUT;  
			        gui.chiudiDiv;
    
            gui.aggiungiGruppoInput; 
                gui.aggiungiBottoneSubmit (value => 'Modifica'); 
            gui.chiudiGruppoInput; 

        gui.ChiudiForm;
        gui.aCapo(3); 
        gui.chiudiPagina; 

        END modificaConvenzione; 

--modificaCliente : procedura che instanzia la pagina HTML della modifica dati cliente
    procedure modificaCliente(
    idSess VARCHAR DEFAULT NULL,
    cl_id VARCHAR2 DEFAULT NULL,
    cl_Email VARCHAR2 DEFAULT NULL,
    cl_Password VARCHAR2 DEFAULT NULL,
    cl_Telefono VARCHAR2 DEFAULT NULL
) IS

    current_email CLIENTI.Email%TYPE := NULL;
    current_telefono CLIENTI.Ntelefono%TYPE := NULL;
    current_password CLIENTI.Password%TYPE := NULL;
    popup BOOLEAN := false;
    c INTEGER := 0;

    BEGIN
    gui.APRIPAGINA(titolo => 'Modifica dati cliente', idSessione => idSess); --accedo alla pagina se sono loggato

    --accedo alla pagina (se sono cliente o operatore)
    if NOT (SESSIONHANDLER.checkRuolo(idSess, 'Cliente') OR SESSIONHANDLER.checkRuolo(idSess, 'Manager')) then 
        gui.aggiungiPopup (False, 'Non hai i permessi per accedere a questa pagina'); 
        return;
    end if;

    --un cliente non può accedere alla pagina modifica di un altro cliente
    if  SESSIONHANDLER.checkRuolo(idSess, 'Cliente') AND cl_id IS NOT NULL AND SESSIONHANDLER.getIDUSER(idSess)<>to_number(cl_id) then
        gui.aggiungiPopup (False, 'Non hai i permessi per accedere alla pagina di modifica di altri clienti');
        return;
    end if;

        SELECT Email, Ntelefono, Password
            INTO current_email, current_telefono, current_password
                FROM CLIENTI
                    WHERE IDCLIENTE  = cl_id;

        -- Aggiornamento dell'email
    IF cl_Email IS NOT NULL AND cl_Email <> current_email THEN
        UPDATE CLIENTI
        SET Email = cl_Email
        WHERE IDcliente = cl_id;
        popup := true;
        c := c + 1;

    END IF;

    --aggiornamento password
    IF cl_Password IS NOT NULL AND cl_Password <> current_password THEN
            UPDATE CLIENTI
                SET Password = cl_Password
                    WHERE IDcliente = cl_id;
        popup := true;
        c := c + 1;
    END IF;

        -- Aggiornamento del telefono
    IF cl_Telefono IS NOT NULL AND cl_Telefono <> current_telefono THEN
        UPDATE CLIENTI
        SET Ntelefono = cl_Telefono
        WHERE IDcliente = cl_id;

        popup := true;
        c := c + 1;
    END IF;

    --logica popup di successo
    if popup AND c>1 then
        gui.AGGIUNGIPOPUP (True , 'Campi modificati');
        gui.aCapo;
        else
        if popup AND c=1 then
        gui.AGGIUNGIPOPUP (True , 'Campo modificato');
        gui.aCapo;
        end if;
    end if;

    --ri-aggiorno i valori da visualizzare nella schermata 
    SELECT Email, Ntelefono, Password
    INTO current_email, current_telefono, current_password
    FROM CLIENTI
    WHERE IDcliente = cl_id;


    gui.AGGIUNGIFORM;

    gui.aggiungiInput (tipo => 'hidden', nome => 'idSess', value => idSess);
    gui.aggiungiInput (tipo => 'hidden', nome => 'cl_id', value => cl_id);


    if SESSIONHANDLER.checkRuolo(idSess, 'Cliente') then 
    gui.aggiungiIntestazione(testo => 'Modifica dati di', dimensione => 'h1');
    gui.aggiungiIntestazione(testo => SESSIONHANDLER.getUsername(idSess));
    else if SESSIONHANDLER.checkRuolo(idSess, 'Manager') then 
            gui.aggiungiIntestazione(testo => 'Modifica dati', dimensione => 'h1');
        end if; 
    end if; 

    -- se chi accede alla pagina è un operatore visualizzo il bottone per tornare alla tabella
    if SESSIONHANDLER.checkRuolo(idSess, 'Manager') then 
        gui.bottoneAggiungi (testo => 'Torna indietro', url => u_root || '.visualizzaClienti?idSess='||idSess||''); 
        gui.aCapo(2); 
        else 
        if SESSIONHANDLER.checkRuolo(idSess, 'Cliente') then 
        gui.bottoneAggiungi (testo => 'Torna indietro', url => u_root || '.visualizzaProfilo?idSess='||idSess||''); 
        gui.aCapo(2); 
        end if; 
    end if; 
    

    gui.AGGIUNGIGRUPPOINPUT;      
        gui.AGGIUNGIINTESTAZIONE (testo => 'Email', dimensione => 'h2');
        gui.AGGIUNGIINTESTAZIONE (testo => 'Email corrente: ', dimensione => 'h3');
        gui.AGGIUNGIPARAGRAFO (testo => current_email);     
        gui.AGGIUNGIINTESTAZIONE (testo => 'Nuova email: ', dimensione => 'h3');  
        gui.AGGIUNGICAMPOFORM (tipo => 'email', classeIcona => 'fa fa-envelope', nome => 'cl_Email', placeholder => 'Nuova mail',ident => 'Email',  required => false);
    gui.CHIUDIGRUPPOINPUT; 

    gui.AGGIUNGIGRUPPOINPUT;
        gui.AGGIUNGIINTESTAZIONE (testo => 'Password', dimensione => 'h2');     
        gui.AGGIUNGIINTESTAZIONE (testo => 'Inserisci la nuova password', dimensione => 'h3');  
        gui.AGGIUNGICAMPOFORM (tipo => 'password', classeIcona => 'fa fa-key', nome => 'cl_Password', placeholder => 'Password', ident => 'Password', required => false); 
    gui.CHIUDIGRUPPOINPUT; 

    gui.AGGIUNGIGRUPPOINPUT; 
        gui.AGGIUNGIINTESTAZIONE (testo => 'Telefono', dimensione => 'h2');
        gui.AGGIUNGIINTESTAZIONE (testo => 'Vecchio numero : ', dimensione => 'h3');
        gui.AGGIUNGIPARAGRAFO (testo => current_telefono);     
        gui.AGGIUNGIINTESTAZIONE (testo => 'Nuovo numero : ', dimensione => 'h3'); 
        gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-phone', nome => 'cl_Telefono', placeholder => 'Telefono', ident => 'Telefono', required => false); 
    gui.CHIUDIGRUPPOINPUT;

    gui.AGGIUNGIGRUPPOINPUT;
                gui.aggiungiBottoneSubmit (value => 'Modifica');
    gui.CHIUDIGRUPPOINPUT;

    gui.CHIUDIFORM; 
    gui.aCapo(2); 
    gui.chiudiPagina; 

    EXCEPTION 
    WHEN OTHERS THEN
    gui.AGGIUNGIPOPUP (False, 'Errore sulla modifica dei campi!'); 
END modificaCliente;

    procedure visualizzaProfilo (
        idSess varchar default '-1', 
        id varchar2 default null
    ) is

    c_Nome varchar2(20); 
    c_Cognome varchar2(20); 
    c_DataNascita date;     
    c_Telefono int;
    c_Email varchar2(50);
    c_Sesso char(1);
    c_Password varchar2(20);
    c_saldo int;

    BEGIN
         gui.apriPagina (titolo => 'Profilo', idSessione => idSess); 

        if NOT (SESSIONHANDLER.checkRuolo (idSess, 'Cliente') OR SESSIONHANDLER.checkRuolo (idSess, 'Manager')) then 
            gui.aggiungiPopup (False, 'Non hai i permessi per accedere a questa pagina'); 
            return;
        end if; 

        if (SESSIONHANDLER.checkRuolo (idSess, 'Cliente')) then
            --prelevo i dati di cui ho bisogno tramite dalla sessione
            SELECT Nome, Cognome, DataNascita, NTelefono, Email, Sesso, Password, Saldo INTO c_Nome, c_Cognome, c_DataNascita, 
            c_Telefono, c_Email, c_Sesso, c_Password, c_saldo FROM CLIENTI WHERE IDCLIENTE = SessionHandler.getIDuser (idSess); 
        end if; 

        if (SESSIONHANDLER.checkRuolo (idSess, 'Manager') AND id IS NOT NULL) then
            --prelevo le informazioni relative all'id del cliente passato per parametro al manager
            SELECT Nome, Cognome, DataNascita, NTelefono, Email, Sesso, Password, Saldo INTO c_Nome, c_Cognome, c_DataNascita, 
            c_Telefono, c_Email, c_Sesso, c_Password, c_saldo FROM CLIENTI WHERE IDCLIENTE = id; 
        end if; 
 
            gui.aggiungiForm; 
                --devo aggiungere i dati del cliente tramite sessionHandler 
                
                gui.aggiungiIntestazione (testo => 'Profilo di '); 

                if (SESSIONHANDLER.checkRuolo (idSess, 'Cliente')) then
                gui.aggiungiIntestazione (testo => SessionHandler.GETUSERNAME (idSess)); 
                else 
                    if (SESSIONHANDLER.checkRuolo (idSess, 'Manager')) then 
                     gui.aggiungiIntestazione (testo => c_Nome); --già salvato il nome del cliente in precedenza
                    end if; 
                end if; 
    
                gui.aCapo(4); 

                gui.aggiungiGruppoInput;
                gui.apriDiv (classe => 'flex-container');
                            gui.apriDiv (classe => 'left');
                                gui.aggiungiIntestazione (testo => 'Nome', dimensione => 'h2');
                            gui.chiudiDiv;
                            gui.apriDiv (classe => 'right');
                                gui.aggiungiIntestazione (testo => c_Nome, dimensione => 'h2');
                            gui.chiudiDiv;
                            gui.apriDiv (classe => 'left');
                                gui.aggiungiIntestazione (testo => 'Cognome', dimensione => 'h2');
                            gui.chiudiDiv;
                            gui.apriDiv (classe => 'right');
                                gui.aggiungiIntestazione (testo => c_Cognome, dimensione => 'h2');
                            gui.chiudiDiv;

                            gui.apriDiv (classe => 'left');
                                gui.aggiungiIntestazione (testo => 'Data di nascita', dimensione => 'h2');
                            gui.chiudiDiv;
                            gui.apriDiv (classe => 'right');
                                gui.aggiungiIntestazione (testo => ''||c_DataNascita||'', dimensione => 'h2');
                            gui.chiudiDiv;

                            gui.apriDiv (classe => 'left');
                                gui.aggiungiIntestazione (testo => 'Telefono', dimensione => 'h2');
                            gui.chiudiDiv;
                            gui.apriDiv (classe => 'right');
                                gui.aggiungiIntestazione (testo => ''||c_Telefono||'', dimensione => 'h2');
                            gui.chiudiDiv;

                            gui.apriDiv (classe => 'left');
                                gui.aggiungiIntestazione (testo => 'Email', dimensione => 'h2');
                            gui.chiudiDiv;
                            gui.apriDiv (classe => 'right');
                                gui.aggiungiIntestazione (testo => c_Email, dimensione => 'h2');
                            gui.chiudiDiv;

                            --se chi entra nella pagina è Cliente, si visualizza la password
                            if (SESSIONHANDLER.checkRuolo (idSess, 'Cliente')) then
                                gui.apriDiv (classe => 'left'); 
                                gui.aggiungiIntestazione (testo => 'Password', dimensione => 'h2');
                            gui.chiudiDiv; 
                            gui.apriDiv (classe => 'right');   
                                gui.aggiungiIntestazione (testo => c_Password, dimensione => 'h2');
                            gui.chiudiDiv; 
                            end if; 

                            --il Manager può visualizzare il saldo del cliente
                            if (SESSIONHANDLER.checkRuolo (idSess, 'Manager')) then
                                gui.apriDiv (classe => 'left'); 
                                gui.aggiungiIntestazione (testo => 'Saldo', dimensione => 'h2');
                            gui.chiudiDiv; 
                            gui.apriDiv (classe => 'right');   
                                gui.aggiungiIntestazione (testo => c_Saldo || '€', dimensione => 'h2');
                            gui.chiudiDiv; 
                            end if; 

                            IF (SESSIONHANDLER.CheckRuolo(idSess, 'Cliente')) THEN
                            gui.apriDiv(classe => 'left');
                            gui.aggiungiIntestazione(testo => 'Convenzioni associate', dimensione => 'h2');
                            gui.chiudiDiv;
                            gui.apriDiv(classe => 'right');
                            gui.aggiungiIntestazione(testo => ' ', dimensione => 'h2');
                            gui.chiudiDiv;

                            --visualizziamo le convenzioni associate
                            FOR i IN (
                                SELECT FK_CONVENZIONE FROM CONVENZIONICLIENTI WHERE FK_CLIENTE = SESSIONHANDLER.getIDUser(idSess)
                            ) LOOP
                                --prendiamo il nome e lo stampiamo
                                for j IN (
                                    SELECT NOME FROM CONVENZIONI WHERE IDCONVENZIONE = i.FK_CONVENZIONE
                                ) LOOP
                                    gui.apriDiv(classe => 'left');
                                    gui.aggiungiIntestazione(testo => ' ', dimensione => 'h2');
                                    gui.chiudiDiv;
                                    gui.apriDiv(classe => 'right');
                                    gui.aggiungiIntestazione(testo => j.NOME , dimensione => 'h2');
                                    gui.chiudiDiv;
                                END LOOP;
                            END LOOP;
                        END IF;

                        gui.chiudiDiv; --flex-container
                    gui.chiudiGruppoInput; 

                    gui.aCapo(2);

                            if (SESSIONHANDLER.checkRuolo(idSess, 'Cliente')) then
                                gui.aggiungiGruppoInput;               
                                    gui.bottoneAggiungi (url => u_root || '.ModificaCliente?idSess='||idSess||'&cl_id='||SESSIONHANDLER.getIDUser(idSess)||'', testo => 'Modifica');                  
                             gui.chiudiGruppoInput; 

                            gui.aCapo(2);

                              gui.aggiungiGruppoInput;               
                                    gui.bottoneAggiungi (url => u_root || '.associaConvenzione?idSess='||idSess||'', testo => 'Associa convenzione');                  
                             gui.chiudiGruppoInput; 

                             gui.aCapo(2);

                            end if; 

                            if (SESSIONHANDLER.checkRuolo (idSess, 'Manager')) then 
                             gui.aCapo(2);
                                gui.aggiungiGruppoInput;               
                                        gui.bottoneAggiungi (url => u_root || '.visualizzaClienti?idSess='||idSess||'', testo => 'Torna indietro');                  
                                 gui.chiudiGruppoInput;
                            end if; 
                            
                            
            gui.chiudiForm;
            gui.aCapo(3); 
        gui.ChiudiPagina;

        END visualizzaProfilo;  
 

--visualizzazioneBustePaga : procedura che visualizza tutte le buste paga presenti nel database
procedure visualizzaBustePaga(
    r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
    r_Dipendente in BUSTEPAGA.FK_DIPENDENTE%TYPE default null,
    r_Contabile  in BUSTEPAGA.FK_CONTABILE%TYPE default null,
    r_Data       in varchar2 default null,
    r_Importo    in BUSTEPAGA.IMPORTO%TYPE default null,
    r_Bonus      in BUSTEPAGA.BONUS%TYPE default null,
    r_PopUp      in varchar2 default null
) is

    head gui.StringArray; 

    BEGIN

    --QUESTO SERVE PER QUANDO SI REFRESHA LA PAGINA, IN MODO DA NON FAR RESTARE IL POP UP DELLA MODIFICA AVVENUTA CON SUCCESSO
     htp.prn('<script>   const newUrl = "'||costanti.URL||'visualizzaBustePaga?r_IdSessione='||r_IdSessione||'";
                        history.replaceState(null, null, newUrl);
        </script>');


    head := gui.StringArray ('Dipendente', 'Data', 'Importo', 'Bonus', 'Contabile', ' ');
    gui.apriPagina(titolo => 'VisualizzazioneBustePaga', idSessione=> r_IdSessione);

    /* Controllo che l'utente abbia i permessi necessari */
    IF(sessionhandler.getRuolo(r_IdSessione) = 'Contabile') THEN
        IF (r_popUp = 'True') THEN
            gui.AGGIUNGIPOPUP(True, 'Modifica avvenuta con successo!');
        END IF;

        gui.APRIFORMFILTRO(); 
            gui.aggiungiinput(tipo=> 'hidden', nome => 'r_IdSessione', value=>r_IdSessione);
            gui.aggiungicampoformfiltro(nome => 'r_Dipendente', placeholder => 'Dipendente');
            gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
            gui.aggiungicampoformfiltro(nome => 'r_Importo', placeholder => 'Importo');
            gui.aggiungicampoformfiltro(nome => 'r_Bonus', placeholder => 'Bonus');
            gui.aggiungicampoformfiltro(nome => 'r_Contabile', placeholder => 'Contabile');
            gui.aggiungicampoformfiltro('submit', '','','Filtra');
        gui.CHIUDIFORMFILTRO; 

        gui.aCapo;

        gui.APRITABELLA (elementi => head); 

        for busta_paga IN (
            select *
            from bustepaga b
            where ( b.fk_dipendente = r_Dipendente or r_Dipendente is null )
                and ( b.fk_contabile = r_Contabile or r_Contabile is null )
                and ( trunc(b.DATA) = TO_DATE(r_Data, 'yyyy-mm-dd') or r_Data is null )
                and ( b.importo = r_Importo or r_Importo is null )
                and ( b.bonus = r_Bonus or r_Bonus is null )
            order by data desc
        ) 
        LOOP
            gui.AGGIUNGIRIGATABELLA; 

                gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.FK_DIPENDENTE); 
                gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Data);
                gui.AGGIUNGIELEMENTOTABELLA(elemento => TO_CHAR(busta_paga.IMPORTO, 'FM999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.'' NLS_CURRENCY=''€''')||'€');
                gui.AGGIUNGIELEMENTOTABELLA(elemento => TO_CHAR(busta_paga.BONUS, 'FM999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.'' NLS_CURRENCY=''€''')||'€');
                gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.FK_CONTABILE);

                gui.apriElementoPulsanti; 
                gui.AGGIUNGIPULSANTEMODIFICA(collegamento => costanti.URL||'modificaBustaPaga?r_IdSessione='||r_IdSessione||'&r_FkDipendente='||busta_paga.FK_DIPENDENTE||'&r_FkContabile='||busta_paga.FK_CONTABILE|| '&r_Data='||busta_paga.Data||'&r_Importo='||busta_paga.Importo||'&r_Bonus='||busta_paga.Bonus);
                gui.chiudiElementoPulsanti; 

            gui.CHIUDIRIGATABELLA;
        END LOOP;
            gui.ChiudiTabella;
        ELSE
            gui.AGGIUNGIPOPUP(FALSE, 'Non hai permessi necessari per accedere a questa pagina!');
    END IF;

    gui.CHIUDIPAGINA();

END visualizzaBustePaga;

function existBustaPaga(
    r_FkDipendente in BUSTEPAGA.FK_DIPENDENTE%TYPE,
    r_Data in BUSTEPAGA.DATA%TYPE
) return boolean IS
    count_b NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO count_b FROM BUSTEPAGA b WHERE b.FK_DIPENDENTE = r_FkDipendente AND TRUNC(b.Data) = TRUNC(r_Data);
    IF(count_b=0) THEN
        return TRUE;
    ELSE
        return FALSE;
    END IF;
END existBustaPaga;

procedure modificaBustaPaga (
    r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
    r_FkDipendente in BUSTEPAGA.FK_CONTABILE%TYPE,
    r_Data in BUSTEPAGA.DATA%TYPE,
    r_PopUp in varchar2 default null,
    new_Importo in varchar2 default null,
    new_Data in varchar2 default null
)
IS
-- Se la data della busta paga è maggiore della data odierna
-- Modifica della data possibile soltanto per una data successiva a oggi
bonus_percent number := 0;
old_importo number := 0;
old_contabile number :=0;
head gui.StringArray;

BEGIN

    --QUESTO SERVE PER QUANDO SI REFRESHA LA PAGINA, IN MODO DA NON FAR RESTARE I POP UP
    htp.prn('<script>   const newUrl = '||costanti.URL||'"modificaBustaPaga?r_IdSessione='||r_IdSessione||'&r_FkDipendente='||r_FkDipendente||'&r_Data='||r_Data||'";
                    history.replaceState(null, null, newUrl);
    </script>');

    gui.apriPagina(titolo => 'modificaBustaPaga', idSessione=>r_IdSessione);
    SAVEPOINT sp1;
    /* Controllo che l'utente sia un contabile e che la busta paga possa essere modificata */
    IF(SESSIONHANDLER.GETRUOLO(r_IdSessione) = 'Contabile' AND r_Data > TRUNC(SYSDATE) )THEN

        IF(r_PopUp IS NOT NULL) THEN
            IF(r_PopUp = 'importoNegativo') THEN
                gui.AGGIUNGIPOPUP(False, 'Errore: importo non può essere negativo. Modifica non effettuata!');
            END IF;
            IF(r_PopUp = 'dubBusta') THEN
                gui.AGGIUNGIPOPUP(False, 'Errore: due buste paga nello stesso giorno. Modifica non effettuata!');
            END IF;
            IF(r_PopUp = 'noDataFound') THEN
                gui.AGGIUNGIPOPUP(False, 'Errore: busta paga che si vuole modificare non esiste. Modifica non effettuata!');
            END IF;
        END IF;

        gui.AGGIUNGIINTESTAZIONE(Testo => 'Modifica Busta Paga del dipendente '||r_FkDipendente, Dimensione=>'h1');

        -- Controllo che la busta paga esista
        IF(existBustaPaga (r_FkDipendente,  r_Data)) THEN
            -- Recupero vecchio Importo e vecchio contabile
            SELECT b.FK_CONTABILE, b.IMPORTO INTO old_contabile, old_importo
            FROM BUSTEPAGA b
            WHERE b.FK_DIPENDENTE = r_FkDipendente AND TRUNC(b.Data) = TRUNC(r_Data);
            -- Creo il form
            gui.AGGIUNGIFORM();
                gui.AGGIUNGIINPUT(tipo=>'hidden', nome=>'r_IdSessione', value=>r_IdSessione);
                gui.AGGIUNGIINPUT(tipo=>'hidden', nome=>'r_FkDipendente', value => r_FkDipendente);
                gui.AGGIUNGIINPUT(tipo=>'hidden', nome=>'r_Data', value => r_Data);

                gui.AGGIUNGIGRUPPOINPUT;
                    gui.AGGIUNGIINTESTAZIONE (testo => 'Importo', dimensione => 'h2');
                    gui.ACAPO;
                    gui.AGGIUNGIINTESTAZIONE (testo => 'Vecchio Importo: ', dimensione => 'h3');
                    gui.AGGIUNGIPARAGRAFO (testo => old_importo);
                    gui.ACAPO;
                    gui.AGGIUNGIINTESTAZIONE (testo => 'Nuovo Importo: ', dimensione => 'h3');
                    gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-money-bill', nome => 'new_Importo', placeholder => 'Inserire nuovo importo...');
                gui.CHIUDIGRUPPOINPUT;
                gui.AGGIUNGIGRUPPOINPUT;
                    gui.AGGIUNGIINTESTAZIONE (testo => 'Data', dimensione => 'h2');
                    gui.ACAPO;
                    gui.AGGIUNGIINTESTAZIONE (testo => 'Vecchia Data: ', dimensione => 'h3');
                    gui.AGGIUNGIPARAGRAFO (testo => r_Data);
                    gui.ACAPO;
                    gui.AGGIUNGIINTESTAZIONE (testo => 'Nuova Data: ', dimensione => 'h3');
                    gui.AGGIUNGIINPUT(tipo=>'date', nome=>'new_Data', minimo=>''||TO_CHAR(SYSDATE,'yyyy-mm-dd')||'', massimo => ''||TO_CHAR(r_Data,'yyyy-mm-dd')||'');
                gui.CHIUDIGRUPPOINPUT;

                gui.AGGIUNGIGRUPPOINPUT;
                    gui.AGGIUNGIBOTTONESUBMIT (value => 'Modifica');
                gui.CHIUDIGRUPPOINPUT;
                gui.AGGIUNGIPARAGRAFO(Testo => 'Ultima modifica effettuata dal contabile: '||old_contabile);
            gui.chiudiform;
        END IF;
        -- Recupero il bonus in percentuale da dipendenti
        SELECT d.BONUS INTO bonus_percent
        FROM DIPENDENTI d
        WHERE d.MATRICOLA = r_FkDipendente;

        IF (new_Importo > 0 AND bonus_percent >= 0) THEN
            -- Aggiornamento del contabile, dell'importo e del bonus (ricalcolato da dipendenti)
            UPDATE BUSTEPAGA
            SET BUSTEPAGA.FK_CONTABILE = SESSIONHANDLER.GETIDUSER(r_IdSessione),
                BUSTEPAGA.DATA = TO_DATE(new_Data, 'yyyy-mm-dd'),
                BUSTEPAGA.Importo = TO_NUMBER(new_Importo),
                BUSTEPAGA.Bonus = (TO_NUMBER(new_Importo)*bonus_percent)/100
            WHERE BUSTEPAGA.Fk_Dipendente = r_FkDipendente AND BUSTEPAGA.Data = r_Data;
            -- Commit
            COMMIT;
            gui.REINDIRIZZA(costanti.URL||'visualizzaBustePaga?r_IdSessione='||r_IdSessione||'&r_popUp=True');
        END IF;

        IF (new_Importo < 0) THEN
            gui.REINDIRIZZA(costanti.URL||'modificaBustaPaga?r_IdSessione='||r_IdSessione||'&r_FkDipendente='||r_FkDipendente||'&r_Data='||r_Data||'&r_PopUp=True');
        END IF;

    ELSE
        gui.AGGIUNGIPOPUP(False,'Non hai permessi necessari per accedere a questa pagina!');
    END IF;

    gui.CHIUDIPAGINA();

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK  TO sp1;
        gui.REINDIRIZZA(costanti.URL||'modificaBustaPaga?r_IdSessione='||r_IdSessione||'&r_FkDipendente='||r_FkDipendente||'&r_Data='||r_Data||'&r_popUp=noDataFound');
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK  TO sp1;
        gui.REINDIRIZZA(costanti.URL||'modificaBustaPaga?r_IdSessione='||r_IdSessione||'&r_FkDipendente='||r_FkDipendente||'&r_Data='||r_Data||'&r_popUp=dubBusta');


END modificaBustaPaga;

procedure visualizzaBustePagaDipendente (
    r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
    r_Data       in varchar2 default null,
    r_Importo    in BUSTEPAGA.IMPORTO%TYPE default null,
    r_Bonus      in BUSTEPAGA.BONUS%TYPE default null
) is

head gui.StringArray;

BEGIN

gui.apriPagina (titolo => 'visualizza buste paga dipendenti', idSessione=>r_IdSessione);

/* Controllo i permessi di accesso */
IF(sessionhandler.getRuolo(r_IdSessione) = 'Autista' OR sessionhandler.getRuolo(r_IdSessione) = 'Operatore' OR sessionhandler.getRuolo(r_IdSessione) = 'Contabile' OR sessionhandler.getRuolo(r_IdSessione) = 'Manager') THEN

    gui.APRIFORMFILTRO();
        gui.AGGIUNGIINPUT(tipo => 'hidden', nome => 'r_idsessione', value => r_idsessione);
        gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
        gui.aggiungicampoformfiltro(nome => 'r_Importo', placeholder => 'Importo');
        gui.aggiungicampoformfiltro(nome => 'r_Bonus', placeholder => 'Bonus');
        gui.aggiungicampoformfiltro('submit', '', '','Filtra');
    gui.CHIUDIFORMFILTRO;

    gui.aCapo;

    head := gui.StringArray('Data', 'Importo', 'Bonus');
    gui.APRITABELLA (elementi => head);

    for busta_paga IN (
        select data, importo, bonus
        from bustepaga b
        where ( b.fk_dipendente = sessionhandler.getiduser(r_IdSessione) )
            and ( trunc(b.data) = TO_DATE(r_Data, 'yyyy-mm-dd') or r_Data is null )
            and ( b.importo = r_Importo or r_Importo is null )
            and ( b.bonus = r_Bonus or r_Bonus is null )
        order by data desc)
    LOOP
        gui.AGGIUNGIRIGATABELLA;

            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Data);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => TO_CHAR(busta_paga.IMPORTO, 'FM999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.'' NLS_CURRENCY=''€''')||'€');
            gui.AGGIUNGIELEMENTOTABELLA(elemento => TO_CHAR(busta_paga.BONUS, 'FM999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.'' NLS_CURRENCY=''€''')||'€');

        gui.ChiudiRigaTabella;
        end LOOP;

        gui.ChiudiTabella;
ELSE
    gui.AGGIUNGIPOPUP(False, 'Non hai i permessi necessari per accedere alla pagina');
END IF;

gui.CHIUDIPAGINA();

END visualizzaBustePagaDipendente;


function existDipendente(r_IdDipendente in DIPENDENTI.MATRICOLA%TYPE) return number IS
    count_d NUMBER;
BEGIN
    SELECT COUNT(*) INTO count_d FROM DIPENDENTI d WHERE d.Matricola = r_IdDipendente;
    IF(count_d=0) THEN
        return 0;
    ELSE IF(count_d = 1) THEN
            return 1;
        ELSE
            return 2;
        END IF;
    END IF;
END existDipendente;

procedure inserimentoBustaPaga(
    r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
    r_FkDipendente in BUSTEPAGA.FK_DIPENDENTE%TYPE default null,
    r_Data       in varchar2 default null,
    r_Importo    in BUSTEPAGA.IMPORTO%TYPE default null,
    r_PopUp     in varchar2 default null
) IS

bonus_percent NUMBER := 0;

head gui.StringArray;

dup_Val_Dipendenti EXCEPTION;

BEGIN

    --QUESTO SERVE PER QUANDO SI REFRESHA LA PAGINA, IN MODO DA NON FAR RESTARE I POP UP
    htp.prn('<script>   const newUrl = "'||costanti.user_root||'inserimentoBustaPaga?r_IdSessione='||r_IdSessione||'";
                    history.replaceState(null, null, newUrl);
    </script>');

    SAVEPOINT sp1;

     --Controllo i permessi di accesso
    IF(sessionhandler.getRuolo(r_IdSessione) = 'Contabile') THEN

        gui.APRIPAGINA(titolo => 'inserimentoBustaPaga', idSessione => r_IdSessione);

        IF(r_PopUp = 'importoNegativo') THEN
            gui.AGGIUNGIPOPUP(False, 'Errore: Non è possibile inserire un importo negativo. Inserimento busta paga non effettuato.');
        END if;
        -- noDataFound Exception
        IF (r_PopUp = 'NoDataFound') THEN
            gui.AGGIUNGIPOPUP(False, 'Errore: Non esiste un dipendente con la matricola inserita. Inserimento busta paga non effettuato.');
        END IF;
        -- tooManyRows Exception
        IF (r_PopUp = 'dupVal') THEN
            gui.AGGIUNGIPOPUP(False, 'Errore: Esistono più buste paga per quel dipendente alla solita data. Inserimento busta paga non effettuato.');
        END IF;

        IF (r_PopUp = 'True') THEN
            gui.AggiungiPopup(True, 'Busta paga inserita con successo!');
        END IF;

        gui.AGGIUNGIFORM (url => costanti.URL||'inserimentoBustaPaga');

            gui.aggiungiIntestazione(testo => 'Inserimento Busta Paga', dimensione => 'h2');
            gui.ACAPO();
            gui.AGGIUNGIGRUPPOINPUT;
                gui.AGGIUNGIINPUT(tipo=>'hidden', nome=>'r_IdSessione', value => r_IdSessione);
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-user', nome => 'r_FkDipendente', placeholder => 'Identificativo Dipendente');
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-money-bill', nome => 'r_Importo', placeholder => 'Importo');
                gui.aggiungiinput(tipo=>'date', nome=>'r_Data');
            gui.CHIUDIGRUPPOINPUT;

            gui.AGGIUNGIGRUPPOINPUT;
                    gui.aggiungiBottoneSubmit (value => 'Inserisci');
            gui.CHIUDIGRUPPOINPUT;

        gui.CHIUDIFORM;
        IF(r_Importo IS NOT NULL) THEN
            IF ( r_Importo > 0 ) THEN
                -- Controllo che esista il dipendente.
                IF(existDipendente(r_FkDipendente) = 1) THEN
                    SELECT d.Bonus INTO bonus_percent FROM DIPENDENTI d WHERE d.Matricola = sessionhandler.getiduser(r_IdSessione);
                    INSERT INTO BUSTEPAGA (FK_Dipendente, FK_Contabile, Data, Importo, Bonus) VALUES
                    (r_FkDipendente, sessionhandler.getiduser(r_IdSessione), TO_DATE(r_Data,'yyyy-mm-dd'), r_Importo, ((r_Importo*bonus_percent)/100));
                    --Commit
                    COMMIT;
                    gui.REINDIRIZZA(u_root||'inserimentoBustaPaga?r_IdSessione='||r_IdSessione||'&r_popUp=True');
                ELSE IF( existDipendente(r_FkDipendente) = 0 ) THEN
                        RAISE NO_DATA_FOUND;
                    ELSE
                        RAISE dup_Val_Dipendenti;
                    END IF;
                END IF;
            ELSE
                gui.REINDIRIZZA(u_root||'inserimentoBustaPaga?r_IdSessione='||r_IdSessione||'&r_popUp=importoNegativo');
            END IF;
        END IF;
    ELSE
        gui.AGGIUNGIPOPUP(False, 'Non hai i permessi necessari per accedere alla pagina!');
    END IF;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK TO sp1;
        gui.REINDIRIZZA(u_root||'inserimentoBustaPaga?r_IdSessione='||r_IdSessione||'&r_popUp=NoDataFound');
    -- C'è già una busta paga per quel dipendente in quel giorno
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK TO sp1;
        gui.REINDIRIZZA(u_root||'inserimentoBustaPaga?r_IdSessione='||r_IdSessione||'&r_popUp=dupVal');
    WHEN OTHERS THEN
        IF(SQLCODE = -1) THEN
            gui.REINDIRIZZA(u_root||'inserimentoBustaPaga?r_IdSessione='||r_IdSessione||'&r_popUp=dupVal');
        END IF;

END inserimentoBustaPaga;

procedure visualizzaRicaricheCliente (
    r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
    r_Data       in varchar2 default null,
    r_Importo    in RICARICHE.IMPORTO%TYPE default null,
    r_PopUp in varchar2 default null
) is

head gui.stringArray;

BEGIN

--QUESTO SERVE PER QUANDO SI REFRESHA LA PAGINA, IN MODO DA NON FAR RESTARE I POP UP
    htp.prn('<script>   const newUrl = "'||costanti.URL||'visualizzaRicaricheCliente?r_IdSessione='||r_IdSessione||'";
                    history.replaceState(null, null, newUrl);
    </script>');

gui.apriPagina (titolo => 'Visualizzazione Ricariche cliente', idSessione=>r_IdSessione);

IF(r_PopUp IS NOT NULL) THEN
    IF(r_PopUp = 'True') THEN
        gui.AGGIUNGIPOPUP(True, 'Ricarica inserita con successo!');
    ELSE
        gui.AGGIUNGIPOPUP(False, 'Ricarica non inserita!');
    END IF;
END IF;


/* Controllo i permessi di accesso */
IF(sessionhandler.getruolo(r_IdSessione) = 'Cliente') THEN

    gui.APRIFORMFILTRO();
        gui.AGGIUNGIINPUT(tipo => 'hidden', nome => 'r_IdSessione', value => r_IdSessione);
        gui.aggiungicampoformfiltro(nome => 'r_Importo', placeholder => 'Importo');
            gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
            gui.aggiungicampoformfiltro('submit', '', '', 'Filtra');
        gui.ACAPO;
    gui.CHIUDIFORMFILTRO;

    head := gui.StringArray('Identificativo','Importo', 'Data');
    gui.APRITABELLA (elementi => head);

    for ricarica IN (
            select idricarica, importo,data
            from ricariche r
            where ( r.fk_cliente = sessionhandler.getiduser(r_IdSessione) )
                and ( trunc(r.data) = TO_DATE(r_Data,'yyyy-mm-dd')  or r_Data is null )
                and ( r.importo = r_Importo or r_Importo is null )
            order by data desc
        )
    LOOP
        gui.AGGIUNGIRIGATABELLA;
            gui.aggiungielementotabella(elemento => ricarica.idricarica);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => TO_CHAR(ricarica.IMPORTO, 'FM999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.'' NLS_CURRENCY=''€''')||'€');
            gui.AGGIUNGIELEMENTOTABELLA(elemento => ricarica.Data);
        gui.ChiudiRigaTabella;
    end LOOP;

        gui.ChiudiTabella;
        gui.BOTTONEAGGIUNGI(testo=>'Inserisci Ricarica', classe=>'bottone2', url=> costanti.URL||'inserimentoRicarica?r_IdSessione='||r_IdSessione);
ELSE
    gui.AggiungiPopup(False, 'Non hai il permesso per accedere a questa pagina');
END IF;
END visualizzaRicaricheCliente;

procedure inserimentoRicarica (
    r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
    r_Importo    in RICARICHE.IMPORTO%TYPE default null,
    r_PopUp in varchar2 default null
)IS

head gui.StringArray;

ImportoNegativo EXCEPTION;

BEGIN
    --QUESTO SERVE PER QUANDO SI REFRESHA LA PAGINA, IN MODO DA NON FAR RESTARE I POP UP
    htp.prn('<script>   const newUrl = "'||costanti.URL||'inserimentoRicarica?r_IdSessione='||r_IdSessione||'";
                    history.replaceState(null, null, newUrl);
    </script>');

    gui.APRIPAGINA(titolo => 'inserimentoRicarica', idSessione=>r_IdSessione);

    IF(r_PopUp IS NOT NULL AND r_PopUp = 'False') THEN
            gui.AGGIUNGIPOPUP(False, 'Ricarica non inserita!');
    END IF;

    IF(r_PopUp = 'ImportoNegativo') THEN
        gui.AGGIUNGIPOPUP(False, 'Errore: Importo inserito non positivo. Ricarica non inserita.');
    END IF;

    SAVEPOINT sp1;

    /* Controllo i permessi di accesso */
    IF(sessionhandler.getruolo(r_IdSessione) = 'Cliente' ) THEN
        gui.AGGIUNGIFORM (url => costanti.URL||'inserimentoRicarica');
            gui.aggiungiIntestazione(testo => 'Inserimento Ricarica', dimensione => 'h2');
            gui.AGGIUNGIGRUPPOINPUT;
                gui.AGGIUNGIINPUT(tipo => 'hidden', nome => 'r_IdSessione', value => r_IdSessione);
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-money-bill', nome => 'r_Importo', placeholder => 'Importo');
            gui.CHIUDIGRUPPOINPUT;

            gui.AGGIUNGIGRUPPOINPUT;
                gui.AGGIUNGIBOTTONESUBMIT (value => 'Inserisci');
            gui.CHIUDIGRUPPOINPUT;

        gui.CHIUDIFORM;

        IF(r_importo IS NOT NULL) THEN
            /* Inserimento nuova ricarica */
            INSERT INTO RICARICHE VALUES(seq_IDricarica.NEXTVAL, sessionhandler.getiduser(r_IdSessione), SYSDATE, r_Importo);
            /* Aggiornamento del Saldo */
            UPDATE CLIENTI SET Saldo = (SELECT c.Saldo FROM CLIENTI c WHERE c.IDCLIENTE = sessionhandler.getiduser(r_IdSessione)) + r_Importo
            WHERE IDcliente = sessionhandler.getiduser(r_IdSessione);
            COMMIT;
            /* Reindiriziamo alla pagina visualizzaRicaricheCliente */
            gui.REINDIRIZZA(costanti.URL||'visualizzaRicaricheCliente?r_IdSessione='||r_IdSessione||'&r_PopUp=True');
        END IF;
    ELSE
        gui.AggiungiPopup(False, 'Non hai il permesso per accedere a questa pagina!');
    END IF;

    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            ROLLBACK TO sp1;
            gui.REINDIRIZZA(costanti.user_root||'inserimentoRicarica?r_IdSessione='||r_IdSessione||'&r_PopUp=ImportoNegativo');
        END IF;
end inserimentoRicarica;

procedure dettagliStipendiPersonale(
    r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
    r_DataInizio in varchar2 default null,
    r_DataFine in varchar2 default null
)
IS
    totStipAutisti number :=0;
    totStipOperatori number :=0;
    totStipContabili number :=0;
    totStipManager number := 0;
    totStipGeneral number := 0;
    minDate varchar2(20);
    maxDate varchar2(20);
    head gui.stringArray;
BEGIN
    IF(sessionhandler.GETRUOLO(r_Idsessione) = 'Manager') THEN
        -- Recupero data minima e massima in buste paga
        SELECT TO_CHAR(MIN(b.DATA), 'dd/mm/yyyy') INTO minDate
        FROM BUSTEPAGA b;
        SELECT TO_CHAR(MAX(b.DATA), 'dd/mm/yyyy') INTO maxDate
        FROM BUSTEPAGA b;
        -- Recupero somma stipendi di tutti
        SELECT SUM(b.IMPORTO + b.BONUS) INTO totStipGeneral
        FROM (DIPENDENTI d JOIN BUSTEPAGA b ON (d.MATRICOLA = b.FK_DIPENDENTE))
        WHERE ( b.data >= TO_DATE(r_DataInizio,'yyyy-mm-dd')  or r_DataInizio is null )
            AND ( b.data <= TO_DATE(r_DataFine,'yyyy-mm-dd')  or r_DataFine is null );
        -- Recupero somma stipendi autisti
        SELECT SUM(b.IMPORTO + b.BONUS) INTO totStipAutisti
        FROM (AUTISTI a JOIN DIPENDENTI d ON (a.FK_DIPENDENTE = d.MATRICOLA) JOIN BUSTEPAGA b ON (d.MATRICOLA = b.FK_DIPENDENTE))
        WHERE ( b.data >= TO_DATE(r_DataInizio,'yyyy-mm-dd')  or r_DataInizio is null )
            AND ( b.data <= TO_DATE(r_DataFine,'yyyy-mm-dd')  or r_DataFine is null );
        -- Recupero somma stipendi operatori
        SELECT SUM(b.IMPORTO + b.BONUS) INTO totStipOperatori
        FROM (OPERATORI o JOIN DIPENDENTI d ON (o.FK_DIPENDENTE = d.MATRICOLA) JOIN BUSTEPAGA b ON (d.MATRICOLA = b.FK_DIPENDENTE))
        WHERE ( b.data >= TO_DATE(r_DataInizio,'yyyy-mm-dd')  or r_DataInizio is null )
            AND ( b.data <= TO_DATE(r_DataFine,'yyyy-mm-dd')  or r_DataFine is null );
        -- Recupero somma stipendi contabili
        SELECT SUM(b.IMPORTO + b.BONUS) INTO totStipContabili
        FROM (RESPONSABILI r JOIN DIPENDENTI d ON (r.FK_DIPENDENTE = d.MATRICOLA) JOIN BUSTEPAGA b ON (d.MATRICOLA = b.FK_DIPENDENTE))
        WHERE r.RUOLO = 1 AND ( b.data >= TO_DATE(r_DataInizio,'yyyy-mm-dd')  or r_DataInizio is null )
            AND ( b.data <= TO_DATE(r_DataFine,'yyyy-mm-dd')  or r_DataFine is null );
        -- Recupero somma stipendi manager
        SELECT SUM(b.IMPORTO + b.BONUS) INTO totStipManager
        FROM (RESPONSABILI r JOIN DIPENDENTI d ON (r.FK_DIPENDENTE = d.MATRICOLA) JOIN BUSTEPAGA b ON (d.MATRICOLA = b.FK_DIPENDENTE))
        WHERE r.RUOLO = 0 AND ( b.data >= TO_DATE(r_DataInizio,'yyyy-mm-dd')  or r_DataInizio is null )
            AND ( b.data <= TO_DATE(r_DataFine,'yyyy-mm-dd')  or r_DataFine is null );

        gui.APRIPAGINA(titolo=> 'dettagliStipendiPersonale', idSessione=>r_IdSessione);
        gui.AGGIUNGIFORM();
            gui.AGGIUNGIINTESTAZIONE (testo => 'Dettagli Stipendi Personale', dimensione => 'h1');
            gui.APRIFORMFILTRO();
                gui.AGGIUNGIINPUT(tipo => 'hidden', nome => 'r_IdSessione', value => r_IdSessione);
                    gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_DataInizio', placeholder => 'Data Inizio');
                    gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_DataFine', placeholder => 'Data Fine');
                    gui.aggiungicampoformfiltro('submit', '', '', 'Filtra');
                gui.ACAPO;
            gui.CHIUDIFORMFILTRO;
            gui.AGGIUNGIGRUPPOINPUT;
                gui.AGGIUNGIINTESTAZIONE (testo => 'Personale completo', dimensione => 'h2');
                gui.AGGIUNGIINTESTAZIONE (testo => 'Totale Stipendi: ', dimensione => 'h3');
                gui.AGGIUNGIPARAGRAFO (testo => TO_CHAR(totStipGeneral, 'FM999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.'' NLS_CURRENCY=''€''')||'€');
                gui.AGGIUNGIINTESTAZIONE (testo => 'Autisti', dimensione => 'h2');
                gui.AGGIUNGIINTESTAZIONE (testo => 'Totale Stipendi: ', dimensione => 'h3');
                gui.AGGIUNGIPARAGRAFO (testo => TO_CHAR(totStipAutisti, 'FM999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.'' NLS_CURRENCY=''€''')||'€');
                IF(r_DataInizio IS NOT NULL AND r_DataFine IS NOT NULL) THEN
                    gui.AGGIUNGIINTESTAZIONE (testo => 'Top 3 autisti più pagati (' ||TO_CHAR(TO_DATE(r_DataInizio, 'yyyy-mm-dd'), 'dd/mm/yyyy')||' - '||TO_CHAR(TO_DATE(r_DataFine, 'yyyy-mm-dd'), 'dd/mm/yyyy')||'): ', dimensione => 'h3');
                ELSE
                    gui.AGGIUNGIINTESTAZIONE (testo => 'Top 3 autisti più pagati (' ||minDate||' - '||maxDate||'): ', dimensione => 'h3');
                END IF;
                head := gui.StringArray('Identificativo','Euro netti percepiti');
                gui.APRITABELLA (elementi => head);
                for autista IN (
                        SELECT *
                        FROM (SELECT d.MATRICOLA, SUM(b.IMPORTO + b.BONUS) AS stipTot
                              FROM (AUTISTI a JOIN DIPENDENTI d ON (a.FK_DIPENDENTE = d.MATRICOLA) JOIN BUSTEPAGA b
                                    ON (d.MATRICOLA = b.FK_DIPENDENTE))
                              WHERE (b.data >= TO_DATE(r_DataInizio, 'yyyy-mm-dd') or r_DataInizio is null)
                                AND (b.data <= TO_DATE(r_DataFine, 'yyyy-mm-dd') or r_DataFine is null)
                              GROUP BY d.MATRICOLA
                              ORDER BY stipTot DESC )
                        WHERE ROWNUM <=3
                    )
                LOOP
                    gui.AGGIUNGIRIGATABELLA;
                        gui.aggiungielementotabella(elemento => autista.MATRICOLA);
                        gui.AGGIUNGIELEMENTOTABELLA(elemento => TO_CHAR(autista.stipTot, 'FM999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.'' NLS_CURRENCY=''€''')||'€');
                    gui.ChiudiRigaTabella;
                end LOOP;
                gui.CHIUDITABELLA();
                gui.ACAPO();
                gui.AGGIUNGIINTESTAZIONE (testo => 'Operatori', dimensione => 'h2');
                gui.AGGIUNGIINTESTAZIONE (testo => 'Totale Stipendi: ', dimensione => 'h3');
                gui.AGGIUNGIPARAGRAFO (testo => TO_CHAR(totStipOperatori, 'FM999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.'' NLS_CURRENCY=''€''')||'€');
                IF(r_DataInizio IS NOT NULL AND r_DataFine IS NOT NULL) THEN
                    gui.AGGIUNGIINTESTAZIONE (testo => 'Top 3 operatori più pagati (' ||TO_CHAR(TO_DATE(r_DataInizio, 'yyyy-mm-dd'), 'dd/mm/yyyy')||' - '||TO_CHAR(TO_DATE(r_DataFine, 'yyyy-mm-dd'), 'dd/mm/yyyy')||'): ', dimensione => 'h3');
                ELSE
                    gui.AGGIUNGIINTESTAZIONE (testo => 'Top 3 operatori più pagati (' ||minDate||' - '||maxDate||'): ', dimensione => 'h3');
                END IF;
                head := gui.StringArray('Identificativo','Euro netti percepiti');
                gui.APRITABELLA (elementi => head);
                for operatore IN (
                        SELECT *
                        FROM (SELECT d.MATRICOLA, SUM(b.IMPORTO + b.BONUS) AS stipTot
                              FROM (Operatori o JOIN DIPENDENTI d ON (o.FK_DIPENDENTE = d.MATRICOLA) JOIN BUSTEPAGA b
                                    ON (d.MATRICOLA = b.FK_DIPENDENTE))
                              WHERE (b.data >= TO_DATE(r_DataInizio, 'yyyy-mm-dd') or r_DataInizio is null)
                                AND (b.data <= TO_DATE(r_DataFine, 'yyyy-mm-dd') or r_DataFine is null)
                              GROUP BY d.MATRICOLA
                              ORDER BY stipTot DESC )
                        WHERE ROWNUM <=3
                    )
                LOOP
                    gui.AGGIUNGIRIGATABELLA;
                        gui.aggiungielementotabella(elemento => operatore.MATRICOLA);
                        gui.AGGIUNGIELEMENTOTABELLA(elemento => TO_CHAR(operatore.stipTot, 'FM999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.'' NLS_CURRENCY=''€''')||'€');
                    gui.ChiudiRigaTabella;
                end LOOP;
                gui.CHIUDITABELLA();
                gui.ACAPO;
                gui.AGGIUNGIINTESTAZIONE (testo => 'Contabili', dimensione => 'h2');
                gui.AGGIUNGIINTESTAZIONE (testo => 'Totale Stipendi: ', dimensione => 'h3');
                gui.AGGIUNGIPARAGRAFO (testo => TO_CHAR(totStipContabili, 'FM999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.'' NLS_CURRENCY=''€''')||'€');
                IF(r_DataInizio IS NOT NULL AND r_DataFine IS NOT NULL) THEN
                    gui.AGGIUNGIINTESTAZIONE (testo => 'Top 3 contabili più pagati (' ||TO_CHAR(TO_DATE(r_DataInizio, 'yyyy-mm-dd'), 'dd/mm/yyyy')||' - '||TO_CHAR(TO_DATE(r_DataFine, 'yyyy-mm-dd'), 'dd/mm/yyyy')||'): ', dimensione => 'h3');
                ELSE
                    gui.AGGIUNGIINTESTAZIONE (testo => 'Top 3 contabili più pagati (' ||minDate||' - '||maxDate||'): ', dimensione => 'h3');
                END IF;
                head := gui.StringArray('Identificativo','Euro netti percepiti');
                gui.APRITABELLA (elementi => head);
                for contabile IN (
                        SELECT *
                        FROM (SELECT d.MATRICOLA, SUM(b.IMPORTO + b.BONUS) AS stipTot
                              FROM (Responsabili r JOIN DIPENDENTI d ON (r.FK_DIPENDENTE = d.MATRICOLA) JOIN BUSTEPAGA b
                                    ON (d.MATRICOLA = b.FK_DIPENDENTE))
                              WHERE r.RUOLO = 1
                                AND (b.data >= TO_DATE(r_DataInizio, 'yyyy-mm-dd') or r_DataInizio is null)
                                AND (b.data <= TO_DATE(r_DataFine, 'yyyy-mm-dd') or r_DataFine is null)
                              GROUP BY d.MATRICOLA
                              ORDER BY stipTot DESC )
                        WHERE ROWNUM <=3
                    )
                LOOP
                    gui.AGGIUNGIRIGATABELLA;
                        gui.aggiungielementotabella(elemento => contabile.MATRICOLA);
                        gui.AGGIUNGIELEMENTOTABELLA(elemento => TO_CHAR(contabile.stipTot, 'FM999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.'' NLS_CURRENCY=''€''')||'€');
                    gui.ChiudiRigaTabella;
                end LOOP;
                gui.CHIUDITABELLA();
                gui.ACAPO;
                gui.AGGIUNGIINTESTAZIONE (testo => 'Manager', dimensione => 'h2');
                gui.AGGIUNGIINTESTAZIONE (testo => 'Totale Stipendi: ', dimensione => 'h3');
                gui.AGGIUNGIPARAGRAFO (testo => TO_CHAR(totStipManager, 'FM999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.'' NLS_CURRENCY=''€''')||'€');
                IF(r_DataInizio IS NOT NULL AND r_DataFine IS NOT NULL) THEN
                    gui.AGGIUNGIINTESTAZIONE (testo => 'Top 3 manager più pagati (' ||TO_CHAR(TO_DATE(r_DataInizio, 'yyyy-mm-dd'), 'dd/mm/yyyy')||' - '||TO_CHAR(TO_DATE(r_DataFine, 'yyyy-mm-dd'), 'dd/mm/yyyy')||'): ', dimensione => 'h3');
                ELSE
                    gui.AGGIUNGIINTESTAZIONE (testo => 'Top 3 manager più pagati (' ||minDate||' - '||maxDate||'): ', dimensione => 'h3');
                END IF;
                head := gui.StringArray('Identificativo','Euro netti percepiti');
                gui.APRITABELLA (elementi => head);
                for manager IN (
                        SELECT *
                        FROM (SELECT d.MATRICOLA, SUM(b.IMPORTO + b.BONUS) AS stipTot
                              FROM (Responsabili r JOIN DIPENDENTI d ON (r.FK_DIPENDENTE = d.MATRICOLA) JOIN BUSTEPAGA b
                                    ON (d.MATRICOLA = b.FK_DIPENDENTE))
                              WHERE r.RUOLO = 0
                                AND (b.data >= TO_DATE(r_DataInizio, 'yyyy-mm-dd') or r_DataInizio is null)
                                AND (b.data <= TO_DATE(r_DataFine, 'yyyy-mm-dd') or r_DataFine is null)
                              GROUP BY d.MATRICOLA
                              ORDER BY stipTot DESC )
                        WHERE ROWNUM <=3
                    )
                LOOP
                    gui.AGGIUNGIRIGATABELLA;
                        gui.aggiungielementotabella(elemento => manager.MATRICOLA);
                        gui.AGGIUNGIELEMENTOTABELLA(elemento => TO_CHAR(manager.stipTot, 'FM999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.'' NLS_CURRENCY=''€''')||'€');
                    gui.ChiudiRigaTabella;
                end LOOP;
                gui.CHIUDITABELLA();
            gui.CHIUDIGRUPPOINPUT;
        gui.CHIUDIFORM();

        gui.CHIUDIPAGINA();
    ELSE
        gui.AGGIUNGIPOPUP(False, 'Errore: non hai i permessi per accedere a questa pagina');
    END IF;

END dettagliStipendiPersonale;


  procedure visualizzaClienti(
    idSess VARCHAR default NULL, 
    c_Nome VARCHAR2 default NULL,
    c_Cognome VARCHAR2 default NULL,
    c_DataNascita VARCHAR2 default NULL,
    c_Sesso VARCHAR2 default NULL
  ) IS

   head gui.StringArray; --parametri per headers della tabella 

   BEGIN

   head := gui.StringArray('Nome', 'Cognome', 'DataNascita', 'Sesso', 'Telefono', 'Email', ' '); 

    if (NOT (SESSIONHANDLER.checkRuolo (idSess, 'Manager'))) then 
        gui.apriPagina (titolo => 'visualizza clienti', idSessione => idSess); 
        gui.aggiungiPopup (False, 'Non hai i permessi per accedere a questa pagina'); 
        return; 
    end if;     

    gui.apriPagina (titolo => 'visualizza clienti', idSessione => idSess);  --se non loggato porta all'homePage

    gui.APRIFORMFILTRO; 
        gui.aggiungiInput (tipo => 'hidden', value => idSess, nome => 'idSess'); 
        gui.aggiungicampoformfiltro(nome => 'c_Nome', placeholder => 'Nome');
		gui.aggiungicampoformfiltro( nome => 'c_Cognome', placeholder => 'Cognome');
		gui.aggiungicampoformfiltro(tipo => 'date', nome => 'c_DataNascita', placeholder => 'Birth');
        gui.apriSelectFormFiltro ('c_Sesso', 'Sesso'); 
        gui.aggiungiOpzioneSelect ('', true, '');
        gui.aggiungiOpzioneSelect ('M', false , 'Maschio');
        gui.aggiungiOpzioneSelect ('F', false , 'Femmina');
        gui.chiudiSelectFormFiltro; 
		gui.aggiungicampoformfiltro(tipo => 'submit', value => 'Filtra', placeholder => 'filtra');
    gui.CHIUDIFORMFILTRO; 
    gui.aCapo(2); 

    gui.APRITABELLA (elementi => head);
   
   for clienti IN
   (SELECT IDCLIENTE, Nome, Cognome, DataNascita, Sesso, Ntelefono, Email, Password FROM CLIENTI
        where ( CLIENTI.NOME = c_Nome or c_Nome is null )
		and ( trunc( CLIENTI.DATANASCITA) = to_date(c_DataNascita,'YYYY-MM-DD') OR c_DataNascita is null)
		and ( CLIENTI.COGNOME = c_Cognome or c_Cognome is null )
        and ( CLIENTI.SESSO = c_Sesso or c_Sesso is null )
    )
   LOOP 
    gui.AGGIUNGIRIGATABELLA;
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.nome);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Cognome);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.DataNascita);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Sesso);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Ntelefono);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Email);

            gui.APRIELEMENTOPULSANTI;  
            gui.aggiungiPulsanteModifica (collegamento => u_root || '.modificaCliente?idSess='||idSess||'&cl_id='||clientI.IDCLIENTE||'&cl_Email='||clienti.Email||'&cl_Password='||clienti.PASSWORD||'&cl_Telefono='||clienti.NTelefono||'');
            gui.aggiungiPulsanteGenerale (collegamento => ''''|| u_root || '.visualizzaProfilo?idSess='||idSess||'&id='||clienti.IDCLIENTE||'''', testo => 'Profilo');      

            gui.chiudiElementoPulsanti;
    gui.ChiudiRigaTabella;
    end LOOP;
   
     gui.CHIUDITABELLA; 
    gui.ChiudiPagina;
        
END visualizzaClienti; 

procedure visualizzaConvenzioni (
    idSess varchar DEFAULT NULL, 
    c_DataInizio VARCHAR2 DEFAULT NULL,
    c_DataFine VARCHAR2 DEFAULT NULL,
    c_Ente VARCHAR2 DEFAULT NULL,
    c_Cumulabile VARCHAR2 DEFAULT NULL) is 

    head gui.StringArray; 

BEGIN

    gui.apriPagina (titolo => 'visualizza Convenzioni', idSessione => idSess, scriptjs => costanti.tablesortscript);

    if (NOT (SESSIONHANDLER.checkRuolo (idSess, 'Cliente') OR SESSIONHANDLER.checkRuolo (idSess, 'Operatore') OR SESSIONHANDLER.checkRuolo (idSess, 'Manager'))) then
        gui.aggiungiPopup (False, 'Non hai i permessi per accedere alla seguente pagina'); 
        return; 
    end if; 

   if SESSIONHANDLER.checkRuolo (idSess, 'Manager') then
        head := gui.StringArray ('Nome', 'Ente', 'Sconto', 'CodiceAccesso', 'DataInizio', 'DataFine', 'Cumulabile',' ');
        else 
        head := gui.StringArray ('Nome', 'Ente', 'Sconto', 'DataInizio', 'DataFine', 'Cumulabile', ' ');
   end if; 
   
   gui.APRIFORMFILTRO; 
   gui.aggiungiInput (tipo => 'hidden', value => idSess, nome => 'idSess'); 
   gui.AGGIUNGICAMPOFORMFILTRO (tipo => 'date', nome => 'c_DataInizio', placeholder => 'Data-inizio');
   gui.AGGIUNGICAMPOFORMFILTRO (tipo => 'date', nome => 'c_DataFine', placeholder => 'Data-fine');
   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'c_Ente', placeholder => 'Ente');
   gui.apriSelectFormFiltro ('c_Cumulabile', 'Cumulabile'); 
        gui.aggiungiOpzioneSelect ('', true, '');
        gui.aggiungiOpzioneSelect ('1', false , 'Si');
        gui.aggiungiOpzioneSelect ('0', false , 'No');
        gui.chiudiSelectFormFiltro; 
   gui.AggiungiCampoFormFiltro(tipo =>'submit', value => 'Filtra', placeholder => 'Filtra');
   gui.CHIUDIFORMFILTRO;
   gui.aCapo(2);

   gui.APRITABELLA (head);

   for convenzioni IN
   (SELECT * FROM CONVENZIONI where 
		 ( trunc(CONVENZIONI.DATAINIZIO) = to_date(c_DataInizio,'YYYY-MM-DD') OR c_DataInizio is null)
        and ( trunc(CONVENZIONI.DATAFINE) = to_date(c_DataFine,'YYYY-MM-DD') OR c_DataFine is null)
		and ( CONVENZIONI.ENTE = c_Ente or c_Ente is null )
        and ( CONVENZIONI.CUMULABILE = to_number(c_Cumulabile) or c_Cumulabile is null )
   )
   LOOP
    gui.AGGIUNGIRIGATABELLA; 

                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.Nome);
                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.Ente);
                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.Sconto);

                if SESSIONHANDLER.checkRuolo (idSess, 'Manager') then 
                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.CodiceAccesso);
                end if; 
                
                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.DataInizio);
                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.DataFine);
                gui.AGGIUNGIELEMENTOTABELLA(elemento => convenzioni.Cumulabile);

                if SESSIONHANDLER.checkRuolo (idSess, 'Manager') then
                gui.apriElementoPulsanti; 
                    gui.aggiungiPulsanteModifica (collegamento => u_root || '.modificaConvenzione?idSess='||idSess||'&c_id='||convenzioni.IDCONVENZIONE||'');
                gui.chiudiElementoPulsanti; 
                end if;

    gui.ChiudiRigaTabella;
    end LOOP; 

    gui.ChiudiTabella; 
    gui.aCapo(2);
    gui.chiudiPagina;

END visualizzaConvenzioni; 

procedure dettagliConvenzioni (
		idSess varchar default null,
        c_nome CONVENZIONI.NOME%TYPE default null
	) IS
    c_check boolean := true; --flag per il controllo dell'esistenza della convenzione
    c_id CONVENZIONI.IDCONVENZIONE%TYPE := NULL;
    num_clienti int := 0;
    totale_clienti int := 0;
    percentage decimal (10,2) := 0;
    BEGIN
        gui.apriPagina (titolo => 'Dettagli convenzioni', idSessione => idSess);

        --controllo manager
        if ( NOT (SESSIONHANDLER.checkRuolo (idSess, 'Manager'))) THEN
            gui.aggiungiPopup (FALSE, 'Non hai i permessi per accedere a questa pagina');
            return;
        END IF;


        if c_nome is not NULL THEN
            SELECT IDCONVENZIONE INTO c_id FROM CONVENZIONI WHERE NOME = c_nome;
            if SQL%ROWCOUNT > 0 THEN --esiste, faccio il calcolo del numero dei clienti e della percentuale

                --prelevo i dati
                SELECT COUNT(IDCLIENTE) INTO totale_clienti FROM CLIENTI;
                if totale_clienti <> 0 then
                    SELECT COUNT(FK_CLIENTE) INTO num_clienti FROM CONVENZIONICLIENTI WHERE FK_CONVENZIONE = c_id;
                    percentage := (num_clienti / totale_clienti) * 100.0;
                end if;

                else
                gui.aggiungiPopup (False, 'Convenzione non esistente');
                gui.aCapo(2);
                c_check:=false;
            end if;
        END IF;

        gui.aggiungiForm;
            gui.aggiungiIntestazione (testo => 'Dettagli statistici');
            gui.aggiungiIntestazione (testo => 'convenzioni');
            gui.aCapo();

            gui.aggiungiIntestazione( testo => 'Immetti il nome di una convenzione', dimensione => 'h2');
            --gui.aCapo();

            --filtro per nome le convenzioni e guardo quanti clienti le utilizzano
            gui.apriFormFiltro;
                gui.aggiungiInput (tipo => 'hidden', nome => 'idSess', value => idSess);
                gui.aggiungiCampoFormFiltro (nome => 'c_nome', placeholder => 'Nome convenzione');
                gui.aggiungiCampoFormFiltro (tipo => 'submit', placeholder => 'filtra');
            gui.chiudiFormFiltro;
            gui.aCapo(2);


            if c_nome IS NOT NULL AND c_check then
            --visualizzo i dati
            gui.aggiungiGruppoInput;
                gui.aggiungiIntestazione( testo => 'Dati su clienti', dimensione => 'h1');

                gui.aCapo(2);
                gui.apridiv (classe => 'flex-container');
                    gui.apridiv (classe => 'left');
                        gui.aggiungiIntestazione( testo => 'Clienti che la usano', dimensione => 'h2');
                    gui.chiudiDiv;
                    gui.apridiv (classe => 'right');
                        gui.aggiungiIntestazione( testo => ''||num_clienti||'', dimensione => 'h2');
                    gui.chiudiDiv;

                    gui.aCapo(2);

                    gui.apridiv (classe => 'left');
                        gui.aggiungiIntestazione( testo => 'In percentuale', dimensione => 'h2');
                    gui.chiudiDiv;
                    gui.apridiv (classe => 'right');
                        gui.aggiungiIntestazione( testo => ''||percentage||'%', dimensione => 'h2');
                    gui.chiudiDiv;

                    --tabella che visualizza le prime tre convenzioni più utilizzate

                    gui.aggiungiIntestazione( testo => 'Top 3 convenzioni più usate', dimensione => 'h2');
                    gui.aCapo;
                    gui.apriTabella (elementi => gui.StringArray('Nome', 'Percentuale', 'Numero clienti'));
                    for convenzione in (
                        SELECT c.IDconvenzione,
                                        c.Nome,
                                        COUNT(ci.FK_Convenzione) AS NumeroClientiUtilizzatori
                                        FROM CONVENZIONI c
                                        JOIN CONVENZIONICLIENTI ci ON c.IDconvenzione = ci.FK_Convenzione
                                        GROUP BY c.IDconvenzione, c.Nome, c.Ente
                                        ORDER BY COUNT(ci.FK_Convenzione) DESC
                                        FETCH FIRST 3 ROWS ONLY

                    ) LOOP
                    gui.AggiungiRigaTabella;

                        gui.aggiungiElementoTabella (elemento => convenzione.Nome);
                        gui.aggiungiElementoTabella (elemento => ''||(convenzione.NumeroClientiUtilizzatori / totale_clienti) * 100.0||'%');
                        gui.aggiungiElementoTabella (elemento => convenzione.NumeroClientiUtilizzatori);

                    gui.chiudiRigaTabella;
                    END LOOP;
                    gui.chiudiTabella;

                gui.chiudiDiv; --flex-container
            gui.chiudiGruppoInput;
            end if;

        gui.chiudiForm;

        gui.aCapo(2);
        gui.chiudiPagina;

        EXCEPTION
            when NO_DATA_FOUND THEN
            gui.aggiungiPopup (False, 'Convenzione non esistente');
        END dettagliConvenzioni;


/* DA RIVEDERE CON L'ALTRO GRUPPO */
procedure inserimentoContabile (
    r_IdSessioneManager varchar2 default null,
    r_FkDipendente varchar2 default null
) 
IS
BEGIN

    INSERT INTO RESPONSABILI VALUES (TO_NUMBER(r_FkDipendente),1);


END inserimentoContabile;


end gruppo3;
