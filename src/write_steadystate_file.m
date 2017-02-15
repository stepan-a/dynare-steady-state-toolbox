function write_steadystate_file(ModelInfo, pathtosource)

% Transforms the Matlab script defining the steady state into a *_steadystate2.m like file (readable by Dynare).
%
% INPUTS 
% - ModelInfo      [struct]  Dynare generated M_ global structure (description of the model)
% - pathtosource   [string]  Path to the folder where the matlab script is to be found.
%
% OUTPUTS 
% none
%
% REMARKS 
% This function has no output, but will write a file called <ModelInfo_.fname>_steadystate_source.m.
    
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

if nargin<2 || isempty(pathtosource)
    pathtosource = [ pwd() filesep() ];
end

% Get the list of symbols (endogenous variables and parameters).
[symboltable, nsymbols] = getallsymbols(ModelInfo);

% Create an m file returning the steadystate.
fidout = fopen([ModelInfo.fname '_steadystate_source.m'],'w');
fprintf(fidout,'function [ys, params, info] = %s_steadystate2(ys, exo, params)\n',ModelInfo.fname);
fprintf(fidout,'% File created by write_steadystate_file routine, %s.\n', datestr(datetime));
fprintf(fidout,'\n');
fprintf(fidout,'info = 0;\n\n');

c = textread([pathtosource ModelInfo.fname '_steadystate.source'],'%s','delimiter','\n');

for i=1:nsymbols
    % Replace endogenous variables and parameters tokens by elements in vectors ys and params.
    c = removetokensincellofstrings(c, symboltable(i,:));
end

fprintf(fidout,'%s\n',c{:});
fclose(fidout);