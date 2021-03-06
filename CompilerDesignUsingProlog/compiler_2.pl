% %read from source code RFile , and out after preProcessing to WFile
% read_from_file(RFile,WFile ):-
%     open(RFile,read,Stream),
%     get_char(Stream, Char1),
%     process_the_stream(Char1,Stream,WFile),
%     close(Stream).
% process_the_stream(end_of_file , _ ,_) :- ! .
% process_the_stream(Char,Stream,WFile):-
%     Char \= '\n' , 
%     Char \= '\t' ,
%     Char \= ' ',
%     write(Char),
%     write_on_file(WFile, Char),
%     get_char(Stream,Char2),
%     process_the_stream(Char2,Stream,WFile), !;

%     get_char(Stream,Char2),
%     process_the_stream(Char2,Stream,WFile),!.
   

% write_on_file(File ,Text):-
%     open(File, append, Stream) ,
%     write(Stream,Text),
%     close(Stream).

% %read from output file the OneBig StringCode
% read(File,End,String):-
%     open(File,read,In),
%     read_string(In, "\n", "\r\t ", End, String).



% main(SourceFile,OutputFileAfterPreProccesing):-
%     read_from_file(SourceFile, OutputFileAfterPreProccesing),
%     read(OutputFileAfterPreProccesing,_,CodeAsOneBigString),
%     write(CodeAsOneBigString),
%     atom_chars(CodeAsOneBigString, TokenList) ,
%     stmt(TokenList,[]) ,
%     write("syntax free"), 
%     ! ;
%     write("syntax error").


main(SourceCode):-
    atom_chars(SourceCode, TokenList) ,
    % tokenize_atom(SourceCode,TokenList),
    write(TokenList),
    stmt(TokenList,[]) ,
    write("syntax free"), 
    ! ;
    write("syntax error").

% means there are zero or more spaces
skip -->  ([' '];['\t'];['\n'];['\r']), skip ; [] .

stmt --> skip , assignment_stmt ,skip | skip,if_stmt,skip|skip, while_stmt ,skip| skip,for_stmt, skip|skip , do_while_stmt ,skip|skip , open_curlybracket ,skip, stmts ,skip,  close_curlybracket,skip.
stmts --> skip ,stmt , skip ,stmts,skip | [] .

assignment_stmt --> assignment_exp, skip , semicolon_op , skip |skip ,  postfix_exp , skip , semicolon_op , skip |skip ,  prefix_exp , skip , semicolon_op , skip .

assignment_exp --> id ,skip, assignment_op ,skip, (exp|postfix_exp|prefix_exp) ,skip.
postfix_exp --> id ,increment_decrease_op , skip .
prefix_exp --> increment_decrease_op , id , skip.

if_stmt --> skip , if_keyword  , skip ,stmt_condition, skip , stmt, skip .
while_stmt --> skip , while_keyword ,skip , stmt_condition ,skip , stmt, skip.
for_stmt --> skip , for_keyword , skip,for_condition ,skip, stmt,skip .
do_while_stmt --> skip,do_keyword , skip,stmt ,skip, while_keyword , skip,stmt_condition ,skip, semicolon_op,skip .

exp --> term , skip, rest .
rest --> skip , plus_minus_op , skip , term ,skip, rest ; [] . 

 
term --> factor ,skip , rest1 , skip .
rest1 --> skip , multiplication_division_op ,skip, term ,skip, rest1 ,skip ; [] .

factor --> skip,digits,skip | skip,id,skip | skip,open_parenthesis,skip,exp,skip,close_parenthesis,skip .

condition --> skip,factor,skip,relational_op,skip,factor,skip|skip,open_parenthesis,condition,close_parenthesis,skip,logical_op,skip,open_parenthesis,condition,close_parenthesis,skip.
stmt_condition --> skip,open_parenthesis ,skip,condition ,skip, close_parenthesis,skip .
for_condition --> skip,open_parenthesis,skip,(assignment_exp | [] ),skip,semicolon_op,skip,condition,skip,semicolon_op,skip,( postfix_exp | prefix_exp),skip,close_parenthesis,skip.




% terminals 
digit --> ['0'];['1'];['2'];['3'];['4'];['5'];['6'];['7'];['8'];['9'].
digits --> digit, digits ; digit .

letter --> ['a'];['b'];['c'];['d'];['e'];['f'];['g'];['h'];['i'];['j'];['k'];['l'];['m'];['n'];['o'];['p'];['q'];['r'];['s'];['t'];['u'];['v'];['w'];['x'];['y'];['z'].
letter --> ['A'];['B'];['C'];['D'];['E'];['F'];['G'];['H'];['I'];['J'];['K'];['L'];['M'];['N'];['O'];['P'];['Q'];['R'];['S'];['T'];['U'];['V'];['W'];['X'];['Y'];['Z'].
letter_or_digit --> letter ; digit .
zero_or_more_letter_or_digit --> letter_or_digit , zero_or_more_letter_or_digit ; [] . 
id --> letter , zero_or_more_letter_or_digit .
    
% operators
plus_minus_op --> [+];[-].
multiplication_division_op --> [*] | [/] | ['%'].  

relational_op --> [>,=] ; [<,=] ; [<] ; [>] ; [=,=] ; [!,=].
logical_op --> ['&','&'] | ['|','|'] . 
assignment_op --> [=] .
increment_decrease_op --> ['+','+'] | ['-','-']. 
semicolon_op --> [;] .

% used parenthesis and brackets 
open_parenthesis --> ['('].
close_parenthesis --> [')'] .
open_curlybracket -->['{'].
close_curlybracket --> ['}'].

% key words 
if_keyword --> ['i','f'].
while_keyword --> ['w','h','i','l','e'] .
for_keyword --> ['f','o','r'].
do_keyword --> ['d','o'].

% A = [i,f,' ',' ',' ','(',' ',x]
% remove_space([],[]).
% remove_space([H|T],[H1|T1]):-
%     H \== ' ', 
%     H1 = H ,
%     remove_space(T,T1) .

% digits([H|T],T):-
%     with_output_to(atom(A),write(H)),
%     re_match('[0-9]+',A).

% id([H|T],T) :- 
%     with_output_to(atom(A),write(H)),
%     re_match("^([a-zA-z])([a-zA-Z0-9]*)",A).