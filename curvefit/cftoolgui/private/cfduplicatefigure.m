function cfduplicatefigure( cffig )
%CFDUPLICATEFIGURE Make a duplicate, editable copy of the curve fitting figure
%
%   CFDUPLICATEFIGURE(CFFIG)
%
%   The datasets get plotted in order they are in the database. The fits
%   get plotted just after the dataset they fit and then in the order
%   they are in the database. The residuals get plotted in the order of
%   the fits in the database.

%   Copyright 2000-2007 The MathWorks, Inc.
%   $Revision: 1.1.6.1.2.1 $    $Date: 2007/01/26 09:50:40 $ 

% Properties of the various lines need to copied from CFTOOL to the new
% figure. These four cell arrays capture the names of those properties
% for the four classes of line in CFTOOL.
DATA_LINE_PROPERTIES     = {'Color', 'Marker', 'LineStyle', 'LineWidth', 'MarkerSize'};
FIT_LINE_PROPERTIES      = {'Color', 'LineStyle', 'LineWidth'};
BOUND_LINE_PROPERTIES    = {'Color'};
RESIDUAL_LINE_PROPERTIES = {'Color', 'LineStyle'};

% We're going to plot the data and fits from what's in the databases.
% Hence we need to get hold of those databases.
dsdb = getdsdb;
fitdb = getfitdb;

% Indents for the main legend
% -- The fits get indented if there are two or more datasets
% -- The bounds get indented (from the fits) if there are two or more
% fits
FIT_INDENT = iWorkOutIndent( dsdb );
BOUND_INDENT = [FIT_INDENT, iWorkOutIndent( fitdb )];

% We need to ensure that the appropriate properties of the axes we're
% about to create agree with those in CFTOOL. Hence we need to get the
% handles to those axes
hCftoolMainAxes = findall( cffig, 'Type', 'axes', 'Tag', 'main' );
hCftoolResidaulAxes = findall( cffig, 'Type', 'axes', 'Tag', 'resid' );
if numel( hCftoolMainAxes ) ~= 1
    % If we hit this case then CFTOOL has got itself into some funny
    % state.
    errordlg( ...
        'There should be exactly one axes for CFTOOL but there is either none or more than one.', ...
        'Error Printing to Figure', 'modal' );
    return
end

% Get some status infomation from CFTOOL
isShowLegend = isequal( cfgetset( 'showlegend' ), 'on' );
residualType = cfgetset( 'residptype' );
isShowResiduals = ~strcmpi( residualType, 'none' );

% If we're showing the residual then we need to check that the we have
% the residual axes from CFTOOL
if isShowResiduals && numel( hCftoolResidaulAxes ) ~= 1
    % If we hit this case then CFTOOL has got itself into some funny
    % state.
    errordlg( ...
        'There should be exactly one residual axes for CFTOOL but there is either none or more than one.', ...
        'Error Printing to Figure', 'modal' );
    return
end

% Setup new figure and axes
hFigure = figure( 'Visible', 'off' );
iSetFigurePosition( hFigure, cffig );
AXES_PROPERTIES = {
    'Parent', hFigure, 'NextPlot', 'Add', 'Box', 'On', ...
    'XGrid', cfgetset( 'showgrid' ), 'YGrid', cfgetset( 'showgrid' ), ...
    'Units', 'Normalized'
    };
if isShowResiduals
    hMainAxes     = axes( AXES_PROPERTIES{:} );
    hResidualAxes = axes( AXES_PROPERTIES{:} );
    iCopyAxesPosition( hCftoolMainAxes,     hMainAxes );
    iCopyAxesPosition( hCftoolResidaulAxes, hResidualAxes );
    linkaxes( [hMainAxes, hResidualAxes], 'x' );
else
    hMainAxes = axes( AXES_PROPERTIES{:} );
    iCopyAxesPosition( hCftoolMainAxes, hMainAxes );
end

