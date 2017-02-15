function b = isnewer(f1, f2, F1, F2)

% Returns true if file f1 is newer than file f2. The routine returns an error if f1
% does not exist, and true if f2 does not exist.
%
% INPUTS 
% - f1   [string]    name of a file.
% - f2   [string]    name of a file.
% - F1   [string]    path to the file designated by f1.
% - F2   [string]    path to the file designated by f2.
%
% OUTPUTS 
% - b    [logical]

% Copyright © 2017 Stéphane Adjemian
%
% This file is part of the Dynare Steady State Toolbox.
%
% Dynare Steady State Toolbox is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This toolbox is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare Steady State Toolbox.  If not, see <http://www.gnu.org/licenses/>.

if nargin<3 || isempty(F1)
    % Files should be in the current folder.
    F1 = pwd();
end

if nargin<4 || isempty(F2)
    % Files should be in the current folder.
    F2 = pwd();
end

% List all the files in F1
allfiles1 = dir(F1);

% List all the files in F2
if isequal(F1, F2)
    allfiles2 = allfiles1;
else
    allfiles2 = dir(F2);
end

% Check that f1 belongs to the set of files in F1, if not throw an error.
if ~ismember(f1, {allfiles1.name})
    error('File %s does not exist!', f1)
else
    % Get index corresponding to f1 in the struct array returned by dir()
    i1 = find(not(cellfun(@isempty,strfind({allfiles1.name}, f1))));
end

% Check that f2 belongs to the set of files in F2, if not return true (f2 is newer than f1, if f1 exists and f2 does not exist).
if ~ismember(f2, {allfiles2.name})
    b = true;
    return
else
    % Get index corresponding to f1 in the struct array returned by dir()
    i2 = find(not(cellfun(@isempty,strfind({allfiles2.name}, f2))));
end

% Get time stamps for f1 and f2.
d1 = allfiles1(find(not(cellfun(@isempty,strfind({allfiles1.name}, f1))))).datenum;
d2 = allfiles2(find(not(cellfun(@isempty,strfind({allfiles2.name}, f2))))).datenum;

% Return true if and only if f1 is more recent than f2.
b = d1>d2;