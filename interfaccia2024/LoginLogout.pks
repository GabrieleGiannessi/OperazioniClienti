create or replace PACKAGE LOGINLOGOUT AS
       URL CONSTANT varchar2(255):='a_cucchiara';
       procedure loginCliente(cEmail IN varchar2 DEFAULT null, password IN varchar2 DEFAULT null);
       procedure loginDipendente(cEmail IN varchar2 DEFAULT null, password IN varchar2 DEFAULT null, ruolo IN VARCHAR2 default null);
       function aggiungiSessione(
                 cEmail IN varchar2,
                 psw IN varchar2,
                 ruolo IN VARCHAR2
       )return int;
       function terminaSessione(
            idUser IN int,
            ruolo varchar2
       )return boolean;

END LOGINLOGOUT;