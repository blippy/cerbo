#!/usr/bin/env perl6

enum Bcode <Add Ass Call Cat Div Drop Dup Getn Gosub Halt Inc Jlt Jmp Jze Mul Neg 
	PrintNum PrintStr Push Return Sub>;
my @bcodes;
my @bvals;


my @sstack; # regular stack
sub spush(int32 $val) { @sstack.push($val); }
sub spop() { return pop(@sstack); }

my @rstack; # return stack for gosub
sub rpush(int32 $ip) { @rstack.push($ip); }
sub rpop() { return pop(@rstack); }


my Str @kstrs; #constant strings

sub bpush(Bcode $code, int32 $val) { @bcodes.push($code) ; @bvals.push($val); }
sub bpush0(Bcode $code) { bpush $code, 0; }
sub slast() { return elems(@sstack) - 1 ; }


#sub do-dup() { spush( @sstack[slast] ; }
sub do-emit() { print chr(spop()); }
sub do-print() { say spop; }
sub do-printkstr() { say @kstrs[spop()]; }
sub do-hello() { say "Hello from raku blang"; }

my @prims = (
	["emit", &do-emit],
	["print", &do-print], 
	["printkstr", &do-printkstr],
	["hello", &do-hello]);

sub find-prim($name) {
	loop (my $i=0; $i <elems(@prims); $i++)  {
		my ($key, $f) = @prims[$i];
		#say "key is $key";
		if $name eq $key { return $i; }
	}
	return -1;
}

my %labels;
my @jump-ids;
my @jump-pos;


sub add-jump($id) { 
	@jump-ids.push($id); 
	@jump-pos.push(here); 
}

sub found($str) { say "Found: $str"; }
sub xfound($str) {  }


sub calls($func-name) {
	my $id = find-prim $func-name;
	die("calls:fatal:unknown function:$func-name") if $id == -1;
	bpush Call, $id; 
}

sub mk-kstr(Str $kstr) {
	my $n = elems(@kstrs);
	@kstrs.push($kstr);
	return $n;
}
#sub mk-kstr(Str $kstr) {
#	bpush Push, (mk-kstr1 $kstr) ;
#	#return $n;
#}

sub here() { return elems(@bcodes); }

my @ifs; # locations of if statements

sub mk-if() {
	@ifs.push(here);
	bpush0 Jze;
}

sub mk-fi() {
	my $loc = @ifs.pop;
	@bvals[$loc] = here;
}


# looping structures
my @loop-starts;
my @loop-ends; # locations where you should abort the loop
sub mk-while() {
	@loop-starts.push(here);
}
sub mk-while-test() {
	@loop-ends.push(here);
	bpush0 Jze;
}
sub mk-wend() {
	my $loc = @loop-starts.pop;
	bpush  Jmp, $loc;
	$loc = @loop-ends.pop;
	@bvals[$loc] = here;
}

# numerical variables
my Str @num-var-names;
my @num-var-values;

# find index
sub findex(@keys, $key) {
	loop (my $i=0; $i <elems(@keys); $i++)  {
		if $key eq @keys[$i] { return $i; }
	}
	return -1;
}


sub mk-assign(Str $varname) {
	my $i = findex(@num-var-names, $varname);
	if $i < 0 {
		$i = elems(@num-var-names);
		@num-var-names.push($varname);
		@num-var-values.push(0);
	}
	bpush Ass, $i;
}

sub mk-get-varn(Str $varname) {
	my $i = findex(@num-var-names, $varname);
	if $i < 0 {
		$i = elems(@num-var-names);
		@num-var-names.push($varname);
		@num-var-values.push(0);
	}
	bpush Getn, $i;
}


