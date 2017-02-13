function varargout = currentModeGUI(varargin)
% CURRENTMODEGUI MATLAB code for currentModeGUI.fig
%      CURRENTMODEGUI, by itself, creates a new CURRENTMODEGUI or raises the existing
%      singleton*.
%
%      H = CURRENTMODEGUI returns the handle to a new CURRENTMODEGUI or the handle to
%      the existing singleton*.
%
%      CURRENTMODEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CURRENTMODEGUI.M with the given input arguments.
%
%      CURRENTMODEGUI('Property','Value',...) creates a new CURRENTMODEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before currentModeGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to currentModeGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help currentModeGUI

% Last Modified by GUIDE v2.5 21-Sep-2016 11:28:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @currentModeGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @currentModeGUI_OutputFcn, ...
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


% --- Executes just before currentModeGUI is made visible.
function currentModeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to currentModeGUI (see VARARGIN)

% Choose default command line output for currentModeGUI
handles.output = hObject;
addpath('../');
epos = Epos();
assignin('base','epos',epos);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes currentModeGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = currentModeGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in activate.
function activate_Callback(hObject, eventdata, handles)
% hObject    handle to activate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Enable device
epos = evalin('base','epos');

if(~epos.changeEposState('shutdown'))
	return;
end
if(~epos.changeEposState('enable operation'))
	return;
end
handles.currentSlider.Value = 0;
handles.setCurrent.String = '0';
if(~epos.setCurrentModeSetting(0))
	warndlg('Failed to set current');
	return;
end
start(handles.timer);





% --- Executes on slider movement.
function currentSlider_Callback(hObject, eventdata, handles)
% hObject    handle to currentSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
epos = evalin('base','epos');
if(~epos.connected)
	set(hObject,'Value',0);
	handles.setCurrent.String = num2str(0);
	warndlg('Epos is not connected');
	return;
end
current = floor(get(hObject,'Value')); %only int
set(hObject,'Value',current);
if(~epos.setCurrentModeSetting(current))
	warndlg('Failed to set current value');
	return;
end
handles.setCurrent.String = num2str(current);
pause(0.1); %do not overload epos with messages!!!




    
% --- Executes during object creation, after setting all properties.
function currentSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.


