    CREATE OR REPLACE PACKAGE operazioniClienti AS
    /*
        user CONSTANT VARCHAR(20):='g_giannessi'; 
        root CONSTANT VARCHAR(20):=user||'.operazioniClienti';
    */
    --capire bene come mai l'integrazione delle costanti causa errori nel pkb

        PROCEDURE registrazioneCliente; 
        PROCEDURE inserisciDati (Nome VARCHAR2 DEFAULT NULL, Cognome VARCHAR2 DEFAULT NULL, Email VARCHAR2 DEFAULT NULL, Password VARCHAR2 DEFAULT NULL, Telefono VARCHAR2 DEFAULT NULL, Day VARCHAR2 DEFAULT NULL, Month VARCHAR2 DEFAULT NULL, Year VARCHAR2 DEFAULT NULL, Gender VARCHAR2 DEFAULT NULL);
        procedure modificaCliente;
        PROCEDURE visualizzaBustePaga; 
        PROCEDURE visualizzaBustePagaDipendente(IDDipendente NUMBER); 
        PROCEDURE visualizzaRicarica(r_Cliente IN VARCHAR2 DEFAULT NULL, r_Data IN VARCHAR2 DEFAULT NULL, r_Importo IN VARCHAR2 DEFAULT NULL); 
        PROCEDURE visualizzaRicaricheCliente(IDcliente NUMBER); 
        PROCEDURE visualizzazioneClienti;
        PROCEDURE visualizzazioneConvenzioni (DataInizio VARCHAR2 DEFAULT NULL,
                                            DataFine VARCHAR2 DEFAULT NULL, 
                                            Ente VARCHAR2 DEFAULT NULL);
        

    END operazioniClienti;
