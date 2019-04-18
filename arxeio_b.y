%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#define YYSTYPE char*
#define YYDEBUG 1

int yylex(void);
void yyerror(char*);
void checkID(char*);
void checkTable();
extern FILE *yyin;
extern FILE *yyout;
extern int lineNumber;
int errorCount = 0;
extern char* yytext;
int i=0;
char* A[100];
void checkStyleID(char *);
int ColumnCount=0;
int ExpandedCount=-1;
int RowCount=0;
int ExpandedRowCount=-1;
%}

%start program
%token WORKBOOK EWORKBOOK
%token STYLES ESTYLES STYLE ESTYLE
%token WORKSHEET EWORKSHEET NAME PROTECTED
%token TABLE ETABLE EXPANDEDCOLUMN EXPANDEDROW STYLEID
%token COLUMN ECOLUMN HIDDEN WIDTH 
%token ROW EROW HEIGHT
%token CELL ECELL MERGEACROSS MERGEDOWN
%token DATA EDATA TYPE NUMBER DATETIME TBOOLEAN TSTRING
%token ALPHANUM
%token BOOLEAN
%token P_INT
%token TEXT
%token QM

%%

program: WORKBOOK content1 EWORKBOOK  {if (!errorCount){printf("%s\n%s\n%s\n", $1,$2,$3);fprintf(yyout,"%s\n%s\n%s\n", $1,$2,$3);}}
		;
				
content1: styles content1 {$$ = malloc(strlen($1) + strlen($2) + 1);sprintf($$, "%s%s", $1, $2);}
		| content2 
		;

content2: worksheet content2 {$$ = malloc(strlen($1) + strlen($2) + 1);sprintf($$, "%s%s", $1, $2);}
		| worksheet
		;

styles: STYLES style ESTYLES {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 6);sprintf($$, "\t%s\n%s\t%s\n", $1, $2, $3);}
		;

style: STYLE ALPHANUM ESTYLE {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 4);sprintf($$, "\t\t%s%s%s\n", $1, $2, $3);checkID($2);}
		| STYLE ALPHANUM ESTYLE style {$$ = malloc(strlen($1) + strlen($2)+ strlen($3)+ strlen($4) + 4);sprintf($$, "\t\t%s%s%s\n%s", $1, $2, $3, $4);checkID($2);}
		| /*nothing*/{$$="";}
		;

worksheet: WORKSHEET worksheetattributes '>' tables EWORKSHEET {$$ = malloc(strlen($1) + strlen($2)+ strlen($3)+ strlen($4) + strlen($5) + 5);sprintf($$, "\t%s%s%s\n%s\n\t%s", $1, $2, $3, $4, $5);}
			;

worksheetattributes: NAME ALPHANUM QM{$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
					|NAME ALPHANUM QM  PROTECTED BOOLEAN QM {$$ = malloc(strlen($1) + strlen($2)+ strlen($3)+ strlen($4) + strlen($5) + strlen($6)+ 1);sprintf($$, "%s%s%s%s%s%s", $1, $2, $3,$4,$5,$6);}
					;



tables: table tables {$$ = malloc(strlen($1) + strlen($2) + 1);sprintf($$, "%s%s", $1, $2);}
		| /*nothing*/{$$="";}
		;

table: TABLE tableattributes '>' tablecontent ETABLE {$$ = malloc(strlen($1) + strlen($2)+ strlen($3)+ strlen($4) + strlen($5) + 7);sprintf($$, "\t\t%s%s%s\n%s\n\t\t%s", $1, $2, $3, $4, $5);checkTable();}
		;

tableattributes: t_att1 t_att2 t_att3 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);strcpy($$, $1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| t_att1 t_att3 t_att2 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);strcpy($$, $1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| t_att2 t_att1 t_att3 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);strcpy($$, $1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| t_att2 t_att3 t_att1 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);strcpy($$, $1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| t_att3 t_att1 t_att2 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);strcpy($$, $1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| t_att3 t_att2 t_att1 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);strcpy($$, $1);sprintf($$, "%s%s%s", $1, $2, $3);}
				;

t_att1: EXPANDEDCOLUMN P_INT QM {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);ExpandedCount=atoi($2);}
		| /*nothing*/{$$="";}
		;

t_att2: EXPANDEDROW P_INT QM  {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);ExpandedRowCount=atoi($2);}
		| /*nothing*/{$$="";}
		;
		
t_att3: STYLEID ALPHANUM QM {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);checkStyleID($2);}
		| /*nothing*/{$$="";}
		;		

tablecontent: columns rows {$$ = malloc(strlen($1) + strlen($2) + 1);strcpy($$, $1);sprintf($$, "%s%s", $1, $2);}
			;

columns: column columns {$$ = malloc(strlen($1) + strlen($2) + 1);strcpy($$, $1);sprintf($$, "%s%s", $1, $2);}
		| /*nothing*/{$$="";}
		;
		
column : COLUMN columnattributes ECOLUMN {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 5);sprintf($$, "\t\t\t%s%s%s\n", $1, $2, $3);ColumnCount++;}
		;

columnattributes: c_att1 c_att2 c_att3 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| c_att1 c_att3 c_att2 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| c_att2 c_att1 c_att3 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| c_att2 c_att3 c_att1 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| c_att3 c_att1 c_att2 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| c_att3 c_att2 c_att1 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				;

