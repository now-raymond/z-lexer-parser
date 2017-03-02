@echo off
REM This file compiles a CUP file on Windows.
java -jar lib/java-cup-11b.jar -destdir src/ -parser Parser src/Parser.cup