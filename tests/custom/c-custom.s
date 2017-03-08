main { 
  b:int := books[3];
  c:string := books[1][3:4];
  d:char := books[2][1];
  
  alias seq<char> string;
  d:char := books[2][1][5];
  
  d : dict<int, dict<int,char>> := {key1:aweg, key2: {1: {1: {1: {1: {1:Td}}}}}};
  
  #d : dict<seq<int>, int> := {[2,3,4]:1};
  
  s : seq<top> := [ 1, 1/2, 3.14, [ 'f', 'o', 'u', 'r'] ];
  
  s:seq<top> := [3];
  
  if (T && F && !T || !3 && 8 != 3) then return; else return; fi
  
  3 in [[1],[2],[3]];
  
  books[3][3][6] := 4;
  
  family.mother.name = "Jane";
  ?T?sum(-10,20).name := 23;
  
  ?T?sum(-10,20);
  
  # Declaring vars in IF and ELSE body
  if (T) then
    s:seq<top> := [3];
    print 0;
  else
    s:seq<top> := [3];
    print 0;
  fi
  
  # Declaring vars in loop body
  loop
    s:seq<top> := [3];
    print 0;
  pool
  
  # Declaring vars in if in loop body
  loop
    if (T) then
        s:seq<top> := ?T?sum(-10,20);
        tdef person {name:string, surname:string, age:int};
        
        print 0;
        break;
        print 0;
    fi
  pool
  
  print 0;
  
  
};

tdef person {name:string, surname:string, age:int};
i:int := 3;
tdef person {name:string, surname:string, age:int};

fdef fibonacci( pos : int ) { 
    tdef person {name:string, surname:string, age:int};
    i:int := 3;
    alias seq<char> string;
    
	if (pos = -1) then
        alias seq<char> string;
		return 0;
	fi
	if (pos = 0) then
		return 1;
	fi	
	return ?T?fibonacci(pos-1) + ?T?fibonacci(pos-2);
} : int ; 