% Set the axes X limits 
% -- we'll do the Y limits after the plots to prevent them getting reset
% by the plots
% -- we need to do the X limits before the plots because the plot method
% of CFIT will use the axis limits to generate evaluation points
% -- don't have to worry about the X limits of the residual plot becuase
% that is taken care of by the linkaxes 
iCopyProperties( 'Xlim', hCftoolMainAxes, hMainAxes );

%
% Plot the data sets with their fits, any other fits and residuals
%
nPlotAllDataSetsAndFits();
nPlotAllFitsWithOutDataSets();
if isShowResiduals
    nPlotAllResiduals();
end
%

% Set the Y limits after all the plots have been done
iCopyProperties( 'Ylim', hCftoolMainAxes, hMainAxes );
if isShowResiduals
    iCopyProperties( 'Ylim', hCftoolResidaulAxes, hResidualAxes );
end

% Display the legend
nDisplayLegend();

% Make everything look nice
if isShowResiduals
    iTidyAxes( hMainAxes, 'Data and Fits' );
    iTidyAxes( hResidualAxes, 'Residuals' );
else
    % There is no axes title if there is only the main plot
    iTidyAxes( hMainAxes, '' );
end

% Only when we're finished do we show the figure
set( hFigure, 'Visible', 'On' );

%
% Effective end of "cfduplicatefigure" -- everything below here is a nested
% function
%-----------------------------------------------------------------------
    function nPlotAllDataSetsAndFits
        % Plot all of the datasets that are plotted in CFTOOL. Also plot
        % the fits associated with any such dataset
        ds = down( dsdb );
        while ~isempty( ds )
            if iIsDataSetPlotted( ds )
                nPlotDataSet( ds );
                nPlotFitsForDataSet( ds );
            end
            % Get the next data set
            ds = right( ds );
        end
    end % of nPlotAllDataSetsAndFits

%-----------------------------------------------------------------------
    function nPlotAllFitsWithOutDataSets
        % Plot the fits where the data sets haven't been plotted
        ds = down( dsdb );
        while ~isempty( ds )
            if ~iIsDataSetPlotted( ds )
                nPlotFitsForDataSet( ds );
            end
            % Get the next data set
            ds = right( ds );
        end
    end % of nPlotAllOtherFits

%-----------------------------------------------------------------------
    function nPlotFitsForDataSet( ds )
        % Plots the fits associated with a given dataset
        ft = down( fitdb );
        while ~isempty( ft )
            if ft.plot && ~isempty( ft.dshandle ) && ft.dshandle == ds 
                nPlotFit( ft )
            end
            % Get the next fit from the database
            ft = right( ft );
        end
    end % of nPlotFitsForDataSet

%-----------------------------------------------------------------------
    function nPlotAllResiduals
        % Plot the residuals in fit order
        ft = down( fitdb );
        while ~isempty( ft )
            if ft.plot
                nPlotResidual( ft )
            end
            % Get the next fit from the database
            ft = right( ft );
        end
    end % of nPlotAllResiduals

%-----------------------------------------------------------------------
    function nPlotDataSet( ds )
        % Plot a single dataset
        h = plot( ds.x, ds.y, 'Parent', hMainAxes, 'DisplayName', ds.name );
        iCopyProperties( DATA_LINE_PROPERTIES, ds.line, h );
    end % of nPlotDataSet

