classdef OledStageClient < StageClient
    
    methods
        
        % Gets the remote OLED brightness.
        function brightness = getOledBrightness(obj)
            obj.sendEvent(OledNetEvents.GET_OLED_BRIGHTNESS);
            brightness = obj.getResponse();
        end
        
        % Sets the remote OLED brightness.
        function setOledBrightness(obj, brightness)
            obj.sendEvent(OledNetEvents.SET_OLED_BRIGHTNESS, brightness);
            obj.getResponse();
        end
        
    end
    
end