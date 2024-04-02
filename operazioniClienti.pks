CREATE OR REPLACE PACKAGE operazioniClienti AS

    u_user CONSTANT VARCHAR2(20) := 'g_giannessi'; 
    u_root CONSTANT VARCHAR2(20) := u_user || '.operazioniClienti';

    PROCEDURE registrazioneCliente; 
    PROCEDURE visualizzaBustePaga; 
    PROCEDURE visualizzaBustePagaDipendente(IDDipendente NUMBER); 
    PROCEDURE visualizzaRicarica(r_Cliente IN VARCHAR2 DEFAULT NULL, r_Data IN VARCHAR2 DEFAULT NULL, r_Importo IN VARCHAR2 DEFAULT NULL); 
    PROCEDURE visualizzaRicaricheCliente(IDcliente NUMBER); 
    PROCEDURE visualizzazioneClienti;
    PROCEDURE visualizzazioneConvenzioni (DataInizio VARCHAR2 DEFAULT NULL,
                                          DataFine VARCHAR2 DEFAULT NULL, 
                                          Ente VARCHAR2 DEFAULT NULL);

END operazioniClienti;
