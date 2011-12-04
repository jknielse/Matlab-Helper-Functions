function latex(matrix, filename, varargin)

% function: matrix2latex(...)
% Author:   M. Koehler
% Contact:  koehler@in.tum.de
% Version:  1.1
% Date:     May 09, 2004

% This software is published under the GNU GPL, by the free software
% foundation. For further reading see: http://www.gnu.org/licenses/licenses.html#GPL

% Usage:
% matrix2late(matrix, filename, varargs)
% where
%   - matrix is a 2 dimensional numerical or cell array
%   - filename is a valid filename, in which the resulting latex code will
%   be stored
%   - varargs is one ore more of the following (denominator, value) combinations
%      + 'rowLabels', array -> Can be used to label the rows of the
%      resulting latex table
%      + 'columnLabels', array -> Can be used to label the columns of the
%      resulting latex table
%      + 'alignment', 'value' -> Can be used to specify the alginment of
%      the table within the latex document. Valid arguments are: 'l', 'c',
%      and 'r' for left, center, and right, respectively
%      + 'format', 'value' -> Can be used to format the input data. 'value'
%      has to be a valid format string, similar to the ones used in
%      fprintf('format', value);
%      + 'size', 'value' -> One of latex' recognized font-sizes, e.g. tiny,
%      HUGE, Large, large, LARGE, etc.
%
% Example input:
%   matrix = [1.5 1.764; 3.523 0.2];
%   rowLabels = {'row 1', 'row 2'};
%   columnLabels = {'col 1', 'col 2'};
%   matrix2latex(matrix, 'out.tex', 'rowLabels', rowLabels, 'columnLabels', columnLabels, 'alignment', 'c', 'format', '%-6.2f', 'size', 'tiny'...
%                   , 'vlines', '1', hlines', '1');
%
% The resulting latex file can be included into any latex document by:
% /input{out.tex}
%
% Enjoy life!!!

rowLabels = [];
colLabels = [];
alignment = 'l';
hlines = 1;
vlines = 1;
format = [];
textsize = [];
if (rem(nargin,2) == 1 || nargin < 2)
    error('matrix2latex: ', 'Incorrect number of arguments to %s.', mfilename);
end

okargs = {'rowlabels','columnlabels', 'alignment', 'format', 'size', 'vlines', 'hlines'};
for j=1:2:(nargin-2)
    pname = varargin{j};
    pval = varargin{j+1};
    k = strmatch(lower(pname), okargs);
    if isempty(k)
        error('matrix2latex: ', 'Unknown parameter name: %s.', pname);
    elseif length(k)>1
        error('matrix2latex: ', 'Ambiguous parameter name: %s.', pname);
    else
        switch(k)
            case 1  % rowlabels
                rowLabels = pval;
                if isnumeric(rowLabels)
                    rowLabels = cellstr(num2str(rowLabels(:)));
                end
            case 2  % column labels
                colLabels = pval;
                if isnumeric(colLabels)
                    colLabels = cellstr(num2str(colLabels(:)));
                end
            case 3  % alignment
                alignment = lower(pval);
                if alignment == 'right'
                    alignment = 'r';
                end
                if alignment == 'left'
                    alignment = 'l';
                end
                if alignment == 'center'
                    alignment = 'c';
                end
                if alignment ~= 'l' && alignment ~= 'c' && alignment ~= 'r'
                    alignment = 'l';
                    warning('matrix2latex: ', 'Unkown alignment. (Set it to \''left\''.)');
                end
            case 4  % format
                format = lower(pval);
            case 5  % Font size
                textsize = pval;
            case 6  % Vertical lines or not
                vlines = pval;
            case 7  % Horizontal lines or not
                hlines = pval;
        end
    end
end


if isequal(filename, '__MCL')

    outputstr = '';

    width = size(matrix, 2);
    height = size(matrix, 1);

    if isnumeric(matrix)
        matrix = num2cell(matrix);
        for h=1:height
            for w=1:width
                if(~isempty(format))
                    matrix{h, w} = num2str(matrix{h, w}, format);
                else
                    matrix{h, w} = num2str(matrix{h, w});
                end
            end
        end
    end

    if(~isempty(textsize))
        outputstr = strcat(outputstr, sprintf('\\begin{%s}', textsize) );
    end

    outputstr = strcat(outputstr,sprintf('\r\\n\b\b$\r\\n\b\b\\left(\r\\n\b\b\\begin{array}{') );

    if(~isempty(rowLabels))
        outputstr = strcat(outputstr, sprintf( 'l|') );
    end
    for i=1:width
        
        % IF vlines is enabled then add them in the tabular.
        if isequal(vlines, 1)
            outputstr = strcat(outputstr, sprintf('%c|', alignment) );
        else
            % Do not add them
                outputstr = strcat(outputstr, sprintf('%c', alignment) );            
        end
    end
    outputstr = strcat(outputstr, sprintf('}\r\\n\b\b') );

    
    if(~isempty(colLabels))
        if(~isempty(rowLabels))
            outputstr = strcat(outputstr, sprintf('&') );
        end
        for w=1:width-1
            outputstr = strcat(outputstr, sprintf('\\textbf{%s}&', colLabels{w}) );
        end
        outputstr = strcat(outputstr, sprintf('\\textbf{%s}\\\\\\hline\r\\n\b\b', colLabels{width}) );
    end

    for h=1:height
        if(~isempty(rowLabels))
            outputstr = strcat(outputstr, sprintf('\\textbf{%s}&', rowLabels{h}) );
        end
        for w=1:width-1
            outputstr = strcat(outputstr, sprintf('%s&', matrix{h, w}) );
        end
        
        % If the horizontal lines are enabled, add them.
        if isequal(hlines, 1)
            outputstr = strcat(outputstr, sprintf('%s\\\\\r\\n\b\b\\hline\r\\n\b\b', matrix{h, width}) );
        else
            if ~isequal(h, height)
                outputstr = strcat(outputstr, sprintf('%s\\\\\r\\n\b\b', matrix{h, width}) );
            else
                outputstr = strcat(outputstr, sprintf('%s\\\\\r\\n\b\b', matrix{h, width}) );
            end
        end
    end

    outputstr = strcat(outputstr, sprintf('\\end{array}\r\\n\b\b\\right)\r\\n\b\b$\r\\n\b\b') );

    if(~isempty(textsize))
        outputstr = strcat(outputstr, sprintf('\\end{%s}', textsize) );
    end
    sprintf('%s',outputstr)

else

    fid = fopen(filename, 'w');

    width = size(matrix, 2);
    height = size(matrix, 1);

    if isnumeric(matrix)
        matrix = num2cell(matrix);
        for h=1:height
            for w=1:width
                if(~isempty(format))
                    matrix{h, w} = num2str(matrix{h, w}, format);
                else
                    matrix{h, w} = num2str(matrix{h, w});
                end
            end
        end
    end

    if(~isempty(textsize))
        fprintf(fid, '\\begin{%s}', textsize);
    end

    fprintf(fid, '\\begin{tabular}{|');

    if(~isempty(rowLabels))
        fprintf(fid, 'l|');
    end
    for i=1:width
        fprintf(fid, '%c|', alignment);
    end
    fprintf(fid, '}\r\n');

    fprintf(fid, '\\hline\r\n');

    if(~isempty(colLabels))
        if(~isempty(rowLabels))
            fprintf(fid, '&');
        end
        for w=1:width-1
            fprintf(fid, '\\textbf{%s}&', colLabels{w});
        end
        fprintf(fid, '\\textbf{%s}\\\\\\hline\r\n', colLabels{width});
    end

    for h=1:height
        if(~isempty(rowLabels))
            fprintf(fid, '\\textbf{%s}&', rowLabels{h});
        end
        for w=1:width-1
            fprintf(fid, '%s&', matrix{h, w});
        end
        fprintf(fid, '%s\\\\\\hline\r\n', matrix{h, width});
    end

    fprintf(fid, '\\end{tabular}\r\n');

    if(~isempty(textsize))
        fprintf(fid, '\\end{%s}', textsize);
    end

    fclose(fid);

end
