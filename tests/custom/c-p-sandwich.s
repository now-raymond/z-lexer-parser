fdef foobar() {
  print "Another function after main.";
};

tdef person {name:string, surname:string, age:int}; # person fdefinition

m:int := 99;

fdef foobar() {
  print "Another function after main.";
};

tdef family {mother:person, father:person, children:seq<person>}; # family fdefinition

fdef foobar() {
  print "Another function after main.";
};

main { 

# here we generate
/# a family #/
  f:family := m,p,[c1,c2];
  alias seq<char> string2;
  f:family := m,p,[c1,c2];
  tdef person {name:string, surname:string, age:int};
  f:family := m,p,[c1,c2];

  m:person := "aaaaAAA", "bbBB0_i", 40;
  p:person := "aaabAAA", "bbBB0_i", 35;
  c1:person := "aaabAAA", "bbBB0_i", 1;
  c2:person := "aaadAAA", "bbBB0_i", 2;
  c3:person := "aaaeAAA", "bbBB0_i", 3;

  f:family := m,p,[c1,c2];
  
  f.children := f.children :: [c3];
  
  # multiple assign
  a := b + (c + 4) - (5*4) :: 44;

  return;
};

fdef bar() {
  print "Another function after main.";
};
