BINS = bcode

all : $(BINS)

bcode : bcode.cc
	g++ -std=c++17 -g -O0 -Wimplicit-fallthrough $< -o $@

clean :
	rm -f $(BINS)

