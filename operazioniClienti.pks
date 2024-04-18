create or replace package operazioniclienti as
    u_user constant varchar(100) := 'http://131.114.73.203:8080/apex/g_giannessi';
    u_root constant varchar(100) := u_user || '.operazioniClienti';
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
        idsess      varchar default null,  -- identifica chi sta facendo l'accesso
        cl_id       varchar2 default null, -- identifica l'id del cliente a cui facciamo le modifiche
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
        r_idsessione           in varchar2,
        r_fkdipendente         in varchar2 default null,
        r_fkcontabile          in varchar2 default null,
        r_data                 in varchar2 default null,
        r_importo              in varchar2 default null,
        r_bonus                in varchar default null,
        r_popupvisualizza      in boolean default false,
        r_popupimportonegativo in varchar2 default null,
        r_popupbonusnegativo   in varchar2 default null,
        new_importo            in varchar2 default null,
        new_bonus              in varchar2 default null
    );

    procedure visualizzabustepagadipendente (
        r_idsessione in varchar2,
        r_data       in varchar2 default null,
        r_importo    in varchar2 default null,
        r_bonus      in varchar2 default null
    );
    procedure inserimentobustapaga (
        r_idsessione   in varchar2,
        r_fkdipendente in varchar2 default null,
        r_importo      in varchar2 default null,
        r_bonus        in varchar2 default null
    );

    procedure visualizzaricarichecliente (
        r_idsessione in varchar2,
        r_data       in varchar2 default null,
        r_importo    in varchar2 default null,
        r_popup      in varchar2 default null
    );
    procedure inserimentoricarica (
        r_idsessione in varchar2,
        r_importo    in varchar2 default null,
        r_popup      in varchar2 default null
    );

    procedure visualizzaclienti (
        c_idsess      varchar default '-1',
        c_nome        varchar2 default null,
        c_cognome     varchar2 default null,
        c_datanascita varchar2 default null,
        sesso         varchar2 default null
    );

    procedure visualizzaprofilo (
        c_idsessione varchar default '-1',
        id           varchar2 default null
    );

    procedure inserimentoconvenzione;
    procedure inseriscidaticonvenzione (
       -- r_IdSessioneManager varchar2,
        r_nome          varchar2 default null,
        r_ente          varchar2 default null,
        r_sconto        varchar2 default null,
        r_codiceaccesso varchar2 default null,
        r_datainizio    varchar2 default null,
        r_datafine      varchar2 default null,
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

    procedure eliminacliente (
        c_email varchar2 default null
    );

end operazioniclienti;