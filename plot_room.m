function varargout = plot_room(varargin)
% PLOT_ROOM Application M-file for plot_room.fig
%   PLOT_ROOM, by itself, creates a new PLOT_ROOM or raises the existing
%   singleton*.
%
%   H = PLOT_ROOM returns the handle to a new PLOT_ROOM or the handle to
%   the existing singleton*.
%
%   PLOT_ROOM('CALLBACK',hObject,eventData,handles,...) calls the local
%   function named CALLBACK in PLOT_ROOM.M with the given input arguments.
%
%   PLOT_ROOM('Property','Value',...) creates a new PLOT_ROOM or raises the
%   existing singleton*.  Starting from the left, property value pairs are
%   applied to the GUI before two_axes_OpeningFunction gets called.  An
%   unrecognized property name or invalid value makes property application
%   stop.  All inputs are passed to plot_room_OpeningFcn via varargin.
%
%   *See GUI Options - GUI allows only one instance to run (singleton).
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plot_room

% Copyright 2001-2006 The MathWorks, Inc.

% Last Modified by GUIDE v2.5 14-Dec-2015 21:08:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',          mfilename, ...
                   'gui_Singleton',     gui_Singleton, ...
                   'gui_OpeningFcn',    @plot_room_OpeningFcn, ...
                   'gui_OutputFcn',     @plot_room_OutputFcn, ...
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

% --- Executes just before plot_room is made visible.
function plot_room_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plot_room (see VARARGIN)

% Choose default command line output for plot_room
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plot_room wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plot_room_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function cue_button_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to cue_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get user input from GUI
x = str2double(get(handles.x_input,'String'));
y = str2double(get(handles.y_input,'String'));
bp_freq = eval(get(handles.bp_freq_input,'String'));
x1 = str2double(get(handles.x1_input,'String'));
y1 = str2double(get(handles.y1_input,'String'));
x2 = str2double(get(handles.x2_input,'String'));
y2 = str2double(get(handles.y2_input,'String'));
num_so = get(handles.checkbox2,'Value') + 1;

[itd,ild] = roomMode(x,y,x1,y1,x2,y2,bp_freq,num_so);

handles.num_so = num_so;
handles.ild = ild;
handles.itd = itd;
handles.bp_freq = bp_freq;
handles.x = x;
handles.y = y;
handles.x1 = x1;
handles.y1 = y1;
handles.x2 = x2;
handles.y2 = y2;

% Create init plot in proper axes
set(handles.itd_axes,'Visible','on');
surf(handles.itd_axes,itd,'EdgeColor', 'None', 'facecolor', 'interp');
set(handles.itd_axes,'YLim',[0,50]);
set(handles.itd_axes,'XLim',[0,50]);
set(handles.itd_axes,'View',[90,90]);
set(handles.itd_axes,'XMinorTick','on');
grid on

% Create result plot in proper axes
set(handles.ild_axes,'Visible','on');
surf(handles.ild_axes,ild,'EdgeColor', 'None', 'facecolor', 'interp');
set(handles.ild_axes,'YLim',[0,50]);
set(handles.ild_axes,'XLim',[0,50]);
set(handles.ild_axes,'View',[90,90]);
set(handles.ild_axes,'XMinorTick','on');
grid on

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
    set(handles.cue_button,'String','Invalid X')
    set(handles.cue_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.cue_button,'String','Plot')
    set(handles.cue_button,'Enable','on')
end


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
    set(handles.cue_button,'String','Invalid Y')
    set(handles.cue_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.cue_button,'String','Plot')
    set(handles.cue_button,'Enable','on')
end


function bp_freq_input_Callback(hObject, eventdata, handles)
% hObject    handle to bp_freq_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bp_freq_input as text
%        str2double(get(hObject,'String')) returns contents of bp_freq_input
%        as a double

% Test that the time vector is not too large, is not scalar, 
% and increases monotonically. First fail if EVAL cannot parse it. 

