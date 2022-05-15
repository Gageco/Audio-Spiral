classdef AudioSpiral_Full < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure           matlab.ui.Figure
        AudioSpiralLabel   matlab.ui.control.Label
        ChooseFileButton   matlab.ui.control.Button
        TimeShift          matlab.ui.control.Slider
        TimeShiftLabel     matlab.ui.control.Label
        CenRad             matlab.ui.control.Slider
        CenterRadiusLabel  matlab.ui.control.Label
        PlotButton         matlab.ui.control.Button
        Ang                matlab.ui.control.Slider
        SpiralLabel        matlab.ui.control.Label
        Mag                matlab.ui.control.Slider
        MagnitudeLabel     matlab.ui.control.Label
        UIAxes             matlab.ui.control.UIAxes
    end

    
    properties (Access = public)
        Path % File Path
        File % File Name
    end
    
    methods (Access = private)
        
        function [y1, fs] = audio_spiral(app)


angle = 0:0.01:app.Ang.Value*pi;

len = length(angle);
radius = zeros(1, len);

[y1,fs] = audioread(append(app.Path, app.File));

y1 = y1(1+app.TimeShift.Value:len+app.TimeShift.Value);

rad_plot = rot90(abs(y1))*app.Mag.Value;
a = 1;
for i = 1:length(radius)
    if (angle(i) < app.CenRad.Value) 
        radius(i) = angle(a) + rad_plot(a);
        
    else
        a = i;
        radius(i) = angle(i) + rad_plot(i);
    end
end
plot(app.UIAxes, radius.*cos(angle), radius.*sin(angle));
end

%Made by Gage Coprivnicar
%Updated May 15, 2022
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Callback function: Ang, CenRad, Mag, PlotButton, TimeShift
        function PlotButtonPushed(app, event)
            audio_spiral(app);
        end

        % Button pushed function: ChooseFileButton
        function ChooseFileButtonPushed(app, event)
            [app.File, app.Path] = uigetfile({'*.*'});
        end

        % Callback function
        function SavePlotButtonPushed(app, event)

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 655 346];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.PlotBoxAspectRatio = [1 1 1];
            app.UIAxes.XColor = 'none';
            app.UIAxes.YColor = 'none';
            app.UIAxes.LineWidth = 0.01;
            app.UIAxes.Position = [269 1 387 346];

            % Create MagnitudeLabel
            app.MagnitudeLabel = uilabel(app.UIFigure);
            app.MagnitudeLabel.HorizontalAlignment = 'right';
            app.MagnitudeLabel.Position = [0 286 63 22];
            app.MagnitudeLabel.Text = 'Magnitude';

            % Create Mag
            app.Mag = uislider(app.UIFigure);
            app.Mag.Limits = [1 1001];
            app.Mag.ValueChangedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.Mag.Position = [84 295 172 7];
            app.Mag.Value = 1;

            % Create SpiralLabel
            app.SpiralLabel = uilabel(app.UIFigure);
            app.SpiralLabel.HorizontalAlignment = 'right';
            app.SpiralLabel.Position = [25 227 42 22];
            app.SpiralLabel.Text = 'Spiral';

            % Create Ang
            app.Ang = uislider(app.UIFigure);
            app.Ang.Limits = [1 1001];
            app.Ang.ValueChangedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.Ang.Position = [84 236 172 7];
            app.Ang.Value = 1;

            % Create PlotButton
            app.PlotButton = uibutton(app.UIFigure, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.Position = [173 46 97 22];
            app.PlotButton.Text = 'Plot';

            % Create CenterRadiusLabel
            app.CenterRadiusLabel = uilabel(app.UIFigure);
            app.CenterRadiusLabel.HorizontalAlignment = 'right';
            app.CenterRadiusLabel.Position = [23 166 43 28];
            app.CenterRadiusLabel.Text = {'Center'; 'Radius'};

            % Create CenRad
            app.CenRad = uislider(app.UIFigure);
            app.CenRad.Limits = [1 1001];
            app.CenRad.ValueChangedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.CenRad.Position = [87 181 169 7];
            app.CenRad.Value = 1;

            % Create TimeShiftLabel
            app.TimeShiftLabel = uilabel(app.UIFigure);
            app.TimeShiftLabel.HorizontalAlignment = 'right';
            app.TimeShiftLabel.Position = [23 102 42 28];
            app.TimeShiftLabel.Text = {'Time'; 'Shift'};

            % Create TimeShift
            app.TimeShift = uislider(app.UIFigure);
            app.TimeShift.Limits = [1 1001];
            app.TimeShift.ValueChangedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.TimeShift.Position = [86 117 170 7];
            app.TimeShift.Value = 1;

            % Create ChooseFileButton
            app.ChooseFileButton = uibutton(app.UIFigure, 'push');
            app.ChooseFileButton.ButtonPushedFcn = createCallbackFcn(app, @ChooseFileButtonPushed, true);
            app.ChooseFileButton.Position = [48 46 86 22];
            app.ChooseFileButton.Text = 'Choose File';

            % Create AudioSpiralLabel
            app.AudioSpiralLabel = uilabel(app.UIFigure);
            app.AudioSpiralLabel.HorizontalAlignment = 'center';
            app.AudioSpiralLabel.FontWeight = 'bold';
            app.AudioSpiralLabel.Position = [116 315 75 22];
            app.AudioSpiralLabel.Text = 'Audio Spiral';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = AudioSpiral_Full

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end