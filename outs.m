function varargout = outs(varargin)
% OUTS MATLAB code for outs.fig
%      OUTS, by itself, creates a new OUTS or raises the existing
%      singleton*.
%
%      H = OUTS returns the handle to a new OUTS or the handle to
%      the existing singleton*.
%
%      OUTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OUTS.M with the given input arguments.
%
%      OUTS('Property','Value',...) creates a new OUTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before outs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to outs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help outs

% Last Modified by GUIDE v2.5 06-Jun-2018 13:10:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @outs_OpeningFcn, ...
                   'gui_OutputFcn',  @outs_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before outs is made visible.
function outs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to outs (see VARARGIN)

% Choose default command line output for outs
handles.output = hObject;
handles.table=0;
% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using outs.
if strcmp(get(hObject,'Visible'),'off')
    
   % try
        handles.settingsTable=readtable('Settings.csv');
        setsize=size(handles.settingsTable);
        setsize=setsize(1);
        x=cell(setsize,1);
        for i=1:setsize
            x(i)=handles.settingsTable{i,6};
        end
        handles.setPop.String=x;
   % catch
    %    errordlg('Settings.csv not found')
    %    return
   % end
    uistack(handles.axes1, 'top') 
    handles.segs=zeros(100,4);
    handles.running=0;
    handles.NumOfSpeakers=2;
    
    handles.axesarr=cell(4,1);
    handles.axesarr{1}=handles.AP1;
    handles.axesarr{2}=handles.AP2;
    handles.axesarr{3}=handles.AP3;
    handles.axesarr{4}=handles.AP4;
    
    handles.axesarra{1}=handles.axes1;
    handles.axesarra{2}=handles.axes2;
    handles.axesarra{3}=handles.axes3;
    handles.axesarra{4}=handles.axes4;
    
    

    
    axes(handles.axes1)
    handles.currax=handles.axesarra{1};
    for i=1:4
        
        set(handles.axesarr{i},'visible', 'off');
    end
    set(handles.axesarr{1},'visible', 'on');
    
    D=imread('.\help\logo.png');
    imshow(D,'Parent', handles.axesH);
    imshow(D,'Parent', handles.axes1);
    
    
    handles.tgroup = uitabgroup('Parent', handles.figure1,'TabLocation', 'top');
    handles.tab1 = uitab('Parent', handles.tgroup, 'Title', 'Graphs');
    handles.tab2 = uitab('Parent', handles.tgroup, 'Title', 'Settings');
    handles.tab3 = uitab('Parent', handles.tgroup, 'Title', 'Table and export');
    handles.tab4 = uitab('Parent', handles.tgroup, 'Title', 'About');
    
    %Place panels into each tab
    set(handles.P1,'Parent',handles.tab1)
    set(handles.P2,'Parent',handles.tab2)
    set(handles.P3,'Parent',handles.tab3)
    set(handles.P4,'Parent',handles.tab4)
    
    %Reposition each panel to same location as panel 1
    set(handles.P2,'position',get(handles.P1,'position'));
    set(handles.P3,'position',get(handles.P1,'position'));
    set(handles.P4,'position',get(handles.P1,'position'));
    
    set(handles.axes1,'position',get(handles.axes3,'position'));
    set(handles.axes2,'position',get(handles.axes3,'position'));
    set(handles.axes4,'position',get(handles.axes3,'position'));
    
end
guidata(hObject, handles);

% UIWAIT makes outs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = outs_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






% --------------------------------------------------------------------





% --------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.timeString.String='working...';
guidata(hObject, handles);

y=handles.y;
fs=handles.fs;
classnum= str2double(get(handles.speakerBox,'String'));
res= str2double(get(handles.mtStep,'String'));
filename=handles.filename;
[segs, classes L2 C2] = speakerDiarization(filename,classnum,...
    str2double(get(handles.stWin,'String')),...
    str2double(get(handles.stStep,'String')),...
    str2double(get(handles.mtWin,'String')),...
    str2double(get(handles.mtStep,'String')));
%set(handles.resTable, 'Data', segs);
handles.segs=segs;
handles.classes=classes;
y = y(:,1);
colorVec = hsv(classnum);
dt = 1/fs;
t = 0:dt:(length(y)*dt)-dt;
time=(length(y)*dt)-dt
%plot(t,y); xlabel('Seconds'); ylabel('Amplitude');

classes=classes+1;
axes(handles.axes2);
cla;
plot(t,y)

axes(handles.axes1);
cla;

