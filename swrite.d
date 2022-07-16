/* Written in the D-Programming Language */
/***
  * Silent writing.
  *
  * This is a D-version of C's sprintf.
  *
  * ---
  * auto keeper= new Swrite;  // declaring an instance of a silent writer
  * keeper.take( string); // formats according to the arguments
  *                       // and remembers the string silently.
  * keeper.toString;      // peeks only.
  * keeper.give;  // return the remembered concatenated strings
  *               // and causes to forget them all.
  * keeper.isEmpty; // returns true iff nothing is remembered
  * ---
  */
class SWrite{
  private:
    import std.array: Appender;
  Appender!string retval; /// the internal storage
  void init(){
    retval= Appender!string("");
  }

  public:
  this(){
    init();
  }

  /// formats according to the arguments and remembers the formatted string
  void take( Any...)(  Any args)
    if( Any[0].stringof == "string")
  {
      import std.format: formattedWrite;
    formattedWrite( retval, args);
  }
  version( none)
  void opOpAssign( string op, Any...)( Any args)
    if( op == "+"  &&  Any[0].stringof == "string")
  do {
    take( args);
  }


  /// peeks only
  override string toString(){
    return retval.data;
  }
  /// returns everything remembered, then forgets all
  string give(){
    auto rv= retval.data;
    init();
    return rv;
  }
  /// is it all forgotten?
  bool isEmpty(){
    return retval.data.length == 0;
  }
}

///
unittest{
  auto keeper= new SWrite;
  assert( keeper.isEmpty, "unexpected content: \"" ~keeper.toString ~"\"");

  keeper.take( "%s", keeper); // peeking into the still empty keeper
  assert( keeper.isEmpty, "unexpected content: \"" ~keeper.toString ~"\"");

  {
    auto t= [ "Hello, world", "!"];
    auto result= t[ 0] ~t[ 1];
    assert( result  ==  "Hello, world!");

    version( none){
      keeper.take( "%s", t[ 0]);
      keeper+= [ "%s", t[ 1]];
    } else
      keeper.take( "%s", result);
    assert( !keeper.isEmpty, "unexpected empty content");

    string g= keeper.give;
    assert( keeper.isEmpty, "unexpected content: \"" ~keeper.toString ~"\"");
     
    debug write( g);
    assert( result  ==  g, "unexpected content: \"" ~keeper.toString ~"\"");
  }

  debug writeln( "SWrite: Done.");
}
version( unittest)
  import std.stdio;
