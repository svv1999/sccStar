private import std.stdio;
private import std.conv : to;
private import stackext: StackExtended;
private import star: Star;
private import graph: Graph;

alias uint Node;
alias Graph!Node Graph2;
Graph2 sccs( Graph2)( Graph2 g){
  auto retval= new Graph2;
  auto found= new Star!Node;
  Graph2 combine( Graph2 a, Graph2 b){
    return new Graph2;
  }
  Graph2 tarjan( Node v){
    return new Graph2;
  }
  foreach( v, val; g.nodes.data){
    if( v !in  found){
      auto scc= tarjan( v);
      combine( retval, scc);
    }
  }
  return retval;
}
unittest{
  auto g= new Graph2;
  g+= cast( Node) 1;
  auto g2= sccs!Graph2( g);
  writeln( g2);
  writeln( "sccPure Done.");
}
