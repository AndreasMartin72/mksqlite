% BUILDIT - builds mksqlite
%
% possible commands:
% - buildit                     : builds the release of mksqlite
% - buildit release             : builds the release of mksqlite
% - buildit debug               : builds the debug version of mksqlite
% - buildit packrelease 1.x     : build a release and src package of version 1.x

%%
function buildit(varargin)

switch nargin

    case 0
        buildmksqlite('release');

    case 1

        switch varargin{1}

            case {'release' 'debug'}
                buildmksqlite(varargin{1});

            otherwise
                help(mfilename);
        end

    case 2

         switch varargin{1}

            case {'packrelease'}
%                 buildmksqlite('release');
                packmksqlite(varargin{2});

            otherwise
                help(mfilename);
        end

    otherwise
        help(mfilename);
        return;
end

%% do the build...
function buildmksqlite (buildtype)

% check the argument
if ~exist('buildtype', 'var') || isempty(buildtype) || ~ischar(buildtype)
    error ('wrong or empty argument');
end

switch buildtype

    case 'release'
        buildrelease = true;

    case 'debug'
        buildrelease = false;

    otherwise
    error ('wrong or empty argument');
end

fprintf ('compiling %s version of mksqlite...\n', buildtype);

% get the mex arguments
if buildrelease
    buildargs = '-output mksqlite -DNDEBUG#1 -DSQLITE_ENABLE_RTREE=1 -O mksqlite.cpp sqlite3.c';
else
    buildargs = '-output mksqlite -UNDEBUG -DSQLITE_ENABLE_RTREE=1 -g -v mksqlite.cpp sqlite3.c';
end

% additional libraries
if ispc
    buildargs = [buildargs ' user32.lib advapi32.lib'];
else
    buildargs = [buildargs ' -ldl'];
end

% save the current directory and get the version information
mksqlite_compile_currdir = pwd;
cd (fileparts(mfilename('fullpath')));

if 0  % set to 1 if you prefer using Windows and TortoiseSVN only...
    mksqlite_compile_subwcrev = [getenv('ProgramFiles') '\TortoiseSVN\bin\SubWCRev.exe'];

    if exist(mksqlite_compile_subwcrev, 'file')
        fprintf ('svn revision info:\n');
        system(['"' mksqlite_compile_subwcrev '" ' pwd ' svn_revision.tmpl svn_revision.h']);
    else
        if ~exist('svn_revision.h','file')
            copyfile('svn_revision.dummy','svn_revision.h');
        end
    end
else
    if ispc
        svnversion_cmd = [getenv('ProgramFiles') '\TortoiseSVN\bin\svnversion.exe'];
        if ~exist( svnversion_cmd, 'file' )
            svnversion_cmd = 'svnversion.exe'; % try if svnversion in in PATH
        end
    else
        svnversion_cmd = 'svnversion';
    end

    [status, str_revision] = system( [svnversion_cmd, ' -n'] );
    if status ~= 0
        copyfile('svn_revision.dummy','svn_revision.h');
    else
        fid = fopen( 'svn_revision.h', 'w' );
        if str_revision(end) == 'M'
            str_modified = '(modified)';
            str_revision(end) = [];
        else
            str_modified = '';
        end

        try
          fprintf( fid, ['#ifndef __SVN_REVISION_H\n', ...
                         '#define __SVN_REVISION_H\n\n', ...
                         '#define SVNREV "build: %s %s"\n\n', ...
                         '#endif // __SVN_REVISION_H'], ...
                         str_revision, str_modified );
        catch ex
            fclose( fid );
            throw ex
        end

        fclose( fid );
    end
end

% do the compile via mex
eval (['mex ' buildargs]);

% back to the start directory
cd (mksqlite_compile_currdir);

fprintf ('completed.\n');

%%
function packmksqlite(versionnumber)

relmaindir = 'releases';

% check the argument
if ~exist('versionnumber', 'var') || isempty(versionnumber) || ~ischar(versionnumber)
    error ('wrong or empty argument');
end

% create the directories
if ~exist(relmaindir, 'dir')
    mkdir(relmaindir);
    if ~exist(relmaindir, 'dir')
       error (['cannot create directory ' relmaindir]);
    end
end

