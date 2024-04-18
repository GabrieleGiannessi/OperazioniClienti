create or replace package operazioniclienti as

    u_user CONSTANT VARCHAR(100):='http://131.114.73.203:8080/apex/g_giannessi'; 
    u_root CONSTANT VARCHAR(100):=u_user||'.operazioniClienti';
  
    procedure registrazionecliente;

    procedure inseriscidati (
        nome     varchar2 default null,
        cognome  varchar2 default null,
        email    varchar2 default null,
        password varchar2 default null,
        telefono varchar2 default null,
        day      varchar2 default null,
        month    varchar2 default null,
        year     varchar2 default null,
        gender   varchar2 default null
    );

    procedure modificacliente (
        id          varchar2 default null,
        cl_email    varchar2 default null,
        cl_password varchar2 default null,
        cl_telefono varchar2 default null
    );

    procedure visualizzabustepaga (
        r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
        r_Dipendente in BUSTEPAGA.FK_DIPENDENTE%TYPE default null,
        r_Contabile  in BUSTEPAGA.FK_CONTABILE%TYPE default null,
        r_Data       in varchar2 default null,
        r_Importo    in BUSTEPAGA.IMPORTO%TYPE default null,
        r_Bonus      in BUSTEPAGA.BONUS%TYPE default null,
        r_PopUp      in varchar2 default null
    );

    procedure modificabustapaga (
            r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
    r_FkDipendente in BUSTEPAGA.FK_CONTABILE%TYPE default null,
    r_Data in BUSTEPAGA.DATA%TYPE default null,
    r_popUpImportoNegativo in varchar2 default null,
    r_popUpBonusNegativo in varchar2 default null,
    new_Importo in varchar2 default null,
    new_Data in varchar2 default null
    );

    procedure visualizzabustepagadipendente (
        r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
        r_Data       in varchar2 default null,
        r_Importo    in BUSTEPAGA.IMPORTO%TYPE default null,
        r_Bonus      in BUSTEPAGA.BONUS%TYPE default null
    );
    procedure inserimentobustapaga (
        r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
        r_FkDipendente in BUSTEPAGA.FK_DIPENDENTE%TYPE default null,
        r_Data       in varchar2 default null,
        r_Importo    in BUSTEPAGA.IMPORTO%TYPE default null
    );

    procedure visualizzaricarichecliente (
        r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
        r_Data       in varchar2 default null,
        r_Importo    in RICARICHE.IMPORTO%TYPE default null,
        r_PopUp in varchar2 default null
    );
    procedure inserimentoricarica (
        r_IdSessione in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
        r_Importo    in RICARICHE.IMPORTO%TYPE default null,
        r_PopUp in varchar2 default null
    );

    procedure visualizzaclienti (
        c_idSess VARCHAR default '-1', 
        c_nome          varchar2 default null,
        c_cognome       varchar2 default null,
        c_datanascita   varchar2 default null,
        sesso       varchar2 default null
    );

    procedure visualizzaProfilo (
        c_idSessione varchar default '-1', 
        id varchar2 default null
    ); 

    procedure inserimentoconvenzione;
    procedure inseriscidaticonvenzione (
       -- r_IdSessioneManager varchar2,
        r_nome          varchar2 default null,
        r_ente          varchar2 default null,
        r_sconto        varchar2 default null,
        r_codiceAccesso varchar2 default null,
        r_dataInizio    varchar2 default null,
        r_dataFine      varchar2 default null,
        r_cumulabile    varchar2 default null
    );
    --procedure associaConvenzione;
    procedure visualizzazioneconvenzioni (
        datainizio varchar2 default null,
        datafine   varchar2 default null,
        ente       varchar2 default null
    );
    procedure inserimentocontabile (
        r_idsessionemanager varchar2 default null,
        r_fkdipendente      varchar2 default null
    );

    function existdipendente (
        r_IdDipendente in DIPENDENTI.MATRICOLA%TYPE default null
    ) return boolean;

	--function checkContabile(r_IdContabile in varchar2 default null) return boolean;

    function existbustapaga (
        r_FkDipendente in BUSTEPAGA.FK_DIPENDENTE%TYPE,
        r_Data in BUSTEPAGA.DATA%TYPE
    ) return boolean;

    procedure eliminaCliente (
        c_email varchar2 default null
    ); 

end operazioniclienti;