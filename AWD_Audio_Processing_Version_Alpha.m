%ENG 6 Sound GUI
%Section 11
%Derek Wong 998761202
%Arthur Shir 999078680
%Wilson Li 999127285

function varargout = AWD_Audio_Processing_Version_Alpha(varargin)
% AWD_AUDIO_PROCESSING_VERSION_ALPHA MATLAB code for AWD_Audio_Processing_Version_Alpha.fig
%      AWD_AUDIO_PROCESSING_VERSION_ALPHA, by itself, creates a new AWD_AUDIO_PROCESSING_VERSION_ALPHA or raises the existing
%      singleton*.
%
%      H = AWD_AUDIO_PROCESSING_VERSION_ALPHA returns the handle to a new AWD_AUDIO_PROCESSING_VERSION_ALPHA or the handle to
%      the existing singleton*.
%
%      AWD_AUDIO_PROCESSING_VERSION_ALPHA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AWD_AUDIO_PROCESSING_VERSION_ALPHA.M with the given input arguments.
%
%      AWD_AUDIO_PROCESSING_VERSION_ALPHA('Property','Value',...) creates a new AWD_AUDIO_PROCESSING_VERSION_ALPHA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AWD_Audio_Processing_Version_Alpha_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AWD_Audio_Processing_Version_Alpha_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AWD_Audio_Processing_Version_Alpha

% Last Modified by GUIDE v2.5 17-Mar-2014 18:42:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AWD_Audio_Processing_Version_Alpha_OpeningFcn, ...
                   'gui_OutputFcn',  @AWD_Audio_Processing_Version_Alpha_OutputFcn, ...
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


% --- Executes just before AWD_Audio_Processing_Version_Alpha is made visible.
function AWD_Audio_Processing_Version_Alpha_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AWD_Audio_Processing_Version_Alpha (see VARARGIN)

% Choose default command line output for AWD_Audio_Processing_Version_Alpha
handles.output = hObject;
handles.mod = cell(9,2);

%Set Zeroes for Frequencies
for i = 1:9
    handles.songs{i,2} = 0;
end
%Set Zeroes for Flags
for i = 1:9
    handles.flag(i) = 0;
end
% Set Zero for handle.which
handles.which = 0;

% Set Default checkBoxes as zero
for n = 1:9
    handles.checkBoxes(n).reverse = 0;
    handles.checkBoxes(n).delay = 0;
    handles.checkBoxes(n).filter = 0;
    handles.checkBoxes(n).speedUp = 0;
    handles.checkBoxes(n).voiceRemove = 0;
end

% Indicate that the advance button is un-pressed for all the samples.
for i = 1:9
    handles.buttonPress(i) = 0;
end

% Find the vector that indicates the original foreGroundColor of the
% advance button.
handles.iniColor = get(handles.Advance, 'foreGroundColor');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AWD_Audio_Processing_Version_Alpha wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AWD_Audio_Processing_Version_Alpha_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function playButton1_Callback(hObject, eventdata, handles)
handles.which = 1;  %Set Marker to Sample 1
n = handles.which;
    
if handles.songs{n,2} ~= 0
clear sound;
isPushed = get(hObject, 'Value');
if isPushed
    sound(handles.mod{n,1},handles.mod{n,2});
end

%Set Information Panel
%   Name
set( handles.selected, 'String', sprintf('File Name: %s', handles.fileName{n}));
%   Length
len = length(handles.mod{n,1}) / handles.mod{n,2};
set( handles.songLength, 'String', sprintf('Length of Sample: %0.2f Seconds', len));
%   Frequency
set( handles.freqShow, 'String', sprintf('Frequency: %0.0f Hz', handles.mod{n,2} ));
%   Mono/Stereo
handles.mod{n, 1} = ConvertMS(handles.mod{n,1}, handles.flag(n));
type = checkChannel(handles.mod{n,1});
set( handles.monSter, 'String', sprintf('Mono/Stereo: %s', type));
% Check the boxes as handles.checkBoxes(n) indicates.
set(handles.ReverseCheck,'value', handles.checkBoxes(n).reverse);
set(handles.DelayCheck,'value', handles.checkBoxes(n).delay);
set(handles.FilterCheck,'value', handles.checkBoxes(n).filter);
set(handles.SpeedUpCheck,'value', handles.checkBoxes(n).speedUp);
set(handles.VoiceRemoveCheck,'value', handles.checkBoxes(n).voiceRemove);
end

guidata(hObject, handles);



% --- Executes on button press in loadButton1.
function loadButton1_Callback(hObject, eventdata, handles)
n = 1;
% Set the initial values of handles.checkBoxes(n) to 0
handles.checkBoxes(n).reverse = 0;
handles.checkBoxes(n).delay = 0;
handles.checkBoxes(n).filter = 0;
handles.checkBoxes(n).speedUp = 0;
handles.checkBoxes(n).voiceRemove = 0;
set(handles.Advance, 'foreGroundColor', handles.iniColor);
%   Extract File Name and Path
[fileName, path] = uigetfile('*');                    
% Prompt user with pop-up browser
if ((fileName == 0) & (path==0))
    % if user clicks cancel or 'X' out of the pop-up
else
    set(handles.playButton1, 'String', n );   % Display filename on the playButton
    set(handles.playButton1, 'BackGroundColor',[0.9412 0.9412 0.9412]);
    fullpathname = strcat(path, fileName);          % Concatinate entire path name
    %   Store Data and Copy
    [handles.songs{n,1},handles.songs{n,2}] = audioread(fullpathname); % Store Data
    [handles.mod{n,1},handles.mod{n,2}] = audioread(fullpathname);     % Store Copy
    [handles.chop{n,1},handles.chop{n,2}] = audioread(fullpathname);   % Store Second Copy
    %   Store File Name
    handles.fileName{n} = fileName;
end

guidata(hObject, handles);


% --- Executes on button press in playButton2.
function playButton2_Callback(hObject, eventdata, handles)
handles.which = 2;  %Set Marker to Sample 1
n = 2;

if handles.songs{n,2} ~= 0
clear sound;
isPushed = get(hObject, 'Value');
if isPushed
    sound(handles.mod{n,1},handles.mod{n,2});
