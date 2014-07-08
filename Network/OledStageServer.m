classdef OledStageServer < StageServer
    
    properties (Access = private)
        microdisplay
    end
    
    methods
        
        function obj = OledStageServer(port)
            if nargin < 1
                port = 5678;
            end
            
            obj = obj@StageServer(port);
        end
        
    end
    
    methods (Access = protected)
        
        function prepareToStart(obj, varargin)
            prepareToStart@StageServer(obj, varargin{:});
            
            obj.microdisplay = OledMicrodisplay();
            obj.microdisplay.connect();
            
            obj.microdisplay.setBrightness(OledBrightness.MIN);
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
        
    end
    
end