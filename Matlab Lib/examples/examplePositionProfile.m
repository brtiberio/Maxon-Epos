
clc;
close all;
addpath('..');
%{ 
configure epos for maxon EC 90 motor and apply profile position mode.
MILE Motor default values:

pulses per turn: 2048
Number of poles: 12
max speed: 5000 rpm

max current : 	2.27 A @ 48V

Type: EC sinus commuted (10)
%}
motorType = 10;
polePair = 12;
maxSpeed = 5000;
maxCurrent = 2000;
 
pulseNumber = 2048;
sensorType = 2;
sensorPolarity = 0;

% create epos object
epos = Epos();
if(~epos.begin('/dev/ttyUSB0'))
	return;
end
% set motor parameters
if(~epos.setMotorConfig(motorType,maxCurrent, maxSpeed, polePair))
	return
end

% set sensor config
if(~epos.setSensorConfig(pulseNumber, sensorType, sensorPolarity))
	return;
end
% set operation mode
if(~epos.setOpMode(1))
	return;
end
% need reset?
[state, ID, OK] = epos.checkEposState();
if OK
	if (ID == 11)
		OK = epos.changeEposState('fault reset');
	end
end

% configure Position profile parameters
maxFollowingError = 2000;
minPos = -2048*4*3; %3 turn
maxPos = 2048*4*3;
maxProfileVelocity = maxSpeed;
profileVelocity = 100;
profileAcceleration = 1;
profileDeceleration = 1;
quickstopDeceleration = 10;
motionProfileType = 1; % sinusoidal
if(~epos.setPositionProfileConfig(maxFollowingError, minPos, maxPos,...
		maxProfileVelocity, profileVelocity, profileAcceleration, profileDeceleration,...
		quickstopDeceleration, motionProfileType))
	return;
end

% Enable device
if(~epos.changeEposState('shutdown'))
	return;
end
if(~epos.changeEposState('enable operation'))
	return;
end

% set Target Position to -1 turn
if(~epos.setTargetPosition(-2048*4))
	return;
end

% enable operation and go
if(~epos.setPositioningControlOptions(0, 0, 1))
	return;
end

epos.disconnect();
delete(epos);







