function varargout = HAR_GUI(varargin)
% HAR_GUI MATLAB code for HAR_GUI.fig
%      HAR_GUI, by itself, creates a new HAR_GUI or raises the existing
%      singleton*.
%
%      H = HAR_GUI returns the handle to a new HAR_GUI or the handle to
%      the existing singleton*.
%
%      HAR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HAR_GUI.M with the given input arguments.
%
%      HAR_GUI('Property','Value',...) creates a new HAR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HAR_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HAR_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HAR_GUI

% Last Modified by GUIDE v2.5 15-Apr-2019 08:46:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @HAR_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @HAR_GUI_OutputFcn, ...
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


% --- Executes just before HAR_GUI is made visible.
function HAR_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HAR_GUI (see VARARGIN)

% Choose default command line output for HAR_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HAR_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HAR_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in videoBrowser.
function videoBrowser_Callback(hObject, eventdata, handles)
% hObject    handle to videoBrowser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear testVideo;
global testVideo;
 set(handles.action,'String','Human Action is: ...');
addpath('3DSIFT');

%  Reading test Video from directory
[filename, filePath] = uigetfile('Videos/*.avi', 'Video Directory');
videoFile = fullfile(filePath, filename);
testVideo = VideoReader(videoFile);

hActivity  = {'. . .'}; % Action string 

nFrame = 1;
detector  = peopleDetectorACF; % object of people detection with HOG
"set(gcbo,'userdata',1)";
%  reading and displaying video frame
set(handles.exit,'userdata',0);
ax = axes(handles.video);
while hasFrame(testVideo)
    vidFrame = readFrame(testVideo);
    frame = rgb2gray(vidFrame);
    videoFrames(:, :, nFrame) = frame ;
    
    if nFrame == 200
        disp('Computing Action Recognition...')
        hActivity = testData3DSift(videoFrames);
        set(handles.action,'String',hActivity);
    end
    [bboxes, scores] = detect(detector,vidFrame);
    imshow(insertText(vidFrame,bboxes(:,1:2)-15,hActivity, 'BoxColor',...
         'green','BoxOpacity', 0.2, 'TextColor','white'));
    set(ax, 'Visible', 'off');
    pause(1/testVideo.FrameRate);
    if get(handles.exit,'userdata') % stop condition
        break;
    end
    nFrame = nFrame + 1;
end


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 clc;
 set(gcbo,'userdata',1);
 clear global testVideo;
 delete(HAR_GUI);  % exit GUI


% --- Executes when backgro
function background_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
