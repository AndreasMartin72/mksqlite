/*
 * mksqlite: A MATLAB Interface to SQLite
 *
 * (c) 2008-2014 by M. Kortmann <mail@kortmann.de>
 *               and A.Martin
 * distributed under LGPL
 */

#pragma once

/* (Error-) Messages */

#include "config.h"
#include "global.hpp"
#include "svn_revision.h" /* get the SVN revision number */
extern "C"
{
  #include "blosc/blosc.h"
}

/* Localization, declaration */

const char*   getMessage    ( int iMsgNr );
void          setLanguage   ( int iLang );
int           getLanguage   ();


#ifdef MAIN_MODULE

/* Implementations */

/*
 * a poor man localization.
 * every language have a table of messages.
 */

#define MSG_HELLO                0
#define MSG_INVALIDDBHANDLE      1
#define MSG_IMPOSSIBLE           2
#define MSG_USAGE                3
#define MSG_INVALIDARG           4
#define MSG_CLOSINGFILES         5
#define MSG_CANTCOPYSTRING       6
#define MSG_NOOPENARG            7
#define MSG_NOFREESLOT           8
#define MSG_CANTOPEN             9
#define MSG_DBNOTOPEN           10
#define MSG_INVQUERY            11
#define MSG_CANTCREATEOUTPUT    12
#define MSG_UNKNWNDBTYPE        13
#define MSG_BUSYTIMEOUTFAIL     14
#define MSG_MSGUNIQUEWARN       15
#define MSG_UNEXPECTEDARG       16
#define MSG_MISSINGARGL         17
#define MSG_ERRMEMORY           18
#define MSG_UNSUPPVARTYPE       19
#define MSG_UNSUPPTBH           20   
#define MSG_ERRPLATFORMDETECT   21
#define MSG_WARNDIFFARCH        22
#define MSG_BLOBTOOBIG          23
#define MSG_ERRCOMPRESSION      24
#define MSG_UNKCOMPRESSOR       25
#define MSG_ERRCOMPRARG         26
#define MSG_ERRCOMPRLOGMINVALS  27
#define MSG_ERRUNKOPENMODE      28
#define MSG_ERRUNKTHREADMODE    29
#define MSG_ERRCANTCLOSE        30
#define MSG_ERRCLOSEDBS         31
#define MSG_ERRNOTSUPPORTED     32
#define MSG_EXTENSION_EN        33
#define MSG_EXTENSION_DIS       34
#define MSG_EXTENSION_FAIL      35
#define MSG_MISSINGARG          36


/* 0 = english message table */
static const char* messages_0[] = 
{
    "mksqlite Version " MKSQLITE_VERSION_STRING " " SVNREV ", an interface from MATLAB to SQLite\n"
    "(c) 2008-2014 by Martin Kortmann <mail@kortmann.de>\n"
    "based on SQLite Version %s - http://www.sqlite.org\n"
    "mksqlite uses further:\n"
    " - DEELX perl compatible regex engine Version " DEELX_VERSION_STRING " (Sswater@gmail.com)\n"
    " - BLOSC/LZ4 " BLOSC_VERSION_STRING " compression algorithm (Francesc Alted / Yann Collett) \n"
    " - MD5 Message-Digest Algorithm (RFC 1321) implementation by Alexander Peslyak\n"
    "   \n"
    "UTF-8, parameter binding, regex and (compressed) typed BLOBs: A.Martin, 2014-01-23\n\n",
    
    "invalid database handle",
    "function not possible",
    "usage: mksqlite([dbid,] command [, databasefile])\n",
    "no or wrong argument",
    "mksqlite: closing open databases",
    "can\'t copy string in getstring()",
    "open without database name",
    "no free database handle available",
    "cannot open database (check access privileges and existence of database)",
    "database not open",
    "invalid query string (semicolon?)",
    "cannot create output matrix",
    "unknown SQLITE data type",
    "cannot set busy timeout",
    "could not build unique field name for %s",
    "unexpected arguments passed",
    "missing argument list",
    "memory allocation error",
    "unsupported variable type",
    "unknown/unsupported typed blob header",
    "error while detecting the type of computer you are using",
    "BLOB stored on different type of computer",
    "BLOB exceeds maximum allowed size",
    "error while compressing data",
    "unknown compressor",
    "chosen compressor accepts 'double' type only",
    "chosen compressor accepts positive values only",
    "unknown open modus (only 'ro', 'rw' or 'rwc' accepted)",
    "unknown threading mode (only 'single', 'multi' or 'serial' accepted)",
    "cannot close connection",
    "not all connections could be closed",
    "this Matlab version doesn't support this feature",
    "extension loading enabled for this db",
    "extension loading disabled for this db",
    "failed to set extension loading feature",
    "missing argument",
};