end
%Set Information Panel
%   Name
set( handles.selected, 'String', sprintf('File Name: %s', handles.fileName{n}));
%   Length
len = length(handles.mod{n,1}) / handles.mod{n,2};
set( handles.songLength, 'String', sprintf('Length of Sample: %0.2f Seconds', len));
%   Frequency
set( handles.freqShow, 'String', sprintf('Frequency: %0.0f Hz', handles.mod{n,2} ));
%   Mono/Stereo
handles.mod{n, 1} = ConvertMS(handles.mod{n,1}, handles.flag(n));
type = checkChannel(handles.mod{n,1});
set( handles.monSter, 'String', sprintf('Mono/Stereo: %s', type));
% Check the boxes as handles.checkBoxes(n) indicates.
set(handles.ReverseCheck,'value', handles.checkBoxes(n).reverse);
set(handles.DelayCheck,'value', handles.checkBoxes(n).delay);
set(handles.FilterCheck,'value', handles.checkBoxes(n).filter);
set(handles.SpeedUpCheck,'value', handles.checkBoxes(n).speedUp);
set(handles.VoiceRemoveCheck,'value', handles.checkBoxes(n).voiceRemove);
end

guidata(hObject, handles);


% --- Executes on button press in loadButton2.
function loadButton2_Callback(hObject, eventdata, handles)
    
n = 2;
% Set the initial values of handles.checkBoxes(n) to 0
handles.checkBoxes(n).reverse = 0;
handles.checkBoxes(n).delay = 0;
handles.checkBoxes(n).filter = 0;
handles.checkBoxes(n).speedUp = 0;
handles.checkBoxes(n).voiceRemove = 0;
set(handles.Advance, 'foreGroundColor', handles.iniColor);
%   Extract File Name and Path
[fileName, path] = uigetfile('*');                    
% Prompt user with pop-up browser
if ((fileName == 0) & (path==0))
    % if user clicks cancel or 'X' out of the pop-up
else
    set(handles.playButton2, 'String', n );   % Display filename on the playButton
    set(handles.playButton2, 'BackGroundColor',[0.9412 0.9412 0.9412]);
    fullpathname = strcat(path, fileName);          % Concatinate entire path name
    %   Store Data and Copy
    [handles.songs{n,1},handles.songs{n,2}] = audioread(fullpathname); % Store Data
    [handles.mod{n,1},handles.mod{n,2}] = audioread(fullpathname);     % Store Copy
    [handles.chop{n,1},handles.chop{n,2}] = audioread(fullpathname);   % Store Second Copy
    %   Store File Name
    handles.fileName{n} = fileName;
end

guidata(hObject, handles);

% --- Executes on button press in playButton3.
function playButton3_Callback(hObject, eventdata, handles)
handles.which = 3;  %Set Marker to Sample 1
n = 3;
    
if handles.songs{n,2} ~= 0
clear sound;
isPushed = get(hObject, 'Value');
if isPushed
    sound(handles.mod{n,1},handles.mod{n,2});
end
%Set Information Panel
%   Name
set( handles.selected, 'String', sprintf('File Name: %s', handles.fileName{n}));
%   Length
len = length(handles.mod{n,1}) / handles.mod{n,2};
set( handles.songLength, 'String', sprintf('Length of Sample: %0.2f Seconds', len));
%   Frequency
set( handles.freqShow, 'String', sprintf('Frequency: %0.0f Hz', handles.mod{n,2} ));
%   Mono/Stereo
handles.mod{n, 1} = ConvertMS(handles.mod{n,1}, handles.flag(n));
type = checkChannel(handles.mod{n,1});
set( handles.monSter, 'String', sprintf('Mono/Stereo: %s', type));
% Check the boxes as handles.checkBoxes(n) indicates.
set(handles.ReverseCheck,'value', handles.checkBoxes(n).reverse);
set(handles.DelayCheck,'value', handles.checkBoxes(n).delay);
set(handles.FilterCheck,'value', handles.checkBoxes(n).filter);
set(handles.SpeedUpCheck,'value', handles.checkBoxes(n).speedUp);
set(handles.VoiceRemoveCheck,'value', handles.checkBoxes(n).voiceRemove);
end
guidata(hObject, handles);


% --- Executes on button press in loadButton3.
function loadButton3_Callback(hObject, eventdata, handles)
n = 3;
% Set the initial values of handles.checkBoxes(n) to 0
handles.checkBoxes(n).reverse = 0;
handles.checkBoxes(n).delay = 0;
handles.checkBoxes(n).filter = 0;
handles.checkBoxes(n).speedUp = 0;
handles.checkBoxes(n).voiceRemove = 0;
set(handles.Advance, 'foreGroundColor', handles.iniColor);
%   Extract File Name and Path
[fileName, path] = uigetfile('*');                    
% Prompt user with pop-up browser
if ((fileName == 0) & (path==0))
    % if user clicks cancel or 'X' out of the pop-up
else
    set(handles.playButton3, 'String', n );   % Display filename on the playButton
    set(handles.playButton3, 'BackGroundColor',[0.9412 0.9412 0.9412]);
    fullpathname = strcat(path, fileName);          % Concatinate entire path name
    %   Store Data and Copy
    [handles.songs{n,1},handles.songs{n,2}] = audioread(fullpathname); % Store Data
    [handles.mod{n,1},handles.mod{n,2}] = audioread(fullpathname);     % Store Copy
    [handles.chop{n,1},handles.chop{n,2}] = audioread(fullpathname);   % Store Second Copy
    %   Store File Name
    handles.fileName{n} = fileName;
end
guidata(hObject, handles);

% --- Executes on button press in playButton4.
function playButton4_Callback(hObject, eventdata, handles)
handles.which = 4;  %Set Marker to Sample 1
n = 4;
    
if handles.songs{n,2} ~= 0
clear sound;
isPushed = get(hObject, 'Value');
if isPushed
    sound(handles.mod{n,1},handles.mod{n,2});
