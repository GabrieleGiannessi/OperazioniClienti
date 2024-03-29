create or replace PACKAGE operazioniClienti as

procedure visualizzaBustePaga(
        r_Dipendente in varchar2 default null,
        r_Contabile in varchar2 default null,
	r_data    in varchar2 default null,
	r_importo in varchar2 default null,
        r_bonus in varchar2 default null); 
procedure visualizzaBustePagaDipendente(
        r_IdSessione in varchar2 default null,
	r_data    in varchar2 default null,
	r_importo in varchar2 default null,
        r_bonus in varchar2 default null); 
procedure visualizzaRicarica( r_Cliente in varchar2 default null,
        r_Data in varchar2 default null,
        r_Importo in varchar2 default null); 
procedure visualizzaRicaricheCliente(r_IdSessione in varchar2 default null,
		r_data    in varchar2 default null,
		r_importo in varchar2 default null); 
procedure visualizzazioneClienti;
procedure visualizzazioneConvenzioni;



end operazioniClienti; 