create or replace PACKAGE BODY LOGINLOGOUT AS
    function aggiungiSessione(
                 cEmail IN varchar2,
                 psw IN varchar2,
                 ruolo IN VARCHAR2

    )
    return int--=null se l'operazione fallisce
    IS
    idUtente int;
    idSess int; --=null se l'operazione fallisce
    stateSession boolean;--true: indica se era già presente una sessione attiva prima di richiedere il login
    nullParameters exception;
    BEGIN
        case ruolo when '00' then
            --verifico che l'utente esista e sia attivo
                select c.IDcliente
                INTO idUtente
                from Clienti c
                where c.Email=cEmail and c.Password=psw and c.Stato=1;
            if(idUtente is null) then
                return null;
            end if;--credenziali non corrette
            --controllo se è già presente una sessione attiva per un utente
            stateSession:=LOGINLOGOUT.terminaSessione(idUtente,ruolo);
            idSess:=SEQUENCEIDSESSIONICLIENTI.nextval;
            INSERT INTO SESSIONICLIENTI(idSessione,IDCLIENTE) values(ruolo||idSess,idUtente);
        else
            case ruolo when '01' then--Clienti
            select d.MATRICOLA
                INTO idUtente
                from DIPENDENTI d JOIN OPERATORI o on o.FK_DIPENDENTE=d.MATRICOLA
                where d.EMAILAZIENDALE=cEmail and d.Password=psw and d.Stato=1;
            when '02' then--Operatori
            select d.MATRICOLA
                INTO idUtente
                from DIPENDENTI d JOIN AUTISTI A on A.FK_DIPENDENTE=d.MATRICOLA
                where d.EMAILAZIENDALE=cEmail and d.Password=psw and d.Stato=1;
            when '03' then--Autisti
            select d.MATRICOLA--manager
                INTO idUtente
                from DIPENDENTI d JOIN RESPONSABILI R on R.FK_DIPENDENTE=d.MATRICOLA
                where d.EMAILAZIENDALE=cEmail and d.Password=psw and d.Stato=1 AND r.RUOLO=0;
            when '04' then--contabili
            select d.MATRICOLA
                INTO idUtente
                from DIPENDENTI d JOIN RESPONSABILI R on R.FK_DIPENDENTE=d.MATRICOLA
                where d.EMAILAZIENDALE=cEmail and d.Password=psw and d.Stato=1 AND r.RUOLO=1;
            end case;
            if(idUtente is null) then
                return null;
            end if;--credenziali non corrette
            stateSession:=LOGINLOGOUT.terminaSessione(idUtente,ruolo);
            idSess:=SEQUENCEIDSESSIONIDIPENDENTI.nextval;
            INSERT INTO SESSIONIDIPENDENTI(idSessione,IDDIPENDENTE) values(ruolo||idSess,idUtente);


        end case;
        return idSess;
    END aggiungiSessione;

    function terminaSessione(idUser IN int, ruolo varchar2)
        return boolean
        IS
        BEGIN
            if Ruolo='00'then
                UPDATE SESSIONICLIENTI sc
                set sc.finesessione=SYSDATE
                where (sc.finesessione is NULL) and sc.IDCLIENTE=idUser;
                RETURN SQL%FOUND;
            else
                UPDATE SESSIONIDIPENDENTI sd
                set sd.finesessione=SYSDATE
                where (sd.finesessione is NULL) and sd.IDDIPENDENTE=idUser;
                RETURN SQL%FOUND;
            end if;
        END terminaSessione;
    procedure loginCliente(cEmail IN varchar2 DEFAULT null, password IN varchar2 DEFAULT null)
        IS
        idSess int;
        BEGIN
            htp.prn('');
            gui.ApriPagina('Login Cliente');
            if(cEmail is null and password is null) then
                gui.AGGIUNGIINTESTAZIONE('Inserisci email e password', 'h1');
                gui.ApriFormFiltro(URL||'.loginlogout.loginCliente');
                gui.AggiungiCampoFormFiltro('text', 'cEmail', '', 'email');
                gui.AggiungiCampoFormFiltro('text', 'password', '', 'password');
                gui.AggiungiCampoFormFiltro('submit', '', 'Login', '');
                gui.chiudiFormFiltro();
            else
                idSess:=LOGINLOGOUT.AGGIUNGISESSIONE(cEmail,password,'00');
                if(idSess<>null) then--login riuscito
                    --Questa è la nostra implementazione di redirect, per testarla rinviamo su un'altra pagina a caso l'utente dopo aver completato il login con successo
                    gui.AGGIUNGIINTESTAZIONE('Login  riuscito', 'h1');
                    else
                        gui.AGGIUNGIINTESTAZIONE('Login non riuscito', 'h1');
                end if;
            end if;
            gui.CHIUDIPAGINA();
        END loginCliente;
    procedure loginDipendente(cEmail IN varchar2 DEFAULT null, password IN varchar2 DEFAULT null, ruolo IN VARCHAR2 default null)
        IS
        idSess int;
        BEGIN
            gui.ApriPagina('Login Dipendente');
            if(cEmail is null or password is null or ruolo is null )   then
                gui.AGGIUNGIINTESTAZIONE('Inserisci email e password', 'h1');
                gui.ApriFormFiltro(URL||'.loginlogout.loginDipendente');
                gui.AggiungiCampoFormFiltro('text', 'cEmail', '', 'email');
                gui.AggiungiCampoFormFiltro('text', 'password', '', 'password');

                gui.APRISELECTFORMFILTRO('ruolo','ruolo');
                gui.AGGIUNGIOPZIONESELECT('01', false, 'Operatore');
                gui.AGGIUNGIOPZIONESELECT('02', false, 'Autista');
                gui.AGGIUNGIOPZIONESELECT('03', false, 'Manager');
                gui.AGGIUNGIOPZIONESELECT('04', false, 'Contabile');
                gui.CHIUDISELECTFORMFILTRO;
                gui.AggiungiCampoFormFiltro('submit', '', 'Login', 'login');
            else
                idSess:=LOGINLOGOUT.AGGIUNGISESSIONE(cEmail,password,ruolo);
                if(idSess<>-2) then--login riuscito
                    --Questa è la nostra implementazione di redirect, per testarla rinviamo su un'altra pagina a caso l'utente dopo aver completato il login con successo
                    gui.AGGIUNGIINTESTAZIONE('Login  riuscito', 'h1');
                    else
                        gui.AGGIUNGIINTESTAZIONE('Login non riuscito', 'h1');
                end if;
            end if;
            gui.CHIUDIPAGINA();
        END loginDipendente;


END LOGINLOGOUT;