end
%Set Information Panel
%   Name
set( handles.selected, 'String', sprintf('File Name: %s', handles.fileName{n}));
%   Length
len = length(handles.mod{n,1}) / handles.mod{n,2};
set( handles.songLength, 'String', sprintf('Length of Sample: %0.2f Seconds', len));
%   Frequency
set( handles.freqShow, 'String', sprintf('Frequency: %0.0f Hz', handles.mod{n,2} ));
%   Mono/Stereo
handles.mod{n, 1} = ConvertMS(handles.mod{n,1}, handles.flag(n));
type = checkChannel(handles.mod{n,1});
set( handles.monSter, 'String', sprintf('Mono/Stereo: %s', type));
% Check the boxes as handles.checkBoxes(n) indicates.
set(handles.ReverseCheck,'value', handles.checkBoxes(n).reverse);
set(handles.DelayCheck,'value', handles.checkBoxes(n).delay);
set(handles.FilterCheck,'value', handles.checkBoxes(n).filter);
set(handles.SpeedUpCheck,'value', handles.checkBoxes(n).speedUp);
set(handles.VoiceRemoveCheck,'value', handles.checkBoxes(n).voiceRemove);
end
guidata(hObject, handles);


% --- Executes on button press in loadButton4.
function loadButton4_Callback(hObject, eventdata, handles)
    
n = 4;
% Set the initial values of handles.checkBoxes(n) to 0
handles.checkBoxes(n).reverse = 0;
handles.checkBoxes(n).delay = 0;
handles.checkBoxes(n).filter = 0;
handles.checkBoxes(n).speedUp = 0;
handles.checkBoxes(n).voiceRemove = 0;
set(handles.Advance, 'foreGroundColor', handles.iniColor);
%   Extract File Name and Path
[fileName, path] = uigetfile('*');                    
% Prompt user with pop-up browser
if ((fileName == 0) & (path==0))
    % if user clicks cancel or 'X' out of the pop-up
else
    set(handles.playButton4, 'String', n );   % Display filename on the playButton
    set(handles.playButton4, 'BackGroundColor',[0.9412 0.9412 0.9412]);
    fullpathname = strcat(path, fileName);          % Concatinate entire path name
    %   Store Data and Copy
    [handles.songs{n,1},handles.songs{n,2}] = audioread(fullpathname); % Store Data
    [handles.mod{n,1},handles.mod{n,2}] = audioread(fullpathname);     % Store Copy
    [handles.chop{n,1},handles.chop{n,2}] = audioread(fullpathname);   % Store Second Copy
    %   Store File Name
    handles.fileName{n} = fileName;
end
guidata(hObject, handles);


% --- Executes on button press in playButton5.
function playButton5_Callback(hObject, eventdata, handles)
handles.which = 5;  %Set Marker to Sample 1
n = 5;
    
if handles.songs{n,2} ~= 0
clear sound;
isPushed = get(hObject, 'Value');
if isPushed
    sound(handles.mod{n,1},handles.mod{n,2});
end
%Set Information Panel
%   Name
set( handles.selected, 'String', sprintf('File Name: %s', handles.fileName{n}));
%   Length
len = length(handles.mod{n,1}) / handles.mod{n,2};
set( handles.songLength, 'String', sprintf('Length of Sample: %0.2f Seconds', len));
%   Frequency
set( handles.freqShow, 'String', sprintf('Frequency: %0.0f Hz', handles.mod{n,2} ));
%   Mono/Stereo
handles.mod{n, 1} = ConvertMS(handles.mod{n,1}, handles.flag(n));
type = checkChannel(handles.mod{n,1});
set( handles.monSter, 'String', sprintf('Mono/Stereo: %s', type));
% Check the boxes as handles.checkBoxes(n) indicates.
set(handles.ReverseCheck,'value', handles.checkBoxes(n).reverse);
set(handles.DelayCheck,'value', handles.checkBoxes(n).delay);
set(handles.FilterCheck,'value', handles.checkBoxes(n).filter);
set(handles.SpeedUpCheck,'value', handles.checkBoxes(n).speedUp);
set(handles.VoiceRemoveCheck,'value', handles.checkBoxes(n).voiceRemove);
end
guidata(hObject, handles);


% --- Executes on button press in loadButton5.
function loadButton5_Callback(hObject, eventdata, handles)
    
n = 5;
% Set the initial values of handles.checkBoxes(n) to 0
handles.checkBoxes(n).reverse = 0;
handles.checkBoxes(n).delay = 0;
handles.checkBoxes(n).filter = 0;
handles.checkBoxes(n).speedUp = 0;
handles.checkBoxes(n).voiceRemove = 0;
set(handles.Advance, 'foreGroundColor', handles.iniColor);
%   Extract File Name and Path
[fileName, path] = uigetfile('*');                    
% Prompt user with pop-up browser
if ((fileName == 0) & (path==0))
    % if user clicks cancel or 'X' out of the pop-up
else
    set(handles.playButton5, 'String', n );   % Display filename on the playButton
    set(handles.playButton5, 'BackGroundColor',[0.9412 0.9412 0.9412]);
    fullpathname = strcat(path, fileName);          % Concatinate entire path name
    %   Store Data and Copy
    [handles.songs{n,1},handles.songs{n,2}] = audioread(fullpathname); % Store Data
    [handles.mod{n,1},handles.mod{n,2}] = audioread(fullpathname);     % Store Copy
    [handles.chop{n,1},handles.chop{n,2}] = audioread(fullpathname);   % Store Second Copy
    %   Store File Name
    handles.fileName{n} = fileName;
end
guidata(hObject, handles);

% --- Executes on button press in playButton6.
function playButton6_Callback(hObject, eventdata, handles)
handles.which = 6;  %Set Marker to Sample 1
n = 6;
    
if handles.songs{n,2} ~= 0
clear sound;
isPushed = get(hObject, 'Value');
if isPushed
    sound(handles.mod{n,1},handles.mod{n,2});
end
%Set Information Panel
%   Name
set( handles.selected, 'String', sprintf('File Name: %s', handles.fileName{n}));
%   Length
len = length(handles.mod{n,1}) / handles.mod{n,2};
set( handles.songLength, 'String', sprintf('Length of Sample: %0.2f Seconds', len));
%   Frequency
set( handles.freqShow, 'String', sprintf('Frequency: %0.0f Hz', handles.mod{n,2} ));
%   Mono/Stereo
handles.mod{n, 1} = ConvertMS(handles.mod{n,1}, handles.flag(n));
type = checkChannel(handles.mod{n,1});
set( handles.monSter, 'String', sprintf('Mono/Stereo: %s', type));
% Check the boxes as handles.checkBoxes(n) indicates.
set(handles.ReverseCheck,'value', handles.checkBoxes(n).reverse);
set(handles.DelayCheck,'value', handles.checkBoxes(n).delay);
set(handles.FilterCheck,'value', handles.checkBoxes(n).filter);
set(handles.SpeedUpCheck,'value', handles.checkBoxes(n).speedUp);
set(handles.VoiceRemoveCheck,'value', handles.checkBoxes(n).voiceRemove);
end
guidata(hObject, handles);



