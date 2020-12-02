%{
	#include<stdio.h>
	#include <string.h>
	#include "2.tab.h"
	#include<stdlib.h>
	

%}
 
identifiers [a-zA-Z]([a-zA-Z0-9])*
single_line_comment [#].*
multiple_line_comment [ ]*[~]['][a-zA-Z0-9!@#*(){}_+-,.:\|?><\n\t ]*['][~]
/*RE and Action*/

%%

{multiple_line_comment} {
	printf("multiple_line_comment\n");
}

{single_line_comment} {
	printf("single line comment\n");

}

"void"	{return VOID;}
"main"	{return MAIN;}
"++"   {return inc;}
"--"	{return dec;}

"!"	{return not;}

"("	{ return *yytext; }
")"	{ return *yytext; }
","	{ return *yytext; }
";"	{ return *yytext; }
"{"	{return *yytext;}
"}"	{return *yytext;}
"="	{return *yytext;}



[-+/*]     { return *yytext; }

"break"    {   return BREAK;     }
"case"      { return CASE;      }
"switch"      { return SWITCH;	}
"default"     {  return DEFAULT; 	}


"int"	{ return INT; }
"float"	{ return FLOAT; }
"char"	{ return CHAR; }
":"     { return COL;}

"for"   { return FOR;}	
"while" { return WHILE;}


"pow"	{ return POW; }
"fact"	{ return FACT; }

">"	{ return GT; }
"<"	{ return LT; }


"if"		{ return IF;}
"else"		{ return ELSE;}
"elif"	{ return ELIF; }

"function "[A-Za-z]+	{ return FUNCTION; }
"func "[A-Za-z]+	{return funct;}

[0-9]+	{ 
		yylval.number = atoi(yytext);
		return NUM;
	}

{identifiers} {
	 yylval.string=strdup(yytext);
	 return VAR;
	}

	




[ \t]   ;       /* skip whitespace */
[ \n]	;
	

.	{
		yyerror("Unknown Character.\n");
	}
%%

/* user subroutines */

int main()
{
	yyin = freopen("in.txt","r",stdin);
	yyout = freopen("out.txt","w",stdout);
	yyparse();
	
}

