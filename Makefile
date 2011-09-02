LIB_ANTLR := lib/antlr.jar
ANTLR_SCRIPT := src/MicroParser.g

all: generate
	rm -rf classes
	mkdir classes
	javac -cp $(LIB_ANTLR) -d classes src/*.java

generate:
	java -cp $(LIB_ANTLR) org.antlr.Tool $(ANTLR_SCRIPT)

clean:
	rm -rf classes MicroParser.tokens src/MicroParser.java 

.PHONY: all generate clean
