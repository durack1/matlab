% DAYS360E  360日を1年とする日付間の日数 (ヨーロッパ型)
%
% この関数は、ヨーロッパ型の慣例に基づく 30/360 の日数カウント基準で、
% 入力された2つの日付間の日数を出力します。
%
%   NumberDays = days360(StartDate, EndDate)
%
% 入力: 
%   StartDate - 最初の日付を示すシリアル日付番号、または日付文字列
%               で構成されるN行1列、または1行N列のベクトルです。
%   EndDate - 最後の日付を示すシリアル日付番号、または日付文字列
%             で構成されるN行1列、または1行N列のベクトルです。
%
% 出力: 
%   NumberDays - 2つの日付間の日数を示すN行1列、または1行N列のベクトル
%                またはスカラ値です。
%
% 例: 
%   StartDate = '28-Feb-1994';
%   EndDate = '1-Mar-1994';
%
%   NumberDays = days360e(StartDate, EndDate);
%
%   NumberDays = 3 
%
%   を出力します。
%
% 参考 DAYS360SIA, DAYS360PSA, DAYS365, DAYSACT, DAYSDIF.


% Copyright 1995-2006 The MathWorks, Inc.
