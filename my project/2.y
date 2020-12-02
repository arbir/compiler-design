%{
	#include<stdio.h>
	#include <math.h>
	int cnt=1,cntt=0,val,track=0;
	typedef struct entry {
    	char *str;
    	int n;
	}storage;
	storage store[1000],sym[1000];
	void insert (storage *p, char *s, int n);
	int cnt2=1; 
	void insert2 (storage *p, char *s, int n);
	#define pi  3.1416
	
%}
%union 
{
        int number;
        char *string;
}
/* BISON Declarations */

%token <number> NUM
%token <string> VAR 
%token <string> VOID MAIN IF ELIF ELSE FUNCTION INT FLOAT CHAR  POW FACT FOR COL WHILE BREAK COLON DEFAULT CASE SWITCH inc dec not funct 
%type <string> statement
%type <number> expression
%type <number> switch_expression
%nonassoc IFX
%nonassoc ELIFX
%nonassoc ELSE
%left LT GT
%left '+' '-'
%left '*' '/'
%left FACT
%right POW

/* Simple grammar rules */

%%

program: VOID MAIN '(' ')' '{' cstatement '}' { printf("\nSuccessful compilation\n"); }
	 ;

cstatement: /* empty */

	| cstatement statement
	
	| cdeclaration
	;

cdeclaration:	TYPE ID1 ';'	{ printf("\nvalid declaration\n"); }
   
			;
			
TYPE : INT

     | FLOAT

     | CHAR
     ;

ID1  : ID1 ',' VAR	{
						if(number_for_key($3))
						{
							printf("%s is already declared\n", $3 );
						}
						else
						{
							insert(&store[cnt],$3, cnt);
							cnt++;
							
						}
			}

     |VAR	{
				if(number_for_key($1))
				{
					printf("%s is already declared\n", $1 );
				}
				else
				{
					insert(&store[cnt],$1, cnt);
							cnt++;
				}
			}
     ;

statement: ';'
	| SWITCH '(' switch_expression ')' '{' BASE '}'    {printf("SWITCH case.\n");} 

	| expression ';' 			{ printf("\nvalue of expression: %d\n", ($1)); }

        | VAR '=' expression ';' 		{
							if(number_for_key($1)){
								int i = number_for_key2($1);
								if (!i){
									insert(&sym[cntt], $1, $3);
									cntt++;
								}
								sym[i].n = $3;
								printf("\n(%s) Value of the variable: %d\t\n",$1,$3);
							}
							else {
								printf("%s not declared yet\n",$1);
							}
							
						}

	| IF '(' expression ')' '{' expression ';' '}' %prec IFX {
								if($3)
								{
									printf("\nvalue of expression in IF: %d\n",($6));
								}
								else
								{
									printf("\ncondition value zero in IF block\n");
								}
							}

	| IF '(' expression ')' '{' expression ';' '}' ELSE '{' expression ';' '}' {
								 	if($3)
									{
										printf("\nvalue of expression in IF: %d\n",$6);
									}
									else
									{
										printf("\nvalue of expression in ELSE: %d\n",$11);
									}
								   }
	| IF '(' expression ')' '{' IF '(' expression ')' '{' expression ';' '}' ELSE '{' expression ';' '}' expression ';' '}' ELSE '{' expression ';' '}' %prec IFX {
								 	if($3)
									{
										if($8)
											printf("\nvalue of expression middle IF: %d\n",$11);
										else
											printf("\nvalue of expression middle ELSE: %d\n",$16);
										printf("\nvalue of expression in first IF: %d\n",$19);
									}
									else
									{
										printf("\nvalue of expression in else: %d\n",$24);
									}
								   }
	| IF '(' expression ')' '{' expression ';' '}' ELIF '(' expression ')' '{' expression ';' '}' ELSE '{' expression ';' '}' {
								 	if($3)
									{
										printf("\nvalue of expression in IF: %d\n",$6);
									}
									else if($11)
									{
										printf("\nvalue of expression in ELIF: %d\n",$14);
									}
									else
									{
										printf("\nvalue of expression in ELSE: %d\n",$19);
									}
								   }							   
	| FOR '(' NUM COL NUM ')' '{' expression '}'     {
	   int i=0;
	   for(i=$3;i<$5;i++){
	   printf("for loop statement\n");
	   }
	}
	| WHILE '(' NUM GT NUM ')' '{' expression '}'   {
										if($3>$5)
										{
										int i;
										printf("While LOOP: ");
										for(i=$5;i<=$3;i++)
										{
											printf("%d ",i);
										}
										printf("\n");
										printf("value of the expression: %d\n",$8);

										}
	}
