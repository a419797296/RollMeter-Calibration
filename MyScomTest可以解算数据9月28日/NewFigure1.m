function varargout = NewFigure1(varargin)
% NEWFIGURE1 MATLAB code for NewFigure1.fig
%      NEWFIGURE1, by itself, creates a new NEWFIGURE1 or raises the existing
%      singleton*.
%
%      H = NEWFIGURE1 returns the handle to a new NEWFIGURE1 or the handle to
%      the existing singleton*.
%
%      NEWFIGURE1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWFIGURE1.M with the given input arguments.
%
%      NEWFIGURE1('Property','Value',...) creates a new NEWFIGURE1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NewFigure1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NewFigure1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NewFigure1

% Last Modified by GUIDE v2.5 12-Oct-2012 11:10:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NewFigure1_OpeningFcn, ...
                   'gui_OutputFcn',  @NewFigure1_OutputFcn, ...
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


% --- Executes just before NewFigure1 is made visible.
function NewFigure1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NewFigure1 (see VARARGIN)

% Choose default command line output for NewFigure1
handles.output = hObject;
if nargin == 4 
   Total_Data = getappdata(varargin{1},'Aver_Data_Rec') ;
   plot(handles.axes1,Total_Data,':.r'); 
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NewFigure1 wait for user response (see UIRESUME)
% uiwait(handles.NewFigure1);


% --- Outputs from this function are returned to the command line.
function varargout = NewFigure1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton1
delete(gcf);
