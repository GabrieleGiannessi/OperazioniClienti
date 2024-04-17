SET DEFINE OFF; 

create or replace PACKAGE BODY operazioniClienti as

--registrazioneCliente : procedura che instanzia la pagina HTML adibita al ruolo di far registrare il cliente al sito
    procedure registrazioneCliente IS
    BEGIN   
    gui.APRIPAGINA(titolo => 'Registrazione');
    gui.AGGIUNGIFORM (url => u_root || '.inserisciDati');  

          
            gui.aggiungiIntestazione(testo => 'Registrazione', dimensione => 'h2');
            gui.AGGIUNGIGRUPPOINPUT; 
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-user', nome => 'Nome', placeholder => 'Nome');        
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-user', nome => 'Cognome', placeholder => 'Cognome');        
                gui.AGGIUNGICAMPOFORM (tipo => 'email', classeIcona => 'fa fa-envelope', nome => 'Email', placeholder => 'Indirizzo Email');   
                gui.AGGIUNGICAMPOFORM (tipo => 'password', classeIcona => 'fa fa-key', nome => 'Password', placeholder => 'Password'); 
                gui.AGGIUNGICAMPOFORM (tipo => 'tel', classeIcona => 'fa fa-phone', nome => 'Telefono', placeholder => 'Telefono'); 
            gui.CHIUDIGRUPPOINPUT;
          
    
           
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
           
            gui.AGGIUNGIGRUPPOINPUT; 
                    gui.aggiungiBottoneSubmit (value => 'Registra'); 
            gui.CHIUDIGRUPPOINPUT; 
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
   
    begin
        gui.ApriPagina ('Registrazione');
        DataNascita := TO_DATE (Day || '/' || Month || '/' || Year, 'DD/MM/YYYY'); 
        Sesso := SUBSTR(Gender, 1, 1);  -- cast da varchar2 a char(1)

        INSERT INTO CLIENTI (Nome, Cognome, DataNascita, Sesso, NTelefono, Email, Password, Stato, Saldo) 
        VALUES (Nome, Cognome, DataNascita, Sesso, TO_NUMBER(Telefono),Email,Password,1,0); 

        gui.AggiungiPopup(True, 'Registrazione avvenuta con successo!');


    EXCEPTION
    WHEN OTHERS THEN
        --visualizza popup di errore
        gui.AggiungiPopup(False, 'Registrazione fallita, cliente già presente sul sito!');
    end inserisciDati;

