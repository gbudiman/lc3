grammar MicroParser;
@rulecatch {
	catch (RecognitionException re) {
		System.out.println("Not Accepted\n");
		System.exit(1);	
	}
}
@header {
	import java.util.Vector;
	import java.util.LinkedList;
	import java.util.Iterator;
	import java.util.Collections;
}
@members {
	private List<String> errors = new LinkedList<String>();
	public void displayRecognitionError(String[] tokenNames, RecognitionException e) {
		String hdr = getErrorHeader(e);
		String msg = getErrorMessage(e, tokenNames);
		errors.add(hdr + " " + msg);
	}
	public List<String> getErrors() {
		return errors;
	}
	public int getErrorCount() {
		return errors.size();
	}

	public List<mSymbol> symbolTable = new Vector<mSymbol>();
}
/* Program */
program 	: 'PROGRAM' id 'BEGIN' pgm_body 'END'
{
	System.out.println("Printing Global Symbol Table");
	Iterator it = symbolTable.iterator();
	while (it.hasNext()) {
		mSymbol element = (mSymbol) it.next();
		if ((element.getType()).equals("info")) {
			System.out.println(element.getName());
		}
		else {
			System.out.print("name: " + element.getName());
			System.out.print(" type " + element.getType());
			if ((element.getValue()).length() != 0) {
				System.out.println(" value: " + element.getValue());
			}
			else {
			System.out.println();
			}
		}
	}
};
id		: IDENTIFIER;
pgm_body	: decl func_declarations;
decl 		: (string_decl | var_decl)*;
/* Global String Declaration */
//string_decl_list: (string_decl string_decl_tail)?;
string_decl	: 'STRING' id ':=' str ';'
{
	symbolTable.add(new mSymbol($id.text, "STRING", $str.text));
};
str		: STRINGLITERAL;
string_decl_tail: string_decl string_decl_tail?;
/* Variable Declaration */
//var_decl_list	: var_decl var_decl_tail?;
var_decl	: var_type id_list ';' 
{
	List<mSymbol> reverseTable = new Vector<mSymbol>();
	for (String id : $id_list.stringList) {
		reverseTable.add(new mSymbol(id, $var_type.text));
	}
	Collections.reverse(reverseTable);
	Iterator its = reverseTable.iterator();
	while (its.hasNext()) {
		symbolTable.add((mSymbol) its.next());
	}
	
};
var_type	: 'FLOAT' | 'INT';
any_type	: var_type | 'VOID';
id_list	returns [ List<String> stringList ]
		: id id_tail 
{
	$stringList = $id_tail.stringList;
	$stringList.add($id.text);
};
id_tail returns [ List<String> stringList ]
	 	: ',' id tailLambda = id_tail 
{
	$stringList = $tailLambda.stringList;
	$stringList.add($id.text);
}
		| 
{
	$stringList = new ArrayList();
};
var_decl_tail	: var_decl var_decl_tail?;
/* Function Parameter List */
param_decl_list : param_decl param_decl_tail;
param_decl	: var_type id;
param_decl_tail	: ',' param_decl param_decl_tail | ;
/* Function Delcarations */
func_declarations: (func_decl func_decl_tail)?;
func_decl	: 'FUNCTION' any_type id 
{
	symbolTable.add(new mSymbol("Printing Symbol Table for " + $id.text, "info"));
}
		'(' param_decl_list? ')' 'BEGIN' func_body 'END' ;
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
compop		: '<' | '>' | '=' | '!=';
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
/*OPERATOR        : ':='
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
                | ',';*/
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
