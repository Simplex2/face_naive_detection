function varargout = DetectGUI(varargin)
% DETECTGUI MATLAB code for DetectGUI.fig
%      DETECTGUI, by itself, creates a new DETECTGUI or raises the existing
%      singleton*.
%
%      H = DETECTGUI returns the handle to a new DETECTGUI or the handle to
%      the existing singleton*.
%
%      DETECTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DETECTGUI.M with the given input arguments.
%
%      DETECTGUI('Property','Value',...) creates a new DETECTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DetectGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DetectGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DetectGUI

% Last Modified by GUIDE v2.5 16-Dec-2016 11:40:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DetectGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DetectGUI_OutputFcn, ...
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


% --- Executes just before DetectGUI is made visible.
function DetectGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DetectGUI (see VARARGIN)

% Choose default command line output for DetectGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DetectGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DetectGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;

% --- Executes on button press in face_detect.
function face_detect_Callback(hObject, eventdata, handles)
% hObject    handle to face_detect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
outputI=Detection(handles.img);
axes(handles.axes3);
imshow(outputI);

% --- Executes on button press in Image_load.
function Image_load_Callback(hObject, eventdata, handles)
% hObject    handle to Image_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.jpg'},'Ñ¡ÔñÍ¼Æ¬');
str = [pathname,filename];
p= imread(str);
axes(handles.axes2);
imshow(p);
handles.img=p;
guidata(hObject, handles);

