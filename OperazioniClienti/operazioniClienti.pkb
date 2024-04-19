SET DEFINE OFF; 

create or replace PACKAGE BODY operazioniClienti as

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

    --if NOT (SESSIONHANDLER.checkRuolo (idSess, 'Manager')) then
    --    gui.APRIPAGINA(titolo => 'Inserimento Convenzione');
    --    gui.aggiungiPopup (False, 'Non hai i permessi per accedere a questa pagina'); 
    --return;  
    --end if; 

    gui.APRIPAGINA(titolo => 'Inserimento Convenzione');
    gui.AGGIUNGIFORM (url => u_root || '.inseriscidatiConvenzione');  
    -- Inserimento dei campi del modulo
    gui.AGGIUNGIGRUPPOINPUT;
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

    EXCEPTION 
    WHEN OTHERS THEN
    gui.AGGIUNGIPOPUP (False, 'Errore sulla modifica dei campi!'); 
END modificaCliente;

-- non si può fare
procedure eliminaCliente(
    c_id VARCHAR2 DEFAULT NULL
) is
BEGIN
    gui.apriPagina ('PaginaEliminaCliente'); 


    DELETE FROM CLIENTI WHERE IDCLIENTE = to_number(c_id); 
    gui.aggiungiPopup (True, 'Ciaooooo'); 

    EXCEPTION
    WHEN OTHERS THEN 
        gui.aggiungiPopup (False, 'Rimozione del cliente non andata a buon fine!');    
    END eliminaCliente; 

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
                                gui.aggiungiIntestazione (testo => c_Saldo, dimensione => 'h2');
                            gui.chiudiDiv; 
                            end if; 

                            gui.apriDiv (classe => 'left');
                                gui.aggiungiIntestazione (testo => 'Convenzione associata', dimensione => 'h2');
                            gui.chiudiDiv;
                            gui.apriDiv (classe => 'right');
                                gui.aggiungiIntestazione (testo => ' ', dimensione => 'h2');
                            gui.chiudiDiv;

                             gui.chiudiGruppoInput; 

                            if (SESSIONHANDLER.checkRuolo(idSess, 'Cliente')) then
                                gui.aggiungiGruppoInput;               
                                    gui.bottoneAggiungi (url => u_root || '.ModificaCliente?idSess='||idSess||'&cl_id='||SESSIONHANDLER.getIDUser(idSess)||'', testo => 'Modifica');                  
                             gui.chiudiGruppoInput; 

                            gui.aCapo(2);

                              gui.aggiungiGruppoInput;               
                                    gui.bottoneAggiungi (url => '#' /*procedura di Antonino*/, testo => 'Associa convenzione');                  
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
        --gui.ChiudiPagina;

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
     htp.prn('<script>   const newUrl = "'||costanti.user_root||'visualizzaBustePaga?r_IdSessione='||r_IdSessione||'";
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
                gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Importo);
                gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Bonus);
                gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.FK_CONTABILE);

                gui.apriElementoPulsanti; 
                gui.AGGIUNGIPULSANTEMODIFICA(collegamento => costanti.user_root||'modificaBustaPaga?r_IdSessione='||r_IdSessione||'&r_FkDipendente='||busta_paga.FK_DIPENDENTE||'&r_FkContabile='||busta_paga.FK_CONTABILE|| '&r_Data='||busta_paga.Data||'&r_Importo='||busta_paga.Importo||'&r_Bonus='||busta_paga.Bonus);
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
    IF(count_b=1) THEN
        return true;
    ELSE
        return false;
    END IF;
END existBustaPaga;

procedure modificaBustaPaga (
    r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
    r_FkDipendente in BUSTEPAGA.FK_CONTABILE%TYPE default null,
    r_Data in BUSTEPAGA.DATA%TYPE default null,
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
    htp.prn('<script>   const newUrl = "'||costanti.user_root||'modificaBustaPaga?r_IdSessione='||r_IdSessione||'&r_FkDipendente='||r_FkDipendente||'&r_Data='||r_Data||'";
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
                gui.AGGIUNGIPOPUP(False, 'Errore: due buste paga nello stesso mese. Modifica non effettuata!');
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
        ELSE
            gui.AGGIUNGIPOPUP(False, 'Non entra nell if');
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
            gui.REINDIRIZZA(costanti.user_root||'visualizzaBustePaga?r_IdSessione='||r_IdSessione||'&r_popUp=True');
        END IF;

        IF (new_Importo < 0) THEN
            gui.REINDIRIZZA(costanti.user_root||'modificaBustaPaga?r_IdSessione='||r_IdSessione||'&r_FkDipendente='||r_FkDipendente||'&r_Data='||r_Data||'&r_PopUp=True');
        END IF;

    ELSE
        gui.AGGIUNGIPOPUP(False,'Non hai permessi necessari per accedere a questa pagina!');
    END IF;

    gui.CHIUDIPAGINA();

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK  TO sp1;
        gui.REINDIRIZZA(costanti.user_root||'modificaBustaPaga?r_IdSessione='||r_IdSessione||'&r_FkDipendente='||r_FkDipendente||'&r_Data='||r_Data||'&r_popUp=noDataFound');
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK  TO sp1;
        gui.REINDIRIZZA(costanti.user_root||'modificaBustaPaga?r_IdSessione='||r_IdSessione||'&r_FkDipendente='||r_FkDipendente||'&r_Data='||r_Data||'&r_popUp=dubBusta');


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
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Importo);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => busta_paga.Bonus);

        gui.ChiudiRigaTabella;
        end LOOP;

        gui.ChiudiTabella;
