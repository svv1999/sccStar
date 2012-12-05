private import std.stdio;
private import std.conv : to;
class Graph{
  NodeStar nodes;
  this(){ nodes= new NodeStar;}
  NodeStar[ Node] reachable;

  NodeStar opIndex( Node source)
  {
    if( source in reachable)
      return reachable[ source];
    assert( 0);
  }


  Graph opIndexOpAssign( string op, T)(T val, T node)
    if( is( T:Node) && ("+"==op || "-"==op))
  {
    if( node !in nodes) assert( 0, "Node not declared");
    if( node !in reachable) reachable[ node]= new NodeStar;
    switch( op){
      case "+": reachable[ node]+= val; break;
      case "-": reachable[ node]-= val; break;
      default: assert( 0, "unexpected operation");
    }
    return this;
  }
  Graph opOpAssign( string op, T)( T node)
    if( is( T:Node) && ("+"==op || "-"==op))
  {
    //if( node !in nodes) assert( 0);
    //if( node !in nodes) nodes= new NodeStar;
    switch( op){
      case "+": nodes+= node; break;
      case "-": nodes-= node; break;
      default: assert( 0, "unexpected operation");
    }
    return this;
  }
  
}
class Stack{
  Node[ int] data;
  static uint count= 0;
  auto opOpAssign( string op, T)( T node)
    if( is( T:Node) && "+"==op )
  {
    data[ ++count]= node;
    return this;
  }
  auto opUnary( string op)()
    if(  "--" == op)
  {
    data.remove( count);
    count--;
    return this;
  }
  auto peek(){
    if( 0 ==count){
      assert( 0, "accessing empty stack");
    }
    return data[ count];
  }
  
  string toString(){
    return "Stack="~to!string( data)~"\n";
  }
}
  class StackExtended: Stack{
    NodeStar stacked;
    this(){ stacked= new NodeStar;}
    auto opOpAssign( string op, T)( T node){
      stacked+= node;
      return super+= node;
    }
    auto opUnary( string op)(){
      stacked -= super.peek;
      return super--;
    }
    bool opBinaryRight( string op, Tquote)( Tquote elem)
      if( is( Tquote:Node) &&( "in"==op ))
    {
      return elem in stacked;
    }
  }
class Star( T){
  bool[ T] data;
  void opOpAssign( string op, Tquote)( Tquote elemStar)
    if( is( Tquote:Star) &&( "+"==op || "-"==op))
  {
    foreach( elem, val; elemStar.data){
      auto pos= elem in data;
      switch( op){
        case "+": if( !elem) data[ elem]= true; break;
        case "-": if( elem) data.remove( elem); break;
        default: ;
      }
    }
  }
  void opOpAssign( string op, Tquote)( Tquote elem)
    if( is( Tquote:T) &&( "+"==op || "-"==op))
  {
    switch( op){
      case "+": data[ elem]= true; break;
      case "-": data.remove( elem); break;
      default: ;
    }
  }
  bool opBinaryRight( string op, Tquote)( Tquote elem)
    if( is( Tquote:T) )
  {
    if( "in" == op) return (elem in data) !is null;
  }

  string toString(){
    return  "* ="~to!string( data)~"\n";
    debug return "star";
  }
}
alias Star!Node NodeStar;
alias Star!NodeStar NodeStarStar;

  enum Node:uint{ min=uint.min, max=uint.max, one=1, two, thr, fou, fiv};
  enum VisNum:uint{ min=uint.min, max=uint.max};
  debug alias uint Node;
  Graph g;
  NodeStar found;
  NodeStarStar sccStar;
  VisNum[ Node] visitorNumber;
  VisNum currentNo= cast(VisNum) 0;
  VisNum[ Node] possibleRoot; // root of scc is node first visiting scc

  StackExtended stack;


NodeStarStar tarjan( Node v){

  VisNum min( VisNum left, VisNum right){
    auto retval= left<right ? left : right;
    debug(min) writefln( "root( %s, %s)==%s", left, right, retval);
    return retval;
  }

  debug( tarjan) writefln( "tarjan( %s):", v);
  debug(localReturn) auto retval= new NodeStarStar;
  alias sccStar retval;

  currentNo++;
  visitorNumber[ v]= currentNo;
  possibleRoot[ v]= currentNo;
  debug(stack) writefln( "On %s, stack tries to insert", v);
  stack+= v;
  debug(stack) writefln( "On %s, stack inserted %s", v, stack.peek);


  foreach( w, val; g[ v].data){
    auto ll(){
      return min( possibleRoot[ v], possibleRoot[ w]);
    }
    debug(neighbour) writefln( " checking %s -> %s", v, w);
    // TODO if( w !in found){
    if( w !in found){
      debug(neighbour) writefln( "  %s is not yet in an scc", w);
      if( w !in visitorNumber ){
        debug(neighbour) writefln( "  %s is not yet handled", w);
        retval+= tarjan( w);
        possibleRoot[ v]= ll();
      } else {
        debug(neighbour) writefln( "  %s is handled already", w);
        if( w in stack){
        //if( w in stack.stacked.data){
          debug(neighbour) writefln( "   %s is stacked", w);
          possibleRoot[ v]= ll();
        } else {
          debug(neighbour) writefln( "   %s is NOT stacked", w);
        }
      }
    }
  }
  debug(neighbour) writeln( " ]checking");
  NodeStar scc= new NodeStar;
  if( possibleRoot[ v] == visitorNumber[ v]){
    debug(scc) writefln( " %s is root of scc:", v);
    Node w;
    do{
      w= stack.peek;
      debug(scc) writefln( "  containing %s", w);
      found+= w;
      stack--;
      scc+= w;
    } while ( w != v);
    debug(scc) write( scc);
    retval+= scc;
    debug(scc) write( retval);

  }
  debug(tarjan) writefln( "] tarjan( %s)", v);
  return retval;

}
  
unittest{  
  g= new Graph;
  //auto one=  Node.one;
  alias Node.one one;
  alias Node.two two;
  alias Node.thr thr;
  alias Node.fou fou;
  alias Node.fiv fiv;
  g+= one; g[ one]+=  two;
  g+= two; g[ two]+=  thr;
  g+= thr; g[ thr]+=  one;
  g+= fou; g[ fou]+=  two; g[ fou]+=  fiv;
  g+= fiv; g[ fiv]+=  two;

  stack= new StackExtended;
  found= new NodeStar;
  sccStar= new NodeStarStar;

  debug(main) writeln( "start");
  foreach( v, val; g.nodes.data){
    if( v !in  found){
      tarjan( v);
    } else {
      debug(main) writefln( "%s quoted", v);
    }
  }
  write( sccStar);
}
