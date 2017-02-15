function c = isexpressionmember(a, b)

% Returns true iff symbol a appears in expression b.
%
% INPUTS 
% - a      [string]   Name of a symbol (endogenous variable or parameter).
% - b      [string]   Mathematical expression.
%
% OUTPUTS 
% - c      [logical]

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

% Set default value (a is not a member of b)
c = false;

% Get all the tokens in expression b.
tokens = getalltokens(b);

% Return false if b is empty
if isempty(tokens)
    return
end

% Test of a belongs to the list of tokens.
c = ismember(a, tokens);