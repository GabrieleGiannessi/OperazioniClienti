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
        r_idsessione varchar2,
        r_dipendente in varchar2 default null,
        r_contabile  in varchar2 default null,
        r_data       in varchar2 default null,
        r_importo    in varchar2 default null,
        r_bonus      in varchar2 default null,
        r_popup      in varchar2 default null
    );

    procedure modificabustapaga (
        r_IdSessione in varchar2,
        r_FkDipendente in varchar2 default null, 
        r_FkContabile in varchar2 default null,
        r_Data in varchar2 default null,
        r_Importo in varchar2 default null,
        r_Bonus in varchar default null,
        r_popUpImportoNegativo in varchar2 default null,
        r_popUpBonusNegativo in varchar2 default null,
        new_Importo in varchar2 default null
    );

    procedure visualizzabustepagadipendente (
        r_idsessione in varchar2,
        r_data       in varchar2 default null,
        r_importo    in varchar2 default null,
        r_bonus      in varchar2 default null
    );
    procedure inserimentobustapaga (
        r_IdSessione in varchar2,
        r_FkDipendente in varchar2 default null,
        r_Importo in varchar2 default null,
        r_data in varchar2 default null
    );

    procedure visualizzaricarichecliente (
        r_IdSessione in varchar2,
		r_Data       in varchar2 default null,
		r_Importo    in varchar2 default null,
        r_PopUp in varchar2 default null
    );
    procedure inserimentoricarica (
        r_IdSessione in varchar2,
        r_Importo in varchar2 default null,
        r_PopUp in varchar2 default null
    );

    procedure visualizzaclienti (
        c_idSess VARCHAR default '-1', 
        c_nome          varchar2 default null,
        c_cognome       varchar2 default null,
        c_datanascita   varchar2 default null,
        maschio       varchar2 default null,
        femmina       varchar2 default null
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
        r_iddipendente in varchar2 default null
    ) return boolean;

	--function checkContabile(r_IdContabile in varchar2 default null) return boolean;

    function existbustapaga (
        r_fkdipendente in varchar2 default null,
        r_fkcontabile  in varchar2 default null,
        r_data         in varchar2 default null
    ) return boolean;

    procedure eliminaCliente (
        id varchar2 default null
    ); 

end operazioniclienti;