grammar G {
	rule TOP { ^ <stmts> $ }
	rule stmts { <statement>* }
	rule statement { <assign> | <call> | <dup> | <drop> | <gosub> | <halt> | 
		<inc> | <if-stm> | <jlt> | <label> | 
		<prin> | <push> | <ret> | <sub> | <whilst> | 
		<comment> }

	rule assign	{ <id> '=' <expr> { mk-assign $<id>.Str; }  }
	rule drop { 'drop' { found "drop"; bpush0 Drop; }}
	rule dup { 'dup' { found "dup"; bpush0 Dup; }}
	rule if-stm	{ 'if' <expr> 'then' { mk-if; } <stmts> 'fi' {mk-fi;} }
	rule inc { 'inc' { bpush0 Inc; }}
	rule jlt 	{ 'jlt' <id> { add-jump $<id>; bpush0 Jlt; }}
	rule label 	{ <id> ':' {found "label"; %labels{$<id>} = here; } }
	rule add	{ 'add' {bpush0 Add;}}
	rule mul	{ 'mul' {bpush0 Mul;}}
	rule div	{ 'div' {bpush0 Div;}}
	rule sub { 'sub' { bpush0 Sub;}}
	rule push { 'push' <expr> }
	rule call { 'call' <id> {calls $<id>; } }
	rule gosub	{ 'gosub' <id> {add-jump $<id> ; bpush0 Gosub; }}
	rule halt { 'halt'  {xfound "halt"; bpush0 Halt;} }
	rule ret	{ 'return' {bpush0 Return;}} 
	rule whilst	{ 'while' {mk-while;} <expr> {mk-while-test;} <stmts> 'wend' {mk-wend;} }


	#rule expr	{ <expr-mul>  ( <add-sub> <expr-mul>  { add-sub $<add-sub>.Str;} )* }
	rule expr	{ <expr-mul>  <expr-a>* }
	rule expr-a	{ ('+' <expr-mul> {bpush0 Add;}) | ('-' <expr-mul> {bpush0 Sub;})}
	rule expr-mul	{ <expr-prim> <expr-b>* }
	rule expr-b	{ ('*' <expr-prim> {bpush0 Mul;}) | ('/'  <expr-prim> {bpush0 Div;}) }
	rule expr-prim	{ ('(' <expr> ')' ) |
			  (<int> { bpush Push, $<int>.Int; }) | 
			  (<id> {mk-get-varn $<id>.Str;}) |
			  ( '-' <expr-prim> { bpush0 Neg;})
		  	}


	rule str-expr	{ <str-expr-prim>  <str-expr-a>* }
	rule str-expr-a	{ '+' <str-expr-prim> { bpush Cat, (mk-kstr "UNDEFINED");} }
	rule str-expr-prim	{ <kstr> }

	rule prin 	{ 'print' (<print-num> | <print-str>) }
	rule print-num	{ <expr> { bpush0 PrintNum; }}
	rule print-str	{ <str-expr> { bpush0 PrintStr; } }

	token comment	{ '#' \N*  }
	#token kstr	{ '"' <( <str=-["]>* )> '"'  { mk-kstr $<str>.Str; }}
	token kstr	{ '"' <kstr1> '"'  { bpush Push, (mk-kstr $<kstr1>.Str); }}
	token kstr1	{ <-["]>*  }

	token id 	{ <[a..zA..Z]>+ }
	token int	{ <[0..9]>+ }
}



# read in program
#my $nargs = elems($*ARGFILES);
#say "nargs = $nargs";
#if elems($*ARGFILES) > 0 {
#	say "process arguments";
#} else {
#	say "read prog from stdin";
#}
#for $*ARGFILES ->$f {
#	say "file $f";
#}

my $prog = slurp;
my $m = G.parse($prog);
bpush0 Halt; # add on a final terminating halt

sub resolve-labels() {
	loop (my $i = 0; $i < elems(@jump-ids); $i++) {
		my $id = @jump-ids[$i];
		my $pos = %labels{$id};
		my $here = @jump-pos[$i];
		@bvals[@jump-pos[$i]] = $pos;
	}
}


sub disasm() {
	my $i;
	loop ($i=0; $i < elems(@bcodes); $i++) {
		print "$i\t";
		my $bcode = @bcodes[$i];
		my $val = @bvals[$i];
		print "$bcode\t";
		given $bcode {
			when Call { say @prims[$val][0]; }
			default { say $val; }
		}
	}

	say "kstrs:";
	loop ($i = 0; $i < elems(@kstrs); $i++) {
		say "$i\t@kstrs[$i]";
	}


	say "---\n";
}
		

sub do-cat( Int $idx) { 
	my $arg2 = @kstrs[spop]; 
	my $res = @kstrs[spop] ~ $arg2;  
	@kstrs[$idx] = $res;
	spush $idx;
}


my $ip = 0;
sub run() {
	loop {
		my $bcode = @bcodes[$ip];
		my $val = @bvals[$ip];
		$ip++;
		given $bcode {
			when Add { my $v = spop; @sstack[slast] += $v; }
			when Ass { @num-var-values[$val] = spop; }
			when Call	{ my $func = @prims[$val][1]; $func(); }
			when Cat	{ do-cat $val;  }
			when Div { my $v = spop; @sstack[slast] /= $v; }
			when Drop { spop;}
			when Dup { spush( @sstack[slast]); }
			when Getn { spush @num-var-values[$val]; }
			when Gosub	{ rpush $ip; $ip = $val; }
			when Halt { last; }
			when Inc { @sstack[slast] += 1; }
			when Jlt { if spop() < 0 { $ip = @bvals[$ip-1];} }
			when Jmp	{ $ip = $val; }
			when Jze { if spop() == 0 { $ip = @bvals[$ip-1];} }
			when Mul { my $v = spop; @sstack[slast] *= $v; }
			when Neg 	{ spush(-spop); }
			when PrintNum	{ say spop; }
			when PrintStr	{ say @kstrs[spop]; }
			when Push { spush $val;}
			when Return	{ $ip = rpop; }
			when Sub { my $v = spop; @sstack[slast] -= $v; }
			default { die "Unknown opcode: $bcode before $ip";  }
		}
	}
	say "Bye";
}

#say %labels;
resolve-labels;
disasm;
run;

