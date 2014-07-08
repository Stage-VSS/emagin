classdef OledStageClient < StageClient
    
    methods
        
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