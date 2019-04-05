%% biosignalsplux Example Code
%  GENERAL INFORMATION
%  The following example shows how to use the biosignalsplux Python API in
%  MATLAB to acquire data using biosignalsplux devices. 
%
%  This examples comes with the standard API (plux.pyd) and an example 
%  Python script (biosignalsplux.py) which contains some sample code that 
%  overrides a standard callback (onRawFrame) to print the acquired data in
%  the Command Window during the acquisition and to store this data in a
%  container that is reachable within MATLAB. 
%
%  The example can, of course, be adjusted to the requirements of the user,
%  which is recommended to take the most out of the available API.

%% Clear everything (remove if needed)
clc;
clear classes;
clear all;

%% Importing all necessary Python modules (safe way)
% Add plux.pyd and biosignalsplux.py into your project folder and add
% everything to the Python search path
if count(py.sys.path, '') == 0
    insert(py.sys.path, int32(0), '');
end

% Reload modules in case some changes have been made to the biosignalsplux
% Python file
py.reload(py.importlib.import_module('biosignalsplux'));

%% Prepare acquisition
%Find connected Devices
py.plux.BaseDev.findDevices( )

% Set the device's MAC-address & create an object of the biosignalsplux
% class
mac_address = 'BTH00:07:80:4D:2F:12';
dev = py.biosignalsplux.biosignalsplux(mac_address);

% Set the sampling rate in Hz (here: 1000Hz)
sampling_rate = int16(1000);

% Set the sampling resolution in bit (here: 16-bit)
sampling_resolution = int8(16);

% Select the active and inactive acquisition channels (here: only ch. 1)
% 0 = inactive; 1 = active; MSB = ch. 8; LSB = ch. 1
acq_channels = '00000001';

% NOTE: If using the biosignalsplux.py example, you can pass the binary
% configuration in a string. If you want to use the regular PLUX API or
% your own callback overrides, use the following line instead.
% acq_channels = int8(bin2dec('0000001'));

% Set acquisition duration (here: 10s)
acq_duration = 10000;

%% Acquisitions
% Start acquisition
disp('Starting acquisitionn...');
dev.startAcquisition(sampling_rate, acq_channels, sampling_resolution, acq_duration);

% Let the device go through the acquisition
disp('Acquiring signals...');
signal = dev.loop();

% Stop acquisition & close the device
disp('Stopping acquisition...');
dev.stop();
dev.close();

%% Unrwap the acquired sensor data (here: for channel 1)
% Get the single channel sensor data and store it in a MATLAB array
% NOTE: Using Python lists in arrays requires a couple of conversion, as
% indexing multi-dimensional arrays might cause issues

% Get all sensor data & prepare a container
acq_data = cell(dev.frames);
channel1_data = [];

% Go through all available samples & extract the data of the first channel
for i = 1:length(acq_data)
    % Convert into MATLAB cells & select channel 1 data
    channel1_data = [channel1_data, cell(acq_data{1, i})];
end

% Convert into a MATLAB array
channel1_data = cellfun(@double, channel1_data);

%% Plot the acquires sensor data
% Create time vector
t = 0:(1/double(sampling_rate)):((length(channel1_data)-1)/double(sampling_rate));

% Plot the acquired data
plot(t, channel1_data);
xlabel('Time [s]');
ylabel('Raw Sensor Data [-]');