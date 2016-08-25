function sqlite_test_object

  clear all
  
  assert( exist( 'sql_object', 'class' ) == 8, ...
          ['You need sql_object from ', ...
           'https://de.mathworks.com/matlabcentral/fileexchange/58433-using-sqlite-databases-via-objects ', ...
           'to run this test!'] );

  % Create a small table
  db = sql_object( 'dbfile.db' );
  db.ParamWrapping = 1;
  db.exec( 'CREATE TABLE tbl (id INT PRIMARY KEY, name TEXT)' );

  % Insert some values
  db.Begin;
  db.exec( 'INSERT INTO tbl VALUES (?,?)', {1, 'red', 2, 'green', 3, 'blue'} );
  db.Commit;
  
  % Create another independent database and delete it
  test_create;
  delete( 'test_delete.db' );

  % Create a new in-memory database and attach the recent created
  db = sql_object( ':memory:' );
  db.Attach( 'colors', 'dbfile.db' );
  values = db.exec( 'SELECT * FROM colors.tbl' );
  clear db

  for i = 1:numel(values)
    fprintf( '%d: %s\n', values(i).id, values(i).name );
  end

  delete( 'dbfile.db' );
  
  test_functors;
  
  fprintf( 'Test succeeded if all databases are closed:\n' );
  sql_object.Status;
end

function test_create
  db = sql_object( 'test_delete.db' );
  db.ParamWrapping = 1;
  db.exec( 'CREATE TABLE tbl (id INT PRIMARY KEY, name TEXT)' );

  db.Begin;
  db.exec( 'INSERT INTO tbl VALUES (?,?)', {10, 'small', 20, 'big', 30, 'huge'} );
  db.Commit;
  
  % No explicit close necessary!
end

function test_functors
  db = sql_object( ':memory:' );
  db.CreateFunction( 'test', @(a,b) a+b );
  x = db.Select( 'test(2,3) as result' )
  assert( x.result == 5 );
end