% Disable the Plot button ... until proven innocent
set(handles.cue_button,'Enable','off') 
try
    bp_freq = eval(get(handles.bp_freq_input,'String'));
    if ~isnumeric(bp_freq)
        % t is not a number
        set(handles.cue_button,'String','freq is not numeric')
    elseif bp_freq <= 150 || bp_freq >= 18000
        set(handles.cue_button,'String','freq must be in (150,18000)')
    else
        % All OK; Enable the Plot button with its original name
        set(handles.cue_button,'String','Plot')
        set(handles.cue_button,'Enable','on')
        return
    end
    % Found an input error other than a bad expression
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
 catch EM
    % Cannot evaluate expression user typed
    set(handles.cue_button,'String','Cannot plot freq')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
end



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
    set(handles.cue_button,'String','Invalid X')
    set(handles.cue_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.cue_button,'String','Plot')
    set(handles.cue_button,'Enable','on')
end

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
    set(handles.cue_button,'String','Invalid X')
    set(handles.cue_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.cue_button,'String','Plot')
    set(handles.cue_button,'Enable','on')
end


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
    set(handles.cue_button,'String','Invalid X')
    set(handles.cue_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.cue_button,'String','Plot')
    set(handles.cue_button,'Enable','on')
end


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
    set(handles.cue_button,'String','Invalid X')
    set(handles.cue_button,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    set(handles.cue_button,'String','Plot')
    set(handles.cue_button,'Enable','on')
end


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
   plot_cues();
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


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile('*.matroom','Save Results As');
if file ~= 0
    num_so = handles.num_so;
    ild = handles.ild;
    itd = handles.itd;
    bp_freq = handles.bp_freq;
    x = handles.x;
    y = handles.y;
    x1 = handles.x1;
    y1 = handles.y1;
    x2 = handles.x2;
    y2 = handles.y2;
    save([path,file], 'num_so', 'ild', 'itd', 'bp_freq', 'x', 'y', 'x1', 'y1', 'x2', 'y2');
else
    disp('Save was cancelled by the user!');
end

% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path] = uigetfile('*.matroom','Load From File');
if file ~= 0
    load([path,file]);
    
    handles.num_so = num_so;
    handles.ild = ild;
    handles.itd = itd;
    handles.bp_freq = bp_freq;
    handles.x = x;
    handles.y = y;
    handles.x1 = x1;
    handles.y1 = y1;
    handles.x2 = x2;
    handles.y2 = y2;

    set(handles.checkbox2,'Value',num_so-1);

    % Create init plot in proper axes
    set(handles.itd_axes,'Visible','on');
    surf(handles.itd_axes,itd,'EdgeColor', 'None', 'facecolor', 'interp');
    set(handles.itd_axes,'YLim',[0,50]);
    set(handles.itd_axes,'XLim',[0,50]);
    set(handles.itd_axes,'View',[90,90]);
    set(handles.itd_axes,'XMinorTick','on');
    grid on

    % Create result plot in proper axes
    set(handles.ild_axes,'Visible','on');
    surf(handles.ild_axes,ild,'EdgeColor', 'None', 'facecolor', 'interp');
    set(handles.ild_axes,'YLim',[0,50]);
    set(handles.ild_axes,'XLim',[0,50]);
    set(handles.ild_axes,'View',[90,90]);
    set(handles.ild_axes,'XMinorTick','on');
    grid on

    % Setting boxes' values
    set(handles.x_input,'String',num2str(x));
    set(handles.y_input,'String',num2str(y));
    set(handles.x1_input,'String',num2str(x1));
    set(handles.y1_input,'String',num2str(y1));
    set(handles.x2_input,'String',num2str(x2));
    set(handles.y2_input,'String',num2str(y2));
    set(handles.bp_freq_input,'String',num2str(bp_freq));
    if num_so == 1
        set(handles.x2_input,'Enable','off');
        set(handles.y2_input,'Enable','off');
    elseif num_so == 2
        set(handles.x2_input,'Enable','on');
        set(handles.y2_input,'Enable','on');
    end

    % Save data
    guidata(hObject,handles)

else
    disp('Loading was cancelled by the user!');
end
