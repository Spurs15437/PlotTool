classdef mainapp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        GridLayout           matlab.ui.container.GridLayout
        Button_2             matlab.ui.control.Button
        yButton              matlab.ui.control.StateButton
        xButton              matlab.ui.control.StateButton
        TitleEditField       matlab.ui.control.EditField
        TitleEditFieldLabel  matlab.ui.control.Label
        Spinner              matlab.ui.control.Spinner
        Label_2              matlab.ui.control.Label
        yDropDown            matlab.ui.control.DropDown
        yDropDownLabel       matlab.ui.control.Label
        xDropDown            matlab.ui.control.DropDown
        xLabel               matlab.ui.control.Label
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

        % Drop down opening function: yDropDown
        function yDropDownOpening(app, event)
            app.yDropDown.Items = evalin('base','who');
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            app.h = plot(app.UIAxes,app.xdata,app.ydata);
            app.UIAxes.Title.String = app.TitleEditField.Value; 
            app.UIAxes.XLabel.String = app.xDropDown.Value;
            app.UIAxes.YLabel.String = app.yDropDown.Value;
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

        % Callback function
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

        % Value changed function: xButton
        function xButtonValueChanged(app, event)
            value = app.xButton.Value;
            if value == true
                set(app.UIAxes,'XDir','reverse');
            else
                set(app.UIAxes,'XDir','normal');
            end
            
        end

        % Value changed function: yButton
        function yButtonValueChanged(app, event)
            value = app.yButton.Value;
            if value == true
                set(app.UIAxes,'YDir','reverse');
            else
                set(app.UIAxes,'YDir','normal');
            end
        end

        % Button pushed function: Button_2
        function Button_2Pushed(app, event)
            selpath = uigetdir('Examples/','选择你要保存的文件夹');
%             cd(selpath)
            prompt = {'输入文件名:','dpi:'};
            dlgtitle = 'Input';
            dims = [1 35];
            definput = {'plotfig','600'};
            answer = inputdlg(prompt,dlgtitle,dims,definput);
%             assignin('base','answer',answer);
            
            filename = fullfile(selpath,answer{1});
            dpi = str2double(answer{2});
            
            list = {'png','jpg'};
            [index, ~] = listdlg("SelectionMode","single","PromptString",'Please select one',"ListString",list,"ListSize",[150,150],"InitialValue",1,'OKString','Apply');
            
            style = list{index};
%             assignin('base','style',style);
            
            fullfilename = [filename '.' style];
%             assignin('base',"fullfilename",fullfilename)
%             print(app.UIFigure, fullfilename,['-r' answer{2}], ['-d' style]);
            exportgraphics(app.UIAxes,fullfilename,"Resolution",dpi)
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
            app.UIAxes.Box = 'on';
            app.UIAxes.Layout.Row = [1 9];
            app.UIAxes.Layout.Column = [1 4];

            % Create Button
            app.Button = uibutton(app.GridLayout, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Layout.Row = 7;
            app.Button.Layout.Column = 5;
            app.Button.Text = '绘图';

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

            % Create Label_2
            app.Label_2 = uilabel(app.GridLayout);
            app.Label_2.HorizontalAlignment = 'right';
            app.Label_2.Layout.Row = 6;
            app.Label_2.Layout.Column = 5;
            app.Label_2.Text = '线的粗细';

            % Create Spinner
            app.Spinner = uispinner(app.GridLayout);
            app.Spinner.Step = 0.1;
            app.Spinner.Limits = [0.1 Inf];
            app.Spinner.ValueChangedFcn = createCallbackFcn(app, @SpinnerValueChanged, true);
            app.Spinner.Layout.Row = 6;
            app.Spinner.Layout.Column = 6;
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

            % Create xButton
            app.xButton = uibutton(app.GridLayout, 'state');
            app.xButton.ValueChangedFcn = createCallbackFcn(app, @xButtonValueChanged, true);
            app.xButton.Text = '反转x轴';
            app.xButton.Layout.Row = 8;
            app.xButton.Layout.Column = 5;

            % Create yButton
            app.yButton = uibutton(app.GridLayout, 'state');
            app.yButton.ValueChangedFcn = createCallbackFcn(app, @yButtonValueChanged, true);
            app.yButton.Text = '反转y轴';
            app.yButton.Layout.Row = 8;
            app.yButton.Layout.Column = 6;

            % Create Button_2
            app.Button_2 = uibutton(app.GridLayout, 'push');
            app.Button_2.ButtonPushedFcn = createCallbackFcn(app, @Button_2Pushed, true);
            app.Button_2.Layout.Row = 7;
            app.Button_2.Layout.Column = 6;
            app.Button_2.Text = '导出';

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