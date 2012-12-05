private import std.stdio;
private import std.conv : to;
private import stackext: StackExtended;
private import star: Star;
private import graph: Graph;

enum Node:uint{ min=uint.min, max=uint.max, one=1, two, thr, fou, fiv};
  debug alias uint Node;
alias Star!Node NodeStar;
alias Star!NodeStar NodeStarStar;
enum VisNum:uint{ min=uint.min, max=uint.max};

Graph!Node g;
NodeStar found;
NodeStarStar sccStar;
VisNum[ Node] visitorNumber;
VisNum currentNo= VisNum.min;
VisNum[ Node] possibleRoot; // root of scc is node first visiting scc

StackExtended!Node stack;
NodeStarStar tarjan( Node v){
  VisNum min( VisNum left, VisNum right){
    auto retval= left<right ? left : right;
    debug(min) writefln( "root( %s, %s)==%s", left, right, retval);
    return retval;
  }

  debug( tarjan) writefln( "tarjan( %s):", v);
  alias sccStar retval;

  currentNo++;
  visitorNumber[ v]= currentNo;
  possibleRoot[ v]= currentNo;
  stack+= v;

  foreach( w, val; g[ v].data){
    auto ll(){
      return min( possibleRoot[ v], possibleRoot[ w]);
    }
    if( w !in found){
      if( w !in visitorNumber ){
        retval+= tarjan( w);
        possibleRoot[ v]= ll();
      } else {
        if( w in stack){
          possibleRoot[ v]= ll();
        } else {
        }
      }
    }
  }
  NodeStar scc= new NodeStar;
  if( possibleRoot[ v] == visitorNumber[ v]){
    debug(scc) writefln( " %s is root of scc:", v);
    Node w;
    do{
      w= stack.max;
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
  g= new Graph!Node;
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

  stack= new StackExtended!Node;
  found= new NodeStar;
  sccStar= new NodeStarStar;

  foreach( v, val; g.nodes.data){
    if( v !in  found){
      tarjan( v);
    } else {
    }
  }
  write( sccStar);
  writeln( "sccPure Done.");
}
