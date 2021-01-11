%UICALENDAR  グラフィカルなカレンダ
%
%   UICALENDAR は、uicontrol とのインタフェースを持ったカスタマイズ可能な
%   グラフィカルなカレンダです。UICALENDAR は、ユーザが選択した日付で 
%   uicontrol を作成します。
%
%   uicalendar('PARAM1', VALUE1, 'PARAM2', VALUE2', ...)
%
%   入力:
%   パラメータ        - 値            : 説明
%   ---------------------------------------------------------------------------
%   'BusDays'          - 0            : (デフォルト) 非営業日の指標を持たない
%                                       標準のカレンダです。
%
%                        1            : NYSE の非営業日を赤で印を付ける。
%
%   'BusDaySelect'     - 0            : 営業日の選択のみを許可します。
%                                       非営業日は以下のパラメータから定義
%                                       されます。
%
%                                       'BusDays'
%                                       'Holiday'
%                                       'Weekend'
%
%                        1            : (デフォルト) 営業日と非営業日の選択を
%                                       許可します。
%
%   'DateBoxColor'     - [日付 R G B] : 日付の枠内の色を指定した [R G B] の
%                                       色に設定します。
%
%   'DateStrColor'     - [日付 R G B] : 日付の色を指定した [R G B] の色に設定します。
%
%   'DestinationUI'    - H            : 指定するオブジェクトのハンドルのスカラ
%                                       またはベクトルです。日付からなるデフォルトの 
%                                       UI は 'string' です。
%
%                        {H, {Prop}}  : ハンドルと指定するオブジェクトの UI 
%                                       プロパティのセル配列です。H はスカラか
%                                       ベクトルでなければなりません。また、
%                                       'Prop' は単一のプロパティの文字列、
%                                       または、プロパティの文字列のセル配列
%                                       でなければなりません。
%
%   'Holiday'          - Dates        : 指定した休日をカレンダに設定します。
%                                       休日に対応する日付文字列は赤で表されます。
%                                       Date は、datenum のスカラまたはベクトル
%                                       でなければなりません。
%
%   'InitDate'         - Datenum      : カレンダを初期化する場合の初期の開始日
%                                       を指定する数値の日付の値です。
%                                       デフォルト値は今日です。
%
%                        Datestr      : カレンダを初期化する場合の初期の開始日
%                                       を指定する日付文字列の値です。Datestr は、
%                                       Year, Month, Day を含まなければなりません 
%                                       (例. 01-Jan-2006)。
%
%   'InputDateFormat'  - Format       : 初期の開始日 InitDate の形式を設定します。
%                                       日付の形式の値については、'help datestr' 
%                                       を参照してください。
%
%   'OutputDateFormat' - Format       : 出力の日付文字列の形式を設定します。
%                                       日付の形式の値については、'help datestr' 
%                                       を参照してください。
%
%   'OutputDateStyle'  - 0            : (デフォルト) 単一の日付文字列、または、
%                                       日付文字列のセル配列 (行) を返します。
%                                       例. {'01-Jan-2001, 02-Jan-2001, ...'}
%
%                        1            : 単一の日付文字列、または、日付文字列
%                                       のセル配列 (列) を返します。
%                                       例. {'01-Jan-2001; 02-Jan-2001; ...'}
%
%                        2            : datenum のベクトルの行ベクトルの文字列
%                                       表現を返します。
%                                       例. '[732758, 732759, 732760, 732761]'
%
%                        3            : datenum のベクトルの列ベクトルの文字列
%                                       表現を返します。
%                                       例. '[732758; 732759; 732760; 732761]'
%
%   'SelectionType'    - 0            : 複数の日付の選択を許可します。
%
%                        1            : (デフォルト) 単一の日付選択のみを許可
%                                       します。
%
%   'Weekend'          - DayOfWeek    : 週の指定した日を週末として設定します。
%                                       週末は赤で印が付けられます。
%
%                                       DayOfWeek は、以下の数値を含むベクトル
%                                       になります。
%
%                                       1 - 日曜
%                                       2 - 月曜
%                                       3 - 火曜
%                                       4 - 水曜
%                                       5 - 木曜
%                                       6 - 金曜
%                                       7 - 土曜
%
%                                       あるいは、0 と 1 を含む長さ 7 の
%                                       ベクトルになります。値 1 は、週末を示します。
%                                       このベクトルの最初の要素は、Sunday に
%                                       対応します。
%
%                                       たとえば、Saturday と Sunday が週末とすると、
%                                       WEEKEND = [1 0 0 0 0 0 1] となります。
%
%   'WindowStyle'      - Normal       : (デフォルト) 標準の Figure のプロパティです。
%
%                        Modal        : Modal の Figure は、上記のすべてのノーマルな 
%                                       Figure と MATLAB コマンドウィンドウを重ねます。
%
%   例:
%      uicontrol の作成:
%      textH1 = uicontrol('style', 'edit', 'position', [10 10 100 20]);
%
%      UICALENDAR の呼び出し:
%      uicalendar('DestinationUI', {textH1, 'string'})
%
%      日付を選択して 'OK' を押します。


% Copyright 1995-2008 The MathWorks, Inc.
