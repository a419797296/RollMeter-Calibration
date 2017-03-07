function h=mycomet(varargin)
%MYCOMET  Comet-like trajectory.
%   MYCOMET(Y) displays an animated comet plot of the vector Y.
%   MYCOMET(X,Y) displays an animated comet plot of vector Y vs. X.
%   MYCOMET(X,Y,p) uses a mycomet of length pause(p*0.1).  Default is p = 0.010.
%
%   MYCOMET(AX,...) plots into AX instead of GCA.
%
%   Example:
%       t = -pi:pi/200:pi;
%       mycomet(t,tan(sin(t))-sin(tan(t)))
%
%   See also COMET3.
%   Author :hyyly520

% Parse possible Axes input
[ax,args,nargs] = axescheck(varargin{:});

error(nargchk(1,3,nargs,'struct'));

% Parse the rest of the inputs
if nargs < 2, x = args{1}; y = x; x = 1:length(y); end
if nargs == 2, [x,y] = deal(args{:}); end
if nargs < 3, p = 0.10; end
if nargs == 3, [x,y,p] = deal(args{:}); end

if ~isscalar(p) || ~isreal(p) ||  p < 0 || p >= 1
    error('MATLAB:comet:InvalidP', ...
          'The input ''p'' must be a real scalar between 0 and 1.');
end

ax = newplot(ax);
if ~ishold(ax)
  [minx,maxx] = minmax(x);
  [miny,maxy] = minmax(y);
  axis(ax,[minx maxx miny maxy])
end
co = get(ax,'colororder');

 % Choose first three colors for head, body, and tail
 head = line('parent',ax,'color',co(1,:),'marker','o','erase','xor', ...
              'xdata',x(1),'ydata',y(1));
 body = line('parent',ax,'color',co(1,:),'linestyle','-','erase','none', ...
              'xdata',[],'ydata',[]);

m = length(x);
p=p*0.1;
% This try/catch block allows the user to close the figure gracefully
% during the comet animation.
try
    % Grow the body
    for i = 2:m%k+1
        j = i-1:i;
        set(head,'xdata',x(i),'ydata',y(i))
        set(body,'xdata',x(j),'ydata',y(j))
        %line([x(i),x(i+1)],[y(i),y(i+1)],'LineStyle','-');
        drawnow
        pause(p)
    end
    hold on;
    h=plot(x,y);
    axis(ax,[minx maxx miny maxy])
    hold off;
catch E
    if ~strcmp(E.identifier, 'MATLAB:class:InvalidHandle')
        rethrow(E);
    end
end

function [minx,maxx] = minmax(x)
minx = min(x(isfinite(x)));
maxx = max(x(isfinite(x)));
if minx == maxx
  minx = maxx-1;
  maxx = maxx+1;
end