% --- Executes on button press in loadButton6.
function loadButton6_Callback(hObject, eventdata, handles)

n = 6;
% Set the initial values of handles.checkBoxes(n) to 0
handles.checkBoxes(n).reverse = 0;
handles.checkBoxes(n).delay = 0;
handles.checkBoxes(n).filter = 0;
handles.checkBoxes(n).speedUp = 0;
handles.checkBoxes(n).voiceRemove = 0;
set(handles.Advance, 'foreGroundColor', handles.iniColor);
%   Extract File Name and Path
[fileName, path] = uigetfile('*');                    
% Prompt user with pop-up browser
if ((fileName == 0) & (path==0))
    % if user clicks cancel or 'X' out of the pop-up
else
    set(handles.playButton6, 'String', n );   % Display filename on the playButton
    set(handles.playButton6, 'BackGroundColor',[0.9412 0.9412 0.9412]);
    fullpathname = strcat(path, fileName);          % Concatinate entire path name
    %   Store Data and Copy
    [handles.songs{n,1},handles.songs{n,2}] = audioread(fullpathname); % Store Data
    [handles.mod{n,1},handles.mod{n,2}] = audioread(fullpathname);     % Store Copy
    [handles.chop{n,1},handles.chop{n,2}] = audioread(fullpathname);   % Store Second Copy
    %   Store File Name
    handles.fileName{n} = fileName;
end
guidata(hObject, handles);

% --- Executes on button press in playButton7.
function playButton7_Callback(hObject, eventdata, handles)
handles.which = 7;  %Set Marker to Sample 1
n = 7;
    
if handles.songs{n,2} ~= 0
clear sound;
isPushed = get(hObject, 'Value');
if isPushed
    sound(handles.mod{n,1},handles.mod{n,2});
end
%Set Information Panel
%   Name
set( handles.selected, 'String', sprintf('File Name: %s', handles.fileName{n}));
%   Length
len = length(handles.mod{n,1}) / handles.mod{n,2};
set( handles.songLength, 'String', sprintf('Length of Sample: %0.2f Seconds', len));
%   Frequency
set( handles.freqShow, 'String', sprintf('Frequency: %0.0f Hz', handles.mod{n,2} ));
%   Mono/Stereo
handles.mod{n, 1} = ConvertMS(handles.mod{n,1}, handles.flag(n));
type = checkChannel(handles.mod{n,1});
set( handles.monSter, 'String', sprintf('Mono/Stereo: %s', type));
% Check the boxes as handles.checkBoxes(n) indicates.
set(handles.ReverseCheck,'value', handles.checkBoxes(n).reverse);
set(handles.DelayCheck,'value', handles.checkBoxes(n).delay);
set(handles.FilterCheck,'value', handles.checkBoxes(n).filter);
set(handles.SpeedUpCheck,'value', handles.checkBoxes(n).speedUp);
set(handles.VoiceRemoveCheck,'value', handles.checkBoxes(n).voiceRemove);
end
guidata(hObject, handles);


% --- Executes on button press in loadButton7.
function loadButton7_Callback(hObject, eventdata, handles)
    
n = 7;
% Set the initial values of handles.checkBoxes(n) to 0
handles.checkBoxes(n).reverse = 0;
handles.checkBoxes(n).delay = 0;
handles.checkBoxes(n).filter = 0;
handles.checkBoxes(n).speedUp = 0;
handles.checkBoxes(n).voiceRemove = 0;
set(handles.Advance, 'foreGroundColor', handles.iniColor);
%   Extract File Name and Path
[fileName, path] = uigetfile('*');                    
% Prompt user with pop-up browser
if ((fileName == 0) & (path==0))
    % if user clicks cancel or 'X' out of the pop-up
else
    set(handles.playButton7, 'String', n );   % Display filename on the playButton
    set(handles.playButton7, 'BackGroundColor',[0.9412 0.9412 0.9412]);
    fullpathname = strcat(path, fileName);          % Concatinate entire path name
    %   Store Data and Copy
    [handles.songs{n,1},handles.songs{n,2}] = audioread(fullpathname); % Store Data
    [handles.mod{n,1},handles.mod{n,2}] = audioread(fullpathname);     % Store Copy
    [handles.chop{n,1},handles.chop{n,2}] = audioread(fullpathname);   % Store Second Copy
    %   Store File Name
    handles.fileName{n} = fileName;
end
guidata(hObject, handles);

% --- Executes on button press in playButton8.
function playButton8_Callback(hObject, eventdata, handles)
handles.which = 8;  %Set Marker to Sample 1
n = 8;
    
if handles.songs{n,2} ~= 0
clear sound;
isPushed = get(hObject, 'Value');
if isPushed
    sound(handles.mod{n,1},handles.mod{n,2});
end
%Set Information Panel
%   Name
set( handles.selected, 'String', sprintf('File Name: %s', handles.fileName{n}));
%   Length
len = length(handles.mod{n,1}) / handles.mod{n,2};
set( handles.songLength, 'String', sprintf('Length of Sample: %0.2f Seconds', len));
%   Frequency
set( handles.freqShow, 'String', sprintf('Frequency: %0.0f Hz', handles.mod{n,2} ));
%   Mono/Stereo
handles.mod{n, 1} = ConvertMS(handles.mod{n,1}, handles.flag(n));
type = checkChannel(handles.mod{n,1});
set( handles.monSter, 'String', sprintf('Mono/Stereo: %s', type));
% Check the boxes as handles.checkBoxes(n) indicates.
set(handles.ReverseCheck,'value', handles.checkBoxes(n).reverse);
set(handles.DelayCheck,'value', handles.checkBoxes(n).delay);
set(handles.FilterCheck,'value', handles.checkBoxes(n).filter);
set(handles.SpeedUpCheck,'value', handles.checkBoxes(n).speedUp);
set(handles.VoiceRemoveCheck,'value', handles.checkBoxes(n).voiceRemove);
end
guidata(hObject, handles);


