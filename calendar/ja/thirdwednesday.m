% THIRDWEDNESDAY  与えられた年と月の第3水曜日
%
% この関数は、与えられた年と月の第3水曜日を見つけます。
%
%   [BeginDates, EndDates] = thirdwednesday(Month, Year)
%
% 入力:
%     Month - ユーロダラーの先物/ LIBOR 契約のN行1列の受渡し月ベクトル。
%             
%      Year - ユーロダラーの先物/ LIBOR 契約月に対応するN行1列の
%             4桁表示の年のベクトル。
%
% 出力:
%      BeginDates - 指定された年と月の第三水曜日。これは3ヶ月期間契約の初日。
%
%        EndDates - 年と月で指定される3ヶ月間の契約の末日。
%
% 注意: 1. すべての日付は、シリアル番号です。
%          DATESTR を使って文字列に変換することができます。
%       2. 同一の月と年を与えた場合、関数は同じ結果を返します。
%
% 例:
%      Months = [10; 10; 10];
%      Year = [2002; 2003; 2004];
%
%      [BeginDates, EndDates] = thirdwednesday(Months, Year)
%      
%      BeginDates =
%            731505
%            731869
%            732240
%      EndDates =
%            731597
%            731961
%            732332


%   Copyright 2002-2006 The MathWorks, Inc.
