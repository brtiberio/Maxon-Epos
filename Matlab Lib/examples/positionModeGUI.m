function varargout = positionModeGUI(varargin)
% POSITIONMODEGUI MATLAB code for positionModeGUI.fig
%      POSITIONMODEGUI, by itself, creates a new POSITIONMODEGUI or raises the existing
%      singleton*.
%
%      H = POSITIONMODEGUI returns the handle to a new POSITIONMODEGUI or the handle to
%      the existing singleton*.
%
%      POSITIONMODEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POSITIONMODEGUI.M with the given input arguments.
%
%      POSITIONMODEGUI('Property','Value',...) creates a new POSITIONMODEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before positionModeGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to positionModeGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help positionModeGUI

% Last Modified by GUIDE v2.5 07-Feb-2017 14:54:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @positionModeGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @positionModeGUI_OutputFcn, ...
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


% --- Executes just before positionModeGUI is made visible.
function positionModeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to positionModeGUI (see VARARGIN)

% Choose default command line output for positionModeGUI
handles.output = hObject;
% include library path
addpath('../');
% create class handle
epos = Epos();
handles.muttex = 0;
% create timer object
handles.myTimer = timer('Name', 'myTimer', 'Period', 0.5, ...
	'ExecutionMode', 'fixedRate', ...
	'timerfcn', {@update, hObject, eventdata, handles});

assignin('base','epos',epos);

evalin('base','import java.util.concurrent.Semaphore');
evalin('base', 'mutex = Semaphore(1);');
evalin('base', 'angleFactor = 1');
angleFactor = evalin('base','angleFactor');
handles.angleGain.String = num2str(angleFactor);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes positionModeGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = positionModeGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function setPosition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setPositionApply.
function setPositionApply_Callback(hObject, eventdata, handles)
% hObject    handle to setPositionApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% wait for mutex
mutex = evalin('base','mutex');
mutex.acquire();

epos = evalin('base','epos');
angleFactor = evalin('base','angleFactor');
position = floor(str2double(handles.setPosition.String));
if(isnan(position))
	warndlg('Position must be a number');
    mutex.release();
	return;
end
if (~epos.connected)
	warndlg('Not connected to Epos');
    mutex.release();
	return;
end
handles.setPosition.String = num2str(position);
handles.setAngle.String = num2str(position/angleFactor);
if(~epos.setPositionModeSetting(position))
	warndlg('Failed to set position value');
    mutex.release();
	return;
end
mutex.release();



% --- Executes on button press in applyMaxFollowingError.
function applyMaxFollowingError_Callback(hObject, eventdata, handles)
% hObject    handle to applyMaxFollowingError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% wait for mutex
mutex = evalin('base','mutex');
mutex.acquire();

epos = evalin('base','epos');
maxFollowingError = floor(str2double(handles.maxFollowingError.String));
if isnan(maxFollowingError)
	warndlg('Max Following Error must be a number');
    mutex.release();
	return;
end
if (~epos.connected)
	warndlg('Not connected to Epos');
    mutex.release();
	return;
end
handles.maxFollowingError.String = num2str(maxFollowingError);
if(~epos.setMaxFollowingError(maxFollowingError))
	warndlg('Failed to set position value');
    mutex.release();
	return;
end

mutex.release();

% --- Executes during object creation, after setting all properties.
function maxFollowingError_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxFollowingError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in haltButton.
function haltButton_Callback(hObject, eventdata, handles)
% hObject    handle to haltButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% todo

% --- Executes on button press in activateButton.
function activateButton_Callback(hObject, eventdata, handles)
% hObject    handle to activateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% wait for mutex
mutex = evalin('base','mutex');
mutex.acquire();

epos = evalin('base','epos');
if (~epos.connected)
	warndlg('Not connected to Epos');
    mutex.release();
	return;
end
[state, ID, OK] = epos.checkEposState();
if OK
	handles.eposState.String = state;
	if (ID == 7 && handles.activateButton.Value == 1) 
		handles.activateButton.BackgroundColor = [0.906 0.906 0.906];
		handles.activateButton.String = 'Activate';
		handles.activateButton.Value = 0;
		if(~epos.changeEposState('disable operation'))
			warndlg('Failed to change Epos state');
            mutex.release();
			return;
		end
		handles.eposState.String = 'disable operation';
        mutex.release();
		return;
	end
else
	warndlg('Failed to change Epos state');
    mutex.release();
	return;