if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ki_Callback(hObject, eventdata, handles)
% hObject    handle to ki (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ki as text
%        str2double(get(hObject,'String')) returns contents of ki as a double


% --- Executes during object creation, after setting all properties.
function ki_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ki (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kp_Callback(hObject, eventdata, handles)
% hObject    handle to kp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kp as text
%        str2double(get(hObject,'String')) returns contents of kp as a double


% --- Executes during object creation, after setting all properties.
function kp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
epos = evalin('base','epos');
OK = epos.changeEposState('fault reset');
if ~OK
	warndlg('Failed to reset Epos');
end



function maxCurrent_Callback(hObject, eventdata, handles)
% hObject    handle to maxCurrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxCurrent as text
%        str2double(get(hObject,'String')) returns contents of maxCurrent as a double


% --- Executes during object creation, after setting all properties.
function maxCurrent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxCurrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to maxSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxSpeed as text
%        str2double(get(hObject,'String')) returns contents of maxSpeed as a double


% --- Executes during object creation, after setting all properties.
function maxSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function polePair_Callback(hObject, eventdata, handles)
% hObject    handle to polePair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of polePair as text
%        str2double(get(hObject,'String')) returns contents of polePair as a double


% --- Executes during object creation, after setting all properties.
function polePair_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polePair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function motor_type_edit_Callback(hObject, eventdata, handles)
% hObject    handle to motor_type_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of motor_type_edit as text
%        str2double(get(hObject,'String')) returns contents of motor_type_edit as a double


% --- Executes during object creation, after setting all properties.
function motor_type_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to motor_type_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function port_edit_Callback(hObject, eventdata, handles)
% hObject    handle to port_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of port_edit as text
%        str2double(get(hObject,'String')) returns contents of port_edit as a double


% --- Executes during object creation, after setting all properties.
function port_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to port_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in motorType.
function motorType_Callback(hObject, eventdata, handles)
% hObject    handle to motorType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns motorType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from motorType


% --- Executes during object creation, after setting all properties.
function motorType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to motorType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in connect.
function connect_Callback(hObject, eventdata, handles)
	% hObject    handle to connect (see GCBO)
	% eventdata  reserved - to be defined in a future version of MATLAB
	% handles    structure with handles and user data (see GUIDATA)
	epos = evalin('base','epos');
	port_string = get(handles.port_edit, 'String');
	if epos.connected == false
		OK = epos.begin(port_string);
		if OK
			set(handles.port_edit, 'Enable', 'inactive');
			set(handles.connect, 'String','Disconnect');
			% update stored values
			% get motor specs
			[motorConfig, OK] = epos.readMotorConfig();
			if OK
				% update fields
				switch motorConfig.motorType
					case 'DC motor'
						handles.motorType.Value = 1;
					case 'Sinusoidal PM BL motor'
						handles.motorType.Value = 2;
					case 'Trapezoidal PM BL motor'
						handles.motorType.Value = 3;
				end
				handles.maxCurrent.string = num2str(motorConfig.currentLimit);
				handles.currentSlider.max = motorConfig.currentLimit;
				handles.polePair.string = num2str(motorConfig.polePairNumber);
			else
				warndlg('Failed to read Motor Config from Epos');
				return;
			end
			handles.timer = timer('ExecutionMode', 'fixedRate', ...       % Run timer repeatedly.
				'Period', 0.2, ...                        % Initial period is 1 sec.
				'TimerFcn', {@update,handles}); % Specify callback function.
		else
			warndlg('Failed to connect to Epos');
			return;
		end
	else
		epos.disconnect();
		set(handles.port_edit, 'Enable','on');
		set(handles.connect, 'String','Connect');
	end




% --- Executes on button press in applyMotorspecs.
function applyMotorspecs_Callback(hObject, eventdata, handles)
	% hObject    handle to applyMotorspecs (see GCBO)
	% eventdata  reserved - to be defined in a future version of MATLAB
	% handles    structure with handles and user data (see GUIDATA)
	epos = evalin('base','epos');
	polePair = str2double(get(handles.polePair, 'String'));
	maxCurrent = str2double(get(handles.maxCurrent, 'String'));
	maxSpeed = str2double(get(handles.maxSpeed, 'String'));
	switch handles.motorType.Value
		case 1
			motorType = 1;
		case 2
			motorType = 10;
		case 3
			motorType = 11;
	end
	if(isnan(polePair))
		warndlg('Pole Pair must be a Number');
		return;
	elseif(isnan(maxCurrent))
		warndlg('Max current must be a Number');
		return;
	elseif(isnan(maxSpeed))
		warndlg( 'Max speed must be a Number');
	end
	if ~epos.connected
		warndlg('Not connected to Epos');
		return;
	end
	OK = epos.setMotorConfig(motorType,maxCurrent, maxSpeed, polePair);
	if(~OK)
		warndlg('Failed to set motor specs');
		return;
	end



% --- Executes on button press in applyGains.
function applyGains_Callback(hObject, eventdata, handles)
% hObject    handle to applyGains (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
epos = evalin('base','epos');
iGain= str2double(get(handles.ki, 'String'));
pGain = str2double(get(handles.kp, 'String'));
if(isnan(iGain))
    warndlg('iGain must be a Number');
	return;
elseif(isnan(pGain))
	warndlg('pGain must be a Number');
	return;
end
if(~epos.connected)
	warndlg('Not connected to Epos');
	return;
end
OK = epos.setCurrentControlParam(pGain, iGain);
if(~OK)
		warndlg('Failed to set motor specs');
		return;
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

if  evalin('base', 'exist(''epos'', ''var'') == 1')
	epos = evalin('base','epos');
	epos.disconnect();
end
delete(hObject);


% --- Executes during object creation, after setting all properties.
function uipanel6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in enableCurrentMode.
function enableCurrentMode_Callback(hObject, eventdata, handles)
% hObject    handle to enableCurrentMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enableCurrentMode
epos = evalin('base','epos');
if (~epos.connected)
	warndlg('Not connected to Epos');
	return;
end
[opMode, OK] = epos.readOpMode();
if OK
	if opMode == -3
		handles.enableCurrentMode.Background = 'green';
		handles.enableCurrentMode.Enable = 'inactive';
		handles.enableCurrentMode.Value = 1;
		return;
	else
		OK = epos.setOpMode(-3);
		if (~OK)
			warndlg('Failed to set Current Mode');
			return;
		end
		handles.enableCurrentMode.Background = [0.906 0.906 0.906];
		handles.enableCurrentMode.Enable = 'inactive';
		handles.enableCurrentMode.Value = 1;
	end
else
	warndlg('Failed to read Operation Mode');
end



function setCurrent_Callback(hObject, eventdata, handles)
% hObject    handle to setCurrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setCurrent as text
%        str2double(get(hObject,'String')) returns contents of setCurrent as a double


% --- Executes during object creation, after setting all properties.
function setCurrent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setCurrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function AverageCurrent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AverageCurrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in setCurrentButton.
function setCurrentButton_Callback(hObject, eventdata, handles)
% hObject    handle to setCurrentButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
epos = evalin('base','epos');
current = floor(str2double(get(handles.setCurrent,'String'))); %only int
if (isnan(current))
	warndlg('Current value must be a number');
	return;
end
maxCurrent = str2double(handles.maxCurrent.String);
if (current > maxCurrent)
	current = maxCurrent;
end
if (current < 0)
	current = 0;
end

set(hObject,'String',num2str(current));
if(~epos.setCurrentModeSetting(current))
	warndlg('Failed to set current value');
	return;
end
handles.sliderCurrent.Value = current;

% --- Executes on key press with focus on connect and none of its controls.
function connect_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to connect (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

function update(hObject, eventdata, handles)
% hObject    handle to connect (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% todo