%-----------------------------------------------------------------------
    function nPlotFit( ft )
        % Plot a single fit, including error bounds (if appropriate)
        set( hFigure, 'CurrentAxes', hMainAxes );

        ftype = category( ft.fit );
        if isequal( ft.line.ShowBounds, 'off' ) ...
                || strcmpi( ftype, 'spline' ) ...
                || strcmpi( ftype, 'interpolant' )
            hFit = plot( ft.fit, 'fit', 0.95 );
            hBound1 = [];
            hBound2 = [];
        else
            h = plot( ft.fit, 'predobs', ft.line.ConfLevel );
            hFit = h(1);
            hBound1 = h(2);
            hBound2 = h(3);
        end

        % Turn off legend from plot method call
        legend( 'off' );

        % Copy relevent properties from the CFTOOL plot
        iCopyProperties( FIT_LINE_PROPERTIES, ft.line, hFit );
        % Set the display name fopr use in the legend
        set( hFit, 'DisplayName', [FIT_INDENT, ft.name] );
        % And for the bounds if we have them
        if ~isempty( hBound1 )
            % Setting the DisplayName gives the text for the legend.
            % We only display one of the bound lines in the legend.
            % To ensure that the second doesn't show up, we hide the
            % handle visibility.
            set( hBound1, 'DisplayName', sprintf( '%sPred bnds (%s)', BOUND_INDENT, ft.name ) );
            set( hBound2, 'HandleVisibility', 'Off' );
            iCopyProperties( BOUND_LINE_PROPERTIES, ft.line, hBound1 );
            iCopyProperties( BOUND_LINE_PROPERTIES, ft.line, hBound2 );
        end
    end % of nPlotFit

%-----------------------------------------------------------------------
    function nPlotResidual( ft )
        % Plot a single residual curve
        set( hFigure, 'CurrentAxes', hResidualAxes );

        [x, y] = iGetXYData( ft );
        h = plot( ft.fit, x, y, 'residuals' );

        % Get two lines but only want one -- the second line is the
        % zero line in the residual plot
        delete( h(2) );
        h = h(1);
        % turn off legend from plot method call
        legend( 'off' );
        % Copy the line properties across...
        iCopyProperties( RESIDUAL_LINE_PROPERTIES, ft.rline, h );
        % Tel the legend about the residual line
        set( h, 'DisplayName', ft.name );
    end % of nPlotResidual

%-----------------------------------------------------------------------
    function nDisplayLegend
        % Only display the legend if there is actually anything to
        % display.
        if isShowLegend && ~isempty( findall( hMainAxes, 'Type', 'Line' ) )
            % The labels for the various lines are obtained from the
            % DisplayName property
            hLegend = legend( hMainAxes, 'Show' );
            % Make location, colours, fonts, etc., agree
            legendProperties = iGetLegendProperties( legend( hCftoolMainAxes ) );
            set( hLegend, legendProperties{:} )

            if isShowResiduals && ~isempty( findall( hResidualAxes, 'Type', 'Line' ) )
                % The labels for the various lines are obtained from the
                % DisplayName property 
                hLegend = legend( hResidualAxes, 'Show' );
                % Make location, colours, fonts, etc., agree
                legendProperties = iGetLegendProperties( legend( hCftoolResidaulAxes ) );
                set( hLegend, legendProperties{:} )
            end
        end
    end % of nDisplayLegend

%-----------------------------------------------------------------------
end % of cfduplicatefigure

%-----------------------------------------------------------------------
function tf = iIsDataSetPlotted( ds )
dsline = ds.line;
tf =  ds.plot && ~isempty( dsline ) && ishandle( dsline );
end

%-----------------------------------------------------------------------
function [x, y] = iGetXYData( ft )
% Get the X- and Y-data for a fit taking into account any outlier that
% should be excluded
if isempty( ft.dshandle ),
    % This fit doesnot have data associated with it. We should never end
    % up in this case, but just in case we have we return empty arrays
    % for the data rather than try to dereference a non-existent data
    % set
    x = zeros( 0, 1 );
    y = zeros( 0, 1 );
else
    % The data set pointer is not empty. Therefore we can get the x- and
    % y-data from it.
    x = ft.dshandle.x;
    y = ft.dshandle.y;
    % We also need to remove any outliers (exclusions) that the user has
    % specified in the fit.
    outlier = ft.outlier;
    if ~isequal( outlier, '(none)' ) && ~isempty( outlier )
        % For convenience, accept either an outlier name or a handle
        if ischar( outlier )
            outlier = find( getoutlierdb, 'name', outlier );
        end
        exclude = cfcreateexcludevector( ft.dshandle, outlier );
        % Remove points from the data vectors
        x = x(~exclude);
        y = y(~exclude);
    end