end

if(~epos.changeEposState('shutdown'))
	warndlg('Failed to change Epos state');
    mutex.release();
	return;
end
if(~epos.changeEposState('switch on'))
	warndlg('Failed to change Epos state');
    mutex.release();
	return;
end
if(~epos.changeEposState('enable operation'))
	warndlg('Failed to change Epos state');
    mutex.release();
	return;
end
[state, ID, OK] = epos.checkEposState();

if OK
	handles.eposState.String = state;
	if ID == 7
		handles.activateButton.BackgroundColor = 'green';
		handles.activateButton.String = 'Disable';
	end
else
	warndlg('Failed to change Epos state');
    mutex.release();
	return;
end
mutex.release();



% --- Executes on button press in positionEnable.
function positionEnable_Callback(hObject, eventdata, handles)
% hObject    handle to positionEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% wait for mutex
mutex = evalin('base','mutex');
mutex.acquire();

epos = evalin('base','epos');
if (~epos.connected)
	warndlg('Not connected to Epos');
    mutex.release();
	return;
end
[opMode, OK] = epos.readOpMode();
if OK
	if opMode == -1
		handles.positionEnable.Background = 'green';
		handles.positionEnable.Value = 1;
		handles.positionEnable.Enable = 'inactive';
	else
		OK = epos.setOpMode(-1);
		if (~OK)
			warndlg('Failed to set Current Mode');
            mutex.release();
			return;
		end
		handles.positionEnable.Background = 'green';
		handles.positionEnable.Value = 1;
		handles.positionEnable.Enable = 'inactive';
	end
else
	warndlg('Failed to read Operation Mode');
end
mutex.release();

% --- Executes on button press in faultReset.
function faultReset_Callback(hObject, eventdata, handles)
% hObject    handle to faultReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% wait for mutex
mutex = evalin('base','mutex');
mutex.acquire();

epos = evalin('base','epos');
if (~epos.connected)
	warndlg('Not connected to Epos');
    mutex.release();
	return;
end
if(~epos.changeEposState('fault reset'))
	warndlg('Failed to change Epos state');
    mutex.release();
	return;
end
mutex.release();

% --- Executes on button press in shutdownButton.
function shutdownButton_Callback(hObject, eventdata, handles)
% hObject    handle to shutdownButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% wait for mutex
mutex = evalin('base','mutex');
mutex.acquire();

epos = evalin('base','epos');
if (~epos.connected)
	warndlg('Not connected to Epos');
    mutex.release();
	return;
end
if(~epos.changeEposState('shutdown'))
	warndlg('Failed to change Epos state');
    mutex.release();
	return;
end
mutex.release();

