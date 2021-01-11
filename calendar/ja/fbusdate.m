% FBUSDATE 月の最初の営業日
%
%   D = fbusdate(Y, M)
%   D = fbusdate(Y, M, HOL, WEEKEND)
%
% オプションの入力: HOL, WEEKEND
%
% 入力:
%         Y - Year (i.e. 2002)
%
%         M - Month (i.e. 12 <December>)
%
% オプションの入力:
%     HOL - 休業日を示すベクトルです。HOL の指定がない場合、休業日の
%           データはルーチンによって HOLIDAYS に対応するデータが使われます。
%           現時点では、HOLIDAYS は NY の休日をサポートします。
%
%     WEEKEND - 週末を 1 とする 0 と 1 を含む長さ 7 のベクトルです。
%               このベクトルの最初の要素は、日曜日に対応します。
%               そのため、土曜日と日曜日が週末とすると、
%               WEEKDAY = [1 0 0 0 0 0 1] となります。デフォルトでは、
%               土曜日と日曜日が週末になります。
%
% 出力:
%         D - 指定された月の最初の営業日
%
% 例:
%      D = fbusdate(1997, 11)
%      D =
%            729697   % 1997年11月3日
%
% 参考 BUSDATE, EOMDATE, HOLIDAYS, ISBUSDAY, LBUSDATE.


% Copyright 1995-2006 The MathWorks, Inc.