--form per la insert della convenzione
PROCEDURE inserimentoConvenzione IS
BEGIN
    gui.APRIPAGINA(titolo => 'Inserimento Convenzione');
    gui.AGGIUNGIFORM (url => u_root || '.inseriscidatiConvenzione');  
    -- Inserimento dei campi del modulo
    gui.AGGIUNGIGRUPPOINPUT;
    gui.aggiungiIntestazione(testo => 'Inserimento Convenzione', dimensione => 'h2');
    gui.AggiungiGruppoInput;
    gui.AggiungiCampoForm(tipo => 'text', nome => 'r_nome', placeholder => 'Nome');
    gui.AggiungiCampoForm(tipo => 'text', nome => 'r_ente', placeholder => 'Ente');
    gui.AggiungiCampoForm(tipo => 'number', nome => 'r_sconto', placeholder => 'Sconto');
    gui.AggiungiCampoForm(tipo => 'number', nome => 'r_codiceAccesso', placeholder => 'Codice Accesso');
    gui.ChiudiGruppoInput;
    

    gui.AGGIUNGIGRUPPOINPUT;
    gui.AggiungiCampoForm(tipo => 'date', nome => 'r_dataInizio', placeholder => 'Data Inizio');
    gui.AggiungiCampoForm(tipo => 'date', nome => 'r_dataFine', placeholder => 'Data Fine');
    gui.ApriSelectFormFiltro(nome => 'r_cumulabile', placeholder => 'Cumulabile');
    gui.AggiungiOpzioneSelect(value => '0', selected => false, testo => 'No');
    gui.AggiungiOpzioneSelect(value => '1', selected => false, testo => 'Sì');
    gui.ChiudiSelectFormFiltro;
    

    -- Bottone di submit per inviare il modulo
    gui.AGGIUNGIGRUPPOINPUT;
    gui.AggiungiGruppoInput;
    gui.AggiungiBottoneSubmit(value => 'Inserisci');
    gui.ChiudiGruppoInput;
    

    -- Chiusura del modulo
    gui.ChiudiForm;

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
    id VARCHAR2 DEFAULT NULL,
    cl_Email VARCHAR2 DEFAULT NULL,
    cl_Password VARCHAR2 DEFAULT NULL,
    cl_Telefono VARCHAR2 DEFAULT NULL
) IS

    current_email CLIENTI.Email%TYPE := NULL;
    current_telefono CLIENTI.Ntelefono%TYPE := NULL;
    current_password CLIENTI.Password%TYPE := NULL; 

    BEGIN
    
    SELECT Email, Ntelefono, Password
    INTO current_email, current_telefono, current_password
    FROM CLIENTI
    WHERE IDcliente = id;

    gui.APRIPAGINA(titolo => 'Modifica dati cliente');

    IF cl_Email <> current_email THEN
        -- Aggiornamento dell'email
        UPDATE CLIENTI
        SET Email = cl_Email
        WHERE IDcliente = id; --sono certo che esista l'id del cliente in quanto è presente nella tabella di visualizzazione

        gui.AGGIUNGIPOPUP (True , 'Email modificata!');
        gui.aCapo;
    END IF;

    IF cl_Password <> current_password THEN
        -- Aggiornamento della password
        UPDATE CLIENTI
        SET Password = cl_Password
        WHERE IDcliente = id; --sono certo che esista l'id del cliente in quanto è presente nella tabella di visualizzazione

        gui.AGGIUNGIPOPUP (True , 'Password modificata!');
        gui.aCapo;  
    END IF;

    IF cl_Telefono <> current_telefono THEN
        -- Aggiornamento del telefono
        UPDATE CLIENTI
        SET Ntelefono = cl_Telefono
        WHERE IDcliente = id; --sono certo che esista l'id del cliente in quanto è presente nella tabella di visualizzazione

        gui.AGGIUNGIPOPUP (True , 'Numero di telefono modificato!');
        gui.aCapo; 
        
    END IF;

    --ri-aggiorno i valori da visualizzare nella schermata 
    SELECT Email, Ntelefono, Password
    INTO current_email, current_telefono, current_password
    FROM CLIENTI
    WHERE IDcliente = id;

    gui.AGGIUNGIFORM;  
        

    gui.aggiungiInput (tipo => 'hidden', nome => 'id', value => id); 

    gui.aggiungiIntestazione(testo => 'Modifica dati', dimensione => 'h1');

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

procedure eliminaCliente(
    id VARCHAR2 DEFAULT NULL
) is
BEGIN
    DELETE FROM CLIENTI WHERE IDCLIENTE = id; 
    gui.REINDIRIZZA (u_root || '.visualizzaClienti');  
    END eliminaCliente; 

    procedure visualizzaProfilo (
        c_idSessione varchar default '-1', 
        id varchar2 default null 
    ) is
    BEGIN

            gui.apriPagina (titolo => 'Profilo di '||SessionHandler.GETUSERNAME (c_idSessione)||'', idSessione => c_idSessione);  
           --htp.prn (''||SESSIONHANDLER.GETRUOLO(c_idSessione)||'');
           --htp.prn (''||SESSIONHANDLER.GETUSERNAME(c_idSessione)||'');
           --htp.prn (''||SESSIONHANDLER.getIdUser(c_idSessione)||'');

        END visualizzaProfilo;  
 

