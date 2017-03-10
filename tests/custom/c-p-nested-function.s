fdef foobar() {
    print "Function before main.";
};

main { 
    fdef foobar() {
        print "Function within main.";
    };
    print 0;
};

fdef foobar() {
    fdef foobar() {
        print "Nested function.";
    };
    ?T?foobar();
    
    print ("Result of function call: " + ?T?foobar());
};