% --- Executes during object creation, after setting all properties.
function pGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function iGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function dGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in applyGains.
function applyGains_Callback(hObject, eventdata, handles)
% hObject    handle to applyGains (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% wait for mutex
mutex = evalin('base','mutex');
mutex.acquire();

epos = evalin('base','epos');
dGain= str2double(get(handles.dGain, 'String'));
iGain= str2double(get(handles.iGain, 'String'));
pGain = str2double(get(handles.pGain, 'String'));
if(isnan(dGain))
	warndlg('dGain must be a Number');
    mutex.release();
	return;

elseif(isnan(iGain))
	warndlg('iGain must be a Number');
    mutex.release();
	return;
elseif(isnan(pGain))
	warndlg('pGain must be a Number');
    mutex.release();
	return;
end
if(~epos.connected)
	warndlg('Not connected to Epos');
    mutex.release();
	return;
end
OK = epos.setPositionControlParam(pGain, iGain, dGain, 0, 0);
if(~OK)
	warndlg('Failed to set Position Control Parameters');
    mutex.release();
	return;
end
mutex.release();

% --- Executes on button press in connectButton.
function connectButton_Callback(hObject, eventdata, handles)
% hObject    handle to connectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of connectButton

mutex = evalin('base','mutex');
mutex.acquire();

epos = evalin('base','epos');
port_string = get(handles.portName, 'String');
if epos.connected == false
	OK = epos.begin(port_string);
	if OK
		set(handles.portName, 'Enable', 'inactive');
		set(handles.connectButton, 'String','Disconnect');
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
			handles.maxCurrent.String = num2str(motorConfig.currentLimit);
			handles.polePair.String = num2str(motorConfig.polePairNumber);
			handles.maxSpeed.String = num2str(motorConfig.maximumSpeed);
		else
			warndlg('Failed to read Motor Config from Epos');
            mutex.release();
			return;
		end
		% get sensor specs
		[sensorConfig, OK] = epos.readSensorConfig();
		if OK
			% update fields
			handles.pulseNumber.String = num2str(sensorConfig.pulseNumber);
			switch sensorConfig.sensorType
				case 'Incremental Encoder with index (3-channel)'
					handles.sensorType.Value = 1;
				case 'Incremental Encoder without index (2-channel)'
					handles.sensorType.Value = 2;
				case 'Hall sensors'
					handles.sensorType.Value = 3;
				otherwise
					warndlg('Unexpected value in SensorType');
                    mutex.release();
					return;
			end
			% check polarity
			aux = ~strcmp(sensorConfig.sensorPolarity.encoderSensor, 'normal');
			aux = aux + ~strcmp(sensorConfig.sensorPolarity.hallSensor, 'normal');
			handles.sensorPolarity.Value = aux+1;
		else
			warndlg('Failed to read Sensor Config from Epos');
            mutex.release();
			return;
		end
		% get OpMode
		[opMode, OK] = epos.readOpMode();
		if OK
			if opMode == -1
				handles.positionEnable.BackgroundColor = 'green';
				handles.positionEnable.Value = 1;
				handles.positionEnable.Enable = 'inactive';
				handles.positionEnable.String = 'Position Mode';
			end
		else
			warndlg('Failed to read Operation mode from Epos');
            mutex.release();
			return;
		end
		% get MaxFollowing Error
		[maxFollowingError, OK] = epos.readMaxFollowingError();
		if OK
			handles.maxFollowingError.String = num2str(maxFollowingError);
		else
			warndlg('Failed to read Max Following Error from Epos');
            mutex.release();
			return;
		end
		% get PID gains
		[pidGains, OK] = epos.readPositionControlParam();
		if OK
			handles.pGain.String = num2str(pidGains.pGain);
			handles.iGain.String = num2str(pidGains.iGain);
			handles.dGain.String = num2str(pidGains.dGain);
		else
			warndlg('Failed to read Position control Parameters from Epos');
            mutex.release();
			return;
		end
		% get Epos state
		[state, ID, OK] = epos.checkEposState();
		if OK
			handles.eposState.String = state;
			if ID == 7
				handles.activateButton.BackgroundColor = 'green';
				handles.activateButton.String = 'Disable';
			end
		else
			warndlg('Failed to read State from Epos');
            mutex.release();
			return;
		end
		start(handles.myTimer);
		
		%assignin('base', 'myTimer', handles.myTimer)
	else
		warndlg('Failed to connect to Epos');
        mutex.release();
		return;
	end
else
	epos.disconnect();
	set(handles.portName, 'Enable','on');
	set(handles.connectButton, 'String','Connect');
	handles.positionEnable.BackgroundColor = [0.906 0.906 0.906];
	handles.positionEnable.Value = 0;
	handles.positionEnable.Enable = 'on';
	handles.positionEnable.String = 'Enable Position Mode';
	handles.activateButton.BackgroundColor = [0.906 0.906 0.906];
	handles.activateButton.String = 'Activate';
	stop(handles.myTimer);
end
mutex.release();


% --- Executes during object creation, after setting all properties.
function portName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to portName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sensorSpecsApply.
function sensorSpecsApply_Callback(hObject, eventdata, handles)
% hObject    handle to sensorSpecsApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 mutex = evalin('base','mutex');
 mutex.acquire();
 
 epos = evalin('base','epos');
 
 pulseNumber = str2double(get(handles.pulseNumber, 'String'));
 sensorType = handles.sensorType.Value;
 sensorPolarity = handles.sensorPolarity.Value -1;
 OK = epos.setSensorConfig(pulseNumber,sensorType, sensorPolarity);
 if(~OK)
	 warndlg('Failed to set motor specs');
	 mutex.release();
	 return;
 end
 mutex.release();



% --- Executes during object creation, after setting all properties.
function pulseNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pulseNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function sensorPolarity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensorPolarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function sensorType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensorType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in applyMotorSpecs.
function applyMotorSpecs_Callback(hObject, eventdata, handles)
% hObject    handle to applyMotorSpecs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mutex = evalin('base','mutex');
mutex.acquire();

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
    mutex.release();
	return;
elseif(isnan(maxCurrent))
	warndlg('Max current must be a Number');
    mutex.release();
	return;
elseif(isnan(maxSpeed))
	warndlg( 'Max speed must be a Number');
    mutex.release();
    return;
end
if ~epos.connected
	warndlg('Not connected to Epos');
    mutex.release();
	return;
end
OK = epos.setMotorConfig(motorType,maxCurrent, maxSpeed, polePair);
if(~OK)
	warndlg('Failed to set motor specs');
    mutex.release();
	return;
end
mutex.release();

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

function angleGain_Callback(hObject, eventdata, handles)

% --- Executes on button press in saveConfig.
function saveConfig_Callback(hObject, eventdata, handles)
% hObject    handle to saveConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mutex = evalin('base','mutex');
mutex.acquire();
epos = evalin('base','epos');
if (~epos.connected)
	warndlg('Not connected to Epos');
    mutex.release();
	return;
end
OK = epos.save();
if(~OK)
	warndlg('Failed to save Motor status');
    mutex.release();
	return;
end
mutex.release();


% --- Executes on button press in setAngleApply.
function setAngleApply_Callback(hObject, eventdata, handles)
% hObject    handle to setAngleApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% wait for mutex

mutex = evalin('base','mutex');
angleFactor = evalin('base','angleFactor');
mutex.acquire();

epos = evalin('base','epos');
angle = str2double(handles.setAngle.String);
position = floor(angle*angleFactor);
if(isnan(position))
	warndlg('Position must be a number');
    mutex.release();
	return;
end
if (~epos.connected)
	warndlg('Not connected to Epos');
    mutex.release();
	return;
end
handles.setPosition.String = num2str(position);
handles.setAngle.String = num2str(position/angleFactor);
if(~epos.setPositionModeSetting(position))
	warndlg('Failed to set position value');
    mutex.release();
	return;
end
mutex.release();



% --- Executes during object creation, after setting all properties.
function setAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function angleGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angleGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in angleGain_apply.
function angleGain_apply_Callback(hObject, eventdata, handles)
% hObject    handle to angleGain_apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mutex = evalin('base','mutex');
mutex.acquire();
angleFactor = str2double(handles.angleGain.String);
assignin('base', 'angleFactor', angleFactor);
mutex.release();

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
mutex = evalin('base','mutex');
mutex.acquire();

if  evalin('base', 'exist(''epos'', ''var'') == 1')
	epos = evalin('base','epos');
	epos.disconnect();
	stop(handles.myTimer);
end
mutex.release();
delete(hObject);

function update(obj, event, hObject, eventdata, handles)
mutex = evalin('base','mutex');
angleFactor = evalin('base','angleFactor');
if(mutex.tryAcquire == 0)
	return;
else
	epos = evalin('base','epos');
	%not connected, nothing to update
	if ~epos.connected
		mutex.release();
		return;
	else	 
		[position, OK] = epos.readPositionValue();
		if OK
			handles.currentPosition.String = num2str(position);
			handles.currentAngle.String = num2str(position/angleFactor);
		end
		% get Epos state
		[state, ID, OK] = epos.checkEposState();
		if OK
			handles.eposState.String = state;
		end
		if (ID ~= 7)
			[listErrors, anyError, OK] = epos.checkEposError();
			handles.log.String = char(listErrors);
			handles.activateButton.BackgroundColor = [0.906 0.906 0.906];
			handles.activateButton.String = 'Activate';
			handles.activateButton.Value = 0;
		end
	end
end
mutex.release();


% unused callbacks
function portName_Callback(hObject, eventdata, handles)

function pGain_Callback(hObject, eventdata, handles)

function iGain_Callback(hObject, eventdata, handles)

function dGain_Callback(hObject, eventdata, handles)

function polePair_Callback(hObject, eventdata, handles)

function maxSpeed_Callback(hObject, eventdata, handles)

function motorType_Callback(hObject, eventdata, handles)

function pulseNumber_Callback(hObject, eventdata, handles)

function sensorPolarity_Callback(hObject, eventdata, handles)

function maxFollowingError_Callback(hObject, eventdata, handles)

function setPosition_Callback(hObject, eventdata, handles)

function maxCurrent_Callback(hObject, eventdata, handles)

function sensorType_Callback(hObject, eventdata, handles)

function setAngle_Callback(hObject, eventdata, handles)

