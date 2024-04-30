%{
#include "parser.tab.h"
#include <string.h>
#include <stdbool.h>

int yycolumn = 1;
#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = yycolumn; yylloc.last_column = yycolumn + yyleng - 1; \
    yycolumn += yyleng;

%}

%x SINGLELINE_COMMENT
%x MULTILINE_COMMENT

%option noyywrap
%option yylineno 

%%

"LET"                                   { return LET_TK;    }

"IN"                                    { return IN_TK;     }

"END"                                   { return END_TK;    }

"INT"                                   { return INT_TK;    }

"STRING"                                { return STRING_TK; }

"DOUBLE"                                { return DOUBLE_TK; }

"BOOL"                                  { return BOOL_TK;   }

"SKIP"                                  { return SKIP_TK;   }

"IF"                                    { return IF_TK;     }

"THEN"                                  { return THEN_TK;   }

"ELSE"                                  { return ELSE_TK;   }

"FI"                                    { return FI_TK;     }

"WHILE"                                 { return WHILE_TK;  }

"DO"                                    { return DO_TK;     }

"READ"                                  { return READ_TK;  }

"WRITE"                                 { return WRITE_TK; }

":="                                    { return ASSIG_TK; }   


([A-Za-z][A-Za-z0-9_]*)                 {
                                            yylval.identifier = strdup(yytext);
                                            if (strcasecmp(yytext, "true") == 0) {
                                                yylval.boolVr = 1;
                                                return BOOL_TK;
                                            } else if (strcasecmp(yytext, "false") == 0) {
                                                yylval.boolVr = 0;
                                                return BOOL_TK;
                                            } else {
                                                return ID_TK;
                                            }
                                        }

[0-9][0-9]*                             {
                                            yylval.intVr = atoi(yytext);
                                            return NUM_TK;
                                        }

(0x|0X)[0-9A-Fa-f]+                      {
                                            yylval.intVr = strtol(yytext, NULL, 16);
                                            return NUM_TK;  
                                        }

(0x|0X)?[0-9A-Fa-f]+(\.[0-9A-Fa-f]*)?([pP][+-]?\d+)? {
                                            yylval.doubleVr = strtod(yytext, NULL);
                                            return DOUBLE_TK;
                                        }

\"([^\"\\\n]|\\.)*\"                    {
                                            yylval.identifier = strdup(yytext);
                                            return STRING_TK;
                                        }


[ \t]                                   { }

\n                                      { yycolumn=1;               }

"//"                                    { BEGIN(SINGLELINE_COMMENT);      }

"/*"                                    { BEGIN(MULTILINE_COMMENT); }

.                                       { return yytext[0];         }

<SINGLELINE_COMMENT>{

\n                                      { BEGIN(INITIAL);           }

.                                       { }

}


<MULTILINE_COMMENT>{

"*/"                                    { BEGIN(INITIAL);            }

.                                       { }

\n                                      { }

}

%%
