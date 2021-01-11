%YEARFRAC  日付間の年に対する割合
%
%   この関数は、指定した日数計算方式を用いて、2 つの日付間の日数を
%   年で表します。
%
%   [YearFraction] = yearfrac(Date1, Date2, Basis)
%
%   入力:
%   Date1 - [Nx1 または 1xN 表示の] Date 1 に対する値を日付文字列、または、
%           シリアル番号日付のいずれかで含むベクトル
%
%   Date2 - [Nx1 または 1xN 表示の] Date 2 に対する値を日付文字列、または、
%           シリアル番号日付のいずれかで含むベクトル
%
%   Basis - [Nx1 または 1xN 表示の] 日付の各設定に対する日数計算方式を
%           指定するベクトル
%
%           入力できる値は、次のとおりです。
%           0 - actual/actual (デフォルト)
%           1 - 30/360 SIA
%           2 - actual/360
%           3 - actual/365
%           4 - 30/360 PSA
%           5 - 30/360 ISDA
%           6 - 30/360 ヨーロッパ
%           7 - actual/365 日本
%           8 - actual/actual ISMA
%           9 - actual/360 ISMA
%          10 - actual/365 ISMA
%          11 - 30/360 ISMA
%          23 - actual/365 ISDA
%
%   出力:
%   YearFraction - [Nx1 または 1xN 表示の] Date1 と Date2 間の 1 年に対する
%                  実数表示される割合のベクトル
%
%   参考: YEAR


% Copyright 1995-2008 The MathWorks, Inc.
