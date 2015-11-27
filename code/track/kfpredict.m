% Credit from http://www.cvlibs.net/software/trackbydet/ by Nov 25, 2015
function s = kfpredict(s)
s.x = s.A*s.x;
s.P = s.A*s.P*s.A' + s.Q;
if s.x(3)<20
    s.x(3) = 20;
end
if s.x(4)<20
    s.x(4) = 20;
end
end