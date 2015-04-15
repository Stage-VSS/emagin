classdef OledStageServer < StageServer
    
    properties (Access = private)
        microdisplayPort
        microdisplay
        background
    end
    
    methods
        
        function obj = OledStageServer(microdisplayPort, serverPort)
            if nargin < 1
                microdisplayPort = 'COM4';
            end
            
            if nargin < 2
                serverPort = 5678;
            end
            
            obj = obj@StageServer(serverPort);
            obj.microdisplayPort = microdisplayPort;
        end
        
    end
    
    methods (Access = protected)
        
        function willStart(obj)
            willStart@StageServer(obj);
            
            monitor = obj.canvas.window.monitor;
            
            obj.microdisplay = OledMicrodisplay(monitor, obj.microdisplayPort);
            obj.microdisplay.connect();
            
            obj.microdisplay.setBrightness(OledBrightness.MIN);            % Add the background to the presentation.
            
            obj.background = Rectangle();
            obj.background.position = obj.canvas.size/2;
            obj.background.size = obj.canvas.size;
            obj.background.color = 0;
            obj.background.init(obj.canvas);
        end
        
        function didStop(obj)
            didStop@StageServer(obj);
            
            obj.microdisplay.disconnect();
        end
        
        function onEventReceived(obj, src, data)
            client = data.client;
            value = data.value;
            
            try
                switch value{1}
                    case OledNetEvents.GET_OLED_BRIGHTNESS
                        obj.onEventGetOledBrightness(client, value);
                    case OledNetEvents.SET_OLED_BRIGHTNESS
                        obj.onEventSetOledBrightness(client, value);
                    otherwise
                        onEventReceived@StageServer(obj, src, data);
                end
            catch x
                client.send(NetEvents.ERROR, x);
            end
        end
        
        function onEventGetOledBrightness(obj, client, value) %#ok<INUSD>
            brightness = obj.microdisplay.getBrightness();
            client.send(NetEvents.OK, brightness);
        end
        
        function onEventSetOledBrightness(obj, client, value)
            brightness = value{2};
            obj.microdisplay.setBrightness(brightness);
            client.send(NetEvents.OK);
        end
        
        function onEventSetCanvasClearColor(obj, client, value)
            color = value{2};
            
            obj.background.color = color;            
            client.send(NetEvents.OK);
        end
        
        function onEventPlay(obj, client, value)
            % Add the background to the presentation.
            presentation = value{2};
            presentation.insertStimulus(1, obj.background);
            
            onEventPlay@StageServer(obj, client, value);
        end
        
    end
    
end