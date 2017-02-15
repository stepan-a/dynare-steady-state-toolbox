function str = exactwordsubstitution(str, old, new)

% Replace word in a string.
%
% INPUTS 
% - str      [string]   Original string.
% - old      [string]   Word to be replaced.
% - new      [string]   Substituted word.
%
% OUTPUTS 
% - str      [string]   Transformed string.

% Copyright © 2017 Stéphane Adjemian
%
% This file is part of the Dynare Steady State Toolbox.
%
% Dynare Steady State Toolbox is free software: you can redistribute it
% and/or modify it under the terms of the GNU General Public License as
% published by the Free Software Foundation, either version 3 of the
% License, or (at your option) any later version.
%
% This toolbox is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare Steady State Toolbox.  If not, see <http://www.gnu.org/licenses/>.

str = strtrim(str);

if ~isequal(str(1),'%')
    str = sprintf(' %s ', str);
    str = regexprep(str, sprintf('(?<=[^a-zA-Z0-9])%s(?=[^a-zA-Z0-9])', old), new);
    str = strtrim(str);
end