end
end % of iGetXYData

%-----------------------------------------------------------------------
function iTidyAxes( hAxes, titleText )
set( hAxes, 'NextPlot', 'Replace' ); % hold off
xlabel( hAxes, '' );               % remove x label
ylabel( hAxes, '' );               % remove y label
title( hAxes, titleText );
end % of iTidyAxes

%-----------------------------------------------------------------------
function iCopyProperties( properties, src, tgt )
% Copy the values of a list of properties from one HG object (src) to
% another (tgt)
if ~iscell( properties )
    properties = {properties};
end
for i = 1:length( properties ),
    set( tgt, properties{i}, get( src, properties{i} ) );
end
end % of iCopyProperties

%-----------------------------------------------------------------------
function indent = iWorkOutIndent( database )
% Indents for the main legend
% -- The fits get indented if there are two or more datasets
% -- The bounds get indented (from the fits) if there are two or more
% fits
% --> Thus if the given database has two or more record we reutrn a
% small string that we can use at the start of a label to trick an
% indent.
n = 0;
record = down( database );
while n < 2 && ~isempty( record )
    n = n+1;
    % Get the next record
    record = right( record );
end
if n > 1,
    indent = '  ';
else
    indent = '';
end
end % of iWorkOutIndent

%-----------------------------------------------------------------------
function pvPairs = iGetLegendProperties( hLegend )
% Get the interesting properties of a lengend including the position or
% location of the legend within the figure
pvPairs = cfgetlegendinfo( hLegend );
% Need to check that we have the right location
if strcmpi( 'none', get( hLegend, 'Location' ) ),
    pvPairs = [pvPairs, {
        'Location', 'None', ...
        'Units',    'Pixels', ...
        'Position', getpixelposition( hLegend, true ), ...
        'Units', 'Normalized'
        }];
end
end % of iGetLegendProperties

%-----------------------------------------------------------------------
function iSetFigurePosition( hFigure, cffig )
% Make the new figure the same size as CFTOOL but don't change the
% location (lower, left corner)
p = get( cffig, 'Position' );
q = get( hFigure, 'Position' );
set( hFigure, 'Position', [q(1:2), p(3:4)] );
end % of iSetFigurePosition

%-----------------------------------------------------------------------
function p = iCopyAxesPosition( hSrcAxes, hTgtAxes )
% Get position of an axes taking into account that a legned might have
% changed it. 
p = getpixelposition( hSrcAxes, true );
hLegend = legend( hSrcAxes );
% The legend will only affect the position of the axes if the location
% of the legend is set, i.e., if the user drags the legend to a new
% position then the axes will not be moved (resized) by the legend but
% the legend will have 'None' for its location.
if ~isempty( hLegend ) && ~strcmpi( get( hLegend, 'Location' ), 'None' )
    q = getpixelposition( hLegend, true );
    
    p = lbwh2lbrt( p );
    q = lbwh2lbrt( q );
    
    % The position of the tgt axes is taken as the maximum extent of the
    % legend and the src axes, except that the bottom of the tgt axes is
    % always the same as that of the src axes becuase the legend might
    % be very long and extend below the src axes.
    p = [min( p(1), q(1) ), p(2), max( p(3), q(3) ), max( p(4), q(4) )];
    p = lbrt2lbwh( p );
end
setpixelposition( hTgtAxes, p );
end % of iCopyAxesPosition

%-----------------------------------------------------------------------
function p = lbwh2lbrt( p )
% Convert a rectange from [Left Bottom Width Height] to [Left Bottom Right Top]
p(3) = p(1) + p(3);
p(4) = p(2) + p(4);
end % of lbwh2lbrt

%-----------------------------------------------------------------------
function p = lbrt2lbwh( p )
% Convert a rectange from [Left Bottom Right Top] to [Left Bottom Width Height]
p(3) = max( 1, p(3) - p(1) );
p(4) = max( 1, p(4) - p(2) );
end % of lbrt2lbwh
