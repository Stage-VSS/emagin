classdef OledStageClient < StageClient
    
    methods
        
        function obj = OledStageClient(stageClient)
            if nargin < 1
                stageClient = [];
            end
            obj = obj@StageClient(stageClient);
        end
        
        % Gets the remote OLED brightness.
        function b = getOledBrightness(obj)
            obj.sendEvent(OledNetEvents.GET_OLED_BRIGHTNESS);
            b = obj.getResponse();
        end
        
        % Sets the remote OLED brightness.
        function setOledBrightness(obj, brightness)
            obj.sendEvent(OledNetEvents.SET_OLED_BRIGHTNESS, brightness);
            obj.getResponse();
        end
        
    end
    
end