% --- Executes on button press in loadButton8.
function loadButton8_Callback(hObject, eventdata, handles)

n = 8;
% Set the initial values of handles.checkBoxes(n) to 0
handles.checkBoxes(n).reverse = 0;
handles.checkBoxes(n).delay = 0;
handles.checkBoxes(n).filter = 0;
handles.checkBoxes(n).speedUp = 0;
handles.checkBoxes(n).voiceRemove = 0;
set(handles.Advance, 'foreGroundColor', handles.iniColor);
%   Extract File Name and Path
[fileName, path] = uigetfile('*');                    
% Prompt user with pop-up browser
if ((fileName == 0) & (path==0))
    % if user clicks cancel or 'X' out of the pop-up
else
    set(handles.playButton8, 'String', n );   % Display filename on the playButton
    set(handles.playButton8, 'BackGroundColor',[0.9412 0.9412 0.9412]);
    fullpathname = strcat(path, fileName);          % Concatinate entire path name
    %   Store Data and Copy
    [handles.songs{n,1},handles.songs{n,2}] = audioread(fullpathname); % Store Data
    [handles.mod{n,1},handles.mod{n,2}] = audioread(fullpathname);     % Store Copy
    [handles.chop{n,1},handles.chop{n,2}] = audioread(fullpathname);   % Store Second Copy
    %   Store File Name
    handles.fileName{n} = fileName;
end
guidata(hObject, handles);

% --- Executes on button press in playButton9.
function playButton9_Callback(hObject, eventdata, handles)
handles.which = 9;  %Set Marker to Sample 1
n = 9;
    
if handles.songs{n,2} ~= 0
clear sound;
isPushed = get(hObject, 'Value');
if isPushed
    sound(handles.mod{n,1},handles.mod{n,2});
end
%Set Information Panel
%   Name
set( handles.selected, 'String', sprintf('File Name: %s', handles.fileName{n}));
%   Length
len = length(handles.mod{n,1}) / handles.mod{n,2};
set( handles.songLength, 'String', sprintf('Length of Sample: %0.2f Seconds', len));
%   Frequency
set( handles.freqShow, 'String', sprintf('Frequency: %0.0f Hz', handles.mod{n,2} ));
%   Mono/Stereo
handles.mod{n, 1} = ConvertMS(handles.mod{n,1}, handles.flag(n));
type = checkChannel(handles.mod{n,1});
set( handles.monSter, 'String', sprintf('Mono/Stereo: %s', type));
% Check the boxes as handles.checkBoxes(n) indicates.
set(handles.ReverseCheck,'value', handles.checkBoxes(n).reverse);
set(handles.DelayCheck,'value', handles.checkBoxes(n).delay);
set(handles.FilterCheck,'value', handles.checkBoxes(n).filter);
set(handles.SpeedUpCheck,'value', handles.checkBoxes(n).speedUp);
set(handles.VoiceRemoveCheck,'value', handles.checkBoxes(n).voiceRemove);
end
guidata(hObject, handles);



% --- Executes on button press in loadButton9.
function loadButton9_Callback(hObject, eventdata, handles)

n = 9;
% Set the initial values of handles.checkBoxes(n) to 0
handles.checkBoxes(n).reverse = 0;
handles.checkBoxes(n).delay = 0;
handles.checkBoxes(n).filter = 0;
handles.checkBoxes(n).speedUp = 0;
handles.checkBoxes(n).voiceRemove = 0;
set(handles.Advance, 'foreGroundColor', handles.iniColor);
%   Extract File Name and Path
[fileName, path] = uigetfile('*');                    
% Prompt user with pop-up browser
if ((fileName == 0) & (path==0))
    % if user clicks cancel or 'X' out of the pop-up
else
    set(handles.playButton9, 'String', n );   % Display filename on the playButton
    set(handles.playButton9, 'BackGroundColor',[0.9412 0.9412 0.9412]);
    fullpathname = strcat(path, fileName);          % Concatinate entire path name
    %   Store Data and Copy
    [handles.songs{n,1},handles.songs{n,2}] = audioread(fullpathname); % Store Data
    [handles.mod{n,1},handles.mod{n,2}] = audioread(fullpathname);     % Store Copy
    [handles.chop{n,1},handles.chop{n,2}] = audioread(fullpathname);   % Store Second Copy
    %   Store File Name
    handles.fileName{n} = fileName;
end
guidata(hObject, handles);




% --- Executes on selection change in SampleChosen.
function SampleChosen_Callback(hObject, eventdata, handles)
% hObject    handle to SampleChosen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SampleChosen contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SampleChosen


% --- Executes during object creation, after setting all properties.
function SampleChosen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SampleChosen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DelayCheck.
function DelayCheck_Callback(hObject, eventdata, handles)
% hObject    handle to DelayCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DelayCheck


% --- Executes on button press in FilterCheck.
function FilterCheck_Callback(hObject, eventdata, handles)
% hObject    handle to FilterCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FilterCheck



% --- Executes on button press in SpeedUpCheck.
function SpeedUpCheck_Callback(hObject, eventdata, handles)
% hObject    handle to SpeedUpCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SpeedUpCheck


% --- Executes on button press in VoiceRemoveCheck.
function VoiceRemoveCheck_Callback(hObject, eventdata, handles)
% hObject    handle to VoiceRemoveCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VoiceRemoveCheck


