% MONTH 月
%
%   Month 与えられたシリアル日付番号、または、日付文字列の月を出力します。
%
%   [N, M] = MONTH(D)
%
% 入力:
%   D   - シリアル日付番号、または日付文字列
%
% 出力:
%   N   - 数字表示
%   M   - 文字列表示
%
% 例:
%      19-Dec-1994 (728647)
%
%      [n, m] = month(728647)
%      n =
%          12
%      m =
%          Dec
%
%      [n, m] = month('19-Dec-1994')
%      n =
%          12
%      m =
%          Dec
%
% 参考 DATEVEC, DAY, YEAR.


% Copyright 1995-2006 The MathWorks, Inc.
