grammar MicroParser;

@ruleCatch {
	catch (RecognitionException e) {
		throw e;
	}
}

/* Program */
program 	: 'PROGRAM' id 'BEGIN' pgm_body 'END';
id		: IDENTIFIER;
pgm_body	: decl func_declarations;
decl 		: (string_decl | var_decl)*;
/* Global String Declaration */
//string_decl_list: (string_decl string_decl_tail)?;
string_decl	: 'STRING' id ':=' str ';';
str		: STRINGLITERAL;
string_decl_tail: string_decl string_decl_tail?;
/* Variable Declaration */
//var_decl_list	: var_decl var_decl_tail?;
var_decl	: var_type id_list ';';
var_type	: 'FLOAT' | 'INT';
any_type	: var_type | 'VOID';
id_list		: id id_tail;
id_tail		: ',' id id_tail | ;
var_decl_tail	: var_decl var_decl_tail?;
/* Function Parameter List */
param_decl_list : param_decl param_decl_tail;
param_decl	: var_type id;
param_decl_tail	: ',' param_decl param_decl_tail | ;
/* Function Delcarations */
func_declarations: (func_decl func_decl_tail)?;
func_decl	: 'FUNCTION' any_type id '(' param_decl_list? ')' 'BEGIN' func_body 'END';
func_decl_tail	: func_decl*;
func_body	: decl stmt_list;
/* Statement List */
stmt_list	: stmt stmt_tail | ;
stmt_tail	: stmt stmt_tail | ;
stmt		: assign_stmt | read_stmt | write_stmt | return_stmt | if_stmt | do_stmt;
/* Basic Statement */
assign_stmt	: assign_expr ';';
assign_expr	: id ':=' expr;
read_stmt	: 'READ' '(' id_list ')' ';';
write_stmt	: 'WRITE' '(' id_list ')' ';';
return_stmt	: 'RETURN' expr ';';
/* Expressions */
expr		: factor expr_tail;
expr_tail	: addop factor expr_tail | ;
factor		: postfix_expr factor_tail;
factor_tail	: mulop postfix_expr factor_tail | ;
postfix_expr	: primary | call_expr;
call_expr	: id '(' expr_list? ')';
expr_list	: expr expr_list_tail;
expr_list_tail 	: ',' expr expr_list_tail |;
primary		: '(' expr ')' | id | INTLITERAL | FLOATLITERAL;
addop		: '+' | '-';
mulop		: '*' | '/';
/* Comples Statemens and Condition */
if_stmt		: 'IF' '(' cond ')' 'THEN' stmt_list else_part 'ENDIF';
else_part	: ('ELSE' stmt_list)*;
cond		: expr compop expr;
compop		: '<' | '>' | '=' | '!';
do_stmt		: 'DO' stmt_list 'WHILE' '(' cond ')' ';';

fragment DIGIT          : '0'..'9';
fragment LETTER         : 'A'..'Z'|'a'..'z';
fragment ALPHANUMERIC   : '0'..'9'|'A'..'Z'|'a'..'z';

KEYWORD         : 'PROGRAM' 
                | 'BEGIN' 
                | 'END' 
                | 'PROTO' 
                | 'FUNCTION' 
                | 'READ' 
                | 'WRITE' 
                | 'IF' 
                | 'THEN'
                | 'ELSE'
                | 'ENDIF'
                | 'RETURN'
		| 'CASE'
		| 'ENDCASE'
		| 'BREAK'
		| 'DEFAULT'
		| 'DO' 
		| 'WHILE' 
                | 'FLOAT'
                | 'INT' 
                | 'VOID'
                | 'STRING';
OPERATOR        : ':='
                | '+'
                | '-'
                | '*'
                | '/'
                | '='
		| '!='
                | '<'
                | '>'
                | '('
                | ')'
                | ';'
                | ',';
INTLITERAL      : (DIGIT)+;
FLOATLITERAL    : (DIGIT)*('.'(DIGIT)+);
STRINGLITERAL   : ('"'(~('\r'|'\n'|'"'))*'"');
WHITESPACE      : ('\n'|'\r'|'\t'|' ')+
                {skip();};
COMMENT         : '--'
                (~('\n'|'\r'))*
                ('\n'|'\r'('\n')?)?
                {skip();};
IDENTIFIER      : (LETTER)(ALPHANUMERIC)*;