hold on;
% Generate arbitrary random variables
handles.yn=zeros(1,length(y));
for i=1:length(segs)
    ind1=round(segs(i,1)*fs+1);
    ind2=round(segs(i,2)*fs);
    yt=y(ind1:ind2);
    tt=t(ind1:ind2);
    plot(tt,yt,'Color',colorVec(classes(i),:));
    handles.yn((segs(i,1)*fs+1):(segs(i,2)*fs))=classes(i);
    
end
hold off;




axes(handles.axes4);
[segs1, classes1, L1, C1] = silenceRemoval(filename,res, 0, 0);


bar(C1, L1-1);
axis ([0 max(C1) 0 max(L1)])

axes(handles.axes4);
cla;
hold on;
axis([0 time 0 2])
for i=1:length(segs)
    ind1=round(segs(i,1)*fs+1);
    ind2=round(segs(i,2)*fs);
    tt=t(ind1:ind2);
    bar(tt,ones(1,length(tt)),'FaceColor',colorVec(classes(i),:),'BarWidth', 1.1)
end
set(handles.axes3,'position',get(handles.axes1,'position'));
%hold off;

handles.axesPop.String = {'Diarlized wavreform','Original waveform','Voice Activity Graph','Diarlization Bars'} ;
linkaxes([handles.axes2,handles.axes1],'xy');

tempres=cell(length(classes),1);
for i=1:length(classes)
    tempres{i}=handles.speakerTable.Data{classes(i)+1,1};
end
handles.resTable.Data=[num2cell(segs) num2cell(classes') tempres];
handles.timeString.String='idle';
handles.currax=handles.axesarra{1};
axes(handles.axesarra{1});


guidata(hObject, handles);


% --------------------------------------------------------------------
function Stop_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.player);
handles.timeString.String='';
handles.running=0;
guidata(hObject, handles);

% --------------------------------------------------------------------
function Pause_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pause(handles.player);
guidata(hObject, handles);

% --------------------------------------------------------------------
function Play_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.running==0)
    x=round(xlim*handles.fs);
    if(x(1)==0)
        x(1)=1;
    end
    
    if(x(2)>length(handles.y))
        x(2)=length(handles.y);
    end
    play(handles.player,x);
    handles.running=1;
else
    resume(handles.player);
end
axes(handles.currax);

hold on;
axis([xlim ylim])
handles.s=plot([0 0],[0 0]);
global s
s=1;
guidata(hObject, handles);



function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[file,path] = uigetfile('*.mp3;*.wav');
handles.file=file;
filename=[path file];
if (file==0)
    return;
end
[y,fs]=audioread(filename);
%handles.timeString=strcat(num2str(y/fs),'/0.0');
handles.player = audioplayer(y, fs);
handles.timeSec  = length(y)/fs;
handles.atSample = 0;

set(handles.player,'TimerFcn',{@timerCallback,handles.figure1}, 'TimerPeriod', 0.1);
set(handles.player,'StopFcn','handles.running=0;');
y = y(:,1);
dt = 1/fs;
t = 0:dt:(length(y)*dt)-dt;

axes(handles.axes1);
cla;
plot(t,y)

axes(handles.axes2);
cla;
plot(t,y)
handles.y=y;
handles.fs=fs;
handles.filename=filename;
guidata(hObject, handles);


function timerCallback(hObject, event, hFig)
handles = guidata(hFig);

x=handles.s
delete(x)



% determine the current sample
currSample = get(hObject,'CurrentSample');
time=currSample/length(handles.y)*handles.timeSec;
handles.s=plot([time time],ylim);
try
    %x = find((handles.segs(:,2)-63) > 0, 1);
    %x=handles.classes(x);
    x=handles.yn(currSample);
catch
    x='0';
end

handles.timeString.String=strcat('speaker index=',int2str(x),'    Time:',num2str(handles.timeSec,4),...
    '/',num2str(time,3));
% get all of the sound data

%pause(0.5)


guidata(hFig,handles);


function speakerBox_Callback(hObject, eventdata, handles)
% hObject    handle to speakerBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speakerBox as text
%        str2double(get(hObject,'String')) returns contents of speakerBox as a double
value = str2double(get(handles.speakerBox,'String'));
flag = value >= 1 && value <= 16
if ~flag
   set(handles.edit_box,'String','1');
   warndlg('Value Out of Range or not a number! Please Enter Again');
else
   handles.NumOfSpeakers=value;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function speakerBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speakerBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function mtStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mtStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end