% --- Executes on button press in Apply.
function Apply_Callback(hObject, eventdata, handles)
% hObject    handle to Apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sound;
if handles.which ~= 0
    if handles.songs{handles.which, 2} ~=0
        n = handles.which;
        % Assign the corresponding handles.checkBoxes(n) with the values of
        % the effect check boxes 
        handles.checkBoxes(n).reverse = get(handles.ReverseCheck, 'value');
        handles.checkBoxes(n).delay = get(handles.DelayCheck, 'value');
        handles.checkBoxes(n).filter = get(handles.FilterCheck, 'value');
        handles.checkBoxes(n).speedUp = get(handles.SpeedUpCheck, 'value');
        handles.checkBoxes(n).voiceRemove = get(handles.VoiceRemoveCheck, 'value');
        % If one of the customizable effects is applied, change the color
        % of the advance button to black.
        if (handles.checkBoxes(n).delay ~= 0) || ...
            (handles.checkBoxes(n).filter ~= 0) || ...
            (handles.checkBoxes(n).speedUp ~= 0) || ...
            (handles.checkBoxes(n).voiceRemove ~= 0)
            set(handles.Advance, 'foreGroundColor', [0, 0, 0]);
        end
        % If all of the customizable effects are de-applied, change the
        % color of the advance button to grey.
        if (handles.checkBoxes(n).delay == 0) && ...
            (handles.checkBoxes(n).filter == 0) && ...
            (handles.checkBoxes(n).speedUp == 0) && ...
            (handles.checkBoxes(n).voiceRemove == 0)
            set(handles.Advance, 'foreGroundColor', handles.iniColor);
        end
        % If the advance button is pressed, use the user-input numbers for 
        % the effect functions.
        if handles.buttonPress(n)
            [handles.mod{n, 1}, handles.mod{n, 2}] = ...
                ManageEffect(handles.chop{n, 1}, handles.chop{n, 2}, handles.checkBoxes(n),...
                handles.buttonPress(n), handles.userSet{1, n});
        % If not, use the default numbers for the effect functions.
        else
            [handles.mod{n, 1}, handles.mod{n, 2}] = ...
                ManageEffect(handles.chop{n, 1}, ...
                handles.chop{n, 2}, handles.checkBoxes(n), 0, 0);
        end

        %Set Information Panel
        set( handles.selected, 'String', sprintf('File Name: %s', handles.fileName{n}));
        len = length(handles.mod{n,1}) / handles.mod{n,2};
        set( handles.songLength, 'String', sprintf('Length of Sample: %0.2f Seconds', len));
        set( handles.freqShow, 'String', sprintf('Frequency: %0.0f Hz', handles.mod{n,2} ));
        guidata(hObject, handles);
    end
end
        

    % Apply effect according to the checked effects.
    function [modData, modFreq] = ManageEffect(dataRead, frequency, checkBoxes, buttonPress, userSet)
        modData = dataRead;
        modFreq = frequency;
        if checkBoxes.reverse
            [modData, modFreq] = Reverse(modData, modFreq);
        end
        if checkBoxes.delay
            [modData, modFreq] = Delay(modData, modFreq, buttonPress, userSet);
        end
        if checkBoxes.filter
            [modData, modFreq] = Filter(modData, modFreq, buttonPress, userSet);
        end
        if checkBoxes.speedUp
            [modData, modFreq] = SpeedUp(modData, modFreq, buttonPress, userSet);
        end
        if checkBoxes.voiceRemove
            [modData, modFreq] = VoiceRemove(modData, modFreq, buttonPress, userSet);
        end
        
    % Apply the reverse effect on the selected sample
    function [modData, modFreq] = Reverse(dataRead, frequency)
        modData = flipud(dataRead);
        modFreq = frequency;
        
    % Apply the delay effect on the selected sample
    function [modData, modFreq] = Delay(dataRead, frequency, buttonPress, userSet)
        modData = dataRead;
        % Use the user-input numbers when the advance button was pushed, or
        % else use the default data.
        if buttonPress
            modFreq = frequency * str2double(userSet{1});
        else
            modFreq = frequency * 0.7;
        end
        
    % Apply the filter effect on the selected sample
    function [modData, modFreq] = Filter(dataRead, frequency, buttonPress, userSet)
        % Use the user-input numbers when the advance button was pushed, or
        % else use the default data.
        if buttonPress
            fNorm = str2double(userSet{3})/(frequency/2);
            if strcmp(strtrim(lower(userSet{2})), 'high')
                [b,a] = butter(10, fNorm, 'high');
            elseif strcmp(strtrim(lower(userSet{2})), 'low')
                [b,a] = butter(10, fNorm, 'low');
            end
        else
            fNorm = 1000/(frequency/2);
            [b,a] = butter(10, fNorm, 'low');
        end
        dataFiltered = filtfilt(b, a, dataRead);
        modData = dataFiltered;
        modFreq = frequency;
        
    % Apply the Speed Up effect on the selected sample
    function [modData, modFreq] = SpeedUp(dataRead, frequency, buttonPress, userSet)
        modData = dataRead;
        % Use the user-input numbers when the advance button was pushed, or
        % else use the default data.
        if buttonPress
            modFreq = frequency * str2double(userSet{4});
        else
            modFreq = frequency * 2;
        end
        
    % Apply the Voice Remove effect on the selected sample
    function [modData, modFreq] = VoiceRemove(dataRead, frequency, buttonPress, userSet)
        % Use the user-input numbers when the advance button was pushed, or
        % else use the default data.
        if buttonPress
            fNorm  = [str2double(userSet{5})/(frequency/2),...
                str2double(userSet{6})/(frequency/2)];
        else
            fNorm  = [150/(frequency/2), 1500/(frequency/2)];
        end
        [b, a] = butter(3, fNorm, 'stop');
        dataBand = filtfilt(b, a, dataRead);
        modData = dataBand;
        modFreq = frequency;
        

% --- Executes on button press in ReverseCheck.
function ReverseCheck_Callback(hObject, eventdata, handles)
% hObject    handle to ReverseCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ReverseCheck


% --- Executes on button press in finalchop.
function finalChop_Callback(hObject, eventdata, handles)
    clear sound;
if handles.which ~= 0
if handles.songs{handles.which, 2} ~=0
n = handles.which;    %Call number of selected sample


if handles.buttonPress(n) == 1
    [handles.mod{n, 1}, handles.mod{n, 2}] = ManageEffect(handles.songs{n, 1}, handles.songs{n, 2}, handles.checkBoxes(n),...
        handles.buttonPress(n), handles.userSet{1, n});
else
    [handles.mod{n, 1}, handles.mod{n, 2}] = ManageEffect(handles.songs{n, 1}, handles.songs{n, 2}, handles.checkBoxes(n), 0, 0);
