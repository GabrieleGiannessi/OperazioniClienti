create or replace package operazioniclienti as
	u_user constant varchar(100) := 'http://131.114.73.203:8080/apex/n_lupi';
	u_root constant varchar(100) := u_user || '.operazioniClienti.';
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
		cl_telefono varchar2 default null  -- questi parametri servono per le update dei campi 
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
        r_PopUp in varchar2 default null,
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
		r_Importo    in BUSTEPAGA.IMPORTO%TYPE default null,
		r_PopUp     in varchar2 default null
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
		idsess        varchar default null,
		c_nome        varchar2 default null,
		c_cognome     varchar2 default null,
		c_datanascita varchar2 default null,
		sesso         varchar2 default null
	);

	procedure visualizzaprofilo (
		idsess varchar default '-1', --id della sessione (cliente o manager)
        id varchar2 default null --id del cliente 
	);

	procedure inserimentoconvenzione (
		idsess varchar --per accedere devi essere loggato (e ruolo = operatore)
	);

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
        r_IdDipendente in DIPENDENTI.MATRICOLA%TYPE default null
    ) return boolean;

	--function checkContabile(r_IdContabile in varchar2 default null) return boolean;

    function existbustapaga (
        r_FkDipendente in BUSTEPAGA.FK_DIPENDENTE%TYPE,
        r_Data in BUSTEPAGA.DATA%TYPE
    ) return boolean;

	procedure eliminacliente (
		c_id varchar2 default null
	);

end operazioniclienti;