ELSE
    gui.AGGIUNGIPOPUP(False, 'Non hai i permessi necessari per accedere alla pagina');
END IF;

gui.CHIUDIPAGINA();

END visualizzaBustePagaDipendente;


function existDipendente(r_IdDipendente in DIPENDENTI.MATRICOLA%TYPE default null) return boolean IS
    count_d NUMBER;
BEGIN
    SELECT COUNT(*) INTO count_d FROM DIPENDENTI d WHERE d.Matricola = r_IdDipendente;
    IF(count_d=1) THEN
        return true;
    ELSE
        return false;
    END IF;
END existDipendente;

/*
    function checkContabile(r_IdContabile in varchar2 default null) return boolean IS
        count_c NUMBER;
    BEGIN
        SELECT COUNT(*) INTO count_c FROM RESPONSABILI r WHERE r.FK_DIPENDENTE = r_IdContabile AND r.RUOLO=0;
        IF(count_c=1) THEN
            return true;
        ELSE
            return false;
        END IF;
    END checkContabile;
*/
procedure inserimentoBustaPaga(
    r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
    r_FkDipendente in BUSTEPAGA.FK_DIPENDENTE%TYPE default null,
    r_Data       in varchar2 default null,
    r_Importo    in BUSTEPAGA.IMPORTO%TYPE default null,
    r_PopUp     in varchar2 default null
) IS

bonus_percent NUMBER := 0;

head gui.StringArray;