c_att1: HIDDEN BOOLEAN QM {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
		| /*nothing*/{$$="";}
		;

c_att2: WIDTH P_INT QM {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
		| /*nothing*/{$$="";}
		;
		
c_att3: STYLEID ALPHANUM QM {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);checkStyleID($2);}
		| /*nothing*/{$$="";}
		;

rows: row rows {$$ = malloc(strlen($1) + strlen($2)+ 1);sprintf($$, "%s%s", $1, $2);}
	| /*nothing*/{$$="";}
	;

row: ROW rowattributes '>' rowcontent EROW {$$ = malloc(strlen($1) + strlen($2)+ strlen($3)+ strlen($4) + strlen($5) + 9);sprintf($$, "\t\t\t%s%s%s%s\n\t\t\t%s", $1, $2, $3, $4, $5);RowCount++;}
	;
	
rowattributes: r_att1 r_att2 r_att3 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| r_att1 r_att3 r_att2 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| r_att2 r_att1 r_att3 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| r_att2 r_att3 r_att1 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| r_att3 r_att1 r_att2 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| r_att3 r_att2 r_att1 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				;
			
r_att1: HEIGHT P_INT QM {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
		| /*nothing*/{$$="";}
		;
		
r_att2: HIDDEN BOOLEAN QM {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
		| /*nothing*/{$$="";}
		;
		
r_att3: STYLEID ALPHANUM QM {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);checkStyleID($2);}
		| /*nothing*/{$$="";}
		;

rowcontent: cell rowcontent {$$ = malloc(strlen($1) + strlen($2)+ 1);sprintf($$, "%s%s", $1, $2);}
			| /*nothing*/{$$="";}
			;

cell: CELL cellattributes '>' cellcontent ECELL {$$ = malloc(strlen($1) + strlen($2)+ strlen($3)+ strlen($4) + strlen($5) + 12);sprintf($$, "\n\t\t\t\t%s%s%s\n%s\n\t\t\t\t%s", $1, $2, $3, $4, $5);}
	;
	
cellattributes: cell_att1 cell_att2 cell_att3 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| cell_att1 cell_att3 cell_att2 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| cell_att2 cell_att1 cell_att3{$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| cell_att2 cell_att3 cell_att1 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| cell_att3 cell_att1 cell_att2 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				| cell_att3 cell_att2 cell_att1 {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
				;

cell_att1: MERGEACROSS P_INT QM {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
| /*nothing*/{$$="";}
			;

cell_att2: MERGEDOWN P_INT QM {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);}
| /*nothing*/{$$="";}
			;

cell_att3:  STYLEID ALPHANUM QM {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);sprintf($$, "%s%s%s", $1, $2, $3);checkStyleID($2);}
		| /*nothing*/{$$="";}
			;
			
cellcontent: data cellcontent {$$ = malloc(strlen($1) + strlen($2)+ 1);sprintf($$, "%s%s", $1, $2);}
			| /*nothing*/{$$="";}
			;

data: DATA dataattribute '>' Datacontent EDATA  {$$ = malloc(strlen($1) + strlen($2)+ strlen($3)+ strlen($4) + strlen($5) + 6);sprintf($$, "\t\t\t\t\t%s%s%s%s%s", $1, $2, $3, $4, $5);}
	;
	
Datacontent: P_INT 
|TEXT 
|ALPHANUM 

dataattribute: TYPE options QM {$$ = malloc(strlen($1) + strlen($2)+ strlen($3) + 1);strcpy($$, $1);strcat($$, $2);strcat($$, $3);}
				;

options: NUMBER 
| DATETIME  
| TBOOLEAN 
| TSTRING 
		;
		
%%

void yyerror(char *errmsg) {
	errorCount++;
    printf("Error:%s in line: %d\n",errmsg,lineNumber);
}									

int main ( int argc, char **argv  ) 
{
  ++argv; --argc;
  if ( argc > 0 ){
		yyin = fopen( argv[0], "r" );
		//yydebug=1;
		lineNumber=1;
		yyout=fopen("output.txt","w");
		yyparse ();		
		lineNumber++;
		if(errorCount==0){
		printf("\n Completed without errors");	
		}
	}	
  else{
		 printf("You must insert a file\n");
 }
 
 
  return 0;  
}


void checkID(char *id){	
	int found=0;
	for (int j=0;j<i;j++){
		if(!strcmp(id,A[j])){
			found=1;
		}
	}
	if(found==1){
		errorCount++;
		printf("Error: The value ss:ID=%s in ss:Style should be Unique!\n\n", id);
	}
	else if(found==0){
		 A[i]=id;
		 i++;
	}
}

void checkStyleID(char *id){
	int found=0;
	for (int j=0;j<i;j++){
		if(!strcmp(id,A[j])){
			found=1;
			break;
		}
	}
	if(!found){
		errorCount++;
		printf("ErrorStyleID: There is no ID with value %s \n\n",id);
	}
}

void checkTable(){
	if(ColumnCount!=ExpandedCount&& ExpandedCount!=-1){
		errorCount++;
		printf("Error: The number of ss:Column is %i but the value of ss:ExpandedColumnCount is %i\n",ColumnCount,ExpandedCount);
	}
	if(RowCount!=ExpandedRowCount&& ExpandedRowCount!=-1){
		errorCount++;
		printf("Error: The number of ss:Row is %i but the value of ss:ExpandedRowCount is %i\n",RowCount,ExpandedRowCount);
	}
	ColumnCount=0;
	ExpandedCount=-1;
	RowCount=0;
	ExpandedRowCount=-1;
}
	
	
	
  




