% ISBUSDAY 指定した日付が営業日かどうかの判定
%
% T = ISBUSDAY(Date, Holiday, Weekend)
%
% 入力:
%        
%   Date    - 対象となる日付のベクトル
%
% オプションの入力:
%
%   HOL     - ユーザ定義の休日のベクトルです。デフォルトは、(holidays.m の)
%             あらかじめ定義されている US の休日です。
%
%   WEEKEND - 週末を 1 とする 0 と 1 を含む長さ 7 のベクトルです。
%             このベクトルの最初の要素は、日曜日に対応します。
%             そのため、土曜日と日曜日が週末とすると、
%             WEEKDAY = [1 0 0 0 0 0 1] となります。デフォルトでは、
%             土曜日と日曜日が週末になります。
%
% 出力:
%
%   T       - Date が営業日なら 1、それ以外は 0 を出力します。
%
% 例:
%
%   Date = ['15 feb 2001'; '16 feb 2001'; '17 feb 2001'];
%
%   として、(holidays.mから) あらかじめ定義されている US の休日ベクトルを
%   用いて、日曜日のみを週末として営業日を見つけるには、MATLAB に以下の
%   ように指示します。
%
%   Busday = isbusday(Date, [], [1 0 0 0 0 0 0])
%
% 参考 BUSDATE, FBUSDATE, HOLIDAYS, LBUSDATE. 


% Copyright 1995-2006 The MathWorks, Inc.
