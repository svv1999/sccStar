import std.conv : to;
import swrite: SWrite;
/* Written in the D-Programming Language */
/**
  * Starring types.

  * For a type T its starred type T* contains an element
  * of the powerset of T.
  *
  * Let x and y be of type T* and z be of type T.
  * Then 
  * ---
  * x += y; // elements of y are included into x
  * x -= y; // elements of y are eliminated from x
  * x += z; // element z is included into x
  * x -= z; // element z is eliminated from x
  * z in x  // yields true iff x conatins z
  * ---
  */

class Star( T){
  bool[ T] data; /// Element of the powerset of T
  /// include or exclude another T*
  void opOpAssign( string op, Tquote)( Tquote elemStar)
    if( is( Tquote:Star) &&( "+"==op || "-"==op))
  {
    foreach( elem, val; elemStar.data){
      switch( op){
        case "+":  this+= elem; break;
        case "-":  this-= elem; break;
        default: ;
      }
    }
  }
  /// add or delete an element
  void opOpAssign( string op, Tquote)( Tquote elem)
    if( is( Tquote:T) &&( "+"==op || "-"==op))
  {
    auto pos= elem in data;
    switch( op){
      case "+": if( !pos) data[ elem]= true; break;
      case "-": if( pos) data.remove( elem); break;
      default: ;
    }
  }
  /// check the presence of an element 
  bool opBinaryRight( string op, Tquote)( Tquote elem)
    if( is( Tquote:T) )
  {
    if( "in" == op) return (elem in data) !is null;
  }

  /// provides formatted output
  override string toString(){
    return  "* ="~to!string( data)~"\n";
    debug return "star";
  }
/**
  * Date: 24.12.2012  Author: Manfred Nowak, svv1999@hotmail.com
  */
  extern T t;
}
unittest{ /// Testing the functionality
  import std.stdio: writeln;
  alias Star!uint uintStar;
  auto star= new uintStar;
  star+= 1;
  assert( 1 in star); /// element is included
  star-= 1;
  assert( 1 !in star); /// element is excluded

  auto star2= new uintStar;
  star2+= 1;
  star2+= 2;
  star+= star2;
  assert( 1 in star && 2 in star); /// star is included
  star2-= 1;
  star-= star2;
  assert( 1 in star && 2 !in star); /// star is excluded

  auto buffer= new SWrite;
  buffer.take( "%s", star);
  auto g= buffer.give;
  debug writeln( ".",g,".");
  assert( g == "* =[1:true]\n");
  writeln( "Star: Done.");
}