end
% Go on If there is anything in 'start' or 'stop'
 if (isfield(handles, 'start') && handles.start >= 0) && (isfield(handles, 'end') && handles.end >= 0)
    len = length(handles.mod{n,1}) / handles.mod{n,2};
    
    %Go on only if length is shorter than input
    if len > handles.end
        %       Alteration of handles.mod
        handles.mod{n,1} = chopped(handles.mod{n,1}, handles.mod{n,2}, handles.start, handles.end);
        newlen = length(handles.mod{n,1}) / handles.mod{n,2};
        set( handles.songLength, 'String', sprintf('Length of Sample: %.2f Seconds', newlen));
        if length(handles.songs{n,1}) / handles.songs{n,2} > handles.end
        %       Alterations of handles.chop      
        handles.chop{n,1} = chopped(handles.songs{n,1}, handles.songs{n,2}, handles.start, handles.end);
        
        end
    end
 end
 
end
end

 
 guidata(hObject, handles);


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
clear sound;
if handles.which ~= 0
    if handles.songs{handles.which, 2} ~=0
        n = handles.which;
        % Reset the values of handles.mod{n, :}
        handles.mod{n, 1} = handles.chop{n,1};
        handles.mod{n, 2} = handles.chop{n,2};
        % Clear the effect check boxes
        set(handles.ReverseCheck, 'value', 0);
        set(handles.DelayCheck, 'value', 0);
        set(handles.FilterCheck, 'value', 0);
        set(handles.SpeedUpCheck, 'value', 0);
        set(handles.VoiceRemoveCheck, 'value', 0);
        % Clear the handles.checkBoxes(n)
        handles.checkBoxes(n).reverse = 0;
        handles.checkBoxes(n).delay = 0;
        handles.checkBoxes(n).filter = 0;
        handles.checkBoxes(n).speedUp = 0;
        handles.checkBoxes(n).voiceRemove = 0;
        % Set the foreGroundColor of the advance button to grey
        set(handles.Advance, 'foreGroundColor', handles.iniColor);
        guidata(hObject, handles);

        %Set Information Panel
        set( handles.selected, 'String', sprintf('File Name: %s', handles.fileName{n}));
        len = length(handles.mod{n,1}) / handles.mod{n,2};
        set( handles.songLength, 'String', sprintf('Length of Sample: %0.2f Seconds', len));
        set( handles.freqShow, 'String', sprintf('Frequency: %0.0f Hz', handles.mod{n,2} ));
    end
end
    
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Advance.
function Advance_Callback(hObject, eventdata, handles)
% hObject    handle to Advance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.which ~= 0
    if handles.songs{handles.which, 2} ~=0
    n = handles.which;
        if  (n ~= 0)
            % When at least one of the customizable effects is selected
            if (handles.checkBoxes(n).delay ~= 0) || ...
                (handles.checkBoxes(n).filter ~= 0) || ...
                (handles.checkBoxes(n).speedUp ~= 0) || ...
                (handles.checkBoxes(n).voiceRemove ~= 0)
                % Define the advance options input dialogue window
                prompt = {'Enter the delay rate (between 0 and 1):',...
                    'Enter filter type (high / low)',...
                    'Enter frequency (high: Supresses below the frequency; low: Supresses above the frequency)',...
                    'Enter the speed up rate (greater than 1 and less than 10):',...
                    'Voice remove from:', 'Voice remove to:'};
                name = 'Advance Effects Options';
                numlines =[1, 50; 1, 50; 1, 50; 1, 50; 1, 50; 1, 50];
                defaultAnswer = cell(1, 9);
                for i = 1:9
                    defaultAnswer{i} = {'0.7', 'low', '1000', '2', '500', '3000'};
                end
                % Mark it if the advance button wasn't pressed before, if
                % it is, assign the default answers to the user's input.
                if handles.buttonPress(n) == 0
                    handles.buttonPress(n) = 1;
                else
                    defaultAnswer{n} = handles.userSet{1, n};
                end
                options.Resize = 'on';
                options.WindowStyle = 'modal';
                % Pop up the advance options
                handles.userSet{1, n} = inputdlg(prompt, name, numlines, defaultAnswer{n}, options);
                highOrLow = handles.userSet{1, n};
                % Check if the high- or low-pass entry is the correct
                % input. If not, a error message will appear until the
                % correct entry is made.
                if isempty(highOrLow) == 0
                    while (strcmp(strtrim(lower(highOrLow)), 'high') == 0 & ...
                            strcmp(strtrim(lower(highOrLow)), 'low') == 0)
                        message = 'Error in box 2: Please enter either ''high'' or ''low''';
                        title = 'Error!';
                        uiwait(msgbox(message, title, 'error'));
                        handles.userSet{1, n} = inputdlg(prompt, name, numlines, defaultAnswer{n}, options);
                        if isempty(highOrLow) == 0
                            defaultAnswer{n} = handles.userSet{1, n};
                            highOrLow = handles.userSet{1, n};
                        else
                        end
                    end
                else
                    handles.userSet{1, n} = defaultAnswer{n};
                end
                guidata(hObject, handles);
            end
        end
    end
end



function startTime_Callback(hObject, eventdata, handles)
% hObject    handle to startTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.start = str2double(get(hObject, 'String'));
guidata(hObject, handles);

 % Hints: get(hObject,'String') returns contents of startTime as text
%        str2double(get(hObject,'String')) returns contents of startTime as a double


% --- Executes during object creation, after setting all properties.
function startTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endTime_Callback(hObject, eventdata, handles)
% hObject    handle to endTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.end = str2double(get(hObject, 'String'));
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of endTime as text
%        str2double(get(hObject,'String')) returns contents of endTime as a double


% --- Executes during object creation, after setting all properties.
function endTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in undoChop.
function undoChop_Callback(hObject, eventdata, handles)
clear sound;
if handles.which ~= 0
if handles.songs{handles.which, 2} ~=0
n = handles.which;

%       Alteration of handles.chop: Copy from original
handles.chop{n,1} = handles.songs{n,1};
handles.chop{n,2} = handles.songs{n,2};

%       Alteration of handles.mod: Apply effects
if handles.buttonPress(n) == 0
    [handles.mod{n, 1}, handles.mod{n, 2}] = ManageEffect(handles.songs{n, 1}, handles.songs{n, 2}, handles.checkBoxes(n), handles.buttonPress(n), ...
                0);
else
    [handles.mod{n, 1}, handles.mod{n, 2}] = ManageEffect(handles.songs{n, 1}, handles.songs{n, 2}, handles.checkBoxes(n), handles.buttonPress(n), ...
                handles.userSet{1, n});
end