reldir = [relmaindir filesep 'mksqlite-' versionnumber];
srcdir = [relmaindir filesep 'mksqlite-' versionnumber '-src'];

if exist (reldir, 'file')
    error(['there is already a directory or file named ' reldir]);
end
if exist (srcdir, 'file')
    error(['there is already a directory or file named ' srcdir]);
end

if ~exist(reldir, 'dir')
    mkdir(reldir);
    if ~exist(reldir, 'dir')
       error (['cannot create directory ' reldir]);
    end
end
if ~exist(srcdir, 'dir')
    mkdir(srcdir);
    if ~exist(srcdir, 'dir')
       error (['cannot create directory ' srcdir]);
    end
end


fprintf ('packing mksqlite release files\n');

% copy files
% release
copyfile('Changelog.txt', reldir);
copyfile('mksqlite.m', reldir);

% x86 32-bit version (MSVC 2010 / Win7) / MATLAB Version 7.7.0.471 (R2008b)
copyfile('mksqlite.mexw32', reldir);

% x86 64-bit version (MSVC 2010 / Win7) / MATLAB Version 7.13.0.564 (R2011b)
if exist('mksqlite.mexw64', 'file' )
  copyfile('mksqlite.mexw64', reldir);
end

% x86 64-bit version (gcc 4.1.2 20080704 / Red Hat 4.1.2-52)
% MATLAB Version 7.13.0.564 (R2011b)
if exist('mksqlite.mexa64', 'file' )
  copyfile('mksqlite.mexa64', reldir);
end

copyfile('README.TXT', reldir);
copyfile('sqlite_test.m', reldir);
copyfile('sqlite_test_bind.m', reldir);
copyfile('sqlite_test_bind_typed.m', reldir);
mkdir ([reldir filesep 'docu']);
copyfile(['docu' filesep 'index.html'], [reldir filesep 'docu']);
copyfile(['docu' filesep 'mksqlite_eng.html'], [reldir filesep 'docu']);
copyfile(['docu' filesep 'mksqlite_ger.html'], [reldir filesep 'docu']);

% source
copyfile('buildit.m', srcdir);
copyfile('Changelog.txt', srcdir);
copyfile('mksqlite.cpp', srcdir);
copyfile('mksqlite.m', srcdir);

% x86 32-bit version (MSVC 2010 / Win7) / MATLAB Version 7.7.0.471 (R2008b)
copyfile('mksqlite.mexw32', srcdir);

% x86 64-bit version (MSVC 2010 / Win7) / MATLAB Version 7.13.0.564 (R2011b)
if exist('mksqlite.mexw64', 'file' )
  copyfile('mksqlite.mexw64', srcdir);
end

% x86 64-bit version (gcc 4.1.2 20080704 / Red Hat 4.1.2-52)
% MATLAB Version 7.13.0.564 (R2011b)
if exist('mksqlite.mexa64', 'file' )
  copyfile('mksqlite.mexa64', srcdir);
end

copyfile('README.TXT', srcdir);
copyfile('shell.c', srcdir);
copyfile('sqlite3.c', srcdir);
copyfile('sqlite3.h', srcdir);
copyfile('sqlite3ext.h', srcdir);
copyfile('sqlite_test.m', srcdir);
copyfile('sqlite_test_bind.m', srcdir);
copyfile('sqlite_test_bind_typed.m', srcdir);
copyfile('svn_revision.dummy', srcdir);
copyfile('svn_revision.h', srcdir);
copyfile('svn_revision.tmpl', srcdir);
mkdir ([srcdir filesep 'docu']);
copyfile(['docu' filesep 'index.html'], [srcdir filesep 'docu']);
copyfile(['docu' filesep 'mksqlite_eng.html'], [srcdir filesep 'docu']);
copyfile(['docu' filesep 'mksqlite_ger.html'], [srcdir filesep 'docu']);

% save the current directory
mksqlite_compile_currdir = pwd;

% create archives
cd (relmaindir);
zip (['mksqlite-' versionnumber], '*.*', ['mksqlite-' versionnumber filesep]);
zip (['mksqlite-' versionnumber '-src'], '*.*', ['mksqlite-' versionnumber '-src' filesep]);

% back to the start directory
cd (mksqlite_compile_currdir);

fprintf ('completed\n');
