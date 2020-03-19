function lorenz(action)
global SIGMA RHO BETA
SIGMA = 10.;
RHO = 28.;
BETA = 8./3.;

play= 1;
if nargin<1,
    action='initialize';
end

switch action
    case 'initialize'
        oldFigNumber=watchon;

        figNumber=figure( ...
            'Name','Lorenz Attractor', ...
            'NumberTitle','off', ...
            'Visible','off');
        colordef(figNumber,'black')
        axes( ...
            'Units','normalized', ...
            'Position',[0.05 0.10 0.75 0.95], ...
            'Visible','off');

        text(0,0,'Press the "Start" button to see the Lorenz demo', ...
            'HorizontalAlignment','center');
        axis([-1 1 -1 1]);
        xPos=0.85;
        btnLen=0.10;
        btnWid=0.10;
        spacing=0.05;
        frmBorder=0.02;
        yPos=0.05-frmBorder;
        frmPos=[xPos-frmBorder yPos btnLen+2*frmBorder 0.9+2*frmBorder];
        uicontrol( ...
            'Style','frame', ...
            'Units','normalized', ...
            'Position',frmPos, ...
            'BackgroundColor',[0.50 0.50 0.50]);
        btnNumber=1;
        yPos=0.90-(btnNumber-1)*(btnWid+spacing);
        labelStr='Start';
        callbackStr='lorenz(''start'');';
        btnPos=[xPos yPos-spacing btnLen btnWid];
        startHndl=uicontrol( ...
            'Style','pushbutton', ...
            'Units','normalized', ...
            'Position',btnPos, ...
            'String',labelStr, ...
            'Interruptible','on', ...
            'Callback',callbackStr);
        btnNumber=2;
        yPos=0.90-(btnNumber-1)*(btnWid+spacing);
        labelStr='Stop';
  callbackStr='set(gca,''Userdata'',-1)';
        btnPos=[xPos yPos-spacing btnLen btnWid];
        stopHndl=uicontrol( ...
            'Style','pushbutton', ...
            'Units','normalized', ...
            'Position',btnPos, ...
            'Enable','off', ...
            'String',labelStr, ...
            'Callback',callbackStr);
        labelStr='Info';
        callbackStr='lorenz(''info'')';
        infoHndl=uicontrol( ...
            'Style','push', ...
            'Units','normalized', ...
            'position',[xPos 0.20 btnLen 0.10], ...
            'string',labelStr, ...
            'call',callbackStr); 
        labelStr='Close';
        callbackStr= 'close(gcf)';
        closeHndl=uicontrol( ...
            'Style','push', ...
            'Units','normalized', ...
            'position',[xPos 0.05 btnLen 0.10], ...
            'string',labelStr, ...
            'call',callbackStr);
  hndlList=[startHndl stopHndl infoHndl closeHndl];
        set(figNumber,'Visible','on', ...
            'UserData',hndlList);
        
        set(figNumber, 'CloseRequestFcn', 'clear global SIGMA RHO BETA;closereq');
        watchoff(oldFigNumber);
        figure(figNumber);

    case 'start'
        axHndl=gca;
        figNumber=gcf;
        hndlList=get(figNumber,'UserData');
        startHndl=hndlList(1);
        stopHndl=hndlList(2);
        infoHndl=hndlList(3);
        closeHndl=hndlList(4);
        set([startHndl closeHndl infoHndl],'Enable','off');
        set(stopHndl,'Enable','on');
        set(figNumber,'Backingstore','off');
        set(axHndl, ...
            'XLim',[0 40],'YLim',[-35 10],'ZLim',[-10 40], ...
            'Userdata',play, ...
            'XTick',[],'YTick',[],'ZTick',[], ...
            'Drawmode','fast', ...
            'Visible','on', ...
            'NextPlot','add', ...
            'Userdata',play, ...
            'View',[-37.5,30]);
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
 	  FunFcn='lorenzeq';
        y0(1)=rand*30+5;
        y0(2)=rand*35-30;
        y0(3)=rand*40-5;
        t0=0;
        tfinal=100;
        pow = 1/3;
        tol = 0.001;

        t = t0;
        hmax = (tfinal - t)/5;
        hmin = (tfinal - t)/200000;
        h = (tfinal - t)/100;
        y = y0(:);
        L = 50;
        Y = y*ones(1,L);
        cla;
        head = line( ...
            'color','r', ...
            'Marker','.', ...
            'markersize',25, ...
            'erase','xor', ...
            'xdata',y(1),'ydata',y(2),'zdata',y(3));
        body = line( ...
            'color','y', ...
            'LineStyle','-', ...
            'erase','none', ...
            'xdata',[],'ydata',[],'zdata',[]);
        tail=line( ...
            'color','b', ...
            'LineStyle','-', ...
            'erase','none', ...
            'xdata',[],'ydata',[],'zdata',[]);

        while (get(axHndl,'Userdata')==play) && (h >= hmin)
            if t + h > tfinal, h = tfinal - t; end
            % Compute the slopes
            s1 = feval(FunFcn, t, y);
            s2 = feval(FunFcn, t+h, y+h*s1);
            s3 = feval(FunFcn, t+h/2, y+h*(s1+s2)/4);

            % Estimate the error and the acceptable error
            delta = norm(h*(s1 - 2*s3 + s2)/3,'inf');
            tau = tol*max(norm(y,'inf'),1.0);

            % Update the solution only if the error is acceptable
            if delta <= tau
                t = t + h;
                y = y + h*(s1 + 4*s3 + s2)/6;

                % Update the plot
                Y = [y Y(:,1:L-1)];
                set(head,'xdata',Y(1,1),'ydata',Y(2,1),'zdata',Y(3,1))
                set(body,'xdata',Y(1,1:2),'ydata',Y(2,1:2),'zdata',Y(3,1:2))
                set(tail,'xdata',Y(1,L-1:L),'ydata',Y(2,L-1:L),'zdata',Y(3,L-1:L))
                drawnow;
            end
            if delta ~= 0.0
                h = min(hmax, 0.9*h*(tau/delta)^pow);
            end
            if ~ishandle(axHndl)
                return
            end
            
        end   
        set([startHndl closeHndl infoHndl],'Enable','on');
        set(stopHndl,'Enable','off');

    case 'info'
        helpwin(mfilename);

end  


function ydot = lorenzeq(t,y)
global SIGMA RHO BETA
A = [-BETA 0 y(2) 0 -SIGMA SIGMA -y(2) RHO -1];
ydot = A*y;