%       Show Old Length
len = length(handles.mod{n,1}) / handles.mod{n,2};
set( handles.songLength, 'String', sprintf('Length of Sample: %0.2f Seconds', len));

%       Empty start stop
set( handles.startTime, 'String', sprintf('Start Time'));
set( handles.endTime, 'String', sprintf('End Time'));
guidata(hObject, handles);
end
end



function [ outdata ] = chopped( data, frequency, start, stop)
%Shortens sound
[~, col] = size(data);
if col == 2;
    outdata = data( round(frequency*start)+1 : round(frequency*stop) )';
else
    outdata = data( round(frequency*start)+1 : round(frequency*stop) );
end

function [channel] = checkChannel(inputSoundData)
%Checks if item is mono or stereo
[~, col] = size(inputSoundData);
if (col == 1)
    channel = 'Mono'; %Inherently Mono
else 
    if(isequal(inputSoundData(:,1), inputSoundData(:,2)) == 1)
        channel = 'Stereo'; % Double Mono
    else
        channel = 'Stereo'; % Stereo
    end
end

function [outData] = ConvertMS(inputData, flag)
 %Checks if item is mono or stereo
[~, col] = size(inputData);

if flag ~= 0
    
    if flag == 1
        %   Stereo/Mono convert to Inherently Mono
        if col == 2
            outData(:,1) = ((inputData(:,1)+inputData(:,2)) /2);
        else
            outData = inputData;
        end
        
    elseif flag == 2
        %   Inherently Mono convert to double Mono
        if (col == 1)
        	outData = cat(2, inputData, inputData);
        else
            outData = inputData;
        end
        
    end
    
    
else
    outData = inputData;
end



    


% --- Executes on selection change in popupMS.
function popupMS_Callback(hObject, eventdata, handles)
% hObject    handle to popupMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupMS contents as cell array



% --- Executes on button press in applyMS.
function applyMS_Callback(hObject, eventdata, handles)
% hObject    handle to applyMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.popupMS,'Value');
clear sound;
if handles.which ~= 0
if handles.songs{handles.which, 2} ~=0
    
n = handles.which;

switch contents
    case 1
        handles.flag(n) = 1;
        set( handles.monSter, 'String', sprintf('Mono/Stereo: Mono'));
    case 2
        handles.flag(n) = 2;
        set( handles.monSter, 'String', sprintf('Mono/Stereo: Stereo'));
end

end
end
guidata(hObject, handles);


% --- Executes on button press in generateTone.
function generateTone_Callback(hObject, eventdata, handles)
% hObject    handle to generateTone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
isPushed = get(hObject, 'Value');
% If pushed, prompt user with dialogue window
if isPushed
    prompt = {'Enter type of mathematical function: (1) sine wave, (2) square wave, or           (3) triangle wave',...
    'Enter sample frequency (positive number between 80 and 1000000):','Enter number of piano key (between 1 to 88):', 'Enter amplitude:',...
    'Enter time span (in sec):','Enter grid number to modify (1 to 9):'};
    dlg_title = 'GenerateTone';
    num_lines = 1;
    def = {'1','8000','40', '1', '2', '1'}; % default entries
    answer = inputdlg(prompt,dlg_title,num_lines,def);
end
set(handles.Advance, 'foreGroundColor', handles.iniColor);
    % Resume the original color of the Advance button.
if (isempty(answer))
    % if user clicks cancel or 'X' out of the pop-up
else
    functionNum = str2double(answer{1}); % mathematical function number
    samplefrequency = str2double(answer{2});
    numpianokey = str2double(answer{3}); % number of piano key
    amp = str2double(answer{4}); % amplitude
    t = str2double(answer{5}); % time span (in sec)
    gridNum = str2double(answer{6}); % grid number
    
    switch functionNum
        case 1 % sine wave
            pianokeyfrequency = (2 ^ ((numpianokey - 49) / 12)) * 440;
            time = linspace(0, 2, samplefrequency * t); % corresponds to 2 sec
            ySound = amp * sin(pianokeyfrequency * 2 * pi *time);
            
        case 2 % square wave
            time = 0:1/samplefrequency:t;
            ySound = amp * sawtooth(2*pi*numpianokey*time);
            
        case 3 % triangle wave
            time = 0:1/samplefrequency:t;
            ySound = amp * square(2*pi*numpianokey*time);
            
    end
    str1 = 'playButton';
    button = [str1, answer{6}]; % Concatenate structure name
    
    % Color-code corresponding buttons and erase number
    switch gridNum
        case 1
            set(handles.(button), 'BackGroundColor', 'y' );
            set(handles.(button), 'string', '');
        case 2
            set(handles.(button), 'BackGroundColor', 'm' );
            set(handles.(button), 'string', '');
        case 3
            set(handles.(button), 'BackGroundColor', 'c' );
            set(handles.(button), 'string', '');
        case 4
            set(handles.(button), 'BackGroundColor', 'r' );
            set(handles.(button), 'string', '');
        case 5
            set(handles.(button), 'BackGroundColor', 'g' );
            set(handles.(button), 'string', '');
        case 6
            set(handles.(button), 'BackGroundColor', 'b' );
            set(handles.(button), 'string', '');
        case 7
            set(handles.(button), 'BackGroundColor', 'w' );
            set(handles.(button), 'string', '');
        case 8
            set(handles.(button), 'BackGroundColor', 'k' );
            set(handles.(button), 'string', '');
        case 9
            set(handles.(button), 'BackGroundColor', [1,0.4,0.6] );
            set(handles.(button), 'string', '');
    end
    handles.checkBoxes(gridNum).reverse = 0;
    handles.checkBoxes(gridNum).delay = 0;
    handles.checkBoxes(gridNum).filter = 0;
    handles.checkBoxes(gridNum).speedUp = 0;
    handles.checkBoxes(gridNum).voiceRemove = 0;
    str2 = 'Generated Pure Tone ';
    fileName = [str2, answer{6}];
    handles.fileName{gridNum} = fileName;
    handles.songs{gridNum,1} = ySound'; % transpose generated tone row array to column array
    handles.songs{gridNum,2} = samplefrequency;
    handles.mod{gridNum,1} = ySound';
    handles.mod{gridNum,2} = samplefrequency;
    handles.chop{gridNum,1} = ySound';
    handles.chop{gridNum,2} = samplefrequency;
end
guidata(hObject, handles);
