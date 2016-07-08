function varargout = plot_position(varargin)
% PLOT_POSITION Application M-file for plot_position.fig
%   PLOT_POSITION, by itself, creates a new PLOT_POSITION or raises the existing
%   singleton*.
%
%   H = PLOT_POSITION returns the handle to a new PLOT_POSITION or the handle to
%   the existing singleton*.
%
%   PLOT_POSITION('CALLBACK',hObject,eventData,handles,...) calls the local
%   function named CALLBACK in PLOT_POSITION.M with the given input arguments.
%
%   PLOT_POSITION('Property','Value',...) creates a new PLOT_POSITION or raises the
%   existing singleton*.  Starting from the left, property value pairs are
%   applied to the GUI before two_axes_OpeningFunction gets called.  An
%   unrecognized property name or invalid value makes property application
%   stop.  All inputs are passed to plot_position_OpeningFcn via varargin.
%
%   *See GUI Options - GUI allows only one instance to run (singleton).
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plot_position

% Copyright 2001-2006 The MathWorks, Inc.

% Last Modified by GUIDE v2.5 03-Jun-2015 13:02:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',          mfilename, ...
                   'gui_Singleton',     gui_Singleton, ...
                   'gui_OpeningFcn',    @plot_position_OpeningFcn, ...
                   'gui_OutputFcn',     @plot_position_OutputFcn, ...
                   'gui_LayoutFcn',     [], ...
                   'gui_Callback',      []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before plot_position is made visible.
function plot_position_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plot_position (see VARARGIN)

% Choose default command line output for plot_position
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plot_position wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plot_position_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function plot_button_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get user input from GUI
x= str2double(get(handles.x_input,'String'));
y = str2double(get(handles.y_input,'String'));
x1= str2double(get(handles.x1_input,'String'));
y1 = str2double(get(handles.y1_input,'String'));
x2= str2double(get(handles.x2_input,'String'));
y2 = str2double(get(handles.y2_input,'String'));
num_so = get(handles.checkbox2,'Value') + 1;

[in,le_out,re_out,ild,itd,freq_array] = positionMode(x,y,x1,y1,x2,y2,num_so);

handles.in = in;
handles.le_out = le_out;
handles.re_out = re_out;
handles.ild = ild;
handles.itd = itd;
handles.freq_array = freq_array;
handles.x = x;
handles.y = y;
handles.x1 = x1;
handles.y1 = y1;
handles.x2 = x2;
handles.y2 = y2;

