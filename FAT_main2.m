function varargout = FAT_main2(varargin)
% FAT_MAIN2 MATLAB code for FAT_main2.fig
%      FAT_MAIN2, by itself, creates a new FAT_MAIN2 or raises the existing
%      singleton*.
%
%      H = FAT_MAIN2 returns the handle to a new FAT_MAIN2 or the handle to
%      the existing singleton*.
%
%      FAT_MAIN2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FAT_MAIN2.M with the given input arguments.
%
%      FAT_MAIN2('Property','Value',...) creates a new FAT_MAIN2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FAT_main2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FAT_main2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FAT_main2

% Last Modified by GUIDE v2.5 04-Feb-2015 15:18:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FAT_main2_OpeningFcn, ...
                   'gui_OutputFcn',  @FAT_main2_OutputFcn, ...
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


% --- Executes just before FAT_main2 is made visible.
function FAT_main2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FAT_main2 (see VARARGIN)
set(handles.proceed,'enable','off');
handles.s = [];
handles.p = [];
% Choose default command line output for FAT_main2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FAT_main2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FAT_main2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function phase_Callback(hObject, eventdata, handles)
% hObject    handle to phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phase as text
%        str2double(get(hObject,'String')) returns contents of phase as a double
handles.p = get(handles.phase,'String');
if ~isempty(handles.s) && ~isempty(handles.p)
    set(handles.proceed,'enable','on');
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function phase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function subject_Callback(hObject, eventdata, handles)
% hObject    handle to subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subject as text
%        str2double(get(hObject,'String')) returns contents of subject as a double
handles.s = get(handles.subject,'String');
if ~isempty(handles.s) && ~isempty(handles.p)
    set(handles.proceed,'enable','on');
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function subject_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in proceed.
function proceed_Callback(hObject, eventdata, handles)
% hObject    handle to proceed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fig = gcf;
close(fig)
expe_run_freq_tables(handles.s, handles.p);
