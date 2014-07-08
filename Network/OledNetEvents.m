classdef OledNetEvents
    
    properties (Constant)
        %% Client to server:
        % Requests the current OLED brightness.
        GET_OLED_BRIGHTNESS = 'GET_OLED_BRIGHTNESS'
        
        % Requests a new OLED brightness.
        SET_OLED_BRIGHTNESS = 'SET_OLED_BRIGHTNESS'
    end
    
end