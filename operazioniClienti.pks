create or replace package operazioniclienti as

/*
    user CONSTANT VARCHAR(20):='g_giannessi'; 
    root CONSTANT VARCHAR(20):=user||'.operazioniClienti';
  */  
    --capire bene come mai l'integrazione delle costanti causa errori nel pkb

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
        r_dipendente in varchar2 default null,
        r_contabile  in varchar2 default null,
        r_data       in varchar2 default null,
        r_importo    in varchar2 default null,
        r_bonus      in varchar2 default null,
        r_PopUp in varchar2 default null
    );

    procedure modificaBustaPaga (
        r_FkDipendente in varchar2 default null, 
        r_FkContabile in varchar2 default null,
        r_Data in varchar2 default null,
        r_Importo in varchar2 default null,
        r_bonus in varchar default null,
        r_popUp in BOOLEAN default false,
        new_Importo in varchar2 default null,
        new_Bonus in varchar2 default null
    );

    procedure visualizzabustepagadipendente (
        r_idsessione in varchar2 default null,
        r_data       in varchar2 default null,
        r_importo    in varchar2 default null,
        r_bonus      in varchar2 default null
    );
    procedure inserimentobustapaga (
        r_idsessionecontabile in varchar2 default null,
        r_fkdipendente        in varchar2 default null,
        r_importo             in varchar2 default null
    );
    procedure visualizzaricariche (
        r_cliente in varchar2 default null,
        r_data    in varchar2 default null,
        r_importo in varchar2 default null
    );
    procedure visualizzaricarichecliente (
        r_idsessionecliente in varchar2 default null,
        r_data              in varchar2 default null,
        r_importo           in varchar2 default null
    );
    procedure inserimentoricarica (
        r_idsessionecliente in varchar2 default null,
        r_importo           in varchar2 default null
    );

    procedure visualizzaclienti (
        c_nome          varchar2 default null,
        c_cognome       varchar2 default null,
        c_datanascita   varchar2 default null,
        c_maschio       varchar2 default null,
        c_femmina       varchar2 default null,
        row_nome        varchar2 default null,
        row_cognome     varchar2 default null,
        row_datanascita varchar2 default null,
        row_sesso       varchar2 default null,
        row_telefono    varchar2 default null,
        row_email       varchar2 default null,
        elimina         varchar2 default null
    );

	procedure inserimentoConvenzione;
	PROCEDURE inseriscidatiConvenzione (
    p_nome IN CONVENZIONI.nome%TYPE,
    p_ente IN CONVENZIONI.ente%TYPE,
    p_sconto IN CONVENZIONI.sconto%TYPE,
    p_codiceAccesso IN CONVENZIONI.codiceAccesso%TYPE,
    p_dataInizio IN CONVENZIONI.dataInizio%TYPE,
    p_dataFine IN CONVENZIONI.dataFine%TYPE,
    p_cumulabile IN CONVENZIONI.cumulabile%TYPE
);

    procedure visualizzazioneconvenzioni (
        datainizio varchar2 default null,
        datafine   varchar2 default null,
        ente       varchar2 default null
    );
    procedure inserimentocontabile (
        r_idsessionemanager varchar2 default null,
        r_fkdipendente      varchar2 default null
    );

	function checkDipendente(r_IdDipendente in varchar2 default null) return boolean;

	function checkContabile(r_IdContabile in varchar2 default null) return boolean;

    function existBustaPaga(r_FkDipendente in varchar2 default null, 
        r_FkContabile in varchar2 default null,
        r_Data in varchar2 default null) return boolean;

end operazioniclienti;