set(handles.freq_listbox,'String',num2str(round(handles.freq_array)','%5.0d'))
set(handles.hide_button,'Enable','on');

% Create init plot in proper axes
plot(handles.init_axes,in)
set(handles.init_axes,'XMinorTick','on')
grid off
[amp,~,fr] = easyfft(in);
plot(handles.infreq_axes,fr,amp);
set(handles.infreq_axes,'XScale','log');

% Create result plot in proper axes
plot(handles.result_axes,le_out(:,1),'b');
set(handles.result_axes,'XMinorTick','on')
set(handles.result_axes,'NextPlot','add')
plot(handles.result_axes,re_out(:,1),'r');
set(handles.result_axes,'XMinorTick','on')
grid off
set(handles.result_axes,'NextPlot','replace')
[amp,~,fr] = easyfft(le_out(:,1));
plot(handles.lefreq_axes,fr,amp);
set(handles.lefreq_axes,'XScale','log');
[amp,~,fr] = easyfft(re_out(:,1));
plot(handles.refreq_axes,fr,amp,'r');
set(handles.refreq_axes,'XScale','log');

% Create position plot in proper axes
scatter(handles.pos_axes,y1,x1);
set(handles.pos_axes,'NextPlot','add')
if num_so == 2
    scatter(handles.pos_axes,y2,x2);
    set(handles.pos_axes,'NextPlot','add')
end
scatter(handles.pos_axes,y,x,'x');
set(handles.pos_axes,'NextPlot','replace')
set(handles.pos_axes,'XMinorTick','on')
set(handles.pos_axes,'XLim',[-0.5 5.5])
set(handles.pos_axes,'YLim',[-0.5 5.5])
set(handles.pos_axes,'YAxisLocation','right')
set(handles.pos_axes,'View',[90 90])
grid off
hold off

% Create cues plot
semilogx(handles.itd_axes,handles.freq_array,handles.itd,...
    'LineStyle', 'none', 'Marker', '.');
% set(handles.itd_axes,'YLim',[-0 50])
grid off
semilogx(handles.ild_axes,handles.freq_array,handles.ild,...
    'LineStyle', 'none', 'Marker', '.');
grid off

% Save data
guidata(hObject,handles)



function x_input_Callback(hObject, eventdata, handles)
% hObject    handle to x_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_input as text
%        str2double(get(hObject,'String')) returns contents of x_input
%        as a double

% Validate that the text in the f1 field converts to a real number
x = str2double(get(hObject,'String'));
if isnan(x) || ~isreal(x)  
    % isdouble returns NaN for non-numbers and f1 cannot be complex
    % Disable the Plot button and change its string to say why
    set(handles.plot_button,'String','Invalid X')
    set(handles.plot_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.plot_button,'String','Plot')
    set(handles.plot_button,'Enable','on')
end

x= str2double(get(handles.x_input,'String'));
y = str2double(get(handles.y_input,'String'));
x1= str2double(get(handles.x1_input,'String'));
y1 = str2double(get(handles.y1_input,'String'));
x2= str2double(get(handles.x2_input,'String'));
y2 = str2double(get(handles.y2_input,'String'));
num_so = get(handles.checkbox2,'Value') + 1;

% Create position plot in proper axes
scatter(handles.pos_axes,y1,x1);
set(handles.pos_axes,'NextPlot','add')
if num_so == 2
    scatter(handles.pos_axes,y2,x2);
    set(handles.pos_axes,'NextPlot','add')
end
scatter(handles.pos_axes,y,x,'x');
set(handles.pos_axes,'NextPlot','replace')
set(handles.pos_axes,'XMinorTick','on')
set(handles.pos_axes,'XLim',[-0.5 5.5])
set(handles.pos_axes,'YLim',[-0.5 5.5])
set(handles.pos_axes,'YAxisLocation','right')
set(handles.pos_axes,'View',[90 90])
grid off
hold off


function y_input_Callback(hObject, eventdata, handles)
% hObject    handle to y_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_input as text
%        str2double(get(hObject,'String')) returns contents of x_input
%        as a double

% Validate that the text in the f2 field converts to a real number
y = str2double(get(hObject,'String'));
if isnan(y) ...          % isdouble returns NaN for non-numbers
        || ~isreal(y)    % f1 should not be complex
    % Disable the Plot button and change its string to say why
    set(handles.plot_button,'String','Invalid Y')
    set(handles.plot_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.plot_button,'String','Plot')
    set(handles.plot_button,'Enable','on')
end

x= str2double(get(handles.x_input,'String'));
y = str2double(get(handles.y_input,'String'));
x1= str2double(get(handles.x1_input,'String'));
y1 = str2double(get(handles.y1_input,'String'));
x2= str2double(get(handles.x2_input,'String'));
y2 = str2double(get(handles.y2_input,'String'));
num_so = get(handles.checkbox2,'Value') + 1;

% Create position plot in proper axes
scatter(handles.pos_axes,y1,x1);
set(handles.pos_axes,'NextPlot','add')
if num_so == 2
    scatter(handles.pos_axes,y2,x2);
    set(handles.pos_axes,'NextPlot','add')
end
scatter(handles.pos_axes,y,x,'x');
set(handles.pos_axes,'NextPlot','replace')
set(handles.pos_axes,'XMinorTick','on')
set(handles.pos_axes,'XLim',[-0.5 5.5])
set(handles.pos_axes,'YLim',[-0.5 5.5])
set(handles.pos_axes,'YAxisLocation','right')
set(handles.pos_axes,'View',[90 90])
grid off
hold off


function x1_input_Callback(hObject, eventdata, handles)
% hObject    handle to x1_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x1_input as text
%        str2double(get(hObject,'String')) returns contents of x1_input as a double

% Validate that the text in the f1 field converts to a real number
x1 = str2double(get(hObject,'String'));
if isnan(x1) || ~isreal(x1)  
    % isdouble returns NaN for non-numbers and f1 cannot be complex
    % Disable the Plot button and change its string to say why
    set(handles.plot_button,'String','Invalid X')
    set(handles.plot_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.plot_button,'String','Plot')
    set(handles.plot_button,'Enable','on')
end

x= str2double(get(handles.x_input,'String'));
y = str2double(get(handles.y_input,'String'));
x1= str2double(get(handles.x1_input,'String'));
y1 = str2double(get(handles.y1_input,'String'));
x2= str2double(get(handles.x2_input,'String'));
y2 = str2double(get(handles.y2_input,'String'));
num_so = get(handles.checkbox2,'Value') + 1;

% Create position plot in proper axes
scatter(handles.pos_axes,y1,x1);
set(handles.pos_axes,'NextPlot','add')
if num_so == 2
    scatter(handles.pos_axes,y2,x2);
    set(handles.pos_axes,'NextPlot','add')
end
scatter(handles.pos_axes,y,x,'x');
set(handles.pos_axes,'NextPlot','replace')
set(handles.pos_axes,'XMinorTick','on')
set(handles.pos_axes,'XLim',[-0.5 5.5])
set(handles.pos_axes,'YLim',[-0.5 5.5])
set(handles.pos_axes,'YAxisLocation','right')
set(handles.pos_axes,'View',[90 90])
grid off
hold off

% --- Executes during object creation, after setting all properties.
function x1_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x1_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y1_input_Callback(hObject, eventdata, handles)
% hObject    handle to y1_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y1_input as text
%        str2double(get(hObject,'String')) returns contents of y1_input as a double

% Validate that the text in the f1 field converts to a real number
y1 = str2double(get(hObject,'String'));
if isnan(y1) || ~isreal(y1)  
    % isdouble returns NaN for non-numbers and f1 cannot be complex
    % Disable the Plot button and change its string to say why
    set(handles.plot_button,'String','Invalid X')
    set(handles.plot_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.plot_button,'String','Plot')
    set(handles.plot_button,'Enable','on')
end

x= str2double(get(handles.x_input,'String'));
y = str2double(get(handles.y_input,'String'));
x1= str2double(get(handles.x1_input,'String'));
y1 = str2double(get(handles.y1_input,'String'));
x2= str2double(get(handles.x2_input,'String'));
y2 = str2double(get(handles.y2_input,'String'));
num_so = get(handles.checkbox2,'Value') + 1;

% Create position plot in proper axes
scatter(handles.pos_axes,y1,x1);
set(handles.pos_axes,'NextPlot','add')
if num_so == 2
    scatter(handles.pos_axes,y2,x2);
    set(handles.pos_axes,'NextPlot','add')
end
scatter(handles.pos_axes,y,x,'x');
set(handles.pos_axes,'NextPlot','replace')
set(handles.pos_axes,'XMinorTick','on')
set(handles.pos_axes,'XLim',[-0.5 5.5])
set(handles.pos_axes,'YLim',[-0.5 5.5])
set(handles.pos_axes,'YAxisLocation','right')
set(handles.pos_axes,'View',[90 90])
grid off
hold off


% --- Executes during object creation, after setting all properties.
function y1_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y1_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x2_input_Callback(hObject, eventdata, handles)
% hObject    handle to x2_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x2_input as text
%        str2double(get(hObject,'String')) returns contents of x2_input as a double

% Validate that the text in the f1 field converts to a real number
x2 = str2double(get(hObject,'String'));
if isnan(x2) || ~isreal(x2)  
    % isdouble returns NaN for non-numbers and f1 cannot be complex
    % Disable the Plot button and change its string to say why
    set(handles.plot_button,'String','Invalid X')
    set(handles.plot_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.plot_button,'String','Plot')
    set(handles.plot_button,'Enable','on')
end

x= str2double(get(handles.x_input,'String'));
y = str2double(get(handles.y_input,'String'));
x1= str2double(get(handles.x1_input,'String'));
y1 = str2double(get(handles.y1_input,'String'));
x2= str2double(get(handles.x2_input,'String'));
y2 = str2double(get(handles.y2_input,'String'));
num_so = get(handles.checkbox2,'Value') + 1;

% Create position plot in proper axes
scatter(handles.pos_axes,y1,x1);
set(handles.pos_axes,'NextPlot','add')
if num_so == 2
    scatter(handles.pos_axes,y2,x2);
    set(handles.pos_axes,'NextPlot','add')
end
scatter(handles.pos_axes,y,x,'x');
set(handles.pos_axes,'NextPlot','replace')
set(handles.pos_axes,'XMinorTick','on')
set(handles.pos_axes,'XLim',[-0.5 5.5])
set(handles.pos_axes,'YLim',[-0.5 5.5])
set(handles.pos_axes,'YAxisLocation','right')
set(handles.pos_axes,'View',[90 90])
grid off
hold off


% --- Executes during object creation, after setting all properties.
function x2_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x2_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y2_input_Callback(hObject, eventdata, handles)
% hObject    handle to y2_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y2_input as text
%        str2double(get(hObject,'String')) returns contents of y2_input as a double

% Validate that the text in the f1 field converts to a real number
y2 = str2double(get(hObject,'String'));
if isnan(y2) || ~isreal(y2)  
    % isdouble returns NaN for non-numbers and f1 cannot be complex
    % Disable the Plot button and change its string to say why
    set(handles.plot_button,'String','Invalid X')
    set(handles.plot_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.plot_button,'String','Plot')
    set(handles.plot_button,'Enable','on')
end

x= str2double(get(handles.x_input,'String'));
y = str2double(get(handles.y_input,'String'));
x1= str2double(get(handles.x1_input,'String'));
y1 = str2double(get(handles.y1_input,'String'));
x2= str2double(get(handles.x2_input,'String'));
y2 = str2double(get(handles.y2_input,'String'));
num_so = get(handles.checkbox2,'Value') + 1;

% Create position plot in proper axes
scatter(handles.pos_axes,y1,x1);
set(handles.pos_axes,'NextPlot','add')
if num_so == 2
    scatter(handles.pos_axes,y2,x2);
    set(handles.pos_axes,'NextPlot','add')
end
scatter(handles.pos_axes,y,x,'x');
set(handles.pos_axes,'NextPlot','replace')
set(handles.pos_axes,'XMinorTick','on')
set(handles.pos_axes,'XLim',[-0.5 5.5])
set(handles.pos_axes,'YLim',[-0.5 5.5])
set(handles.pos_axes,'YAxisLocation','right')
set(handles.pos_axes,'View',[90 90])
grid off
hold off


% --- Executes during object creation, after setting all properties.
function y2_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y2_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in selection_menu.
function selection_menu_Callback(hObject, eventdata, handles)
% hObject    handle to selection_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selection_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selection_menu
% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch str{val};
case 'Position Mode' % User selects peaks.
   delete(handles.figure1);
   plot_position();
case 'Room Mode' % User selects membrane.
   delete(handles.figure1);
   plot_room();
end


% --- Executes during object creation, after setting all properties.
function selection_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selection_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in freq_listbox.
function freq_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to freq_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns freq_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from freq_listbox
val = get(hObject,'Value');
% Create result plot in proper axes


plot(handles.result_axes,handles.le_out(:,val),'b');
set(handles.result_axes,'XMinorTick','on')
set(handles.result_axes,'NextPlot','add')
plot(handles.result_axes,handles.re_out(:,val),'r');
set(handles.result_axes,'XMinorTick','on')
grid off
set(handles.result_axes,'NextPlot','replace')
[amp,~,fr] = easyfft(handles.le_out(:,val));
plot(handles.lefreq_axes,fr,amp);
set(handles.lefreq_axes,'XScale','log');
[amp,~,fr] = easyfft(handles.re_out(:,val));
plot(handles.refreq_axes,fr,amp,'r');
set(handles.refreq_axes,'XScale','log');


% --- Executes during object creation, after setting all properties.
function freq_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path] = uigetfile('*.matpos','Load From File');
if file ~= 0
    load([path,file],'-mat');
    
    handles.in = in;
    handles.le_out = le_out;
    handles.re_out = re_out;
    handles.ild = ild;
    handles.itd = itd;
    handles.freq_array = freq_array;
    handles.x = x;
    handles.y = y;
    handles.x1 = x1;
    handles.y1 = y1;
    handles.x2 = x2;
    handles.y2 = y2;

    set(handles.freq_listbox,'String',num2str(round(handles.freq_array)','%5.0d'))

    % Create init plot in proper axes
    plot(handles.init_axes,in)
    set(handles.init_axes,'XMinorTick','on')
    grid off

    % Create result plot in proper axes
    plot(handles.result_axes,le_out(:,1),'b');
    set(handles.result_axes,'XMinorTick','on')
    set(handles.result_axes,'NextPlot','add')
    plot(handles.result_axes,re_out(:,1),'r');
    set(handles.result_axes,'XMinorTick','on')
    grid off
    set(handles.result_axes,'NextPlot','replace')

    % Create position plot in proper axes
    scatter(handles.pos_axes,y1,x1);
    set(handles.pos_axes,'NextPlot','add')
    scatter(handles.pos_axes,y2,x2);
    set(handles.pos_axes,'NextPlot','add')
    scatter(handles.pos_axes,y,x,'x');
    set(handles.pos_axes,'NextPlot','replace')
    set(handles.pos_axes,'XMinorTick','on')
    set(handles.pos_axes,'XLim',[-0.5 5.5])
    set(handles.pos_axes,'YLim',[-0.5 5.5])
    set(handles.pos_axes,'YAxisLocation','right')
    set(handles.pos_axes,'View',[90 90])
    grid off
    hold off

    % Create cues plot
    semilogx(handles.itd_axes,handles.freq_array,handles.itd,...
        'LineStyle', 'none', 'Marker', '.');
%     set(handles.itd_axes,'YLim',[-200 200])
    grid off
    semilogx(handles.ild_axes,handles.freq_array,handles.ild,...
        'LineStyle', 'none', 'Marker', '.');
    grid off

    % Setting boxes' values
    set(handles.x_input,'String',num2str(x));
    set(handles.y_input,'String',num2str(y));
    set(handles.x1_input,'String',num2str(x1));
    set(handles.y1_input,'String',num2str(y1));
    set(handles.x2_input,'String',num2str(x2));
    set(handles.y2_input,'String',num2str(y2));

    % Save data
    guidata(hObject,handles)

else
    disp('Loading was cancelled by the user!');
end


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path] = uiputfile('*.matpos','Save Results As');
if file ~= 0
    in = handles.in;
    le_out = handles.le_out;
    re_out = handles.re_out;
    ild = handles.ild;
    itd = handles.itd;
    freq_array = handles.freq_array;
    x = handles.x;
    y = handles.y;
    x1 = handles.x1;
    y1 = handles.y1;
    x2 = handles.x2;
    y2 = handles.y2;
    save([path,file], 'in', 'le_out', 're_out', 'ild', 'itd', 'freq_array',...
        'x', 'y', 'x1', 'y1', 'x2', 'y2');
else
    disp('Save was cancelled by the user!');
end


% --- Executes on button press in hide_button.
function hide_button_Callback(hObject, eventdata, handles)
% hObject    handle to hide_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
id = get(handles.freq_listbox,'Visible');
switch id
    case 'off'
        set(handles.freq_listbox,'Visible','on');
        set(handles.hide_button,'String','<');
    case 'on'
        set(handles.freq_listbox,'Visible','off');
        set(handles.hide_button,'String','>');
end        


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
num_so = get(hObject,'Value')+1;

if num_so == 1
    set(handles.x2_input,'Enable','off');
    set(handles.y2_input,'Enable','off');
elseif num_so == 2
    set(handles.x2_input,'Enable','on');
    set(handles.y2_input,'Enable','on');
end

% Save data
guidata(hObject,handles)

