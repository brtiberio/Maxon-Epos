% clear all;
clc;
close all;
opMode = -3; %current Mode

%motor options

maxCurrent = 1000;
maxSpeed = 5000;
polePair = 1; 
motorType = 1; % 1 for DC, 10 for EC sine commuted, 11 for EC trapzoidal commuted

%sensor options
pulseNumber = 500;
sensorType = 2;
sensorPolarity = 0;

addpath('..');
if(~exist('epos','var'))
	epos = Epos();
end
if(~epos.begin('/dev/ttyUSB0'))
	return;
end
[state, ID, OK] = epos.checkEposState();
if OK
	if (ID == 11)
		OK = epos.changeEposState('fault reset');
	end
end

% set motor parameters
if(~epos.setMotorConfig(1,maxCurrent, maxSpeed, polePair))
	return
end

% set sensor config
if(~epos.setSensorConfig(pulseNumber, sensorType, sensorPolarity))
	return;
end
epos.checkEposError();
%%
% set operation mode
if(~epos.setOpMode(opMode))
	return;
end

% Enable device
if(~epos.changeEposState('shutdown'))
	return;
end
if(~epos.changeEposState('enable operation'))
	return;
end
% set current value
current = 0;
epos.setCurrentModeSetting(current);
%%
% fig1 = bar(0);
% ylim([0 maxCurrent]);
% updateFunction = @(epos,fig1) (set(fig1,'YData',epos.readCurrentValueAveraged));
% timer1 = timer('ExecutionMode', 'fixedRate', 'Period', 0.2, 'TimerFcn', updateFunction);
waitfor(warndlg('Input value of current or "exit" to stop...'));
% start(timer1);
while 1
	current = input('Change value of current [mA]:', 's');
	if strcmp(current,'exit')
		current = 0;
% 		stop(timer1);
		break;
	end
	current = str2double(current);
	if isnan(current)
		fprintf('Invalid option\n');
	else
		if(current <0 )
			current = 0;
		elseif current > maxCurrent
			current = maxCurrent;
		end
		current = floor(current); % only ints!
		epos.setCurrentModeSetting(current);
	end
end
epos.setCurrentModeSetting(0);
epos.disconnect();






