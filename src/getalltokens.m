function tokens = getalltokens(str)

% Returns all variables and parameters in a mathematical expression.
%
% INPUTS 
% - str      [string]  Mathematical expression.
%
% OUTPUTS 
% - tokens   [cell]    Cell of strings

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


% Returns tokens, as a cell a strings, in expression str. 
tokens = unique(strsplit(str,{' ', '*', '(', ')', '+', '[', ']', '-', '^', '/', '=', ';', '{', '}', '>', '<', '<=', '>='}));

% Remove empty elements.
if ~isempty(tokens)
    tokens = tokens(find(not(cellfun(@isempty, tokens))));
end