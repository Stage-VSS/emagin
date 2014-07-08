classdef OledMicrodisplay < handle
    
    properties (Access = private)
        monitor
        serialPort
    end
    
    methods
        
        function obj = OledMicrodisplay(monitor, port)
            if nargin < 2
                port = 'COM4';
            end
            
            obj.monitor = monitor;
            obj.serialPort = serial(port);
        end
        
        function delete(obj)
            obj.disconnect();
        end
        
        function connect(obj)
            fopen(obj.serialPort);
            
            % Test connection.
            fwrite(obj.serialPort, 'T');
            
            [~, ~, msg] = fread(obj.serialPort, 3);
            if ~strcmp(msg, '')
                obj.disconnect();
                error(['Unable to connect: ' msg]);
            end
        end
        
        function disconnect(obj)
            fclose(obj.serialPort);
        end
        
        function setBrightness(obj, brightness)
            fwrite(obj.serialPort, ['U', char(uint8(brightness))]);
        end
        
        function b = getBrightness(obj)
            fwrite(obj.serialPort, 'S');
            
            [data, ~, msg] = fread(obj.serialPort, 4);
            if ~strcmp(msg, '')
                error(msg);
            end
            
            b = data(1);
        end
        
    end
    
end