/* 1 = german message table */
static const char* messages_1[] = 
{
    "mksqlite Version " MKSQLITE_VERSION_STRING " " SVNREV ", ein MATLAB Interface zu SQLite\n"
    "(c) 2008-2014 by Martin Kortmann <mail@kortmann.de>\n"
    "basierend auf SQLite Version %s - http://www.sqlite.org\n"
    "mksqlite verwendet dar�berhinaus:\n"
    " - DEELX perl kompatible regex engine Version " DEELX_VERSION_STRING " (Sswater@gmail.com)\n"
    " - BLOSC/LZ4 " BLOSC_VERSION_STRING " zur Datenkompression (Francesc Alted / Yann Collett) \n"
    " - MD5 Message-Digest Algorithm (RFC 1321) Implementierung von Alexander Peslyak\n"
    "   \n"
    "UTF-8, parameter binding, regex und (komprimierte) typisierte BLOBs: A.Martin, 2014-01-23\n\n",
    
    "ung�ltiger Datenbankhandle",
    "Funktion nicht m�glich",
    "Verwendung: mksqlite([dbid,] Befehl [, Datenbankdatei])\n",
    "kein oder falsches Argument �bergeben",
    "mksqlite: Die noch ge�ffneten Datenbanken wurden geschlossen",
    "getstring() kann keine neue Zeichenkette erstellen",
    "Open Befehl ohne Datenbanknamen",
    "Kein freier Datenbankhandle verf�gbar",
    "Datenbank konnte nicht ge�ffnet werden (ggf. Zugriffsrechte oder Existenz der Datenbank pr�fen)",
    "Datenbank nicht ge�ffnet",
    "ung�ltiger query String (Semikolon?)",
    "Kann Ausgabematrix nicht erstellen",
    "unbekannter SQLITE Datentyp",
    "busytimeout konnte nicht gesetzt werden",
    "konnte keinen eindeutigen Bezeichner f�r Feld %s bilden",
    "Argumentliste zu lang",
    "keine Argumentliste angegeben",
    "Fehler bei Speichermanagement", 
    "Nicht unterst�tzter Variablentyp",
    "Unbekannter oder nicht unterst�tzter typisierter BLOB Header",
    "Fehler beim Identifizieren der Computerarchitektur",
    "BLOB wurde mit abweichender Computerarchitektur erstellt",
    "BLOB ist zu gro�",
    "Fehler w�hrend der Kompression aufgetreten",
    "unbekannte Komprimierung",
    "gew�hlter Kompressor erlaubt nur Datentyp 'double'",
    "gew�hlter Kompressor erlaubt nur positive Werte",
    "unbekannter Zugriffmodus (nur 'ro', 'rw' oder 'rwc' m�glich)",
    "unbekannter Threadingmodus (nur 'single', 'multi' oder 'serial' m�glich)",
    "die Datenbank kann nicht geschlossen werden",
    "nicht alle Datenbanken konnten geschlossen werden",
    "Feature wird von dieser Matlab Version nicht unterst�tzt",
    "DLL Erweiterungen f�r diese db aktiviert",
    "DLL Erweiterungen f�r diese db deaktiviert",
    "Einstellung f�r DLL Erweiterungen nicht m�glich",
    "Parameter fehlt",
};


/* Number of message table to use */
static int Language = -1;

/*
 * Message Tables
 */
static const char **messages[] = 
{
    messages_0,   /* English messages */
    messages_1    /* German messages  */
};

const char* getMsg( int iMsgNr )
{
    return messages[Language][iMsgNr];
}

void setLanguage( int iLang )
{
    Language = iLang;
}

int getLanguage()
{
    return Language;
}

#endif
