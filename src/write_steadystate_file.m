function write_steadystate_file(ModelInfo, pathtosource, scriptname)

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

if nargin<2 || isempty(pathtosource)
    pathtosource = [ pwd() filesep() ];
end

% Create an m file returning the steadystate.
fidout = fopen([ModelInfo.fname '_steadystate_source.m'],'w');
fprintf(fidout, 'function [ys, params, info] = steadystate(ys, exo, params)\n');
if isoctave()
    fprintf(fidout,'%% File created by write_steadystate_file routine, %s.\n', datestr(clock));
else
    fprintf(fidout,'% File created by write_steadystate_file routine, %s.\n', datestr(clock));
end
fprintf(fidout,'\n');
fprintf(fidout,'info = 0;\n\n');

% Run script before evaluating the steady state
if nargin>2
   fidin = fopen(scriptname, 'r');
   while ~feof(fidin)
        line = fgetl(fidin);
        if ischar(line)
            fprintf(fidout, '%s\n', line);
        end
    end
   fprintf('\n')
end

c = textread([pathtosource ModelInfo.fname '_steadystate.source'],'%s','delimiter','\n');

c(cellfun(@isempty, c)) = [];  % Remove empty lines.
c = strtrim(c);                % Remove leading and trailing ses.

%
% Remove comments (%, %{, %}) and blank lines.
%

j = 1;
while j<=numel(c)
    cblock = false;
    % Convert Dynare-style comments to MATLAB-style comments
    c{j} = d2mcomments(c{j});
    id = regexp(c{j}, '%{');
    if ~isempty(id)
        cblock = true;
        if id(1)>1
            c{j} = c{j}(1:id(1)-1); % Keep part of the line before %{
            i = j + 1;
        else
            c(j) = [];              % Remove entire line if %{ is at the beginning of the line
            i = j;
        end
    end
    while cblock && i<=length(c)
        c{i} = d2mcomments(c{i});
        id = regexp(c{i}, '%}');
        if isempty(id)
            c(i) = [];
        else
            if length(c{i})>id(1)+1
                c{i} = c{i}(id{1}+2:end); % Keep part of the line after %}
                i = i + 1;
            else
                c(i) = [];
                c{i} = d2mcomments(c{i});
            end
            cblock = false;
        end
    end
    % Remove comments
    id = regexp(c{j}, '%');
    if ~isempty(id)
        if id(1)>1
            c{j} = c{j}(1:id(1)-1); % Keep part of the line before %
        else
            c(j) = [];              % Remove entire line if % is at the beginning of the line
        end
    end
    c{j} = strtrim(c{j});
    j = j + 1;
end

%
% Remove linebreaks in assignments.
%

i = 1;
while i < numel(c)
    if ~isequal(c{i}(end), ';')
        c{i} = strcat(c{i}, c{i+1});
        c(i+1) = [];
    else
        i = i + 1;
    end
end

%
% Replace endogenous variables, exogenoous variables and parameters by ys(i), xxo(i) and params(i).
%

for i=1:ModelInfo.param_nbr
    c = regexprep(c, sprintf('\\<%s\\>', ModelInfo.param_names{i}), sprintf('params(%u)', i));
end

for i=1:ModelInfo.orig_endo_nbr
    c = regexprep(c, sprintf('\\<%s\\>', ModelInfo.endo_names{i}), sprintf('ys(%u)', i));
end

for i=1:ModelInfo.exo_nbr
    c = regexprep(c, sprintf('\\<%s\\>', ModelInfo.exo_names{i}), sprintf('exo(%u)', i));
end

fprintf(fidout,'%s\n',c{:});
fclose(fidout);
