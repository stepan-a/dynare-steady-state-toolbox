function [symboltable, nsymbols] = getallsymbols(ModelInfo)

% Get all the symbols in a mod file (parameters and endogenous variables).
%
% INPUTS 
% - ModelInfo      [struct]    Dynare generated M_ global structure (description of the model)
%
% OUTPUTS 
% - symboltable    [cell]      nsymbols*4 cell array. First column holds the names of the objects. Second column
%                              shows corresponding indices in the vector of endogenous variables and the vector
%                              of parameters. Third column gives the length of the names in first column. Finally,
%                              the fourth column is a dummy variable equal to 1 if the name is for an endogenous 
%                              variable, 0 if the name is for a parameter.  
% - nsymbols       [integer]   scalar, number of symbols.
    
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

% First column holds the names of the endogenous variables and parameters.    
varnames = ModelInfo.endo_names;
parnames = ModelInfo.param_names;

% (Add) Second column holding the indices of the variables and parameters in ModelInfo.endo_simul and ModelInfo.params
varnames = [cellstr(varnames), num2cell(transpose(1:length(varnames)))];
parnames = [cellstr(parnames), num2cell(transpose(1:length(parnames)))];

% (Add) Third column holding the number of number alphanumeric caracters in each object name.
% (Add) Fourth column with a dummy variable (1 => endogenous variable, 0 => parameter).
varnames = [varnames, num2cell(cellfun('size',varnames(:,1),2)), num2cell(ones(length(varnames),1))];
parnames = [parnames, num2cell(cellfun('size',parnames(:,1),2)), num2cell(zeros(length(parnames),1))];

% Sort the table of symbols with respect to the length of the object names (decreasing order).
symboltable = [varnames; parnames];
if isoctave()
    lengths = cell2mat(symboltable(:,3));
    [~, idx] = sort(lengths, 'descend');
    symboltable = symboltable(idx,:);
else
    symboltable = sortrows(symboltable, -3);
end

% Return the number of symbols
nsymbols = size(symboltable,1);