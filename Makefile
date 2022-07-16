all: sccpure
sccpure: sccpure.d
	rdmd --main -unittest sccpure
sccpure2: sccpure2.d
	rdmd --main -unittest sccpure2
stackext: stackext.d
	rdmd --main -unittest stackext
stack: stack.d
	rdmd --main -unittest stack
graph: graph.d
	rdmd --main -unittest graph
doc: docs/swrite.html docs/graph.html docs/sccpure.html
docs/sccpure.html: sccpure.d
	dmd -o- -Dddocs sccpure
docs/graph.html: graph.d
	dmd -o- -Dddocs graph
docs/swrite.html: swrite.d
	dmd -o- -Dddocs swrite
clean:
	del *.exe
	del *.obj
	del *~
