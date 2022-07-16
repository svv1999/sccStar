import std.conv : to;
import swrite: SWrite;
/* Written in the D-Programming Language */
/**
  * Starring types.

  * For a type T its starred type T* contains an element
  * of the powerset of T.
  *
  * Let T be some type and t be an element of type T.
  * Let x and y be of type T*.
  * Then 
  * ---
  * t in x // yields true iff x contains t
  * x+= t; // element t is included into x
  *        // i.e. assert( t in x) does not fail
  * x-= t; // element t is eliminated from x
  *        // i.e. assert( t !in x) does not fail
  * x+= y; // elements of y are included into x
  *        // i.e. assert( t in x) does not fail for any t with t in y
  * x-= y; // elements of y are eliminated from x
  *        // i.e. assert( t !in x) does not fail for any t with t in y
  * ---
  */

class Star( T){
  static bool argHasTypeThis;
  static
  this(){
    auto name= T.stringof;
    argHasTypeThis= name.length  >  5  &&  name[ 0 .. 5]  ==  "Star!";
    debug writeln( "Star.this: isStar= ", isStar, " ", typeof( this).stringof);
  }

  bool[ T] data; /// Element of the powerset of T

  /// include or exclude another T*
  void opOpAssign( string op, Tquote)( Tquote elemStar)
    if( is( Tquote:Star) &&( "+"==op || "-"==op))
  {
    foreach( elem, val; elemStar.data){
      static if( "+"  ==  op)
        this+= elem;
      else
        this-= elem;
    }
  }
  /// add or delete an element
  void opOpAssign( string op, Tquote)( Tquote elem)
    if( is( Tquote:T) &&( "+"==op || "-"==op))
  do {
    auto pos= elem in data;
    static if( "+"  ==  op) {
      if( !pos)
        data[ elem]= true;
    } else {
      if( pos)
        data.remove( elem);
    }
  }
  /// check the presence of an element 
  bool opBinaryRight( string op, Tquote)( Tquote elem)
    if( is( Tquote:T)  &&  ( op  == "in"))
  do {
    return (elem in data) !is null;
  }

  /// provides formatted output
  override
  string toString()
  do {
    //auto preResult=  "* =" ~to!( string[ T])( data) ~"* \n";
    if( true || argHasTypeThis){
      switch( data.length){
        case 0:
          return "";
        default:
          auto result= ""; {
            auto preResult=  to!( string[ T])( data);
            auto first= true;
            foreach( elem, unused; preResult){
              if( first)
                first= false;
              else
                result~= ", ";
              result~= to!string( elem);
            }
          }
          if ( data.length  ==  1)
            return result;
          else
            return "[ " ~result ~"]";
      }
    } else {
      //auto Result=  "* =" ~to!( string[ T])( data) ~"* \n";
      //return  "* =" ~to!( string[ T])( data) ~"*";
      return "not yet implemented";
    }
  }
/**
  * Date: 24.12.2012  Author: Manfred Nowak, svv1999@hotmail.com
  */
  extern T t;
}
unittest{ /// Testing the functionality
  {
    alias Star!uint UintStar;
    auto star= new UintStar;
    assert( !star.argHasTypeThis);
    star+= 1;
    assert( 1 in star); /// element is included
    star-= 1;
    assert( 1 !in star); /// element is excluded

    auto star2= new UintStar;
    star2+= 1;
    star2+= 2;
    assert( 1 in star2 && 2 in star2); /// star2 has two elements
    star+= star2;
    assert( 1 in star && 2 in star); /// element is included
    star2-= 1;
    assert( 1 !in star2 && 2 in star2); /// star2 has one element
    star-= star2;
    assert( 1 in star && 2 !in star); /// element is excluded

    auto buffer= new SWrite;

    buffer.take( "%s", star);
    auto g= buffer.give;
    debug writeln( "\"",g,"\"");
    assert( g == "1");

    //auto buffer2= new SWrite;
    buffer.take( "%s", star2);
    auto g2= buffer.give;
    debug writeln( "\"",g2,"\"");
    assert( g2 == "2");

    star-= star;
    assert( star.data.length == 0);

  }

  {
    alias UintStar2= Star!( Star!uint);
    auto star= new UintStar2;
    assert( star.argHasTypeThis);

    auto buffer= new SWrite;
    buffer.take( "%s", star);
    auto g= buffer.give;
    debug writeln( "\"",g,"\"");
    assert( g == "");
  }

  debug writeln( "Star: Done.");
}
version( unittest){
  import std.stdio: writeln;
}