--visualizzazioneBustePaga : procedura che visualizza tutte le buste paga presenti nel database
/* [IMPORTANTE] appena viene aggiornato il meccanismo delle sessioni:
    aggiungere il controllo che la modifica di una busta paga può essere
    fatta soltanto dal contabile che la inserita.
*/
    procedure visualizzaBustePaga(
        r_IdSessione in varchar2,
        r_Dipendente in varchar2 default null,
        r_Contabile  in varchar2 default null,
        r_Data       in varchar2 default null,
        r_Importo    in varchar2 default null,
        r_Bonus      in varchar2 default null,
        r_PopUp      in varchar2  default null
    ) is

    head gui.StringArray; 

    BEGIN

    --QUESTO SERVE PER QUANDO SI REFRESHA LA PAGINA, IN MODO DA NON FAR RESTARE IL POP UP DELLA MODIFICA AVVENUTA CON SUCCESSO
    htp.prn('<script>   const newUrl = '||costanti.user_root||'"visualizzaBustePaga?r_IdSessione='||r_IdSessione||'"; 
                        history.replaceState(null, null, newUrl); 
    </script>'); 


    head := gui.StringArray ('Dipendente', 'Data', 'Importo', 'Bonus', 'Contabile', ' '); 
    gui.apriPagina(titolo => 'VisualizzazioneBustePaga'); 
    
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
                and ( ( trunc(b.data) = to_date(r_data,'YYYY-MM-DD') ) or r_Data is null )
                and ( b.importo = to_number(r_Importo) or r_Importo is null )
                and ( b.bonus = to_number(r_Bonus) or r_Bonus is null )
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
        end LOOP; 
            gui.ChiudiTabella; 
    else
        gui.AGGIUNGIPOPUP(FALSE, 'Non hai permessi necessari per accedere a questa pagina!');
    end if;
    END visualizzaBustePaga; 

    function existBustaPaga(r_FkDipendente in varchar2 default null, 
        r_FkContabile in varchar2 default null,
        r_Data in varchar2 default null) return boolean IS

        count_b NUMBER;
    BEGIN
        SELECT COUNT(*) INTO count_b FROM BUSTEPAGA b WHERE b.FK_DIPENDENTE = r_FkDipendente AND b.FK_CONTABILE = r_FkContabile AND TRUNC(b.Data) = r_Data;
        IF(count_b=1) THEN
            return true;
        ELSE
            return false;
        END IF;
    END existBustaPaga;

    procedure modificaBustaPaga (
        r_IdSessione in varchar2,
        r_FkDipendente in varchar2 default null, 
        r_FkContabile in varchar2 default null,
        r_Data in varchar2 default null,
        r_Importo in varchar2 default null,
        r_Bonus in varchar default null,
        r_popUpVisualizza in BOOLEAN default false,
        r_popUpImportoNegativo in varchar2 default null,
        r_popUpBonusNegativo in varchar2 default null,
        new_Importo in varchar2 default null,
        new_Bonus in varchar2 default null
    )
    IS
    head gui.StringArray;
    
    BEGIN 

        --QUESTO SERVE PER QUANDO SI REFRESHA LA PAGINA, IN MODO DA NON FAR RESTARE I POP UP 
        htp.prn('<script>   const newUrl = '||costanti.user_root||'"modificaBustaPaga?r_IdSessione='||r_IdSessione||'&r_FkDipendente='||r_FkDipendente||'&r_FkContabile='||r_FkContabile||'&r_Data='||r_Data||'&r_Importo='||r_Importo||'&r_Bonus='||r_Bonus||'"; 
                        history.replaceState(null, null, newUrl); 
        </script>');

        gui.apriPagina(titolo => 'modificaBustaPaga');

        /* Controllo che l'utente sia un contabile e che sia il contabile che ha creato la busta paga che vuole modificare*/
        IF(sessionhandler.getRuolo(r_IdSessione) = 'Contabile' and TO_NUMBER(r_FkContabile) = sessionhandler.getIdUser(r_IdSessione)) THEN
            /* Stampa del popup*/
            IF (r_popUpImportoNegativo = 'True') THEN
                gui.AGGIUNGIPOPUP(False, 'Il valore del nuovo importo inserito è minore di zero.');
            END IF;
            IF (r_popUpBonusNegativo = 'True') THEN
                gui.AGGIUNGIPOPUP(False, 'Il valore del nuovo bonus inserito è minore di zero.');
            END IF;

            gui.AGGIUNGIINTESTAZIONE(Testo => 'Modifica Busta Paga di '||r_FkDipendente);
            /* Controllo che la busta paga esista */
            IF(existBustaPaga (r_FkDipendente, r_FkContabile, r_Data)) THEN
                gui.AGGIUNGIFORM();
                    gui.AGGIUNGIINPUT(tipo=>'hidden', nome=>'r_IdSessione', value=>r_IdSessione);
                    gui.AGGIUNGIINPUT(tipo=>'hidden', nome=>'r_Importo', value=>r_Importo);
                    gui.AGGIUNGIINPUT(tipo=>'hidden', nome=>'r_Bonus', value=>r_Bonus);
                    gui.AGGIUNGIINPUT(tipo=>'hidden', nome=>'r_FkDipendente', value => r_FkDipendente);
                    gui.AGGIUNGIINPUT(tipo=>'hidden', nome=>'r_FkContabile', value => r_FkContabile);
                    gui.AGGIUNGIINPUT(tipo=>'hidden', nome=>'r_Data', value => r_Data);

                     
                        gui.AGGIUNGIGRUPPOINPUT;    
                            gui.AGGIUNGIINTESTAZIONE (testo => 'Importo', dimensione => 'h2');
                            gui.ACAPO; 
                            gui.AGGIUNGIINTESTAZIONE (testo => 'Vecchio Importo: ', dimensione => 'h3');
                            gui.AGGIUNGIPARAGRAFO (testo => r_Importo);    
                            gui.ACAPO; 
                            gui.AGGIUNGIINTESTAZIONE (testo => 'Nuovo Importo: ', dimensione => 'h3');  
                            gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-money-bill', nome => 'new_Importo', placeholder => 'Inserire nuovo importo...');
                        gui.CHIUDIGRUPPOINPUT; 


                        gui.AGGIUNGIGRUPPOINPUT;
                            gui.AGGIUNGIINTESTAZIONE (testo => 'Bonus', dimensione => 'h2');
                            gui.ACAPO; 
                            gui.AGGIUNGIINTESTAZIONE (testo => 'Vecchio Bonus: ', dimensione => 'h3');
                            gui.AGGIUNGIPARAGRAFO (testo => r_Bonus);    
                            gui.ACAPO; 
                            gui.AGGIUNGIINTESTAZIONE (testo => 'Nuovo Bonus: ', dimensione => 'h3');  
                            gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-money-bill-trend-up', nome => 'new_Bonus', placeholder => 'Inserire nuovo bonus...'); 

                        gui.CHIUDIGRUPPOINPUT; 
                      

                     
                        gui.AGGIUNGIGRUPPOINPUT; 
                            gui.AGGIUNGIBOTTONESUBMIT (value => 'Modifica'); 
                        gui.CHIUDIGRUPPOINPUT; 
                      
                gui.chiudiform; 

            END IF;

            IF (new_Importo > 0 AND new_Bonus >= 0) THEN

                UPDATE BUSTEPAGA 
                SET BUSTEPAGA.Importo = TO_NUMBER(new_Importo),
                    BUSTEPAGA.Bonus = TO_NUMBER(new_Bonus)
                WHERE BUSTEPAGA.Fk_Dipendente = TO_NUMBER(r_FkDipendente) AND BUSTEPAGA.Fk_Contabile = TO_NUMBER(r_FkContabile) AND TRUNC(BUSTEPAGA.Data) = TRUNC(TO_DATE(r_Data));

                gui.REINDIRIZZA(costanti.user_root||'visualizzaBustePaga?r_IdSessione='||r_IdSessione||'&r_popUp=True');

            END IF;

            IF (new_Importo < 0) THEN 
                gui.REINDIRIZZA(costanti.user_root||'modificaBustaPaga?r_IdSessione='||r_IdSessione||'&r_FkDipendente='||r_FkDipendente||'&r_FkContabile='||r_FkContabile||'&r_Data='||r_Data||'&r_Importo='||r_Importo||'&r_Bonus='||r_Bonus||'&r_popUpImportoNegativo=True');
            END IF;

            IF (new_Bonus < 0) THEN
                gui.REINDIRIZZA(costanti.user_root||'modificaBustaPaga?r_IdSessione='||r_IdSessione||'&r_FkDipendente='||r_FkDipendente||'&r_FkContabile='||r_FkContabile||'&r_Data='||r_Data||'&r_Importo='||r_Importo||'&r_Bonus='||r_Bonus||'&r_popUpBonusNegativo=True');
            END IF;

        ELSE
            gui.AGGIUNGIPOPUP(False,'Non hai permessi necessari per accedere a questa pagina!');
        END IF;

    END modificaBustaPaga;

    procedure visualizzaBustePagaDipendente (
        r_IdSessione in varchar2,
		r_Data       in varchar2 default null,
		r_Importo    in varchar2 default null,
		r_Bonus      in varchar2 default null
    ) is

    head gui.StringArray; 

    BEGIN

    gui.apriPagina (titolo => 'visualizza buste paga dipendenti');

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
                and ( ( trunc(b.data) = to_date(r_Data,'YYYY-MM-DD')) or r_Data is null )
                and ( b.importo = to_number(r_Importo) or r_Importo is null )
                and ( b.bonus = to_number(r_Bonus) or r_Bonus is null )
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
    END visualizzaBustePagaDipendente;


    function existDipendente(r_IdDipendente in varchar2 default null) return boolean IS 
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
        r_IdSessione in varchar2, 
        r_FkDipendente in varchar2 default null,
        r_Importo in varchar2 default null,
        r_bonus in varchar2 default null) IS

    bonus_percent NUMBER := 0;
    
    head gui.StringArray; 

    BEGIN
        
    /* Controllo i permessi di accesso */
    IF(sessionhandler.getRuolo(r_IdSessione) = 'Contabile') THEN

        gui.APRIPAGINA(titolo => 'inserimentoBustaPaga', idSessione => r_IdSessione);
        gui.AGGIUNGIFORM (url => costanti.user_root||'inserimentoBustaPaga');  

               
                gui.aggiungiIntestazione(testo => 'Inserimento Busta Paga', dimensione => 'h2');
                gui.AGGIUNGIGRUPPOINPUT; 
                    gui.AGGIUNGIINPUT(tipo=>'hidden', nome=>'r_IdSessione', value => r_IdSessione); 
                    gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-user', nome => 'r_FkDipendente', placeholder => 'Identificativo Dipendente');        
                    gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-money-bill', nome => 'r_Importo', placeholder => 'Importo');   
                gui.CHIUDIGRUPPOINPUT;
               

             
                gui.AGGIUNGIGRUPPOINPUT; 
                        gui.aggiungiBottoneSubmit (value => 'Inserisci'); 
                gui.CHIUDIGRUPPOINPUT; 
               
        gui.CHIUDIFORM;

        if(r_FkDipendente IS NOT NULL AND r_Importo > 0) THEN
            IF(existDipendente(r_FkDipendente)) THEN 
                /* Recupero il bonus percentuale in dipendenti */
                SELECT d.Bonus INTO bonus_percent FROM DIPENDENTI d WHERE d.Matricola = sessionhandler.getiduser(r_IdSessione);
                /* Inserisco la busta paga calcolando il bonus */
                INSERT INTO BUSTEPAGA (FK_Dipendente, FK_Contabile, Data, Importo, Bonus) VALUES 
                (TO_NUMBER(r_FkDipendente), sessionhandler.getiduser(r_IdSessione), SYSDATE, TO_NUMBER(r_Importo), (TO_NUMBER(r_Importo)*bonus_percent)/100);
                /* Popup di successo */
                gui.AggiungiPopup(True, 'Busta paga inserita con successo!');
            ELSE
                gui.AggiungiPopup(False, 'Errori inserimento dati');
            END IF;
        END IF;
    ELSE
        gui.AGGIUNGIPOPUP(False, 'Non hai i permessi necessari per accedere alla pagina!');
    END IF;

    END inserimentoBustaPaga;
 
    procedure visualizzaRicaricheCliente (
        r_IdSessione in varchar2,
		r_Data       in varchar2 default null,
		r_Importo    in varchar2 default null,
        r_PopUp in varchar2 default null
    ) is

    head gui.stringArray; 

    BEGIN

    --QUESTO SERVE PER QUANDO SI REFRESHA LA PAGINA, IN MODO DA NON FAR RESTARE I POP UP 
        htp.prn('<script>   const newUrl = "'||costanti.user_root||'visualizzaRicaricheCliente?r_IdSessione='||r_IdSessione||'"; 
                        history.replaceState(null, null, newUrl); 
        </script>');

    gui.apriPagina (titolo => 'Visualizzazione Ricariche cliente'); 

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
    ELSE
        gui.AggiungiPopup(False, 'Non hai il permesso per accedere a questa pagina');
    END IF;
    END visualizzaRicaricheCliente; 

    procedure inserimentoRicarica (
        r_IdSessione in varchar2,
        r_Importo in varchar2 default null,
        r_PopUp in varchar2 default null
    )IS

    head gui.StringArray; 

    BEGIN
        --QUESTO SERVE PER QUANDO SI REFRESHA LA PAGINA, IN MODO DA NON FAR RESTARE I POP UP 
        htp.prn('<script>   const newUrl = "'||costanti.user_root||'inserimentoRicarica?r_IdSessione='||r_IdSessione||'"; 
                        history.replaceState(null, null, newUrl); 
        </script>');

        gui.APRIPAGINA(titolo => 'inserimentoRicarica');

        IF(r_PopUp IS NOT NULL AND r_PopUp = 'False') THEN
                gui.AGGIUNGIPOPUP(False, 'Ricarica non inserita!');
        END IF;

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
                    INSERT INTO RICARICHE VALUES(seq_IDricarica.NEXTVAL, sessionhandler.getiduser(r_IdSessione), SYSDATE, TO_NUMBER(r_Importo));
                    /* Aggiornamento del Saldo */
                    UPDATE CLIENTI SET Saldo = (SELECT c.Saldo FROM CLIENTI c WHERE c.IDCLIENTE = sessionhandler.getiduser(r_IdSessione)) + r_Importo 
                    WHERE IDcliente = sessionhandler.getiduser(r_IdSessione);
                    /* Pop Up all'utente */
                    gui.AggiungiPopup(True, 'Ricarica inserita con successo!');
                    /* Reindiriziamo alla pagina visualizzaRicaricheCliente */
                    gui.REINDIRIZZA(costanti.user_root||'visualizzaRicaricheCliente?r_IdSessione='||r_IdSessione||'&r_PopUp=True');
                ELSE
                    gui.REINDIRIZZA(costanti.user_root||'inserimentoRicarica?r_IdSessione='||r_IdSessione||'&r_PopUp=False');
                END IF;
            END IF;
        ELSE
            gui.AggiungiPopup(False, 'Non hai il permesso per accedere a questa pagina!');
        END IF;
    end inserimentoRicarica;

  procedure visualizzaClienti(
    c_idSess VARCHAR default '-1', 
    c_Nome VARCHAR2 default NULL,
    c_Cognome VARCHAR2 default NULL,
    c_DataNascita VARCHAR2 default NULL,
    Maschio VARCHAR2 default NULL,
    Femmina VARCHAR2 default NULL
  ) IS

   head gui.StringArray; --parametri per headers della tabella 

   BEGIN

   head := gui.StringArray('Nome', 'Cognome', 'DataNascita', 'Sesso', 'Telefono', 'Email', ' '); 
   gui.apriPagina (titolo => 'visualizza clienti', idSessione => c_idSess);  

  gui.APRIFORMFILTRO; 
        gui.aggiungicampoformfiltro(nome => 'c_Nome', placeholder => 'Nome');
		gui.aggiungicampoformfiltro( nome => 'c_Cognome', placeholder => 'Cognome');
		gui.aggiungicampoformfiltro(tipo => 'date', nome => 'c_DataNascita', placeholder => 'Birth');
        gui.aggiungiDropdownFormFiltro (testo => 'Scegli', placeholder => 'Sesso', ids => gui.StringArray ('M', 'F'), names => gui.StringArray ('Maschio', 'Femmina')); 
		gui.aggiungicampoformfiltro(tipo => 'submit', value => 'Filtra', placeholder => 'filtra');
    gui.CHIUDIFORMFILTRO; 
    gui.aCapo(2); 

    gui.APRITABELLA (elementi => head);
   
   for clienti IN
   (SELECT IDCLIENTE, Nome, Cognome, DataNascita, Sesso, Ntelefono, Email, Password FROM Clienti 
        where ( Clienti.NOME = c_Nome or c_Nome is null )
		and ( ( trunc( Clienti.DATANASCITA) = to_date(c_DataNascita,'YYYY-MM-DD') ) or c_DataNascita is null )
		and ( Clienti.COGNOME = c_Cognome or c_Cognome is null)
        and ( (Clienti.SESSO = 'M' and Maschio = 'M') or Maschio is null)
        and ( (Clienti.SESSO = 'F' and Femmina = 'F') or Femmina is null)
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
            gui.AggiungiPulsanteCancellazione (collegamento => u_root || '.eliminaCliente?id='||clienti.IDCLIENTE||'');  
            gui.aggiungiPulsanteModifica (collegamento =>  u_root || '.modificaCliente?id='||clienti.IDCLIENTE||'&cl_Email='||clienti.Email||'&cl_Password='||clienti.PASSWORD||'&cl_Telefono='||clienti.NTelefono||'');
            gui.chiudiElementoPulsanti;
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

