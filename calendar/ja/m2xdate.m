%M2XDATE  MATLAB シリアル番号日付を Excel シリアル番号日付に変換
%
%   DateNumber = m2xdate(MATLABDateNumber, Convention)
%
%   詳細：この関数は、MATLAB シリアル番号日付書式を Excel シリアル番号
%         日付書式に変換します。
%
%   入力:   MATLABDateNumber - MATLAB シリアル番号日付で表示されたシリアル
%           日付番号の Nx1 または 1xN のベクトルです。
%           Convention -  MATLAB シリアル番号日付から変換を行う際に、どの 
%           Excel シリアル番号日付変換規則を用いるかを示す Nx1 または 1xN の
%           ベクトル、または、スカラのフラグ値です。以下の値を設定します。
%           a) Convention = 0 - シリアル番号日付 1 が、1899 年 12 月 31 日に
%                対応する 1900 日付システム (デフォルト)
%           b) Convention = 1 - シリアル番号日付 0 が、1904 年 1 月 1 日に
%                対応する 1904 日付システム
%
%   出力: Excel のシリアル日付の番号形式の Nx1 または 1xN のシリアル番号
%         日付のベクトル。
%
%
%   例: StartDate = 729706
%            Convention = 0;
%
%            EndDate = m2xdate(StartDate, Convention);
%
%            は、以下を返します。
%
%            EndDate = 35746
%
%   注意： Excel のバグのため (Excel 2003 SP1 まではバグあり)、Excel では 
%          1900 年はうるう年として処理されます。結果として、1900 年 1 月 1 日から 
%          1900 年 2 月 28 日までの日付は、関数 M2XDATE によって 1 違う値が
%          報告されます。
%
%         例:
%                     Excel では、 1900 年 1 月 1 日 = 1
%                     MATLAB では、1900 年 1 月 1 日 = 2
%
%   参考 X2MDATE.


%   Copyright 1995-2008 The MathWorks, Inc.
