function labels_write (tracklets,filename)

% parse input file
fid = fopen(filename,'w');

% for all frames do
for f = 1:numel(tracklets)
  objects = tracklets{f};
  
  % for all objects do
  for o = 1:numel(objects)
    
    % set frame and tracking-id
    if isfield(objects(o),'frame'),        fprintf(fid,'%d ',objects(o).frame);
    else                                   error('ERROR: frame not specified!'), end;
    if isfield(objects(o),'id'),           fprintf(fid,'%d ',objects(o).id);
    else                                   error('ERROR: frame not specified!'), end;
    
    % set 2D bounding box in 0-based C++ coordinates
    if isfield(objects(o),'x1'),           fprintf(fid,'%.2f ',objects(o).x1);
    else                                   error('ERROR: x1 not specified!'); end;
    if isfield(objects(o),'y1'),           fprintf(fid,'%.2f ',objects(o).y1);
    else                                   error('ERROR: y1 not specified!'); end;
    if isfield(objects(o),'x2'),           fprintf(fid,'%.2f ',objects(o).x2);
    else                                   error('ERROR: x2 not specified!'); end;
    if isfield(objects(o),'y2'),           fprintf(fid,'%.2f ',objects(o).y2);
    else                                   error('ERROR: y2 not specified!'); end;

    % next line
    fprintf(fid,'\n');
  end
end

% close file
fclose(fid);

function alpha = wrapToPi(alpha)

% wrap to [0..2*pi]
alpha = mod(alpha,2*pi);

% wrap to [-pi..pi]
idx = alpha>pi;
alpha(idx) = alpha(idx)-2*pi;

