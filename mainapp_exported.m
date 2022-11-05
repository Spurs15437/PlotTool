classdef mainapp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        GridLayout           matlab.ui.container.GridLayout
        TitleEditField       matlab.ui.control.EditField
        TitleEditFieldLabel  matlab.ui.control.Label
        Spinner              matlab.ui.control.Spinner
        Label_2              matlab.ui.control.Label
        Knob                 matlab.ui.control.Knob
        Label                matlab.ui.control.Label
        yDropDown            matlab.ui.control.DropDown
        yDropDownLabel       matlab.ui.control.Label
        xDropDown            matlab.ui.control.DropDown
        xLabel               matlab.ui.control.Label
        Button3              matlab.ui.control.Button
        Button2              matlab.ui.control.Button
        Button               matlab.ui.control.Button
        UIAxes               matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        xdata
        ydata
        h % Description
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Drop down opening function: xDropDown
        function xDropDownOpening(app, event)
%             baseverb = who;
%             [m,~] = size(baseverb);
%             for i=1:1:m
%                 app.xDropDown.Items = 
%             end
            app.xDropDown.Items = evalin('base','who'); 
            
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            app.h = plot(app.UIAxes,app.xdata,app.ydata);
            app.UIAxes.Title.String = app.TitleEditField.Value; 
            app.UIAxes.XLabel.String = app.xDropDown.Value;
            app.UIAxes.YLabel.String = app.yDropDown.Value;
        end

        % Drop down opening function: yDropDown
        function yDropDownOpening(app, event)
            app.yDropDown.Items = evalin('base','who');
        end

        % Value changed function: xDropDown
        function xDropDownValueChanged(app, event)
%             var = ;
            app.xdata = evalin('base',app.xDropDown.Value);
%             assignin('base', 'value', value);
        end

        % Value changed function: yDropDown
        function yDropDownValueChanged(app, event)
            app.ydata = evalin('base',app.yDropDown.Value);            
        end

        % Value changed function: Knob
        function KnobValueChanged(app, event)
            value = app.Knob.Value;
            set(app.h, 'lineWidth',value)
        end

        % Value changed function: Spinner
        function SpinnerValueChanged(app, event)
            value = app.Spinner.Value;
            set(app.h, 'lineWidth',value)
        end

        % Value changed function: TitleEditField
        function TitleEditFieldValueChanged(app, event)
            value = app.TitleEditField.Value;
%             assignin('base',"value",value)
%             title(app.h,"value")
            app.UIAxes.Title.String = value;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 712 525];
            app.UIFigure.Name = 'MATLAB App';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create UIAxes
            app.UIAxes = uiaxes(app.GridLayout);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Layout.Row = [1 9];
            app.UIAxes.Layout.Column = [1 4];

            % Create Button
            app.Button = uibutton(app.GridLayout, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Layout.Row = 11;
            app.Button.Layout.Column = 2;
            app.Button.Text = '绘图';

            % Create Button2
            app.Button2 = uibutton(app.GridLayout, 'push');
            app.Button2.Layout.Row = 11;
            app.Button2.Layout.Column = 3;
            app.Button2.Text = 'Button2';

            % Create Button3
            app.Button3 = uibutton(app.GridLayout, 'push');
            app.Button3.Layout.Row = 11;
            app.Button3.Layout.Column = 4;
            app.Button3.Text = 'Button3';

            % Create xLabel
            app.xLabel = uilabel(app.GridLayout);
            app.xLabel.HorizontalAlignment = 'center';
            app.xLabel.WordWrap = 'on';
            app.xLabel.Layout.Row = 2;
            app.xLabel.Layout.Column = 5;
            app.xLabel.Text = 'x轴数据';

            % Create xDropDown
            app.xDropDown = uidropdown(app.GridLayout);
            app.xDropDown.DropDownOpeningFcn = createCallbackFcn(app, @xDropDownOpening, true);
            app.xDropDown.ValueChangedFcn = createCallbackFcn(app, @xDropDownValueChanged, true);
            app.xDropDown.Layout.Row = 2;
            app.xDropDown.Layout.Column = 6;

            % Create yDropDownLabel
            app.yDropDownLabel = uilabel(app.GridLayout);
            app.yDropDownLabel.HorizontalAlignment = 'center';
            app.yDropDownLabel.WordWrap = 'on';
            app.yDropDownLabel.Layout.Row = 3;
            app.yDropDownLabel.Layout.Column = 5;
            app.yDropDownLabel.Text = 'y轴数据';

            % Create yDropDown
            app.yDropDown = uidropdown(app.GridLayout);
            app.yDropDown.DropDownOpeningFcn = createCallbackFcn(app, @yDropDownOpening, true);
            app.yDropDown.ValueChangedFcn = createCallbackFcn(app, @yDropDownValueChanged, true);
            app.yDropDown.Layout.Row = 3;
            app.yDropDown.Layout.Column = 6;

            % Create Label
            app.Label = uilabel(app.GridLayout);
            app.Label.HorizontalAlignment = 'center';
            app.Label.Layout.Row = 8;
            app.Label.Layout.Column = 5;
            app.Label.Text = '线的粗细';

            % Create Knob
            app.Knob = uiknob(app.GridLayout, 'continuous');
            app.Knob.Limits = [1 3];
            app.Knob.ValueChangedFcn = createCallbackFcn(app, @KnobValueChanged, true);
            app.Knob.Layout.Row = [4 9];
            app.Knob.Layout.Column = 5;
            app.Knob.Value = 1;

            % Create Label_2
            app.Label_2 = uilabel(app.GridLayout);
            app.Label_2.HorizontalAlignment = 'right';
            app.Label_2.Layout.Row = 6;
            app.Label_2.Layout.Column = 6;
            app.Label_2.Text = '线的粗细';

            % Create Spinner
            app.Spinner = uispinner(app.GridLayout);
            app.Spinner.Step = 0.1;
            app.Spinner.Limits = [0.1 Inf];
            app.Spinner.ValueChangedFcn = createCallbackFcn(app, @SpinnerValueChanged, true);
            app.Spinner.Layout.Row = 6;
            app.Spinner.Layout.Column = 7;
            app.Spinner.Value = 1;

            % Create TitleEditFieldLabel
            app.TitleEditFieldLabel = uilabel(app.GridLayout);
            app.TitleEditFieldLabel.HorizontalAlignment = 'center';
            app.TitleEditFieldLabel.Layout.Row = 4;
            app.TitleEditFieldLabel.Layout.Column = 5;
            app.TitleEditFieldLabel.Text = 'Title';

            % Create TitleEditField
            app.TitleEditField = uieditfield(app.GridLayout, 'text');
            app.TitleEditField.ValueChangedFcn = createCallbackFcn(app, @TitleEditFieldValueChanged, true);
            app.TitleEditField.Layout.Row = 4;
            app.TitleEditField.Layout.Column = 6;
            app.TitleEditField.Value = 'Title';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = mainapp_exported

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