% --- Executes on selection change in setPop.
function setPop_Callback(hObject, eventdata, handles)
% hObject    handle to setPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns setPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from setPop
value = get(hObject,'Value')
handles.speakerBox.String=handles.settingsTable{value,1};
handles.stWin.String=handles.settingsTable{value,2};
handles.stStep.String=handles.settingsTable{value,3};
handles.mtWin.String=handles.settingsTable{value,4};
handles.mtStep.String=handles.settingsTable{value,5};

% --- Executes during object creation, after setting all properties.
function setPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in exportPop.
function exportPop_Callback(hObject, eventdata, handles)
% hObject    handle to exportPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns exportPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from exportPop


% --- Executes during object creation, after setting all properties.
function exportPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exportPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Export.
function Export_Callback(hObject, eventdata, handles)
% hObject    handle to Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ext=cell(5,1);
ext{1}={'*.jpg';'*.png';'*.tif';'*.*'};
ext{2}={'*.jpg';'*.png';'*.tif';'*.*'};
ext{3}={'*.xlsx';'*.csv';'*.*'};
v = get(handles.exportPop	,'Value'); %get currently selected option from menu
strv  = get(handles.exportPop, 'String');
if (v~=5)
    [file, path] = uiputfile(ext{v});
    if (file==0)    
        return;
    end
    if v == 1
        fh = figure;
        copyobj(handles.axes1, fh);
        saveas(fh, strcat(path,file));
        close(fh);
    elseif v == 2
        F = getframe(handles.axes2);
        Image = frame2im(F);
        imwrite(Image,strcat(path,file))
    elseif v == 3
        if strcmp('.csv',file(end-4:end))
            csvwrite([path file],str(handles.resTable));
        else
            xlswrite([path file],handles.resTable.Data);
        end
    elseif v == 4
        
    end
else
    path=uigetdir
    segs=handles.segs;
    y=handles.y;
    fs=handles.fs;
    classes=handles.classes;
    for i=1:length(segs)
        ind1=round(segs(i,1)*fs+1);
        ind2=round(segs(i,2)*fs);
        yt=y(ind1:ind2);
        name=[path '\' handles.file(1:end-4) '-' int2str(i) '-' handles.speakerTable.Data{classes(i)+1,1} '.wav']
        handles.exportText.String=['writing: ' name];
        audiowrite(name,yt,fs);
        handles.exportText.String='';
    end
    
end


% --- Executes on selection change in axesPop.
function axesPop_Callback(hObject, eventdata, handles)
% hObject    handle to axesPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns axesPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from axesPop
v = get(handles.axesPop	,'Value');
for i=1:4
    if (i==v)
        set(handles.axesarr{i},'visible', 'on')
        uistack(handles.axesarr{i}, 'top')
        handles.currax=handles.axesarra{i};
        axes(handles.axesarra{i});
    else
        set(handles.axesarr{i},'visible', 'off');
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function axesPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mtStep_Callback(hObject, eventdata, handles)
% hObject    handle to mtStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mtStep as text
%        str2double(get(hObject,'String')) returns contents of mtStep as a double



function stStep_Callback(hObject, eventdata, handles)
% hObject    handle to stStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stStep as text
%        str2double(get(hObject,'String')) returns contents of stStep as a double


% --- Executes during object creation, after setting all properties.
function stStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mtWin_Callback(hObject, eventdata, handles)
% hObject    handle to mtWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mtWin as text
%        str2double(get(hObject,'String')) returns contents of mtWin as a double


% --- Executes during object creation, after setting all properties.
function mtWin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mtWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stWin_Callback(hObject, eventdata, handles)
% hObject    handle to stWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stWin as text
%        str2double(get(hObject,'String')) returns contents of stWin as a double


% --- Executes during object creation, after setting all properties.
function stWin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveSet.
function saveSet_Callback(hObject, eventdata, handles)
% hObject    handle to saveSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
name=inputdlg('input Settings name');
if (isempty(name))
    return;
end

if (strfind(name{1},','))
    errordlg('Name cant contain , sign');
    return;
end

rowcell=cell(1,6) 
rowcell{1,1}= handles.speakerBox.String
rowcell{1,2}= handles.stWin.String
rowcell{1,3}= handles.stStep.String
rowcell{1,4}= handles.mtWin.String
rowcell{1,5}= handles.mtStep.String
rowcell{1,6}=name{1}
handles.settingsTable= [handles.settingsTable; rowcell]
writetable(handles.settingsTable,'Settings.csv','Delimiter',',','QuoteStrings',true)
setsize=size(handles.settingsTable);
setsize=setsize(1);
x=cell(setsize,1);
for i=1:setsize
    x(i)=handles.settingsTable{i,6};
end
handles.setPop.String=x;
handles.setPop.Value=setsize;
