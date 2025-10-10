function c = removetokensincellofstrings(c, symboltableelement)

% Remplaces an endogenous variable by ys(i) or a parameter by params(j) in a cell of strings.
%
% INPUTS 
% - c                    [cell]    Cell of strings, mathematical expressions used to define the steady state.
% - symboltableelement   [cell]    Row of the first output of getallsymbols() routine, describes an endogenous 
%                                  variable or a parameter.
%
% OUTPUTS 
% - c                    [cell]    Cell of strings.

% Copyright © 2017, 2025 Stéphane Adjemian
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

for j=1:length(c)
    c{j} = d2mcomments(c{j}); % Convert Dynare-style comments to MATLAB-style comments
    if isexpressionmember(symboltableelement{1}, c{j})
        if symboltableelement{4}
            % Endogenous variable.
            c(j) = { exactwordsubstitution(c{j}, symboltableelement{1}, sprintf('ys(%i)', symboltableelement{2})) };
        else
            % Parameter.
            c(j) = { exactwordsubstitution(c{j}, symboltableelement{1}, sprintf('params(%i)', symboltableelement{2})) };
        end
    end
end