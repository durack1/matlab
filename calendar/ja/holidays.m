%HOLIDAYS  休日及び休業日
%
%   H = HOLIDAYS(D1,D2) は、日付 D1 及び D2 間の休日及び休業日に対応する
%   シリアル番号日付のベクトルをすべて返します。
%
%   H = HOLIDAYS はすべての既知の休業日データを返します。
%
%   H = HOLIDAYS(D1, D2, ALTHOLIDAYS) は、ALTHOLIDAYS で指定した日付の
%   休日ベクトルを返します。
%
%   この関数には、1950 年から 2050 年までの (米国の) 休日とニューヨーク
%   証券取引所の休業日に関するすべてのデータが組み込まれています。
%
%   注意: 1998 年 1 月以降、Martin Luther King Jr. Day が、米国市場で休日と
%         なりました。
%
%   例:
%      h = holidays('01-jan-1997', '23-jun-1997')
%
%      h =
%            729391 % 1997 年 1 月 1 日
%            729438 % 1997 年 2 月 17 日
%            729477 % 1997 年 3 月 28 日
%            729536 % 1997 年 3 月 26 日
%
%   参考 BUSDATE, FBUSDATE, ISBUSDAY, LBUSDATE.


%   Copyright 1995-2008 The MathWorks, Inc.
