/* Written in the D Programming Language */
import star: Star;
import swrite: SWrite;
/**
  * Representing a graph by nodes and neighbourhood

  * ---
  * g.toString; // returns the string representation of the graph
  * g+= n;  // inserting a node
  * g-= n;  // deleting a node and all of its edges
  * g[ n];  // returns the nodes reachable over edges
  * g[ m]+= n; // inserting an edge from node m to node n
  * g[ m]-= n; // deleting an edge from node m to node n
  * ---
  * Datum: 17.12.12 Author: Manfred Nowak, svv1999@hotmail.com
  */

class Graph( Node){
  alias Star!Node NodeStar;
  /// A graph is defined by its nodes ...
  NodeStar nodes;
  /// and those nodes reachable from a particules node
  NodeStar[ Node] neighbourhood;
  /// contruct
  this(){ nodes= new NodeStar;}

  /// stringify
  override string toString(){
    auto buffer= new SWrite;
    buffer.take( "Graph: {");
    buffer.take( "  Nodes: %s", nodes);
    buffer.take( "  Edges: %s", neighbourhood);
    buffer.take( "}");
    auto s= buffer.give;
    return s;
  }

  /// Of course the nodes reachable from some node
  /// can be requested
  NodeStar opIndex( Node source)
  {
    if( source in neighbourhood)
      return neighbourhood[ source];
    else
      return new NodeStar;
    /// TODO: is it an error to ask for a non existing node?
    assert( 0);
  }

  /// ... and edges can be introduced or deleted
  /// It is okay to reintroduce or redelete an edge
  Graph opIndexOpAssign( string op, T)(T val, T node)
    if( is( T:Node) && ("+"==op || "-"==op))
  {
    /// TODO: is it an error to ask for a non existing node?
    if( node !in nodes) assert( 0, "Node not declared");
    if( node !in neighbourhood) neighbourhood[ node]= new NodeStar;
    switch( op){
      case "+": neighbourhood[ node]+= val; break;
      case "-": neighbourhood[ node]-= val; break;
      default: assert( 0, "unexpected operation");
    }
    return this;
  }

  /// ... nodes can also be introduced or deleted.
  /// It is okay to reintroduce or redelete a node
  Graph opOpAssign( string op, T)( T node)
    if( is( T:Node) && ("+"==op || "-"==op))
  {
    //if( node !in nodes) assert( 0);
    //if( node !in nodes) nodes= new NodeStar;
    switch( op){
      case "+": nodes+= node; break;
      case "-": nodes-= node;
                if( node in neighbourhood) neighbourhood.remove( node);
                break;
      default: assert( 0, "unexpected operation");
    }
    return this;
  }

}
private import std.stdio: writeln;
unittest{
  auto g= new Graph!uint;
  /// inserts a node
  g+= 1;
  assert( 1 in g.nodes);
  /// reinserts a node
  g+= 1;
  assert( 1 in g.nodes);
  /// inserts an edge
  g[ 1]+= 1;
  assert( 1 in g[1]);
  /// reinserts an edge
  g[ 1]+= 1;
  assert( 1 in g[1]);

  auto res =
"Graph: {  Nodes: * =[1:true]
  Edges: [1:* =[1:true]
]}";
  auto buffer= new SWrite;
  buffer.take( "%s", g);
  auto s= buffer.give;
  debug writeln( s);
  assert( s == res);

  debug delete g;
  writeln( "Graph Done.");
}
