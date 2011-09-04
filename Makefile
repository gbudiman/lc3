LIB_ANTLR := lib/antlr.jar
ANTLR_SCRIPT := src/MicroParser.g

all: generate
	rm -rf classes
	mkdir classes
	javac -cp $(LIB_ANTLR) -d classes src/*.java generated/src/*.java

generate:
	java -cp $(LIB_ANTLR) org.antlr.Tool $(ANTLR_SCRIPT) -o generated

clean:
	rm -rf classes MicroParser.tokens src/MicroParser.java generated

group:
	@more README	

.PHONY: all generate clean
