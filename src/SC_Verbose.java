import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.StringReader;

import java_cup.runtime.*;

class SC_Verbose {
    public static void main(String[] args) {
    	Lexer lexer;
		try {
			lexer = new Lexer(new FileReader(args[0]));
			try {
				Parser parser = new Parser(lexer);
				Symbol result = parser.parse();
				if(!parser.syntaxErrors){
					System.out.println("parsing successful");
				}
				
				
			} catch (Exception e) {
				// Uncommented the commenting out because the output may be useful during development. RJT
				// Commented out because this output is uniformative.  ETB
				System.out.println("Parse exception occurred - see stack trace:");
				e.printStackTrace();
			}
		} catch (FileNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
    }
}
