create or replace PACKAGE operazioniClienti as


      /*  u_user CONSTANT VARCHAR(20):='a_cucchiara'; 
        u_root CONSTANT VARCHAR(20):=u_user||'.operazioniClienti';
    */
    --capire bene come mai l'integrazione delle costanti causa errori nel pkb
    --ho riprovato e ancora non va 

procedure registrazioneCliente; 
PROCEDURE inserisciDati (Nome VARCHAR2 DEFAULT NULL, Cognome VARCHAR2 DEFAULT NULL, Email VARCHAR2 DEFAULT NULL, Password VARCHAR2 DEFAULT NULL, Telefono VARCHAR2 DEFAULT NULL, Day VARCHAR2 DEFAULT NULL, Month VARCHAR2 DEFAULT NULL, Year VARCHAR2 DEFAULT NULL, Gender VARCHAR2 DEFAULT NULL);
procedure modificaCliente;
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
procedure visualizzazioneConvenzioni (DataInizio VARCHAR2 DEFAULT NULL,
    DataFine VARCHAR2 DEFAULT NULL, 
    Ente VARCHAR2 DEFAULT NULL);

end operazioniClienti; 