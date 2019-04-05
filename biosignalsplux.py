"""
biosignalsplux Sample Script for MATLAB Use

GENERAL INFORMATION
The following example shows how to use the create a custom biosignalsplux class that inherits from the plux.SignalsDev class of the
Python API and creates or modifies some functionatilities in order to facilitate the use of the API in MATLAB.

"""
import plux

class biosignalsplux(plux.SignalsDev):
    def __init__(self, plux_class):
        # Inherit from parent class plux.SignalsDev
        plux.SignalsDev.__init__(self)

        # Add some data containers to store important acquisition data/parameters
        self.seq_number = []                 # Sequence number
        self.frames = []                    # Frames containing channel samples
        self.acquisition_duration = 5000    # Acquisition duration in ms (default: 5000ms)

    # Callback override
    def onRawFrame(self, nSeq, data):
        """This callback is called by message loop when a real-time data acquisition frame is received from the device.

        Here:   Checks if the acquisition duration has been exceeded.
                - If yes:   Returns True and stops the acquisition loop.
                - If no:    Prints and stores the received frames, and returns False to continue the acquisition loop.
                
        """
        # Check if the acquisition duration has been surpassed
        if nSeq >= self.acquisition_duration: 
            # If yes, stop the acquisition loop
            return True
        else:
            # If no, print the sequence number & samples (just to visualize that it works)
            print(nSeq, data)

            # Store the sequence number & the frames
            self.seq_number.append(nSeq)
            self.frames.append(list(data))
            return False

    def startAcquisition(self, sampling_rate=1000, acq_channels='00000001', sampling_resolution=16, acq_duration=5000):
        """Sets the acquisition duration and callse the plux.SignalsDev.start() method to start the acquisition

        Parameters:
        -----------
        sampling_rate : int
            Sampling rate in Hz (default: 1000Hz).
        acq_channels : str
            String with 8-digit binary code to set active/inactive channels (default: '00000001')
            0 = inactive; 1 = active; MSB = ch. 8; LSB = ch. 1
        sampling_resolution : int
            Sampling resolution in bits (8 or 16; default: 16-bit)
        acq_duration : int
            Acquisition duration in ms (default: 5000ms)

        """
        # Set the acquisition duration
        self.acquisition_duration = acq_duration

        # Start the acquisition using the normal biosignalsplux API function
        self.start(sampling_rate, int(hex(int(acq_channels, 2)), 16), sampling_resolution);
