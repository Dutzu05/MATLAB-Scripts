classdef DCMRun
    methods (Static)
        function [vel, alpha, t] = run(u, varargin)
            Ts = 1e-3;
            port = 'COM1'; % Default fallback port
            
            % 1. Manually extract the port if the argument count is odd
            if mod(length(varargin), 2) ~= 0
                port = varargin{1}; % Grab 'COM6'
                varargin(1) = [];   % Delete it from the list so the parser doesn't see it
            end
            
            p = inputParser;
            p.KeepUnmatched = true; 
            
            % 2. Only parse the remaining Name-Value pairs
            addParameter(p, 'Ts', Ts);
            parse(p, varargin{:});
            
            Ts = p.Results.Ts;
            t = (0:Ts:(numel(u)-1)*Ts).';
            vel = zeros(size(t));
            alpha = zeros(size(t));
            
            % Placeholder integration
            for k = 2:numel(t)
                vel(k) = vel(k-1) + u(k-1)*Ts;
            end
        end
    end
end