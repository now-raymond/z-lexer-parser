@echo off
REM This file runs a test case through the lexer+scanner on Windows.
java -cp bin;lib/java-cup-11b-runtime.jar SC %1 > results/%~n1.csv