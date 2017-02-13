% clear all;
clc;
close all;
opMode = -3; %current Mode
maxCurrent = 2200;
maxSpeed = 15000;
polePair = 12;
% 1 for DC, 10 for EC sine commuted, 11 for EC trapzoidal commuted 
motorType = 10;
addpath('..');
epos = Epos();
if(~epos.begin('/dev/ttyUSB0'))
	return;
end
format short;

[state, ID, OK] = epos.checkEposState();
if OK
	if (ID == 11)
		OK = epos.changeEposState('fault reset');
	end
end
epos.printStatusWord;
% set operation mode
if(~epos.setOpMode(opMode))
	return;
end

% % set motor parameters
% if(~epos.setMotorConfig(1,maxCurrent, maxSpeed, polePair))
% 	return
% end

% Enable device
if(~epos.changeEposState('shutdown'))
	return;
end
if(~epos.changeEposState('switch on'))
	return;
end
% epos.printStatusWord;
if(~epos.changeEposState('enable operation'))
	return;
end
% epos.printStatusWord;
% set current value
current = 700;
epos.setCurrentModeSetting(current);
% fig1 = bar(0);
% ylim([0 maxCurrent]);
% updateFunction = @(epos,fig1) (set(fig1,'YData',epos.readCurrentValueAveraged));
% timer1 = timer('ExecutionMode', 'fixedRate', 'Period', 0.2, 'TimerFcn', updateFunction);
waitfor(warndlg('Input value of current or "exit" to stop...'));
epos.setCurrentModeSetting(0);
epos.disconnect();