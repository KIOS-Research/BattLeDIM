function [detection] = readResultsFile(fname)

%% Read file and sort info:
fid=fopen(fname);
tline = fgetl(fid);
det_lines = cell(0,1);
i=1;
while ischar(tline)
    if isempty(tline) || strcmp(tline(1),'#') 
        tline = fgetl(fid);
        continue
    end
    det_lines{end+1,1} = tline;
    com = strfind(det_lines{end,1},',');
    detection(i).linkID = det_lines{end}(1:com(1)-1);
    detection(i).startTime = time2steps(det_lines{end}(com(1)+2:end));
    tline = fgetl(fid);
    i=i+1;
end
fclose(fid);

end