BEGIN

    --QUESTO SERVE PER QUANDO SI REFRESHA LA PAGINA, IN MODO DA NON FAR RESTARE I POP UP
    htp.prn('<script>   const newUrl = "'||costanti.user_root||'inserimentoBustaPaga?r_IdSessione='||r_IdSessione||'";
                    history.replaceState(null, null, newUrl);
    </script>');

    SAVEPOINT sp2;

    /* Controllo i permessi di accesso */
    IF(sessionhandler.getRuolo(r_IdSessione) = 'Contabile') THEN

        gui.APRIPAGINA(titolo => 'inserimentoBustaPaga', idSessione => r_IdSessione);

        IF (r_PopUp = 'NoDataFound') THEN
            gui.AGGIUNGIPOPUP(False, 'Errore: Non esiste un dipendente con la matricola inserita. Inserimento busta paga non effettuato.');
        END IF;

        /*  DA RIVEDERE
        IF (r_PopUp = 'TooManyRows') THEN
            gui.AGGIUNGIPOPUP(False, 'Errore: Esistono più di un dipendente con la matricola inserita. Inserimento busta paga non effettuato.');
        END IF; */

        IF (r_PopUp = 'True') THEN
            gui.AggiungiPopup(True, 'Busta paga inserita con successo!');
        END IF;

        gui.AGGIUNGIFORM (url => u_root||'inserimentoBustaPaga');

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

        IF (r_FkDipendente IS NOT NULL /* AND r_Importo > 0 */) THEN

            IF(existDipendente(r_FkDipendente)) THEN
                SELECT d.Bonus INTO bonus_percent FROM DIPENDENTI d WHERE d.Matricola = sessionhandler.getiduser(r_IdSessione);
                INSERT INTO BUSTEPAGA (FK_Dipendente, FK_Contabile, Data, Importo, Bonus) VALUES
                (r_FkDipendente, sessionhandler.getiduser(r_IdSessione), TO_DATE(r_Data,'yyyy-mm-dd'), r_Importo, ((r_Importo*bonus_percent)/100));
                --Commit
                COMMIT;
                gui.REINDIRIZZA(u_root||'inserimentoBustaPaga?r_IdSessione='||r_IdSessione||'&r_popUp=True');
            ELSE
                ROLLBACK TO sp2;
                RAISE NO_DATA_FOUND;
            END IF;
        END IF;
    ELSE
        gui.AGGIUNGIPOPUP(False, 'Non hai i permessi necessari per accedere alla pagina!');
    END IF;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK TO sp2;
        gui.REINDIRIZZA(u_root||'inserimentoBustaPaga?r_IdSessione='||r_IdSessione||'&r_popUp=NoDataFound');

    WHEN TOO_MANY_ROWS THEN
        ROLLBACK TO sp2;
        gui.REINDIRIZZA(u_root||'inserimentoBustaPaga?r_IdSessione='||r_IdSessione||'&r_popUp=TooManyRows');

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
    htp.prn('<script>   const newUrl = "'||costanti.user_root||'visualizzaRicaricheCliente?r_IdSessione='||r_IdSessione||'";
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
            gui.AGGIUNGIELEMENTOTABELLA(elemento => ricarica.Importo);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => ricarica.Data);

        gui.ChiudiRigaTabella;
        end LOOP;

        gui.ChiudiTabella;
        gui.BOTTONEAGGIUNGI(testo=>'Inserisci Ricarica', classe=>'bottone2', url=> costanti.user_root||'inserimentoRicarica?r_IdSessione='||r_IdSessione);
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
SessioneInesistente EXCEPTION;

BEGIN

    --QUESTO SERVE PER QUANDO SI REFRESHA LA PAGINA, IN MODO DA NON FAR RESTARE I POP UP
    htp.prn('<script>   const newUrl = "'||costanti.user_root||'inserimentoRicarica?r_IdSessione='||r_IdSessione||'";
                    history.replaceState(null, null, newUrl);
    </script>');

    gui.APRIPAGINA(titolo => 'inserimentoRicarica', idSessione=>r_IdSessione);

    IF(r_PopUp IS NOT NULL AND r_PopUp = 'False') THEN
            gui.AGGIUNGIPOPUP(False, 'Ricarica non inserita!');
    END IF;

    IF(r_PopUp = 'ImportoNegativo') THEN
        gui.AGGIUNGIPOPUP(False, 'Errore: Importo inserito negativo. Ricarica non inserita.');
    END IF;

    IF(r_PopUp = 'SessioneInesistente') THEN
        gui.AGGIUNGIPOPUP(False, 'Errore: Non esiste una sessione per l utente per cui si sta inserendo la ricarica. Ricarica non inserita.');
    END IF;

    SAVEPOINT sp3;

    /* Controllo i permessi di accesso */
    IF(sessionhandler.getruolo(r_IdSessione) = 'Cliente' ) THEN
        gui.AGGIUNGIFORM (url => costanti.user_root||'inserimentoRicarica');

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
            IF (r_importo>0) THEN
                /* Inserimento nuova ricarica */
                IF (sessionhandler.getiduser(r_IdSessione) = null) THEN
                    RAISE SessioneInesistente;
                END IF;
                 INSERT INTO RICARICHE VALUES(seq_IDricarica.NEXTVAL, sessionhandler.getiduser(r_IdSessione), SYSDATE, r_Importo);
                /* Aggiornamento del Saldo */
                UPDATE CLIENTI SET Saldo = (SELECT c.Saldo FROM CLIENTI c WHERE c.IDCLIENTE = sessionhandler.getiduser(r_IdSessione)) + r_Importo
                WHERE IDcliente = sessionhandler.getiduser(r_IdSessione);
                /* Reindiriziamo alla pagina visualizzaRicaricheCliente */
                COMMIT;
                gui.REINDIRIZZA(costanti.user_root||'visualizzaRicaricheCliente?r_IdSessione='||r_IdSessione||'&r_PopUp=True');
            ELSE
                RAISE ImportoNegativo;
            END IF;
        END IF;
    ELSE
        gui.AggiungiPopup(False, 'Non hai il permesso per accedere a questa pagina!');
    END IF;

    EXCEPTION
    WHEN ImportoNegativo THEN 
    ROLLBACK TO sp3;
    gui.REINDIRIZZA(costanti.user_root||'inserimentoRicarica?r_IdSessione='||r_IdSessione||'&r_PopUp=ImportoNegativo');

    WHEN SessioneInesistente THEN 
    ROLLBACK TO sp3;
    gui.REINDIRIZZA(costanti.user_root||'inserimentoRicarica?r_IdSessione='||r_IdSessione||'&r_PopUp=SessioneInesistente');


end inserimentoRicarica;

    /*procedure dettagliBustePagaDipendente (
        r_IdSessione varchar2 default null,
        r_FkDipendente varchar2 default null,
        r_DataInizio varchar2 default null,
        r_DataFine varchar2 default null
    )
    IS
        head gui.StringArray;
    DECLARE
        stip_medio_bonus number := 0;
        stip_medio number := 0;
        stip_max_bonus number := 0;
        stip_min_bonus number := 0;

    BEGIN

        IF(existDipendente(r_FkDipendente)) THEN
            -- Query che recupera lo stipendio+bonus medio del relativo dipendente.
            SELECT AVG(b.IMPORTO + b.BONUS)
            INTO stip_medio_bonus
            FROM BUSTEPAGA b
            WHERE b.FK_DIPENDENTE = r_FkDipendente
                AND (r_DataInizio IS NULL OR r_DataFine IS NULL OR(b.DATA >= TO_DATE(r_DataInizio) AND b.Data <= TO_DATE(r_DataFine)));
            -- Query che recupera lo stipendio medio del relativo dipendente.
            SELECT AVG(b.IMPORTO)
            INTO stip_medio
            FROM BUSTEPAGA b
            WHERE FK_Dipendente = r_FkDipendente;
            -- Query che recupera lo stipendio+bonus massimo del relativo dipendente.
            SELECT MAX(b.IMPORTO + b.BONUS)
            INTO stip_max_bonus
            FROM BUSTEPAGA b
            WHERE FK_Dipendente = r_FkDipendente;
            -- Query che recupera lo stipendio+bonus minimo del relativo dipendente.
            SELECT MIN(b.IMPORTO + b.BONUS)
            INTO stip_min_bonus
            FROM BUSTEPAGA b
            WHERE FK_Dipendente = r_FkDipendente;
        ELSE
            gui.AGGIUNGIPOPUP(False, 'Dipendente inesistente!');
        END IF;



    END dettagliBustePagaDIpendente;*/


  procedure visualizzaClienti(
    idSess VARCHAR default NULL, 
    c_Nome VARCHAR2 default NULL,
    c_Cognome VARCHAR2 default NULL,
    c_DataNascita VARCHAR2 default NULL,
    Sesso VARCHAR2 default NULL
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
        gui.aggiungicampoformfiltro(nome => 'c_Nome', placeholder => 'Nome');
		gui.aggiungicampoformfiltro( nome => 'c_Cognome', placeholder => 'Cognome');
		gui.aggiungicampoformfiltro(tipo => 'date', nome => 'c_DataNascita', placeholder => 'Birth');
        gui.apriSelectFormFiltro ('Sesso', 'Sesso'); 
        gui.aggiungiOpzioneSelect ('', true, '');
        gui.aggiungiOpzioneSelect ('M', true, 'Maschio');
        gui.aggiungiOpzioneSelect ('F', true , 'Femmina');
        gui.chiudiSelectFormFiltro; 
		gui.aggiungicampoformfiltro(tipo => 'submit', value => 'Filtra', placeholder => 'filtra');
    gui.CHIUDIFORMFILTRO; 
    gui.aCapo(2); 

    gui.APRITABELLA (elementi => head);
   
   for clienti IN
   (SELECT IDCLIENTE, Nome, Cognome, DataNascita, Sesso, Ntelefono, Email, Password FROM CLIENTI
        where ( CLIENTI.NOME = c_Nome or c_Nome is null )
		and ( ( trunc( CLIENTI.DATANASCITA) = to_date(c_DataNascita,'YYYY-MM-DD') OR trunc( CLIENTI.DATANASCITA) < to_date(c_DataNascita,'YYYY-MM-DD')) or c_DataNascita is null )
		and ( CLIENTI.COGNOME = c_Cognome or c_Cognome is null )
        and ( CLIENTI.SESSO = Sesso or Sesso is null )
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
            gui.AggiungiPulsanteCancellazione (collegamento => ''''|| u_root || '.eliminaCliente?email='||clienti.Email||''''); 
            gui.aggiungiPulsanteModifica (collegamento => u_root || '.modificaCliente?idSess='||idSess||'&cl_id='||clientI.IDCLIENTE||'&cl_Email='||clienti.Email||'&cl_Password='||clienti.PASSWORD||'&cl_Telefono='||clienti.NTelefono||'');
            gui.aggiungiPulsanteGenerale (collegamento => ''''|| u_root || '.visualizzaProfilo?idSess='||idSess||'&id='||clienti.IDCLIENTE||'''', testo => 'Profilo');      

            gui.chiudiElementoPulsanti;
    gui.ChiudiRigaTabella;
    end LOOP;
   
     gui.CHIUDITABELLA; 
    gui.ChiudiPagina;
        

END visualizzaClienti; 

procedure visualizzazioneConvenzioni (DataInizio VARCHAR2 DEFAULT NULL,
    DataFine VARCHAR2 DEFAULT NULL,
    Ente VARCHAR2 DEFAULT NULL
    /*cumulabile*/) is 

    head gui.StringArray; 

BEGIN

   head := gui.StringArray ('IDConvenzione', 'Nome', 'Ente', 'Sconto', 'CodiceAccesso', 'DataInizio', 'DataFine', 'Cumulabile'); 
   gui.apriPagina (titolo => 'visualizza Convenzioni');
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

