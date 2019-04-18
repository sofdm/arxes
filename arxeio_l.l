%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char*
#include "arxeio_b.tab.h"  
int lineNumber = 1;
%}


alphanum [0-9a-zA-Z]+
boolean (TRUE|FALSE) 
posint [1-9][0-9]*
text [ .!,;1-9a-zA-Z]+

%%

"<ss:Workbook>"  {yylval=strdup(yytext);return WORKBOOK ;}
"</ss:Workbook>"  {yylval=strdup(yytext);return EWORKBOOK ;}
"<ss:Styles>"   {yylval=strdup(yytext);return STYLES;}
"</ss:Styles>"   {yylval=strdup(yytext);return ESTYLES;}
"<ss:Style ss:ID=\""   {yylval=strdup(yytext); return STYLE ;}
"\"></ss:Style>"  {yylval=strdup(yytext);return ESTYLE;}
"<ss:Worksheet"  {yylval=strdup(yytext);return WORKSHEET ;}
"</ss:WorkSheet>"   {yylval=strdup(yytext);return EWORKSHEET ;}
">"   {yylval=strdup(yytext);return '>' ;}
" ss:Name=\""   {yylval=strdup(yytext);return NAME ;}
" ss:Protected=\""   {yylval=strdup(yytext);return PROTECTED;}
"<ss:Table"   {yylval=strdup(yytext);return TABLE;}
"</ss:Table>"   {yylval=strdup(yytext);return ETABLE;} 
" ss:ExpandedColumnCount=\""   {yylval=strdup(yytext);return EXPANDEDCOLUMN;}
" ss:ExpandedRowCount=\""   {yylval=strdup(yytext);return  EXPANDEDROW;}
" ss:StyleID=\""   {yylval=strdup(yytext);return STYLEID;}
"<ss:Column"   {yylval=strdup(yytext);return COLUMN ;}
"/>"   {yylval=strdup(yytext);return ECOLUMN;}
" ss:Hidden=\""  {yylval=strdup(yytext);return HIDDEN;}
" ss:Width=\""  {yylval=strdup(yytext);return WIDTH ;}
"<ss:Row"   {yylval=strdup(yytext);return ROW ;}
"</ss:Row>"   {yylval=strdup(yytext);return EROW ;}
"<ss:Cell"   {yylval=strdup(yytext);return CELL ;}
"</ss:Cell>"   {yylval=strdup(yytext);return ECELL ;}
" ss:MergeAcross=\""   {yylval=strdup(yytext);return MERGEACROSS;}
" ss:MergeDown=\""   {yylval=strdup(yytext);return MERGEDOWN;}
"<ss:Data"   {yylval=strdup(yytext);return DATA;} 
"</ss:Data>"   {yylval=strdup(yytext);return EDATA ;}
" ss:Type=\""   {yylval=strdup(yytext);return TYPE;}
"Number"    {yylval=strdup(yytext);return NUMBER;}
"DateTime"    {yylval=strdup(yytext);return DATETIME;} 
"Boolean"    {yylval=strdup(yytext);return TBOOLEAN ;}
"String"    {yylval=strdup(yytext);return TSTRING;}
"\""   {yylval=strdup(yytext);return QM;}
"\n" {/* Dont Do Anything */lineNumber++;}
"\t" {/* Dont Do Anything */}
{boolean} {yylval=strdup(yytext);return BOOLEAN;}	
{posint}   {yylval=strdup(yytext);return P_INT;}
{alphanum}  {yylval=strdup(yytext); return ALPHANUM;}
{text} {yylval=strdup(yytext);return TEXT;}

%%