/*------function begin-----------*/

	| funct func
	;

			func : COL TYPE '(' ')' '{' statement '}'
							{
								printf("Function Declared\n");
							}
				;


/*-------function end------------*/
	
///////////////////////
	
			BASE : Bas   
				 | Bas Dflt 
				 ;

			Bas   : /*NULL*/
				 | Bas Cs     
				 ;

			Cs    : CASE NUM COL expression ';'   {
						
						if(val==$2){
							  track=1;
							  printf("\nCase No : %d  and Result :  %d\n",$2,$4);
						}
					}
				 ;

			Dflt    : DEFAULT COL expression ';'    {
						if(track!=1){
							printf("\nResult in default Value is :  %d\n",$3);
						}
						track=0;
					}
				 ;    
	/////////////////////////////
	
	
expression: NUM				{ $$ = $1;val = $$; 	}

	| VAR				{ $$ = number_for_key2($1);val = $$; printf("Variable value: %d",$$)}

	| expression '+' expression	{ $$ = $1 + $3;val = $$; }

	| expression '-' expression	{ $$ = $1 - $3;val = $$; }

	| expression '*' expression	{ $$ = $1 * $3;val = $$; }

	| expression '/' expression	{ 	if($3) 
				  		{
				     			$$ = $1 / $3;val = $$;
				  		}
				  		else
				  		{
							$$ = 0;val = $$;
							printf("\ndivision by zero\t");
				  		} 	
				    	}
	| expression POW expression { $$ = pow($1,$3);val = $$; }

	| expression FACT {
						int mult=1 ,i;
						for(i=$1;i>0;i--)
						{
							mult=mult*i;
						}
						$$=mult;val = $$;
						
					 }	

	| expression LT expression	{ $$ = $1 < $3;val = $$; }

	| expression GT expression	{ $$ = $1 > $3;val = $$; }

	| '(' expression ')'		{ $$ = $2;val = $$;	}
	
	| inc expression          { $$=$2+1; printf("inc: %d\n",$$);val = $$;}

	| dec expression          { $$=$2-1; printf("dec: %d\n",$$);val = $$;}

	| not expression  {
						if($2 != 0)
						{
							$$ = 0; printf("not: %d\n",$$);val = $$;
						}
						else{
							$$ = 1 ; printf("aff: %d\n",$$);val = $$;
						}
					}
	;

%%

//////////////////////////
void insert(storage *p, char *s, int n)
{
  p->str = s;
  p->n = n;
}

int number_for_key(char *key)
{
    int i = 1;
    char *name = store[i].str;
    while (name) {
        if (strcmp(name, key) == 0)
            return store[i].n;
        name = store[++i].str;
    }
    return 0;
}
/////////////////////////
void insert2 (storage *p, char *s, int n)
{
  p->str = s;
  p->n = n;
  
}

int number_for_key2(char *key)
{
    int i = 1;
    char *name = sym[i].str;
    while (name) {
        if (strcmp(name, key) == 0)
            return i;
        name = sym[++i].str;
    }
    return 0;
}

///////////////////////////


int yywrap()
{
return 1;
}


yyerror(char *s){
	printf( "%s\n", s);
}

