create or replace package body operazioniclienti as

	procedure visualizzaBustePaga (
		r_Dipendente in varchar2 default null,
        r_Contabile in varchar2 default null,
		r_data    in varchar2 default null,
		r_importo in varchar2 default null,
        r_bonus in varchar2 default null
	)
    is
	begin
		gui.apripagina('VisualizzazioneBustePaga');
        gui.apriformfiltro('http://131.114.73.203:8080/apex/l_bindi.OperazioniClienti.visualizzaBustePaga');
		gui.aggiungicampoformfiltro(nome => 'r_Dipendente', placeholder => 'Dipendente');
		gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
		gui.aggiungicampoformfiltro(nome => 'r_Importo', placeholder => 'Importo');
        gui.aggiungicampoformfiltro(nome => 'r_Bonus', placeholder => 'Bonus');
        gui.aggiungicampoformfiltro(nome => 'r_Contabile', placeholder => 'Contabile');
		gui.aggiungicampoformfiltro('submit', '', 'Filtra', '');
		htp.prn('<br>');
		gui.chiudiformfiltro;

		gui.apritabella;
		gui.apriheadertabella;
		gui.aggiungiheadertabella(elemento => 'Dipendente');
		gui.aggiungiheadertabella(elemento => 'Data');
		gui.aggiungiheadertabella(elemento => 'Importo');
		gui.aggiungiheadertabella(elemento => 'Bonus');
		gui.aggiungiheadertabella(elemento => 'Contabile');
		gui.chiudiheadertabella;
		for busta_paga in (
			select *
			from BUSTEPAGA b
			where ( b.FK_DIPENDENTE = r_Dipendente or r_Dipendente is null )
			and ( b.FK_CONTABILE = r_Contabile or r_Contabile is null )
			and ( ( trunc(b.Data) = to_date(r_data,'YYYY-MM-DD') ) or r_data is null )
			and ( b.Importo = to_number(r_importo) or r_importo is null )
			and ( b.Bonus = to_number(r_bonus) or r_bonus is null)
			order by data desc
		) loop
			gui.aggiungirigatabella;
			gui.aggiungielementotabella(elemento => busta_paga.fk_dipendente);
			gui.aggiungielementotabella(elemento => busta_paga.data);
			gui.aggiungielementotabella(elemento => busta_paga.importo);
			gui.aggiungielementotabella(elemento => busta_paga.bonus);
			gui.aggiungielementotabella(elemento => busta_paga.fk_contabile);
			gui.aggiungipulsanteintabella('.','.');
			gui.chiudirigatabella;
		end loop;

		gui.chiuditabella();
		gui.chiudibody();

	end visualizzabustepaga;

	procedure visualizzaBustePagaDipendente (
		r_IdSessione in varchar2 default null,
		r_data    in varchar2 default null,
		r_importo in varchar2 default null,
        r_bonus in varchar2 default null
	) is
	begin

		gui.apripagina;

		gui.apriformfiltro('http://131.114.73.203:8080/apex/l_bindi.OperazioniClienti.visualizzaBustePagaDipendente');
		htp.prn('<input type = "hidden" name = "r_IdSessione" value="'||r_IdSessione||'">');
		gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
        gui.aggiungicampoformfiltro(nome => 'r_Importo', placeholder => 'Importo');
		gui.aggiungicampoformfiltro(nome => 'r_Bonus', placeholder => 'Bonus');
        gui.aggiungicampoformfiltro('submit', '', 'Filtra', '');
		htp.prn('<br>');
		gui.chiudiformfiltro;


		gui.apritabella;
		gui.apriheadertabella;
		gui.aggiungiheadertabella(elemento => 'Data');
		gui.aggiungiheadertabella(elemento => 'Importo');
		gui.aggiungiheadertabella(elemento => 'Bonus');
		gui.chiudiheadertabella;
		for busta_paga in (
			select data, importo, bonus
			from BUSTEPAGA b
			where (b.FK_DIPENDENTE = SessionHandler.GETIDUSER(r_IdSessione))
			and ( ( trunc(b.Data) = to_date(r_data,'YYYY-MM-DD') ) or r_data is null )
			and ( b.Importo = to_number(r_importo) or r_importo is null )
			and ( b.Bonus = to_number(r_bonus) or r_bonus is null)
			order by data desc
		) loop
			gui.aggiungirigatabella;
			gui.aggiungielementotabella(elemento => busta_paga.data);
			gui.aggiungielementotabella(elemento => busta_paga.importo);
			gui.aggiungielementotabella(elemento => busta_paga.bonus);
			gui.chiudirigatabella;
		end loop;

		gui.chiuditabella();
		gui.chiudibody();

	end visualizzabustepagadipendente;

	procedure visualizzaRicarica (
		r_cliente in varchar2 default null,
		r_data    in varchar2 default null,
		r_importo in varchar2 default null
	) is
	begin
		gui.apripagina('VisualizzaRicarica');
		gui.apriformfiltro('http://131.114.73.203:8080/apex/l_bindi.OperazioniClienti.visualizzaRicarica');
		gui.aggiungicampoformfiltro(nome => 'r_Cliente', placeholder => 'Cliente');
		gui.aggiungicampoformfiltro(nome => 'r_Importo', placeholder => 'Importo');
		gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
		gui.aggiungicampoformfiltro('submit', '', 'Filtra', '');
		htp.prn('<br>');
		gui.chiudiformfiltro;

		gui.apritabella;
		gui.apriheadertabella;
		gui.aggiungiheadertabella(elemento => 'IDricarica');
		gui.aggiungiheadertabella(elemento => 'Cliente');
		gui.aggiungiheadertabella(elemento => 'Importo');
		gui.aggiungiheadertabella(elemento => 'Data');
		gui.chiudiheadertabella;
		gui.apribodytabella();
        
		for ricarica in (
			select *
            from RICARICHE
			where ( RICARICHE.FK_cliente = r_cliente or r_cliente is null )
			and ( ( trunc(RICARICHE.Data) = to_date(r_data,'YYYY-MM-DD') ) or r_data is null )
			and ( RICARICHE.Importo = to_number(r_importo) or r_importo is null )
		) loop
			gui.aggiungirigatabella;
			gui.aggiungielementotabella(elemento => ricarica.idricarica);
			gui.aggiungielementotabella(elemento => ricarica.fk_cliente);
			gui.aggiungielementotabella(elemento => ricarica.importo);
			gui.aggiungielementotabella(elemento => ricarica.data);
			gui.aggiungipulsanteintabella('.','.');
			gui.chiudirigatabella;
		end loop;

		gui.chiuditabella();
		gui.chiudibody();
	end visualizzaricarica;


	procedure visualizzaRicaricheCliente (
        r_IdSessione in varchar2 default null,
		r_data    in varchar2 default null,
		r_importo in varchar2 default null
	) is
	begin

        gui.apripagina('VisualizzaRicaricheCliente');
		gui.apriformfiltro('http://131.114.73.203:8080/apex/l_bindi.OperazioniClienti.visualizzaRicaricheCliente');
		htp.prn('<input type = "hidden" name = "r_IdSessione" value="'||r_IdSessione||'">');
		gui.aggiungicampoformfiltro(nome => 'r_Importo', placeholder => 'Importo');
		gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
        gui.aggiungicampoformfiltro('submit', '', 'Filtra', '');
		htp.prn('<br>');
		gui.chiudiformfiltro;

		gui.apritabella;
		gui.apriheadertabella;
        gui.aggiungiheadertabella(elemento => 'Identificativo');
		gui.aggiungiheadertabella(elemento => 'Importo');
		gui.aggiungiheadertabella(elemento => 'Data');
		gui.chiudiheadertabella;
        gui.apribodytabella();

		for ricarica in (
			select IDricarica, Importo, Data
			from RICARICHE r
			where (r.FK_cliente = SessionHandler.GETIDUSER(r_IdSessione))
            and ( ( trunc(r.Data) = to_date(r_data,'YYYY-MM-DD') ) or r_data is null )
			and ( r.Importo = to_number(r_importo) or r_importo is null )
			order by data desc
		) loop
			gui.aggiungirigatabella;
			gui.aggiungielementotabella(elemento => ricarica.IDricarica);
			gui.aggiungielementotabella(elemento => ricarica.Importo);
			gui.aggiungielementotabella(elemento => ricarica.Data);
			gui.chiudirigatabella;
		end loop;

        gui.chiuditabella();
		gui.chiudibody();
	end visualizzaricarichecliente;

    procedure registrazioneCliente IS
    BEGIN
    gui.APRIPAGINA('Registrazione');
    gui.AGGIUNGIFORM;  

        gui.AGGIUNGIRIGAFORM;   
            gui.aggiungiIntestazione(testo => 'Registrazione', dimensione => 'h2');
            gui.AGGIUNGIGRUPPOINPUT; 
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-user', nome => 'Nome', placeholder => 'Nome');        
                gui.AGGIUNGICAMPOFORM (classeIcona => 'fa fa-user', nome => 'Cognome', placeholder => 'Cognome');        
                gui.AGGIUNGICAMPOFORM (tipo => 'email', classeIcona => 'fa fa-envelope', nome => 'Email', placeholder => 'Indirizzo Email');   
                gui.AGGIUNGICAMPOFORM (tipo => 'password', classeIcona => 'fa fa-key', nome => 'Password', placeholder => 'Password'); 
                gui.AGGIUNGICAMPOFORM (tipo => 'password', classeIcona => 'fa fa-phone', nome => 'Telefono', placeholder => 'Telefono'); 
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
                        gui.AGGIUNGIINPUT (nome => 'gender', classe => '', ident => 'gender-male', tipo => 'radio');
                        gui.AGGIUNGILABEL (target => 'gender-male', testo => 'Maschio');  
                        gui.AGGIUNGIINPUT (nome => 'gender', classe => '', ident => 'gender-female',    tipo => 'radio');
                        gui.AGGIUNGILABEL (target => 'gender-female', testo => 'Femmina'); 
                    gui.CHIUDIGRUPPOINPUT;  
            gui.CHIUDIDIV;
        gui.CHIUDIRIGAFORM; 

        gui.AGGIUNGIRIGAFORM;
            gui.AGGIUNGIGRUPPOINPUT; 
                gui.AGGIUNGIBOTTONESUBMIT (nome => 'Registra', value => 'Registra'); 
            gui.CHIUDIGRUPPOINPUT; 
        gui.CHIUDIRIGAFORM; 

    gui.CHIUDIFORM; 
    END registrazioneCliente; 

    
  procedure visualizzazioneClienti IS
    /*DECLARE

    TYPE array_di_stringhe IS VARRAY(10) OF VARCHAR2(100);
    */

    BEGIN
   gui.apriPagina;     
   gui.APRITABELLA; 
   gui.APRIHEADERTABELLA;
   gui.AGGIUNGIHEADERTABELLA(elemento => 'IDCliente');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Nome'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Cognome'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'DataNascita'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Sesso');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'NTelefono');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Email');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Stato');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Saldo');

   gui.CHIUDIHEADERTABELLA; 

   for clienti IN
   (SELECT IDCliente, Nome, Cognome, DataNascita, Sesso, Ntelefono, Email, Stato, Saldo FROM Clienti) 
   LOOP
    gui.AGGIUNGIRIGATABELLA; 

            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.IDCliente);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.nome);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Cognome);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.DataNascita);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Sesso);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Ntelefono);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Email);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Stato);
            gui.AGGIUNGIELEMENTOTABELLA(elemento => clienti.Saldo);
            gui.AGGIUNGIPULSANTEINTABELLA('null', '.');


    gui.ChiudiRigaTabella;

    end LOOP;
      
END visualizzazioneClienti; 

procedure visualizzazioneConvenzioni (DataInizio VARCHAR2 DEFAULT NULL,
    DataFine VARCHAR2 DEFAULT NULL,
    Ente VARCHAR2 DEFAULT NULL
    /*cumulabile*/) is      
BEGIN

   gui.apriPagina;
   htp.prn('<br>');
   gui.APRIFORMFILTRO(azione => 'GET'); 

   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataInizio', placeholder => 'Data-inizio'); 
   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataFine', placeholder => 'Data-fine');  
   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'Submit', tipo => 'submit', value => 'Filtra');

   gui.CHIUDIFORMFILTRO; 

   htp.prn('<br>'); 

   gui.APRITABELLA; 
   gui.APRIHEADERTABELLA;
   gui.AGGIUNGIHEADERTABELLA(elemento => 'IDConvenzione');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Nome'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Ente'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Sconto'); 
   gui.AGGIUNGIHEADERTABELLA(elemento => 'CodiceAccesso');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'DataInizio');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'DataFine');
   gui.AGGIUNGIHEADERTABELLA(elemento => 'Cumulabile');

   gui.CHIUDIHEADERTABELLA; 

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

    END visualizzazioneConvenzioni; 


end operazioniClienti; 
