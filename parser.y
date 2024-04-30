%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
extern int yylex();
void yyerror(const char *s);
%}

%locations
%union {
    int intVr;
    char* identifier;
    int boolVr;
    double doubleVr;
}
%start Program
%type<intVr,doubleVr,boolVr> expr
%token<intVr> NUM_TK
%token<doubleVr> DOUBLE_TK
%token<identifier> STRING_TK
%token<boolVr> BOOL_TK
%token<identifier> ID_TK
%token LET_TK IN_TK END_TK
%token SKIP_TK IF_TK THEN_TK ELSE_TK FI_TK WHILE_TK DO_TK
%token READ_TK WRITE_TK ASSIG_TK INT_TK


%left '='
%left '<' '>'
%left '+' '-'
%left '*' '/' '%'
%right '^'
%left '||' '&'
%left '!'

%%

Program : LET_TK Declarations IN_TK Command_sequence END_TK                         {  }
;

Declarations : Declaration ';' Declarations
    |          Declaration ';'
    ;



Declaration : INT_TK Id_seq ID_TK                                                   {  }
    | DOUBLE_TK Id_seq ID_TK                                                        {  }
    | STRING_TK Id_seq ID_TK                                                        {  }
;  

Id_seq : Id_seq ID_TK ','                                                           {  }
    | 
;

Command_sequence : Command_sequence Command                                         {  }
    | 
;

Command : SKIP_TK ';'                                                               {  }
    | ID_TK ASSIG_TK expr ';'                                                       {  }
    | IF_TK expr THEN_TK Command_sequence ELSE_TK Command_sequence FI_TK ';'        {  }
    | WHILE_TK expr DO_TK Command_sequence END_TK ';'                               {  }
    | READ_TK ID_TK ';'                                                             {  }
    | WRITE_TK expr ';'                                                             {  }
;

 
expr :  expr '||' expr      {  }
        |expr '=' expr      {  }
        | expr '<' expr     {  }
        | expr '>' expr     {  }
        | expr '+' expr     {  }
        | expr '-' expr     {  }
        | expr '*' expr     {  }
        | expr '/' expr     {  }
        | expr '%' expr     {  }
        | expr '^' expr     {  }
        | expr '>''=' expr  {  }
        | expr '<''=' expr  {  }
        | expr '=''=' expr  {  }
        | expr '!''=' expr  {  }
        | '!' expr          {  }
        | expr '&''&' expr  {  }
        | '(' expr ')'      {  }
        | NUM_TK            {  }
        | DOUBLE_TK         {  }
        | STRING_TK         {  }
        | ID_TK             {  }
        | BOOL_TK           {  }
;
 
%%

int main(){

    if(yyparse() == 0) {
        printf("The program has successfully completed its work!\n");
    }
    else {
        printf("The program failed!\n");
    }

    return 0;

}

void yyerror(const char* msg) {
    fprintf(stderr, "The error is at position (%d, %d), please check. -> %s\n", yylloc.first_line, yylloc.first_column, msg);
}
