main { 
  b:int := books[3];
  c:string := books[1][3:4];
  d:char := books[2][1];
  d:char := books[2][1][5];
  
  d : dict<int, dict<int,char>> := {key1:aweg, key2: {1: {1: {1: {1: {1:Td}}}}}};
  
  #d : dict<seq<int>, int> := {[2,3,4]:1};
  
  s : seq<top> := [ 1, 1/2, 3.14, [ 'f', 'o', 'u', 'r'] ];
  
  if (T && F && !T || !3 && 8 != 3) then return; else return; fi
  
  3 in [[1],[2],[3]];
  
  books[3][3][6] := 4;
  
  family.mother.name = "Jane";
  ?T?sum(-10,20).name := 23;
  
  ?T?sum(-10,20);
  
  print 0;
};